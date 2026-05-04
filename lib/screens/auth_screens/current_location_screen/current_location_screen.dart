// ignore_for_file: unused_local_variable, use_build_context_synchronously

import '../../../config.dart';

class CurrentLocationScreen extends StatelessWidget {
  const CurrentLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context1, value, child) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final bool isServiceman = args?['isServiceman'] ?? false;
      final PrimaryAddress? data = args?['data'];

      return StatefulWrapper(
          onInit: () => Future.delayed(DurationsDelay.ms150)
              .then((value1) => value.getUserCurrentLocation(context)),
          child: Scaffold(
              body: Stack(children: [
            GoogleMap(
                onTap: (LatLng tappedPoint) {
                  value.newLat = tappedPoint.latitude;
                  value.newLog = tappedPoint.longitude;
                  position = tappedPoint;
                  value.getAddressFromLatLng(context);
                },
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: true,
                fortyFiveDegreeImageryEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: value.position == null
                        ? const LatLng(0.0, 0.0)
                        : LatLng(value.position!.latitude,
                            value.position!.longitude),
                    zoom: 17),
                markers: value.markers,
                mapType: MapType.normal,
                onMapCreated: (controller) => value.onController(controller)),
            const BottomLocationLayout()
          ])));
    });
  }
}
