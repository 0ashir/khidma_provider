import 'package:fixit_provider/config.dart';

class OngoingBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  String? amount, id;
  bool isServicemen = false;
  TextEditingController reasonCtrl = TextEditingController();

  onReady(context) {
    isServicemen = userModel!.role == "provider" ? false : true;
    final args = ModalRoute.of(context)!.settings.arguments;
    id = (args ?? '').toString();
    getBookingDetailById(context, id);
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

  //update status
  updateStatus(context, id) async {
    route.pop(context);
    Provider.of<UserDataApiProvider>(context, listen: false)
        .getBookingHistory(context);
    route.pushNamed(context, routeName.completedBooking, arg: id);
  }

//booking detail by id
  getBookingDetailById(context, id) async {
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {

          bookingModel = BookingModel.fromJson(value.data['data']);
          notifyListeners();
        }
      });

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  //go to add charges pages and in fetch data after com back
  addCharges(context) {
    route
        .pushNamed(context, routeName.addExtraCharges, arg: bookingModel)
        .then((e) {
      getBookingDetailById(context, bookingModel!.id);
    });
  }
}
