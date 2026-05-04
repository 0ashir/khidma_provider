import 'dart:developer';

import 'package:fixit_provider/config.dart';

class ViewLocationProvider with ChangeNotifier {
  LatLng? position;
  GoogleMapController? mapController;
  Placemark? place;
  Set<Marker> markers = {};

  onController(controller) {
    mapController = controller;
    notifyListeners();
  }

  // page init data fetch and get location
  getUserCurrentLocation(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    log("data :$data");
    position =
        LatLng(double.parse(data['latitude']), double.parse(data['longitude']));
    getAddressFromLatLng(context);
    notifyListeners();
  }

  //get address detail from lat long
  getAddressFromLatLng(context) async {
    await placemarkFromCoordinates(position!.latitude, position!.longitude)
        .then((List<Placemark> placeMarks) async {
      place = placeMarks[0];
      markers = {};

      markers.add(Marker(
          draggable: true,
          markerId: MarkerId(
              LatLng(position!.latitude, position!.longitude).toString()),
          position: LatLng(position!.latitude, position!.longitude),
          infoWindow:
              InfoWindow(title: place!.name, snippet: place!.subLocality),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(devicePixelRatio: 2.5),
              eImageAssets.currentLocation) //Icon for Marker
          ));
      notifyListeners();
    }).catchError((e) {
      debugPrint("ee VIEW LOCATION: $e");
    });
  }
}
