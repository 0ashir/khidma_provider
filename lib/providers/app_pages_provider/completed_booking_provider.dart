import 'dart:developer';

import 'package:fixit_provider/config.dart';

class CompletedBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  String id = "";
  TextEditingController reasonCtrl = TextEditingController();

  onReady(context) {
    notifyListeners();
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    id = data.toString();
    log("ID : $id", name: "CompletedBookingProvider");
    getBookingDetailById(context, id);

    notifyListeners();
  }

  onBack(context, isBack) {
    // bookingModel = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context, bookingModel!.id);
    hideLoading(context);
    notifyListeners();
  }

  bool isLoading = false;
//booking detail by id
  getBookingDetailById(context, id) async {
    isLoading = true;
    try {
      log("object==========${api.booking}/$id");
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          isLoading = false;
          bookingModel = BookingModel.fromJson(value.data['data']);
          notifyListeners();
        } else {
          isLoading = false;
          snackBarMessengers(context, message: value.message);
        }
      });
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  //add proof routing
  addProofTap(context, {data}) {
    route.pushNamed(context, routeName.addServiceProof, arg: {
      "bookingModel": bookingModel,
      if (data != null) "data": data
    }).then((e) => getBookingDetailById(context, bookingModel!.id));
  }
}
