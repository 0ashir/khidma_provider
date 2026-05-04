import 'package:fixit_provider/config.dart';

class CommissionInfoProvider with ChangeNotifier {
  TextEditingController searchCtrl = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<CategoryModel> searchList = [];

  onReady(context) {
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    userApi.getCategory();
    searchCategory(context);
    notifyListeners();
  }

  //search category
  searchCategory(context) async {
    showLoading(context);
    searchList = [];
    notifyListeners();
    try {
      String apiUrl = "${api.category}?providerId=${userModel!.id}";
      if (searchCtrl.text.isNotEmpty && searchCtrl.text != "") {
        apiUrl =
            "${api.category}?providerId=${userModel!.id}&search=${searchCtrl.text}";
      } else {
        apiUrl = "${api.category}?providerId=${userModel!.id}";
      }
      await apiServices.getApi(apiUrl, []).then((value) {
        hideLoading(context);
        if (value.isSuccess!) {
          List category = value.data;
          for (var data in category.reversed.toList()) {
            if (!searchList.contains(CategoryModel.fromJson(data))) {
              searchList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });

      notifyListeners();
    } catch (e) {
      hideLoading(context);
      notifyListeners();
    }
    notifyListeners();
  }
}
