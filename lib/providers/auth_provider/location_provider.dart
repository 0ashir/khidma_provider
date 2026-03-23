import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fixit_provider/model/current_zone_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../../config.dart';
import 'dart:ui' as ui;

import '../../screens/auth_screens/current_location_screen/layouts/google.dart';

class LocationProvider with ChangeNotifier {
  AnimationController? animationController;
  LatLng? position, currentPosition;
  double? newLog, newLat;
  Position? position1;
  int primaryAddress = 0;
  String? currentAddress, street;
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  PrimaryAddress? address;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  dynamic argumentData;

  FocusNode areaFocus = FocusNode();
  FocusNode latitudeFocus = FocusNode();
  FocusNode longitudeFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();

  List<CountryStateModel> countryStateList = [];
  List<StateModel> stateList = [];

  Placemark? place;
  bool isEdit = false,
      isCompany = false,
      isServiceman = false,
      isAddressServiceman = false,
      isSignUp = false,
      isService = false;
  int count = 0;
  bool isNewPassword = true, isConfirmPassword = true;
  //fetch current location on click
  fetchCurrent(context) async {
    newLat = null;
    newLog = null;

    mapController!.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentPosition!.latitude, currentPosition!.longitude)));
    position = currentPosition;
    getAddressFromLatLng(context);
    notifyListeners();
  }

  //on map create controller initialize
  onController(controller) {
    mapController = controller;
    notifyListeners();
  }

  searchLocation(context) {
    route.push(context, SearchLocation()).then((e) async {
      if (e != null) {
        log("GET :$e");
        newLat = null;
        newLog = null;
        position = e;
        mapController!.animateCamera(CameraUpdate.newLatLng(
            LatLng(position!.latitude, position!.longitude)));
        notifyListeners();
        getAddressFromLatLng(context);
        notifyListeners();
      }
    });
  }

  //animation
  onAnimate(TickerProvider sync, context) async {
    animationController = AnimationController(
        vsync: sync, duration: const Duration(milliseconds: 1200));
    _runAnimation();
    notifyListeners();
  }

  //run movement
  void _runAnimation() async {
    for (int i = 0; i < 300; i++) {
      await animationController!.forward();
      await animationController!.reverse();
    }
  }

  // click on confirmation button add in list
  onTapLocationAdd(context) {
    final value = Provider.of<SignUpCompanyProvider>(context, listen: false);
    final location = Provider.of<LocationListProvider>(context, listen: false);
    appArray.serviceAvailableAreaList.add({
      "title": "${place!.name!} - ${place!.subLocality!}",
      "subtext": "${place!.country!} - ${place!.postalCode!}"
    });
    log("ADDED LIST ${appArray.serviceAvailableAreaList}");
    location.locationList.add({
      "title": "${place!.name!} - ${place!.subLocality!}",
      "subtext": "${place!.country!} - ${place!.postalCode!}",
      "latitude": "${position!.latitude}",
      "longitude": "${position!.longitude}",
      "zip": "${place!.postalCode}",
      "address":
          "${place!.street!}, ${place!.name!}, ${place!.subLocality!}, ${place!.administrativeArea!}",
    });
    value.notifyListeners();
    location.notifyListeners();
    notifyListeners();
  }

  // created method for getting user current location
  getUserCurrentLocation(context, {isRoute = false}) async {
    argumentData = ModalRoute.of(context)?.settings.arguments;

    if (argumentData != null) {
      if (argumentData['isSignUp'] != null) {
        isSignUp = true;
        await Geolocator.requestPermission().then((value) async {
          log("GEO LOCATION : $value");
          Position position1 = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          position = LatLng(position1.latitude, position1.longitude);
          currentPosition = LatLng(position1.latitude, position1.longitude);
          log("GET INIT LOC : $position");

          //hideLoading(context);
          notifyListeners();
          getAddressFromLatLng(context);
        }).onError((error, stackTrace) async {
          await Geolocator.requestPermission();
          log("ERROR $error");
        });
      } else {
        isSignUp = false;
        isCompany = argumentData["isCompany"] ?? false;
        isService = argumentData["isService"] ?? false;
        isAddressServiceman = argumentData["isAddressServiceman"] ?? false;
        if (userModel != null) {
          isServiceman = userModel!.role == "provider" ? false : true;
        }

        var arg = argumentData['data'];
        if (arg != null) {
          isEdit = true;
          address = arg;
          log("LAT : ${address!.latitude}// ${address!.longitude}");

          position = LatLng(double.parse(address!.latitude!),
              double.parse(address!.longitude!));

          log("ARGH :$position");
          notifyListeners();

          getAddressFromLatLng(context);
          notifyListeners();
        } else {
          await Geolocator.requestPermission().then((value) async {
            log("GEO LOCATION : $value");
            position1 = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);

            position = LatLng(position1!.latitude, position1!.longitude);
            currentPosition = LatLng(position1!.latitude, position1!.longitude);
            log("GET INIT LOC : $position");
            notifyListeners();
            getAddressFromLatLng(context);
          }).onError((error, stackTrace) async {
            await Geolocator.requestPermission();
            log("ERROR $error");
          });
        }
      }
    } else {
      await Geolocator.requestPermission().then((value) async {
        log("GEO LOCATION : $value");
        Position position1 = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        position = LatLng(position1.latitude, position1.longitude);
        currentPosition = LatLng(position1.latitude, position1.longitude);
        log("GET INIT LOC : $position");

        //hideLoading(context);
        notifyListeners();
        getAddressFromLatLng(context);
      }).onError((error, stackTrace) async {
        await Geolocator.requestPermission();
        log("ERROR $error");
      });
      isCompany = false;
    }

    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //fetch location detail as per lat long
  getAddressFromLatLng(context) async {
    //log("MESS :$position");
    await placemarkFromCoordinates(
            newLat ?? position!.latitude, newLog ?? position!.longitude)
        .then((List<Placemark> placeMarks) async {
      final locationVal =
          Provider.of<NewLocationProvider>(context, listen: false);
      place = placeMarks[0];
      markers = {};
      //log("place : ${placeMarks[0]}");
      currentAddress = '${place!.name}';
      street =
          '${place!.name}, ${place!.street}, ${place!.subLocality}, ${place!.subAdministrativeArea} ${place!.postalCode}';

      locationVal.latitudeCtrl.text = position!.latitude.toString();
      locationVal.longitudeCtrl.text = position!.longitude.toString();
      locationVal.zipCtrl.text = place!.postalCode!;
      locationVal.streetCtrl.text = place!.street!;
      locationVal.cityCtrl.text = place!.locality!;
      locationVal.countryCtrl.text = place!.country!;
      locationVal.stateCtrl.text = place!.administrativeArea!;
      //locationVal.countryCtrl.text = place!.country!;
      //locationVal.stateCtrl.text = place!.administrativeArea!;
      log("COUNTRY : ${place!.country}");
      locationVal.addressCtrl.text = place!.subLocality!;
      final Uint8List markerIcon =
          await getBytesFromAsset(eImageAssets.pin, 80);
      markers.add(Marker(
        draggable: true,
        onDrag: (value) {
          mapController!.animateCamera(
              CameraUpdate.newLatLng(LatLng(value.latitude, value.longitude)));
          notifyListeners();
        },
        onDragEnd: (value) {
          log("newLat :$value");
          newLat = value.latitude;
          newLog = value.longitude;
          position = LatLng(value.latitude, value.longitude);
          if (newLat != null && newLog != null) {
            getAddressFromLatLng(context);
          }
          notifyListeners();
        },
        markerId: MarkerId(
            LatLng(newLat ?? position!.latitude, newLog ?? position!.longitude)
                .toString()),
        position:
            LatLng(newLat ?? position!.latitude, newLog ?? position!.longitude),
        infoWindow: InfoWindow(title: place!.name, snippet: place!.subLocality),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));

      notifyListeners();
    }).catchError((e, s) {
      hideLoading(context);
      debugPrint("eeEE getAddressFromLatLng : $e==>$s");
    });
  }

  //location add successfully pop up
  onSuccess(context) {
    onTapLocationAdd(context);
    notifyListeners();
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              title: translations!.successfullyChanged,
              image: eGifAssets.successGif,
              subtext: translations!.congratulation,
              bText1: translations!.okay,
              height: Sizes.s145,
              b1OnTap: () {
                route.pop(context);
                route.pop(context);
                route.pop(context);
              });
        });
  }

  //edit location tap redirect to edit page
  onEdit(context) {
    if (isSignUp) {
      route.pop(context, arg: true);
    } else {
      log("argumentData :${argumentData}");
      route.pushNamed(context, routeName.addNewLocation,
          arg: {"argumentData": argumentData, "isService": isService});
    }
  }

  getZoneId() async {
    Position position1 = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
    log("position getZoneId:${position1.latitude}//${position1.longitude}");
    try {
      await apiServices.getApi(
          "${api.zoneByPoint}?lat=${position1.latitude}&lng=${position1.longitude}",
          []).then((value) async {
        log("CALUE :${value.data}");
        if (value.isSuccess!) {
          List o = value.data;
          String idsString = o.map((obj) => obj['id'].toString()).join(',');

          for (var data in value.data) {
            currentZoneModel.add(Datum.fromJson(data));
            notifyListeners();
          }
          zoneIds = idsString;
          // log("string :$idsString");
          // log("string :${currentZoneModel.first.currency?.code}");

          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString(session.zoneIds, idsString);

          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: value.messsage);
        }
        notifyListeners();
      });
    } catch (e, s) {
      log("cc $e====> $s");
      notifyListeners();
    }
  }
}
