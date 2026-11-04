import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

import '../../app/generalImports.dart';
import '../screens/map/appMap/appMapController.dart';
import '../screens/map/appMap/appMapTypes.dart';
import '../screens/map/appMap/appMapView.dart';

class MiniMapWidget extends StatefulWidget {
  const MiniMapWidget({
    super.key,
    required this.orderId,
    required this.handymanLat,
    required this.handymanLng,
    this.orderLat,
    this.orderLng,
    this.isHandymanMode = false,
  });

  final String orderId;
  final double handymanLat;
  final double handymanLng;
  final double? orderLat;
  final double? orderLng;
  final bool isHandymanMode;

  @override
  State<MiniMapWidget> createState() => _MiniMapWidgetState();
}

class _MiniMapWidgetState extends State<MiniMapWidget> {
  static const double _mapHeight = 180;

  /// Edge room so the 36px marker icons are fully inside the small map.
  static const double _fitPadding = 40;
  static const double _singlePointZoom = 15;
  static const double _maxFitZoom = 17;

  BitmapDescriptor? _handymanIcon;
  BitmapDescriptor? _orderIcon;
  bool _iconsLoaded = false;
  AppMapController? _mapController;

  bool get _hasOrder => widget.orderLat != null && widget.orderLng != null;

  @override
  void didUpdateWidget(covariant MiniMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // initialCenter/initialZoom only apply on creation; keep both markers in
    // view as the handyman moves.
    if (oldWidget.handymanLat != widget.handymanLat ||
        oldWidget.handymanLng != widget.handymanLng ||
        oldWidget.orderLat != widget.orderLat ||
        oldWidget.orderLng != widget.orderLng) {
      _focusMarkers();
    }
  }

  void _focusMarkers() {
    final controller = _mapController;
    if (controller == null) return;
    final handymanPos = AppLatLng(widget.handymanLat, widget.handymanLng);
    if (_hasOrder) {
      controller.fitBounds(
        handymanPos,
        AppLatLng(widget.orderLat!, widget.orderLng!),
        padding: _fitPadding,
      );
    } else {
      controller.animateTo(handymanPos, zoom: _singlePointZoom);
    }
  }

  /// Web-Mercator zoom at which [a]–[b] fit in [size] minus [_fitPadding] on
  /// every side, so the very first frame already frames both markers.
  static double _zoomToFit(AppLatLng a, AppLatLng b, Size size) {
    double latRad(double lat) {
      final s = math.sin(lat * math.pi / 180);
      final radX2 = math.log((1 + s) / (1 - s)) / 2;
      return math.max(math.min(radX2, math.pi), -math.pi) / 2;
    }

    double zoomFor(double px, double fraction) =>
        fraction <= 0 ? _maxFitZoom : math.log(px / 256 / fraction) / math.ln2;

    final usableW = math.max(1.0, size.width - _fitPadding * 2);
    final usableH = math.max(1.0, size.height - _fitPadding * 2);
    final latFraction =
        (latRad(math.max(a.latitude, b.latitude)) -
            latRad(math.min(a.latitude, b.latitude))) /
        math.pi;
    final lngFraction = (a.longitude - b.longitude).abs() / 360;
    final zoom = math.min(
      zoomFor(usableH, latFraction),
      zoomFor(usableW, lngFraction),
    );
    return zoom.clamp(2.0, _maxFitZoom).toDouble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iconsLoaded) {
      _iconsLoaded = true;
      _loadIcons();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadIcons() async {
    final results = await Future.wait([
      _svgToMarker(AppAssets.handyman, size: 36),
      _svgToMarker(AppAssets.customerPin, size: 36),
    ]);
    if (!mounted) return;
    setState(() {
      _handymanIcon = results[0];
      _orderIcon = results[1];
    });
  }

  Future<BitmapDescriptor> _svgToMarker(
    String assetPath, {
    double size = 36,
  }) async {
    final accentColor = Theme.of(context).colorScheme.accentColor;
    final data = await rootBundle.load(assetPath);
    final loader = SvgStringLoader(utf8.decode(data.buffer.asUint8List()));
    final pictureInfo = await vg.loadPicture(loader, null);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(size / pictureInfo.size.width, size / pictureInfo.size.height);
    canvas.drawPicture(pictureInfo.picture);
    canvas.drawColor(accentColor, BlendMode.srcATop);
    pictureInfo.picture.dispose();
    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  static Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        decoration: BoxDecoration(
          color: Theme.of(fromHeroContext).colorScheme.secondaryColor,
          borderRadius: BorderRadius.lerp(
            BorderRadius.circular(12),
            BorderRadius.zero,
            direction == HeroFlightDirection.push
                ? animation.value
                : 1 - animation.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final handymanPos = AppLatLng(widget.handymanLat, widget.handymanLng);
    final hasOrder = widget.orderLat != null && widget.orderLng != null;
    final orderPos = hasOrder
        ? AppLatLng(widget.orderLat!, widget.orderLng!)
        : null;

    final initialCenter = hasOrder
        ? AppLatLng(
            (handymanPos.latitude + orderPos!.latitude) / 2,
            (handymanPos.longitude + orderPos.longitude) / 2,
          )
        : handymanPos;

    final markers = <AppMapMarker>[
      AppMapMarker(
        id: 'mini_handyman',
        position: handymanPos,
        anchor: const Offset(0.5, 0.5),
        googleIcon:
            _handymanIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        osmChild: CustomSvgPicture(
          svgImage: AppAssets.handyman,
          color: Theme.of(context).colorScheme.accentColor,
          height: 36,
          width: 36,
        ),
      ),
      if (orderPos != null)
        AppMapMarker(
          id: 'mini_order',
          position: orderPos,
          googleIcon:
              _orderIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          osmChild: CustomSvgPicture(
            svgImage: AppAssets.customerPin,
            color: Theme.of(context).colorScheme.accentColor,
            height: 36,
            width: 36,
          ),
        ),
    ];

    final polylines = orderPos != null
        ? [
            AppMapPolyline(
              id: 'mini_track',
              points: [handymanPos, orderPos],
              color: Colors.blue,
              width: 3,
            ),
          ]
        : const <AppMapPolyline>[];

    return Hero(
      tag: 'live-tracking-map-${widget.orderId}',
      flightShuttleBuilder: _flightShuttle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: _mapHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: LayoutBuilder(
                    builder: (context, constraints) => AppMapView(
                      liteMode: true,
                      initialCenter: initialCenter,
                      initialZoom: hasOrder
                          ? _zoomToFit(
                              handymanPos,
                              orderPos!,
                              Size(constraints.maxWidth, _mapHeight),
                            )
                          : _singlePointZoom,
                      onMapReady: (controller) => _mapController = controller,
                      markers: markers,
                      polylines: polylines,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      showOsmAttribution: false,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.liveTracking,
                    arguments: widget.isHandymanMode
                        ? {
                            'orderId': widget.orderId,
                            'orderLat': widget.orderLat,
                            'orderLng': widget.orderLng,
                          }
                        : widget.orderId,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
