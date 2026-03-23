import 'package:fixit_provider/config.dart';

class SelectServiceProvider with ChangeNotifier {
  List<Services> selectServiceList = [];

  TextEditingController searchCtrl = TextEditingController();
  FocusNode searchFocus = FocusNode();

  //image remove from list
  onImageRemove(index) {
    selectServiceList.removeAt(index);
    notifyListeners();
  }

  //service add to list and remove from list if already exists
  onSelectService(context, id, val, index) {
    if (!selectServiceList.contains(val)) {
      selectServiceList.add(val);
    } else {
      selectServiceList.removeAt(index);
    }
    notifyListeners();
  }
}
