import '../../config.dart';

class ProviderDetailsProvider with ChangeNotifier {
  int selectIndex = 0;
  int selectProviderIndex = 0;
  List<CategoryModel> categoryList = [];
  List<Services> serviceList = [];
  bool visible = true;
  int val = 1;
  double loginWidth = 100.0;
  int providerId = 0;
  ProviderModel? provider;

  //page init data fetch
  onReady(context, {id}) async {
    dynamic data;
    if (id != null) {
      data = id;
    } else {
      data = ModalRoute.of(context)!.settings.arguments;
      notifyListeners();
      debugPrint("data : $data");
    }
  }
}
