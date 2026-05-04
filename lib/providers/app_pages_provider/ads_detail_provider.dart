import 'dart:developer';

import 'package:fixit_provider/model/advertisement_details_model.dart';

import '../../config.dart';
import '../../model/advertisement_model.dart';

class AdsDetailProvider extends ChangeNotifier {
  int tabIndex = 0;
  AdvertisementDetailsModel? advertisingModel;
  int selectedIndex = 0;
  String? selectedImage;

  onHomeImageChange(index, value) {
    selectedIndex = index;
    selectedImage = value;
    log("selectedImage:$selectedImage");

    notifyListeners();
  }

  onReady(context, id) {
    /*  dynamic data = ModalRoute.of(context)!.settings.arguments ?? ""; */
    /* advertisingModel = data; */
    notifyListeners();
    /*  getAdvertisementList(context, id); */
  }

  onBack(context, {isBack = false}) {
    advertisingModel = null;
    selectedImage = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

//advertisement List
  getAdvertisementList(context, id) async {
    try {
      await apiServices
          .getApi("${api.advertisement}/$id", [], isToken: true, isData: true)
          .then((value) {
        hideLoading(context);
        if (value.isSuccess!) {
          // advertisingModel = null;
          log("messagevalue.data::${value.data['data']}");
          advertisingModel =
              AdvertisementDetailsModel.fromJson(value.data['data']);
          log("AA :${advertisingModel!.services}");
          notifyListeners();
        } else {
          snackBarMessengers(context, message: value.message);
        }

        notifyListeners();
      });
    } catch (e, s) {
      hideLoading(context);
      log("ERRROEEE getAdvertisementList : $e====$s");
      notifyListeners();
    }
  }
}
