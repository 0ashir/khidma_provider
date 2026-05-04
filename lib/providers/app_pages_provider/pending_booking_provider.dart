import 'dart:developer';

import 'package:fixit_provider/utils/toast_utils.dart';

import '../../config.dart';

class PendingBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  String? id;
  TextEditingController reasonCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  FocusNode reasonFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> amountFormKey = GlobalKey<FormState>();

  bool isServicemen = false, isAmount = false, isNotify = false;

  onReady(context) {
    isLoading = true;
    notifyListeners();
    final args = ModalRoute.of(context)!.settings.arguments;
    id = (args ?? '').toString();
    getBookingDetailById(context, id);
    notifyListeners();
  }

  onRefresh(context) async {
    // showLoading(context);
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
    print("object===========> ${api.booking}/$id");
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          isLoading = false;
          notifyListeners();
          debugPrint("BOOKING DATA : ${value.data['data']}");
          bookingModel = BookingModel.fromJson(value.data["data"]);

          log("BOOKING DATA Is CALLING:${bookingModel!.toJson()}");
          notifyListeners();
        } else {
          isLoading = false;
          Navigator.pushReplacementNamed(context, routeName.intro);
          showErrorToast(context, value.message);
        }
      });

      notifyListeners();
    } catch (e, s) {
      isLoading = false;
      print("object===========> $e,========> $s");
      notifyListeners();
    }
  }

  onRejectBooking(context) {
    showDialog(
        context: context,
        builder: (context1) => AppAlertDialogCommon(
            isField: true,
            validator: (value) {
              if (value!.isEmpty) {
                return language(context, "Please enter reason");
              }
              return null;
            } /* => validation.commonValidation(context, value) */,
            focusNode: reasonFocus,
            controller: reasonCtrl,
            title: translations!.reasonOfRejectBooking,
            singleText: translations!.send,
            globalKey: formKey,
            singleTap: () {
              if (formKey.currentState!.validate()) {
                updateStatus(context, bookingModel!.id, isCancel: true);
              }
              notifyListeners();
            })).then((value) {
      reasonCtrl.text = "";
      notifyListeners();
    });
  }

  //update status
  bool isLoadingStatus = false;

  updateStatus(
    BuildContext context,
    id, {
    bool isCancel = false,
    bool isBack = false,
    bool isServiceAssgn = false,
  }) async {
    isLoadingStatus = true;
    notifyListeners();
    try {
      log("id khjdfjkadsfhkads $id");
      // showLoading(context);

      notifyListeners();
      dynamic data;
      if (isCancel) {
        data = {
          "reason": reasonCtrl.text,
          "booking_status":
              translations?.cancel ?? "cancelled", // Null-safe translations
        };
      } else {
        data = isServiceAssgn == true
            ? {"booking_status": appFonts.assigned}
            : {"booking_status": appFonts.accepted};
      }

      log("DATA: $data");
      await apiServices
          .putApi("${api.booking}/$id", data, isToken: true, isData: true)
          .then((value) {
        isLoadingStatus = false;
        loading = false;
        hideLoading(context);
        notifyListeners();

        if (value.isSuccess == true && value.data != null) {
          createBookingNotification(NotificationType.updateBookingStatusEvent);
          getBookingDetailById(context, id);

          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          final dash = Provider.of<UserDataApiProvider>(context, listen: false);
          dash.getBookingHistory(context);
          commonApi.getDashBoardApi(context);

          try {
            bookingModel = BookingModel.fromJson(value.data);
          } catch (e) {
            log("Error parsing BookingModel: $e");
            snackBarMessengers(context,
                message: "Failed to parse booking data");
            return;
          }

          // Update user booking history
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          userApi.getBookingHistory(context);
          userApi.notifyListeners();

          if (isCancel) {
            reasonCtrl.text = "";
            isLoadingStatus = true;
            route.pop(context);
            route.pop(context);
            notifyListeners();
            if (isBack) {
              log("=======${bookingModel!.id}");
              // Pop two screens for cancellation
              /*  Navigator.popUntil(
                  context, (route) => route.isFirst); // Clear stack to root
              route.pushNamed(context, routeName.cancelledBooking,
                  arg: bookingModel!.id); */
            } else {
              log("=======23${bookingModel!.id}");
              /*  Navigator.pop(context); // Pop current screen
              route.pushNamed(context, routeName.cancelledBooking,
                  arg: bookingModel!.id); */
            }
          } else {
            log("Booking ID: ${bookingModel!.id}");
            // Show dialog for accepted booking
            showDialog(
                context: context,
                builder: (context1) => AppAlertDialogCommon(
                    height: Sizes.s100,
                    title: translations?.assignBooking ?? "Assign Booking",
                    firstBText: translations?.doItLater ?? "Do it later",
                    secondBText: translations?.yes ?? "Yes",
                    image: eGifAssets.dateGif,
                    subtext:
                        translations?.doYouWant ?? "Do you want to assign now?",
                    firstBTap: () {
                      Navigator.pop(context1); // Close dialog
                      Navigator.pop(context); // Pop previous screen
                    },
                    secondBTap: () {
                      log("DDDDD");

                      Navigator.pop(context1); // Close dialog
                      Navigator.pop(context1);
                      userApi.getBookingHistory(context);
                      userApi.notifyListeners();
                      route.pushNamed(context, routeName.acceptedBooking,
                          arg: bookingModel!.id);
                      notifyListeners();
                    }));
          }
        } else {
          isLoadingStatus = false;
          loading = false;
          notifyListeners();
          showErrorToast(context, value.message);
          /*  snackBarMessengers(context,
              message: value.message ?? "Failed to update booking status"); */
        }
      });
    } catch (e) {
      isLoadingStatus = false;
      loading = false;
      hideLoading(context);

      showErrorToast(context, e.toString());
      /*  snackBarMessengers(context, message: e.toString()); */
      notifyListeners();
    }
  }

  bool loading = false;

  //accept booking
  onAcceptBooking(context) {
    loading = true;
    updateStatus(context, bookingModel!.id,
        isServiceAssgn: bookingModel!.servicemen!.isEmpty ? false : true);
  }
}
