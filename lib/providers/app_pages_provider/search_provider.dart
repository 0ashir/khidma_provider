import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:fixit_provider/config.dart';

class SearchProvider with ChangeNotifier {
  AnimationController? animationController;
  SharedPreferences? pref;
  TextEditingController searchCtrl = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<Services> searchList = [];
  List<Services> recentSearchList = [];
  bool isSearch = false;

  //page init preference initialise
  onReady() async {
    pref = await SharedPreferences.getInstance();

    notifyListeners();
  }

  //get recent search list
  getRecentSearch() {
    dynamic save = pref!.getString(session.recentSearch);

    if (save != null) {
      final List<dynamic> jsonData =
          jsonDecode(pref!.getString(session.recentSearch) ?? '[]');

      recentSearchList = jsonData.map<Services>((jsonList) {
        return Services.fromJson(jsonList);
      }).toList();
      notifyListeners();
    }
  }

  //on search clear tap
  searchClear() {
    searchCtrl.text = "";
    isSearch = false;
    notifyListeners();
  }

//on tap services list save in local and redirect to detail page
  onTapFeatures(context, Services? services, id) async {
    List<Services> saveList = [];
    dynamic save = pref!.getString(session.recentSearch);

    if (save == null) {
      saveList.add(services!);
    } else {
      final List<dynamic> jsonData =
          jsonDecode(pref!.getString(session.recentSearch) ?? '[]');

      saveList = jsonData.map<Services>((jsonList) {
        return Services.fromJson(jsonList);
      }).toList();
      log("jsonData :${saveList.length}");
      if (saveList.length == 5) {
        saveList.removeAt(0);
        saveList.add(services!);
      } else {
        int ind = saveList.indexWhere((element) => services!.id == element.id);
        log("ind:$ind");
        if (ind < 0) {
          saveList.add(services!);
        }
      }
    }

    recentSearchList = saveList;

    pref!.setString(session.recentSearch, jsonEncode(saveList));
    notifyListeners();
    route.pushNamed(context, routeName.serviceDetails,
        arg: {"detail": services!.id});
  }

  //update active status of service
  updateActiveStatusService(context, id, val, index) async {
    showLoading(context);

    if (searchList.isNotEmpty) {
      searchList[index].status = val == true ? 1 : 0;
    } else {
      recentSearchList[index].status = val == true ? 1 : 0;
    }
    notifyListeners();

    var body = {"status": val == true ? "1" : 0, "_method": "PUT"};
    dio.FormData formData = dio.FormData.fromMap(body);
    try {
      await apiServices
          .postApi("${api.service}/$id", formData, isToken: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.getPopularServiceList();
          if (recentSearchList.isNotEmpty) {
            pref!.setString(session.recentSearch, jsonEncode(recentSearchList));
          }
        } else {
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE updateActiveStatusService : $e");
    }
  }

  // search list
  searchService(context, {isPop = false}) async {
    notifyListeners();
    String apiUrl = "";
    apiUrl = "${api.providerServices}?search=${searchCtrl.text}";

    try {
      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        searchList = [];
        notifyListeners();
        if (value.isSuccess!) {
          for (var data in value.data) {
            if (!searchList.contains(Services.fromJson(data))) {
              searchList.add(Services.fromJson(data));
            }
          }
        }
        if (isPop) {
          route.pop(context);
        }
        if (searchList.isNotEmpty) {
          isSearch = false;
        } else {
          isSearch = true;
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE searchService $e");
      notifyListeners();
    }
  }
}
