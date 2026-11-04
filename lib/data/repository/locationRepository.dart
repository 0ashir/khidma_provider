import 'package:edemand_partner/app/generalImports.dart';
import 'package:geocoding/geocoding.dart';

class LocationRepository {
  static Future<Position> getLocationDataAndStoreIntoHive() async {
    final Position position = await Geolocator.getCurrentPosition(
      // desiredAccuracy: LocationAccuracy.low
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );

    return position;
  }

  static Future<void> requestPermission({
    ///if permission is allowed recently then onGranted method will invoke,
    final Function(Position position)? onGranted,

    ///if permission is rejected  then onRejected method will invoke,
    final Function()? onRejected,

    ///if permission is allowed already then allowed method will invoke,
    final Function(Position position)? allowed,
  }) async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      final LocationPermission permission =
          await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final Position position = await getLocationDataAndStoreIntoHive();
        onGranted?.call(position);
      } else {
        onRejected?.call();
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position position = await getLocationDataAndStoreIntoHive();
      allowed?.call(position);
    } else if (permission == LocationPermission.deniedForever) {}
  }

  static Future getCurrentLocationAndStoreDataIntoHive() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position position = await getLocationDataAndStoreIntoHive();

      final List<Placemark> placeMark = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return placeMark;
    }
  }

  static Future<Position?> getCurrentLocation() async {
    final LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position position = await Geolocator.getCurrentPosition(
        // desiredAccuracy: LocationAccuracy.low,
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      return position;
    } else if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      await requestPermission(
        allowed: (position) {
          return position;
        },
        onGranted: (position) {
          return position;
        },
        onRejected: () {
          return null;
        },
      );
    }
    return null;
  }
}
