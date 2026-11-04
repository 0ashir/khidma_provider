import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart'
    show MapController, CameraFit, LatLngBounds;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart' as osm;

import 'appMapTypes.dart';

/// Provider-agnostic camera controller: wraps [gmaps.GoogleMapController] on the
/// Google Maps path and flutter_map's [MapController] on the OpenStreetMap path.
///
/// The Google controller is only available asynchronously (via `onMapCreated`),
/// so camera commands issued before it attaches are queued and replayed once it does.
class AppMapController {
  AppMapController({required this.isOsm}) : osmController = MapController();

  final bool isOsm;
  final MapController osmController;

  gmaps.GoogleMapController? _googleController;
  final List<void Function(gmaps.GoogleMapController)> _pendingGoogleActions =
      [];

  /// Raw controller, for call sites that need Google-specific packages
  /// (e.g. `custom_info_window`). Only ever non-null on the Google path.
  gmaps.GoogleMapController? get googleController => _googleController;

  void attachGoogleController(gmaps.GoogleMapController controller) {
    _googleController = controller;
    final pending = List<void Function(gmaps.GoogleMapController)>.from(
      _pendingGoogleActions,
    );
    _pendingGoogleActions.clear();
    for (final action in pending) {
      action(controller);
    }
  }

  Future<void> animateTo(AppLatLng target, {double zoom = 16}) async {
    if (isOsm) {
      osmController.move(osm.LatLng(target.latitude, target.longitude), zoom);
      return;
    }
    final controller = _googleController;
    if (controller == null) {
      _pendingGoogleActions.add((c) => _animateGoogle(c, target, zoom));
      return;
    }
    await _animateGoogle(controller, target, zoom);
  }

  Future<void> _animateGoogle(
    gmaps.GoogleMapController controller,
    AppLatLng target,
    double zoom,
  ) => controller.animateCamera(
    gmaps.CameraUpdate.newCameraPosition(
      gmaps.CameraPosition(
        target: gmaps.LatLng(target.latitude, target.longitude),
        zoom: zoom,
      ),
    ),
  );

  Future<void> fitBounds(
    AppLatLng a,
    AppLatLng b, {
    double padding = 80,
  }) async {
    if (isOsm) {
      osmController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(
            osm.LatLng(a.latitude, a.longitude),
            osm.LatLng(b.latitude, b.longitude),
          ),
          padding: EdgeInsets.all(padding),
        ),
      );
      return;
    }
    final controller = _googleController;
    if (controller == null) {
      _pendingGoogleActions.add((c) => _fitGoogleBounds(c, a, b, padding));
      return;
    }
    await _fitGoogleBounds(controller, a, b, padding);
  }

  Future<void> _fitGoogleBounds(
    gmaps.GoogleMapController controller,
    AppLatLng a,
    AppLatLng b,
    double padding,
  ) {
    final bounds = gmaps.LatLngBounds(
      southwest: gmaps.LatLng(
        a.latitude < b.latitude ? a.latitude : b.latitude,
        a.longitude < b.longitude ? a.longitude : b.longitude,
      ),
      northeast: gmaps.LatLng(
        a.latitude > b.latitude ? a.latitude : b.latitude,
        a.longitude > b.longitude ? a.longitude : b.longitude,
      ),
    );
    return controller.animateCamera(
      gmaps.CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  void dispose() {
    if (isOsm) {
      osmController.dispose();
    } else {
      _googleController?.dispose();
    }
  }
}
