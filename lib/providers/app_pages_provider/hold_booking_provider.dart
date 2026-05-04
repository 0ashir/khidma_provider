import 'package:fixit_provider/config.dart';

class HoldBookingProvider with ChangeNotifier {
  String amount = "0", id = "id";

  BookingModel? bookingModel;

  TextEditingController reasonCtrl = TextEditingController();
  onReady(context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    id = (args ?? '').toString();

    notifyListeners();
    getBookingDetailById(context, id);
    //  holdBookingModel = PendingBookingModel.fromJson(appArray.holdBookingList);
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
          .getApi("${api.booking}/${id ?? bookingModel!.id}", [],
              isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          isLoading = false;
          debugPrint("BOOKING DATA Is CALLING: ${value.data}");
          bookingModel = BookingModel.fromJson(value.data['data']);
          notifyListeners();
        } else {
          isLoading = false;
          snackBarMessengers(context, message: value.message);
          notifyListeners();
        }
      });

      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}
