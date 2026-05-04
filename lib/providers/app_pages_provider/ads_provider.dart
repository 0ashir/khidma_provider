import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../config.dart';
import '../../model/advertisement_model.dart';
import '../../screens/app_pages_screens/advertising_screens/common_adslist_layout.dart';

class AdsProvider extends ChangeNotifier {
  int tabIndex = 0;

  onReady(context) {
    getAdvertisementList(context);
  }

  // service list as per sub category tab change
  onTapTab(context, index, val) {
    tabIndex = index;
    log("aacepe :$val");
    if (val == "all") {
      getAdvertisementList(context);
    } else {
      getAdvertisementList(context, status: val);
    }
    notifyListeners();
  }

  // // Group ads list data by status
  // groupAdsByStatus() {
  //   var groupedData = {};
  //   for (var ad in appArray.adsListData) {
  //     final status = ad["status"] ?? "unknown";
  //     if (!groupedData.containsKey(status)) {
  //       groupedData[status] = [];
  //     }
  //     groupedData[status]!.add(ad);
  //   }
  //   return groupedData;
  // }
  bool isLoading = false;
//advertisement List
  getAdvertisementList(context, {status}) async {
    try {
      isLoading = true;
      // showLoading(context);
      String apiUrl = api.advertisement;
      if (status != null) {
        if (status == "All") {
          apiUrl = api.advertisement;
        } else {
          apiUrl = "${api.advertisement}?status=$status";
        }
      }

      log("apiUrl :$apiUrl");
      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        log("AA :${value.data}");
        advertisementList = [];
        hideLoading(context);
        if (value.isSuccess!) {
          isLoading = false;
          log("advertisementList::${value.data}");
          if (value.data != null || value.data != [] || value.data.isNotEmpty) {
            for (var d in value.data) {
              advertisementList.add(AdvertisementModel.fromJson(d));
            }
            notifyListeners();
          } else {
            log("asjdfuasyfaduih");
          }
          notifyListeners();
        } else {
          log("asjdfuasyfaduiSSSSSSh");
          isLoading = false;
          snackBarMessengers(context, message: value.message);
        }
        notifyListeners();
      });
    } catch (e) {
      hideLoading(context);
      isLoading = false;
      log("ERRROEEE getAdvertisementList : $e");
      notifyListeners();
    }
  }

  onBack(context, {isBack = false}) {
    tabIndex = 0;
    notifyListeners();
    getAdvertisementList(context);
    if (isBack) {
      route.pop(context);
    }
  }
}
