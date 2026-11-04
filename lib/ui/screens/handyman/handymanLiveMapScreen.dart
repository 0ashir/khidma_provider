import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

import '../../../app/generalImports.dart';
import '../map/appMap/appMapController.dart';
import '../map/appMap/appMapTypes.dart';
import '../map/appMap/appMapView.dart';

class HandymanLiveMapScreen extends StatefulWidget {
  const HandymanLiveMapScreen({super.key});

  static Route route(RouteSettings settings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => HandymanLiveMapCubit(),
        child: const HandymanLiveMapScreen(),
      ),
    );
  }

  @override
  State<HandymanLiveMapScreen> createState() => _HandymanLiveMapScreenState();
}

class _HandymanLiveMapScreenState extends State<HandymanLiveMapScreen> {
  AppMapController? _mapController;
  final List<AppMapMarker> _markers = [];
  HandymanLiveMapCubit? _cubit;
  bool _iconLoaded = false;
  BitmapDescriptor? _handymanIcon;
  String? _selectedHandymanId;
  late final PageController _cardPageController = PageController(
    viewportFraction: 0.92,
  );
  List<HandymanLiveMapItem> _currentHandymen = [];
  bool _didFitBounds = false;
  bool _isProgrammaticPageChange = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iconLoaded) {
      _iconLoaded = true;
      _loadMarkerIcon();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit = context.read<HandymanLiveMapCubit>();
      _cubit!.startPolling();
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

  Future<void> _loadMarkerIcon() async {
    final accentColor = Theme.of(context).colorScheme.accentColor;
    final data = await rootBundle.load(AppAssets.handyman);
    final loader = SvgStringLoader(utf8.decode(data.buffer.asUint8List()));
    final pictureInfo = await vg.loadPicture(loader, null);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const size = 48.0;
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
    if (!mounted) return;
    setState(() {
      _handymanIcon = BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
    });
  }

  @override
  void dispose() {
    _cubit?.onTransientError = null;
    _cubit?.stopPolling();
    _mapController?.dispose();
    _cardPageController.dispose();
    super.dispose();
  }

  void _updateMarkers(List<HandymanLiveMapItem> handymen) {
    _currentHandymen = handymen;
    final markers = handymen
        .map(
          (h) => AppMapMarker(
            id: h.handymanId,
            position: AppLatLng(h.latitude, h.longitude),
            anchor: const Offset(0.5, 0.5),
            infoWindowTitle: h.handymanName,
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
            onTap: () => _selectHandyman(h.handymanId, animatePage: true),
          ),
        )
        .toList();

    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
    });

    if (!_didFitBounds && handymen.isNotEmpty) {
      _didFitBounds = true;
      _fitToHandymen(handymen);
    }
  }

  void _fitToHandymen(List<HandymanLiveMapItem> handymen) {
    if (handymen.length == 1) {
      _mapController?.animateTo(
        AppLatLng(handymen.first.latitude, handymen.first.longitude),
        zoom: 14,
      );
      return;
    }
    double minLat = handymen.first.latitude;
    double maxLat = handymen.first.latitude;
    double minLng = handymen.first.longitude;
    double maxLng = handymen.first.longitude;
    for (final h in handymen) {
      if (h.latitude < minLat) minLat = h.latitude;
      if (h.latitude > maxLat) maxLat = h.latitude;
      if (h.longitude < minLng) minLng = h.longitude;
      if (h.longitude > maxLng) maxLng = h.longitude;
    }
    _mapController?.fitBounds(
      AppLatLng(minLat, minLng),
      AppLatLng(maxLat, maxLng),
      padding: 100,
    );
  }

  void _selectHandyman(
    String handymanId, {
    bool animateMap = true,
    bool animatePage = false,
  }) {
    setState(() => _selectedHandymanId = handymanId);
    final marker = _markers.where((m) => m.id == handymanId).firstOrNull;
    if (animateMap && marker != null) {
      _mapController?.animateTo(marker.position, zoom: 15);
    }
    if (animatePage) {
      final index = _currentHandymen.indexWhere(
        (h) => h.handymanId == handymanId,
      );
      if (index != -1 && _cardPageController.hasClients) {
        _isProgrammaticPageChange = true;
        _cardPageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onCardPageChanged(int index) {
    if (_isProgrammaticPageChange) {
      _isProgrammaticPageChange = false;
      return;
    }
    if (index < 0 || index >= _currentHandymen.length) return;
    _selectHandyman(_currentHandymen[index].handymanId, animateMap: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        backgroundColor: context.colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'handymanLocationsLbl'.translate(context: context),
        ),
        body: BlocConsumer<HandymanLiveMapCubit, HandymanLiveMapState>(
          listener: (context, state) {
            if (state is HandymanLiveMapSuccess) {
              _updateMarkers(state.handymen);
            }
          },
          builder: (context, state) {
            if (state is HandymanLiveMapFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessage: state.errorMessage.translate(context: context),
                  onTapRetry: () =>
                      context.read<HandymanLiveMapCubit>().startPolling(),
                ),
              );
            }

            final handymen = state is HandymanLiveMapSuccess
                ? state.handymen
                : <HandymanLiveMapItem>[];

            return Stack(
              children: [
                AppMapView(
                  initialCenter: handymen.isNotEmpty
                      ? AppLatLng(
                          handymen.first.latitude,
                          handymen.first.longitude,
                        )
                      : const AppLatLng(0, 0),
                  initialZoom: handymen.isNotEmpty ? 14 : 2,
                  markers: _markers,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  onMapReady: (controller) {
                    _mapController = controller;
                    if (handymen.isNotEmpty) _fitToHandymen(handymen);
                  },
                ),
                if (state is HandymanLiveMapLoading)
                  CustomCircularProgressIndicator(
                    color: Theme.of(context).colorScheme.accentColor,
                  ),
                if (state is HandymanLiveMapSuccess && handymen.isEmpty)
                  Center(
                    child: NoDataContainer(
                      title: 'noHandymanOnlineLbl'.translate(context: context),
                    ),
                  ),
                if (handymen.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildHandymanCardList(handymen),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openBookingDetails(HandymanLiveMapItem h) {
    Navigator.pushNamed(
      context,
      Routes.bookingDetails,
      arguments: {'bookingId': h.orderId},
    );
  }

  Widget _buildHandymanCardList(List<HandymanLiveMapItem> handymen) {
    return SafeArea(
      child: SizedBox(
        height: 120,
        child: PageView.builder(
          controller: _cardPageController,
          padEnds: false,
          onPageChanged: _onCardPageChanged,
          itemCount: handymen.length,
          itemBuilder: (context, index) {
            final h = handymen[index];
            final selected = h.handymanId == _selectedHandymanId;
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 8, bottom: 10),
              child: GestureDetector(
                onTap: () => _openBookingDetails(h),
                child: CustomContainer(
                  padding: const EdgeInsets.all(14),
                  borderRadius: UiUtils.borderRadiusOf10,
                  color: context.colorScheme.secondaryColor,
                  border: Border.all(
                    color: selected
                        ? context.colorScheme.accentColor
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.lightGreyColor.withValues(
                        alpha: 0.2,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              UiUtils.borderRadiusOf10,
                            ),
                            child: h.handymanImage.isNotEmpty
                                ? CustomCachedNetworkImage(
                                    imageUrl: h.handymanImage,
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                  )
                                : CustomContainer(
                                    height: 56,
                                    width: 56,
                                    color: context.colorScheme.accentColor
                                        .withValues(alpha: 0.1),
                                    child: Icon(
                                      Icons.person,
                                      color: context.colorScheme.accentColor,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  h.handymanName,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  maxLines: 1,
                                  color: context.colorScheme.blackColor,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    CustomText(
                                      '${'orderID'.translate(context: context)}: ',
                                      fontSize: 13,
                                      color: context.colorScheme.blackColor,
                                    ),
                                    CustomText(
                                      h.orderId,
                                      fontSize: 13,
                                      color: context.colorScheme.accentColor,
                                    ),
                                  ],
                                ),
                                if (h.averageRating != '0.0') ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 15,
                                        color: AppColors.starRatingColor,
                                      ),
                                      const SizedBox(width: 3),
                                      CustomText(
                                        h.averageRating,
                                        fontSize: 13,
                                        color: context.colorScheme.blackColor,
                                      ),
                                      const SizedBox(width: 4),
                                      CustomText(
                                        '(${h.totalReviews})',
                                        fontSize: 13,
                                        color:
                                            context.colorScheme.lightGreyColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: context.colorScheme.lightGreyColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
