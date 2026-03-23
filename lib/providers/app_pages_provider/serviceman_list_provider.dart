import 'dart:developer';

import 'package:fixit_provider/config.dart';

class ServicemanListProvider with ChangeNotifier {
  double widget1Opacity = 0.0;
  List statusList = [];
  int selectIndex = 0;
  String? yearValue;
  List<ServicemanModel> searchList = [];
  String? expValue;
  TextEditingController categoryCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();

  FocusNode searchFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();

  //year selection option
  onTapYear(val) {
    yearValue = val;
    notifyListeners();
  }

  onReady(context) {
    isServicemenLoading = true;
    getServicemenByProviderId(context);
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      widget1Opacity = 1;
      notifyListeners();
    });
  }

  //on refresh
  onRefresh(context) async {
    log("onRefresh");
    notifyListeners();
    await getServicemenByProviderId(context);
    notifyListeners();
  }

  //serviceman list as per experience filter selection
  onExperience(val, context) {
    log("HHHH :$val");
    expValue = val;
    notifyListeners();
    if (expValue == translations!.allServicemen) {
      searchList = [];
      expValue = null;
      notifyListeners();
      getServicemenByProviderId(context);
    } else {
      getServicemenByProviderId(context);
    }
    log("expValue :$expValue");
  }

  //category add in and remove from list if already added
  onCategoryChange(context, id) {
    if (!statusList.contains(id)) {
      statusList.add(id);
    } else {
      statusList.remove(id);
    }
    notifyListeners();
  }

  //filer option select
  onFilter(index) {
    selectIndex = index;
    notifyListeners();
  }

  //filter bottom sheet open
  onTapFilter(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) {
        return const ServicemenBookingFilterLayout();
      },
    );
  }

  //get serviceman by provider id
  bool isServicemenLoading = false;
  bool isServicemenSearchLoading = false;

  getServicemenByProviderId(BuildContext context, {val}) async {
    log("searchCtrl.text::${searchCtrl.text}");
    if (searchCtrl.text.isNotEmpty) {
      isServicemenSearchLoading = true;
    } else {
      isServicemenLoading = true;
    }

    notifyListeners();
    try {
      log("expValue ss:$expValue");
      String exp = expValue.toString().contains("Highest Experience") ||
              expValue.toString().contains("Highest Served")
          ? "high"
          : "low";
      log("exp::${exp}///$expValue");
      String apiUrl = "";
      if (searchCtrl.text.isEmpty) {
        if (expValue != null) {
          if (expValue.toString().contains("Highest Experience") ||
              expValue.toString().contains("lowest Experience")) {
            log("expValue::Experience $expValue");
            apiUrl =
                "${api.serviceman}?provider_id=${userModel!.id}&experience=$exp&search=${searchCtrl.text}";
          } else {
            log("expValue::served $expValue");
            String sortOrder = exp == "high" ? "desc" : "asc";

            apiUrl = "${api.serviceman}"
                "?provider_id=${userModel!.id}"
                "&field=served"
                "&sort=$sortOrder"
                "&search=${searchCtrl.text}";
          }
        } else {
          apiUrl = "${api.serviceman}?provider_id=${userModel!.id}";
        }
      } else {
        apiUrl =
            "${api.serviceman}?provider_id=${userModel!.id}&search=${searchCtrl.text}";
      }

      log("APPPP :$apiUrl");

      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          log("SERVICEMAN DATA : ${value.data.length}");
          List data = value.data;

          if (searchCtrl.text.isNotEmpty) {
            searchList = [];

            for (var list in data) {
              if (!searchList.contains(ServicemanModel.fromJson(list))) {
                searchList.add(ServicemanModel.fromJson(list));
              }
            }
          } else {
            servicemanList = [];

            for (var list in data) {
              if (!servicemanList.contains(ServicemanModel.fromJson(list))) {
                servicemanList.add(ServicemanModel.fromJson(list));
              }
            }
          }
        }
        
        if (searchCtrl.text.isNotEmpty) {
          isServicemenSearchLoading = false;
        } else {
          isServicemenLoading = false;
        }
        notifyListeners();
      });
    } catch (e) {
      if (searchCtrl.text.isNotEmpty) {
        isServicemenSearchLoading = false;
      } else {
        isServicemenLoading = false;
      }

      notifyListeners();
    }
  }

  onBack(context, isBack) {
    searchCtrl.text = "";
    expValue = null;
    servicemanList = [];
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
    /* getServicemenByProviderId(context); */
  }
}
