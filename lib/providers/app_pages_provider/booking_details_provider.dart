import 'dart:developer';

import 'package:fixit_provider/config.dart';

class BookingDetailsProvider with ChangeNotifier {
  Histories? commission;
  BookingModel? bookingModel;

  onReady(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    notifyListeners();
    commission = data;
    showLoading(context);
    notifyListeners();
    getBookingDetailById(context, commission?.booking?.id);
  }

  bool isLoading = false;
  //booking detail by id
  getBookingDetailById(context, id) async {
    isLoading = true;
    log("idDddd::$id");
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        log("BookingDetails::${value.data}");
        if (value.isSuccess!) {
          isLoading = false;
          hideLoading(context);

          notifyListeners();
          bookingModel = BookingModel.fromJson(value.data['data']);
          notifyListeners();
        } else {
          hideLoading(context);
          snackBarMessengers(context, message: value.message);
          notifyListeners();
        }
      });
    } catch (e, s) {
      isLoading = false;
      hideLoading(context);
      print("object===========> $e,========> $s");
      notifyListeners();
    }
  }

  onTapPhone(phone, context) {
    if (phone != null) {
      launchCall(context, phone);
      notifyListeners();
    }
  }
}
