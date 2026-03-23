import 'dart:developer';

import 'package:fixit_provider/config.dart';

class PendingApprovalBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  List statusList = [];
  String amount = "0", id = "";

  TextEditingController reasonCtrl = TextEditingController();
  onReady(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    id = data.toString();
    //pendingApprovalBookingModel = PendingBookingModel.fromJso
    notifyListeners();
    getBookingDetailById(context);
  }

  bool isLoading = false;
//booking detail by id
  getBookingDetailById(context) async {
    isLoading = true;
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          isLoading = false;

          notifyListeners();
          debugPrint("BOOKING DATA Is CALLING: ${value.data["data"]}");
          bookingModel = BookingModel.fromJson(value.data["data"]);

          log("BOOKING DATA Is CALLING: $bookingModel");
          notifyListeners();
        } else {
          isLoading = false;
          snackBarMessengers(context, message: value.message);
          notifyListeners();
        }
      });
      hideLoading(context);

      notifyListeners();
    } catch (e, s) {
      isLoading = false;
      hideLoading(context);
      debugPrint("BOOKING DATA Is CALLING: $e, $s");
      notifyListeners();
    }
  }
}
