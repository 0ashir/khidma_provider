import 'package:geolocator/geolocator.dart';

class GetLocation {
  Future<void> requestPermission({
    ///if permission is allowed recently then onGranted method will invoke,
    Function(Position position)? onGranted,

    ///if permission is rejected  then onRejected method will invoke,
    Function()? onRejected,

    ///if permission is allowed already then allowed method will invoke,
    Function(Position position)? allowed,
    bool wantsToOpenAppSetting = false,
  }) async {
    final LocationPermission checkPermission =
        await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      final LocationPermission permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever &&
          wantsToOpenAppSetting) {
        //open app setting for permission
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        );

        onGranted?.call(position);
      } else {
        onRejected?.call();
      }
    } else if (checkPermission == LocationPermission.always ||
        checkPermission == LocationPermission.whileInUse) {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      allowed?.call(position);
    }
  }

  Future<Position?> getPosition() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      return position;
    }
    return null;
  }
}
