import 'dart:developer';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:fixit_provider/config.dart';

class AddExtraChargesProvider with ChangeNotifier {
  TextEditingController chargeTitleCtrl = TextEditingController();
  TextEditingController perServiceAmountCtrl = TextEditingController();
  FocusNode chargeTitleFocus = FocusNode();
  FocusNode perServiceAmountFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BookingModel? bookingModel;
  int val = 1;

  //on add service
  onAddService() {
    val++;
    notifyListeners();
  }

  //on remove service
  onRemoveService() {
    if (val > 1) {
      val--;
      notifyListeners();
    }
  }

  deleteExtraCharges(context, {int? extraChargeId}) async {
    await apiServices
        .deleteApi(
            "${api.booking}/${bookingModel?.id}/extra-charges/$extraChargeId",
            [],
            isToken: true)
        .then((value) async {
      if (value.isSuccess!) {
        final userApi =
            Provider.of<OngoingBookingProvider>(context, listen: false);
        await userApi.getBookingDetailById(context, bookingModel!.id);
        log("FFFFFFF::${value.data}");

        showSuccessToast(context, value.message);
      } else {
        log("FFFFFFF ELSE::${value.data}");

        showErrorToast(context, value.message);
      }
    });
  }

  //add charges
  onAddCharge(context) {
    if (formKey.currentState!.validate()) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context1) {
            return const UpdateBillSummaryBottom();
          });
    }
  }

  //on update bill
  onUpdateBill(context) {
    addExtraServiceApi(context);

    notifyListeners();
  }

  //on page initialise data fetch
  onInit(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    bookingModel = data;
    notifyListeners();
  }

  //add extra service api
  bool isExtraChargeLoader = false;

  addExtraServiceApi(context) async {
    isExtraChargeLoader = true;
    try {
      showLoading(context);
      notifyListeners();

      var body = {
        "booking_id": bookingModel!.id,
        "title": chargeTitleCtrl.text,
        "per_service_amount": int.parse(perServiceAmountCtrl.text) * val,
        "no_service_done": val,
        "payment_method": bookingModel!.paymentMethod
      };

      log("BODY L$body");
      await apiServices
          .postApi(api.addExtraServiceCharge, body, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH :${value.isSuccess}");
        if (value.isSuccess!) {
          createBookingNotification(NotificationType.extraChargeEvent);
          final userApi =
              Provider.of<OngoingBookingProvider>(context, listen: false);
          await userApi.getBookingDetailById(context, bookingModel!.id);
          isExtraChargeLoader = false;
          notifyListeners();
          showSuccessToast(context, value.message);

          route.pop(context);
          chargeTitleCtrl.text = "";
          perServiceAmountCtrl.text = "";
          val = 1;
          route.pop(context);
          notifyListeners();
        } else {
          isExtraChargeLoader = false;
          notifyListeners();
          final userApi =
              Provider.of<OngoingBookingProvider>(context, listen: false);
          await userApi.getBookingDetailById(context, bookingModel!.id);
          route.pop(context);
          showErrorToast(context, value.message);
        }
      });
    } catch (e) {
      isExtraChargeLoader = false;
      hideLoading(context);
      notifyListeners();
      log("EEEE addExtraServiceApi : $e");
    }
  }
}
