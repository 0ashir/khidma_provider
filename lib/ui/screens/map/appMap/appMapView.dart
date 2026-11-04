import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart' as osm;

import '../../../../cubits/fetchSystemSettingsCubit.dart';
import 'appMapController.dart';
import 'appMapTypes.dart';

/// Renders either a Google Map or an OpenStreetMap tile map depending on
/// [FetchSystemSettingsCubit.isOpenStreetMap], behind one shared, provider-agnostic API.
///
/// Known limitations vs. the Google path: no dark-tile theming for OSM (always
/// renders the standard light OSM raster tiles), and no custom animated tap
/// tooltip (that behaviour is specific to the `custom_info_window` package).
class AppMapView extends StatefulWidget {
  const AppMapView({
    super.key,
    required this.initialCenter,
    this.initialZoom = 16,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
    this.onCameraMove,
    this.onMapReady,
    this.zoomControlsEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.rotateGesturesEnabled = true,
    this.myLocationButtonEnabled = false,
    this.liteMode = false,
    this.googleMapStyle,
    this.showOsmAttribution = true,
  });

  final AppLatLng initialCenter;
  final double initialZoom;
  final List<AppMapMarker> markers;
  final List<AppMapPolyline> polylines;
  final void Function(double latitude, double longitude)? onTap;
  final VoidCallback? onCameraMove;
  final void Function(AppMapController controller)? onMapReady;
  final bool zoomControlsEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool myLocationButtonEnabled;

  /// Google: `liteModeEnabled`. OSM: disables all interaction (static preview).
  final bool liteMode;

  /// JSON map style string (dark/light theme), Google path only.
  final String? googleMapStyle;

  /// OSM tile usage policy requires attribution to stay visible; only turn this
  /// off if an attribution is already shown elsewhere on the same screen.
  final bool showOsmAttribution;

  @override
  State<AppMapView> createState() => _AppMapViewState();
}

class _AppMapViewState extends State<AppMapView> {
  late final bool _isOsm;
  late final AppMapController _mapController;

  @override
  void initState() {
    super.initState();
    _isOsm = context.read<FetchSystemSettingsCubit>().isOpenStreetMap;
    _mapController = AppMapController(isOsm: _isOsm);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _isOsm ? _buildOsmMap() : _buildGoogleMap();

  Widget _buildGoogleMap() {
    final markers = widget.markers
        .map(
          (m) => gmaps.Marker(
            markerId: gmaps.MarkerId(m.id),
            position: gmaps.LatLng(m.position.latitude, m.position.longitude),
            icon: m.googleIcon ?? gmaps.BitmapDescriptor.defaultMarker,
            anchor: m.anchor,
            onTap: m.onTap,
            infoWindow: m.infoWindowTitle == null
                ? gmaps.InfoWindow.noText
                : gmaps.InfoWindow(title: m.infoWindowTitle),
          ),
        )
        .toSet();

    final polylines = widget.polylines
        .map(
          (p) => gmaps.Polyline(
            polylineId: gmaps.PolylineId(p.id),
            points: p.points
                .map((pt) => gmaps.LatLng(pt.latitude, pt.longitude))
                .toList(),
            color: p.color,
            width: p.width.round(),
          ),
        )
        .toSet();

    return gmaps.GoogleMap(
      style: widget.googleMapStyle,
      initialCameraPosition: gmaps.CameraPosition(
        target: gmaps.LatLng(
          widget.initialCenter.latitude,
          widget.initialCenter.longitude,
        ),
        zoom: widget.initialZoom,
      ),
      markers: markers,
      polylines: polylines,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      liteModeEnabled: widget.liteMode,
      minMaxZoomPreference: const gmaps.MinMaxZoomPreference(0, 18),
      onTap: widget.onTap == null
          ? null
          : (pos) => widget.onTap!(pos.latitude, pos.longitude),
      onCameraMove: widget.onCameraMove == null
          ? null
          : (_) => widget.onCameraMove!(),
      onMapCreated: (controller) {
        _mapController.attachGoogleController(controller);
        widget.onMapReady?.call(_mapController);
      },
    );
  }

  Widget _buildOsmMap() {
    final osmMarkers = widget.markers
        .map(
          (m) => fmap.Marker(
            point: osm.LatLng(m.position.latitude, m.position.longitude),
            width: 40,
            height: 40,
            rotate: true,
            alignment: Alignment(
              (m.anchor.dx - 0.5) * 2,
              (m.anchor.dy - 0.5) * 2,
            ),
            child: GestureDetector(
              onTap: m.onTap,
              behavior: HitTestBehavior.translucent,
              child:
                  m.osmChild ??
                  const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ),
        )
        .toList();

    final osmPolylines = widget.polylines
        .map(
          (p) => fmap.Polyline(
            points: p.points
                .map((pt) => osm.LatLng(pt.latitude, pt.longitude))
                .toList(),
            color: p.color,
            strokeWidth: p.width,
          ),
        )
        .toList();

    final interactive = !widget.liteMode && widget.scrollGesturesEnabled;

    return fmap.FlutterMap(
      mapController: _mapController.osmController,
      options: fmap.MapOptions(
        initialCenter: osm.LatLng(
          widget.initialCenter.latitude,
          widget.initialCenter.longitude,
        ),
        initialZoom: widget.initialZoom,
        interactionOptions: fmap.InteractionOptions(
          flags: interactive
              ? fmap.InteractiveFlag.all
              : fmap.InteractiveFlag.none,
        ),
        onTap: widget.onTap == null
            ? null
            : (_, point) => widget.onTap!(point.latitude, point.longitude),
        onPositionChanged: widget.onCameraMove == null
            ? null
            : (_, __) => widget.onCameraMove!(),
        onMapReady: () => widget.onMapReady?.call(_mapController),
      ),
      children: [
        fmap.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // urlTemplate:
          //     'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.provider.khadamat',
        ),
        if (osmPolylines.isNotEmpty)
          fmap.PolylineLayer(polylines: osmPolylines),
        if (osmMarkers.isNotEmpty) fmap.MarkerLayer(markers: osmMarkers),
        if (widget.showOsmAttribution)
          const fmap.SimpleAttributionWidget(
            source: Text('© OSM, © CARTO', style: TextStyle(fontSize: 10)),
          ),
      ],
    );
  }
}
