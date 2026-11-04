import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

import '../../../app/generalImports.dart';
import '../../../cubits/getLiveTrackingDataCubit.dart';
import '../../../data/model/liveTracking/liveTrackingDataModel.dart';
import '../map/appMap/appMapController.dart';
import '../map/appMap/appMapTypes.dart';
import '../map/appMap/appMapView.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({
    super.key,
    required this.orderId,
    this.orderLat,
    this.orderLng,
    this.isHandymanMode = false,
  });

  final String orderId;
  final double? orderLat;
  final double? orderLng;
  final bool isHandymanMode;

  static Route route(RouteSettings settings) {
    final args = settings.arguments;
    String orderId;
    double? orderLat;
    double? orderLng;
    bool isHandymanMode;

    if (args is Map) {
      orderId = args['orderId'] as String;
      orderLat = args['orderLat'] as double?;
      orderLng = args['orderLng'] as double?;
      isHandymanMode = true;
    } else {
      orderId = args as String;
      isHandymanMode = false;
    }

    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => GetLiveTrackingDataCubit(),
        child: LiveTrackingScreen(
          orderId: orderId,
          orderLat: orderLat,
          orderLng: orderLng,
          isHandymanMode: isHandymanMode,
        ),
      ),
    );
  }

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  AppMapController? _mapController;
  final List<AppMapMarker> _markers = [];
  final List<AppMapPolyline> _polylines = [];
  GetLiveTrackingDataCubit? _cubit;
  bool _iconsLoaded = false;

  BitmapDescriptor? _handymanIcon;
  BitmapDescriptor? _orderIcon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iconsLoaded) {
      _iconsLoaded = true;
      _loadMarkerIcons();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isHandymanMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cubit = context.read<GetLiveTrackingDataCubit>();
        _cubit!.startPolling(orderId: widget.orderId);
        _cubit!.onTransientError = () {
          if (!context.mounted) return;
          UiUtils.showMessage(
            context,
            'locationUpdateFailed'.translate(context: context),
            ToastificationType.warning,
          );
        };
      });
    }
  }

  Future<void> _loadMarkerIcons() async {
    final results = await Future.wait([
      _svgToMarker(AppAssets.handyman, size: 48),
      _svgToMarker(AppAssets.customerPin, size: 48),
    ]);
    if (!mounted) return;
    setState(() {
      _handymanIcon = results[0];
      _orderIcon = results[1];
    });
  }

  Future<BitmapDescriptor> _svgToMarker(
    String assetPath, {
    double size = 48,
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

  @override
  void dispose() {
    _cubit?.onTransientError = null;
    _cubit?.stopPolling();
    _mapController?.dispose();
    super.dispose();
  }

  void _updateMapWithPositions(AppLatLng handymanPos, AppLatLng orderPos) {
    final markers = <AppMapMarker>[
      AppMapMarker(
        id: 'order_location',
        position: orderPos,
        infoWindowTitle: 'serviceLocation'.translate(context: context),
        googleIcon:
            _orderIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        osmChild: CustomSvgPicture(
          svgImage: AppAssets.customerPin,
          color: Theme.of(context).colorScheme.accentColor,
          height: 48,
          width: 48,
        ),
      ),
      AppMapMarker(
        id: 'handyman_location',
        position: handymanPos,
        anchor: const Offset(0.5, 0.5),
        infoWindowTitle: 'handymanLocation'.translate(context: context),
        googleIcon:
            _handymanIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        osmChild: CustomSvgPicture(
          svgImage: AppAssets.handyman,
          color: Theme.of(context).colorScheme.accentColor,
          height: 48,
          width: 48,
        ),
      ),
    ];

    final polylines = <AppMapPolyline>[
      AppMapPolyline(
        id: 'tracking_line',
        points: [handymanPos, orderPos],
        color: Colors.blue,
        width: 4,
      ),
    ];

    _fitBounds(handymanPos, orderPos);

    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
      _polylines
        ..clear()
        ..addAll(polylines);
    });
  }

  void _updateMap(LiveTrackingDataModel data) {
    final orderPos = AppLatLng(data.orderLat, data.orderLng);

    if (data.hasHandymanLocation) {
      _updateMapWithPositions(
        AppLatLng(data.handymanLat!, data.handymanLng!),
        orderPos,
      );
    } else {
      setState(() {
        _markers
          ..clear()
          ..add(
            AppMapMarker(
              id: 'order_location',
              position: orderPos,
              infoWindowTitle: 'serviceLocation'.translate(context: context),
              googleIcon:
                  _orderIcon ??
                  BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
              osmChild: CustomSvgPicture(
                svgImage: AppAssets.customerPin,
                color: Theme.of(context).colorScheme.accentColor,
                height: 48,
                width: 48,
              ),
            ),
          );
        _polylines.clear();
      });
      _mapController?.animateTo(orderPos, zoom: 14);
    }
  }

  void _fitBounds(AppLatLng a, AppLatLng b) {
    _mapController?.fitBounds(a, b, padding: 80);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        backgroundColor: context.colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'liveTracking'.translate(context: context),
        ),
        body: Hero(
          tag: 'live-tracking-map-${widget.orderId}',
          flightShuttleBuilder: (_, animation, direction, fromCtx, __) =>
              AnimatedBuilder(
                animation: animation,
                builder: (ctx, _) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(fromCtx).colorScheme.secondaryColor,
                    borderRadius: BorderRadius.lerp(
                      BorderRadius.circular(12),
                      BorderRadius.zero,
                      direction == HeroFlightDirection.push
                          ? animation.value
                          : 1 - animation.value,
                    ),
                  ),
                ),
              ),
          child: widget.isHandymanMode
              ? _buildHandymanMap()
              : _buildProviderMap(),
        ),
      ),
    );
  }

  Widget _buildHandymanMap() {
    final hasOrderPos = widget.orderLat != null && widget.orderLng != null;
    final orderPos = hasOrderPos
        ? AppLatLng(widget.orderLat!, widget.orderLng!)
        : null;

    return BlocConsumer<HandymanLiveTrackingCubit, HandymanLiveTrackingState>(
      listener: (context, state) {
        if (state is HandymanLiveTrackingActive && state.hasPosition) {
          final handymanPos = AppLatLng(state.latitude!, state.longitude!);
          if (orderPos != null) {
            _updateMapWithPositions(handymanPos, orderPos);
          } else {
            _updateHandymanOnly(handymanPos);
          }
        }
      },
      builder: (context, state) {
        final hasPosition =
            state is HandymanLiveTrackingActive && state.hasPosition;

        final initialCenter = hasPosition
            ? AppLatLng(state.latitude!, state.longitude!)
            : orderPos ?? const AppLatLng(0, 0);
        final initialZoom = hasPosition || orderPos != null ? 14.0 : 2.0;

        return Stack(
          children: [
            AppMapView(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              markers: _markers,
              polylines: _polylines,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onMapReady: (controller) {
                _mapController = controller;
                if (hasPosition) {
                  final handymanPos = AppLatLng(
                    state.latitude!,
                    state.longitude!,
                  );
                  if (orderPos != null) {
                    _updateMapWithPositions(handymanPos, orderPos);
                  } else {
                    _updateHandymanOnly(handymanPos);
                  }
                }
              },
            ),
            if (!hasPosition)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: CustomContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  borderRadius: 8,
                  color: context.colorScheme.secondaryColor,
                  child: Row(
                    children: [
                      const Icon(Icons.location_searching, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          'waitingForLocation'.translate(context: context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _updateHandymanOnly(AppLatLng handymanPos) {
    setState(() {
      _markers
        ..clear()
        ..add(
          AppMapMarker(
            id: 'handyman_location',
            position: handymanPos,
            anchor: const Offset(0.5, 0.5),
            googleIcon:
                _handymanIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
            osmChild: CustomSvgPicture(
              svgImage: AppAssets.handyman,
              color: Theme.of(context).colorScheme.accentColor,
              height: 48,
              width: 48,
            ),
          ),
        );
      _polylines.clear();
    });
    _mapController?.animateTo(handymanPos, zoom: 14);
  }

  Widget _buildProviderMap() {
    return BlocConsumer<GetLiveTrackingDataCubit, GetLiveTrackingDataState>(
      listener: (context, state) {
        if (state is GetLiveTrackingDataSuccess) {
          _updateMap(state.data);
        }
      },
      builder: (context, state) {
        if (state is GetLiveTrackingDataFailure) {
          return Center(
            child: ErrorContainer(
              errorMessage: state.errorMessage.translate(context: context),
              onTapRetry: () => context
                  .read<GetLiveTrackingDataCubit>()
                  .startPolling(orderId: widget.orderId),
            ),
          );
        }

        final LiveTrackingDataModel? data = state is GetLiveTrackingDataSuccess
            ? state.data
            : null;

        final initialCenter = data != null
            ? AppLatLng(data.orderLat, data.orderLng)
            : const AppLatLng(0, 0);
        final initialZoom = data != null ? 14.0 : 2.0;

        return Stack(
          children: [
            AppMapView(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              markers: _markers,
              polylines: _polylines,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onMapReady: (controller) {
                _mapController = controller;
                if (data != null) _updateMap(data);
              },
            ),
            if (state is GetLiveTrackingDataLoading)
              CustomCircularProgressIndicator(
                color: Theme.of(context).colorScheme.accentColor,
              ),
            if (state is GetLiveTrackingDataSuccess &&
                !state.data.hasHandymanLocation)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: CustomContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  borderRadius: 8,
                  color: context.colorScheme.secondaryColor,
                  child: Row(
                    children: [
                      const Icon(Icons.location_searching, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          'waitingForLocation'.translate(context: context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
