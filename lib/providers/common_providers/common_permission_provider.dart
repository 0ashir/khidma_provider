
import '../../config.dart';


class CommonPermissionProvider extends ChangeNotifier {
  //location permission
  Future<bool> checkIfLocationEnabled() async {

    if (await Permission.location.request().isGranted) {
      return true;
    } else if (await Permission.locationAlways.request().isGranted) {
      return true;
    } else if (await Permission.locationWhenInUse.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

}
