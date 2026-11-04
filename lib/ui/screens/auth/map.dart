import 'package:edemand_partner/ui/widgets/bottomSheets/layouts/locationBottomSheet.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../../app/generalImports.dart';
import '../map/appMap/appMapController.dart';
import '../map/appMap/appMapTypes.dart';
import '../map/appMap/appMapView.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key, this.longitude, this.latitude});

  final String? latitude;
  final String? longitude;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  StreamController markerController = StreamController();
  AppMapController? _mapController;

  String? selectedLatitude;
  String? selectedLongitude;
  AppLatLng initialCenter = const AppLatLng(0.00, 0.00);
  String lineOneAddress = '';
  String lineTwoAddress = '';
  String? locality;
  List<Placemark> placeMark = [];
  String? mapStyle;

  @override
  void initState() {
    super.initState();

    setMapStyle();
    setMapIcon();
  }

  @override
  void dispose() {
    markerController.close();
    super.dispose();
  }

  Future<void> setMapIcon() async {
    if (widget.latitude != '' && widget.longitude != '') {
      selectedLongitude = widget.longitude;
      selectedLatitude = widget.latitude;
      final AppLatLng latLong = AppLatLng(
        double.parse(widget.latitude != '' ? widget.latitude! : '22.00'),
        double.parse(widget.longitude != '' ? widget.longitude! : '92.00'),
      );
      markerController.sink.add([AppMapMarker(id: '1', position: latLong)]);

      initialCenter = latLong;

      createAddressFromCoordinates(
        latitude: double.parse(
          widget.latitude != '' ? widget.latitude! : '90.00',
        ),
        longitude: double.parse(
          widget.longitude != '' ? widget.longitude! : '180.00',
        ),
      );
    }
  }

  Future<void> setMapStyle() async {
    if (context.read<AppThemeCubit>().state.appTheme == AppTheme.dark) {
      mapStyle = await rootBundle.loadString('assets/mapTheme/darkMap.json');
    } else {
      mapStyle = await rootBundle.loadString('assets/mapTheme/lightMap.json');
    }
  }

  Future<void> _onTapMap(double latitude, double longitude) async {
    _placeMarkerOnLatitudeAndLongitude(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'selectLocation'.translate(context: context),
        elevation: 1,
        statusBarColor: context.colorScheme.secondaryColor,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          } else {
            Future.delayed(
              const Duration(milliseconds: 1000),
            ).then((value) => Navigator.pop(context));
          }
        },
        child: StreamBuilder(
          stream: markerController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Stack(
              children: [
                AppMapView(
                  googleMapStyle: mapStyle,
                  zoomControlsEnabled: false,
                  markers: snapshot.data != null
                      ? List<AppMapMarker>.from(snapshot.data)
                      : const [],
                  initialCenter: initialCenter,
                  initialZoom: 16,
                  onTap: _onTapMap,
                  onMapReady: (controller) {
                    _mapController = controller;
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        BlocProvider(
                          create: (context) => GooglePlaceAutocompleteCubit(),
                          child: Expanded(
                            child: CustomInkWellContainer(
                              onTap: () {
                                UiUtils.showModelBottomSheets(
                                  constraints: BoxConstraints(
                                    maxHeight: context.screenHeight * 0.8,
                                  ),
                                  enableDrag: true,
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  child: BlocProvider(
                                    create: (_) =>
                                        GooglePlaceAutocompleteCubit(),
                                    child: const LocationBottomSheet(),
                                  ),
                                  context: context,
                                ).then((final value) {
                                  if (value != null) {
                                    if (value['navigateToMap']) {
                                      _placeMarkerOnLatitudeAndLongitude(
                                        latitude: double.parse(
                                          value['latitude'].toString(),
                                        ),
                                        longitude: double.parse(
                                          value['longitude'].toString(),
                                        ),
                                      );
                                    }
                                  }
                                });
                              },
                              child: CustomContainer(
                                // margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(15),
                                height: 50,
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryColor,
                                borderRadius: UiUtils.borderRadiusOf10,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.lightGreyColor,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: CustomText(
                                        'searchLocation'.translate(
                                          context: context,
                                        ),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.lightGreyColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomSvgPicture(
                                        svgImage: AppAssets.search,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CustomInkWellContainer(
                          onTap: () {
                            context
                                .read<FetchUserCurrentLocationCubit>()
                                .fetchUserCurrentLocation();
                          },
                          child:
                              BlocConsumer<
                                FetchUserCurrentLocationCubit,
                                FetchUserCurrentLocationState
                              >(
                                listener: (context, state) {
                                  if (state
                                      is FetchUserCurrentLocationSuccess) {
                                    _placeMarkerOnLatitudeAndLongitude(
                                      latitude: state.position.latitude,
                                      longitude: state.position.longitude,
                                    );
                                  } else if (state
                                      is FetchUserCurrentLocationFailure) {
                                    UiUtils.showMessage(
                                      context,
                                      state.errorMessage.translate(
                                        context: context,
                                      ),
                                      ToastificationType.error,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  Widget? child;
                                  if (state
                                      is FetchUserCurrentLocationInProgress) {
                                    child = CustomCircularProgressIndicator(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                    );
                                  }
                                  return CustomContainer(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.accentColor,
                                    borderRadius: UiUtils.borderRadiusOf10,
                                    width: 50,
                                    height: 50,
                                    child:
                                        child ??
                                        Icon(
                                          Icons.my_location_outlined,
                                          size: 25,
                                          color: AppColors.whiteColors,
                                        ),
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (lineOneAddress.isNotEmpty)
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: CustomContainer(
                      margin: const EdgeInsets.all(15),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.secondaryColor,
                      borderRadiusStyle: const BorderRadius.only(
                        topLeft: Radius.circular(UiUtils.borderRadiusOf20),
                        topRight: Radius.circular(UiUtils.borderRadiusOf20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  15,
                                  10,
                                  15,
                                  10.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            lineOneAddress,
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.blackColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            lineTwoAddress,
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.lightGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 12,
                              ),
                              child: CustomRoundedButton(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.accentColor,
                                widthPercentage: 0.9,
                                showBorder: false,
                                height: 43,
                                buttonTitle: 'confirmAddress'.translate(
                                  context: context,
                                ),
                                onTap: () {
                                  // Nothing picked yet (no location access
                                  // and no tap on the map).
                                  if (selectedLatitude == null ||
                                      selectedLongitude == null) {
                                    return;
                                  }
                                  Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () {
                                      if (!context.mounted) return;
                                      Navigator.pop(context, {
                                        'selectedLatitude': selectedLatitude!
                                            .trimLatLong(),
                                        'selectedLongitude': selectedLongitude!
                                            .trimLatLong(),
                                        'selectedAddress':
                                            '$lineOneAddress,$lineTwoAddress'
                                                .removeExtraComma(),
                                        'selectedCity': locality ?? '',
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _placeMarkerOnLatitudeAndLongitude({
    required double latitude,
    required double longitude,
  }) async {
    selectedLatitude = latitude.toString();
    selectedLongitude = longitude.toString();

    final AppLatLng latLong = AppLatLng(latitude, longitude);

    markerController.sink.add([AppMapMarker(id: '1', position: latLong)]);

    await _mapController?.animateTo(latLong, zoom: 15);

    createAddressFromCoordinates(latitude: latitude, longitude: longitude);
  }

  Future<void> createAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    placeMark = await Geocoding().placemarkFromCoordinates(latitude, longitude);
    if (placeMark.isEmpty) {
      locality = null;
      lineOneAddress = '';
      lineTwoAddress = '';
    } else {
      final Placemark place = placeMark[0];
      locality = place.locality;
      // Geocoding leaves parts it does not know null; '$part' would print
      // "null" into the saved address.
      lineOneAddress = [
        place.name,
        place.subLocality,
        place.locality,
        place.country,
      ].map((part) => part ?? '').join(',').removeExtraComma();
      lineTwoAddress = (place.postalCode ?? '').removeExtraComma();
    }

    if (mounted) setState(() {});
  }
}
