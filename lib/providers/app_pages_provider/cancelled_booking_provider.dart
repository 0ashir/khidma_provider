import 'dart:developer';

import 'package:fixit_provider/config.dart';

class CancelledBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  String? id;

  onReady(context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    id = (args ?? '').toString();
    getBookingDetailById(context, id);
    log("id :$id");
    //  ongoingBookingModel = PendingBookingModel.fromJson( isServicemen ? appArray.ongoingBookingWithList : appArray.ongoingBookingList);
    notifyListeners();
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context, bookingModel!.id);
    hideLoading(context);
    notifyListeners();
  }

  onBack(context, isBack) {
    bookingModel = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  bool isLoading = false;
//booking detail by id
  getBookingDetailById(context, id) async {
    isLoading = true;
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          isLoading = false;
          debugPrint("BOOKING DATA Is CALLING: ${value.data}");
          bookingModel = BookingModel.fromJson(value.data['data']);
          debugPrint("BOOKING DATA Is CALLING: ${bookingModel?.toJson()}");
          notifyListeners();
        } else {
          isLoading = false;
          snackBarMessengers(context, message: value.message);
          notifyListeners();
        }
      });
      hideLoading(context);

      notifyListeners();
    } catch (e) {
      hideLoading(context);
      isLoading = false;
      notifyListeners();
    }
  }
}
