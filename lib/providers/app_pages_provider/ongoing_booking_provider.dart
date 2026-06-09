import 'dart:developer';
import 'package:fixit_provider/config.dart';

class OngoingBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  String? amount, id;
  bool isServicemen = false;
  bool isUpdating = false;
  TextEditingController reasonCtrl = TextEditingController();
  FocusNode reasonFocus = FocusNode();

  // Immediately reflects a status change in the UI before the server responds.
  // Cleared once getBookingDetailById brings back confirmed server data.
  String? _pendingSlug;
  String get currentSlug =>
      _pendingSlug ?? bookingModel?.bookingStatus?.slug ?? '';

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

  // Start service confirmation dialog
  onStart(context) {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              title: translations!.startService,
              image: eGifAssets.rocket,
              subtext: translations!.areYouSureStartService,
              height: Sizes.s145,
              isTwoButton: true,
              firstBText: translations!.cancel,
              secondBText: translations!.yes,
              firstBTap: () => route.pop(context),
              secondBTap: () {
                route.pop(context);
                _callUpdateStatus(context, appFonts.onGoing);
              });
        });
  }

  // Pause / restart confirmation dialog
  onPauseConfirmation(context, {bool isHold = true}) {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              isTwoButton: true,
              title: isHold ? "Hold Service" : "Restart Service",
              image: eGifAssets.error,
              subtext: isHold
                  ? "Are you sure you want to hold this service?"
                  : "Are you sure you want to restart this service?",
              height: Sizes.s145,
              firstBText: translations!.cancel,
              secondBText: translations!.yes,
              firstBTap: () => route.pop(context),
              secondBTap: () {
                route.pop(context);
                if (isHold) {
                  _showHoldReasonDialog(context);
                } else {
                  _callUpdateStatus(context, appFonts.startAgain);
                }
              });
        });
  }

  void _showHoldReasonDialog(context) {
    reasonCtrl.clear();
    showDialog(
        context: context,
        builder: (context1) => AppAlertDialogCommon(
              isField: true,
              focusNode: reasonFocus,
              controller: reasonCtrl,
              title: "Reason of Hold",
              singleText: translations!.submit,
              singleTap: () {
                if (reasonCtrl.text.isNotEmpty) {
                  route.pop(context);
                  _callUpdateStatus(context, appFonts.onHold1,
                      reason: reasonCtrl.text);
                }
              },
            ));
  }

  // Complete service confirmation dialog
  completeConfirmation(context) {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              isTwoButton: true,
              title: "Complete Service",
              image: eGifAssets.successGif,
              subtext: "Are you sure you want to complete this service?",
              height: Sizes.s145,
              firstBText: translations!.cancel,
              secondBText: translations!.yes,
              firstBTap: () => route.pop(context),
              secondBTap: () {
                route.pop(context);
                _callUpdateStatus(context, appFonts.completed);
              });
        });
  }

  // API call to update booking status — optimistic update:
  // the UI reflects the new status immediately; the server is synced in the
  // background. On server failure the previous status is restored.
  _callUpdateStatus(context, String status, {String? reason}) async {
    final currentId = bookingModel!.id;
    final previousSlug = _pendingSlug ?? bookingModel!.bookingStatus?.slug;
    showLoading(context);

    try {
      final data = reason != null
          ? {"reason": reason, "booking_status": status}
          : {"booking_status": status};

      log("OngoingBookingProvider updateStatus: $data");

      final response = await apiServices.putApi(
          "${api.booking}/$currentId", data,
          isToken: true, isData: true);

      hideLoading(context);

      if (response.isSuccess == true) {
        // Show new status buttons only after server confirms
        _pendingSlug = status;
        notifyListeners();
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        Provider.of<UserDataApiProvider>(context, listen: false)
            .loadBookingsFromLocal(context);
        if (status == translations!.completed || status == appFonts.completed) {
          route.pop(context);
          Provider.of<UserDataApiProvider>(context, listen: false)
              .getBookingHistory(context);
          route.pushNamed(context, routeName.completedBooking, arg: currentId);
        } else {
          getBookingDetailById(context, currentId);
        }
      } else {
        _pendingSlug = previousSlug;
        notifyListeners();
        snackBarMessengers(context, message: response.message);
      }
    } catch (e, s) {
      log("EEEE OngoingBookingProvider _callUpdateStatus: $e ====> $s");
      hideLoading(context);
      _pendingSlug = previousSlug;
      notifyListeners();
    }
  }

  // booking detail by id
  getBookingDetailById(context, id) async {
    try {
      final response = await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true);
      if (response.isSuccess == true && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          bookingModel = BookingModel.fromJson(data);
          _pendingSlug = null; // confirmed data is here — stop overriding
        }
      }
    } catch (e, s) {
      log("getBookingDetailById error: $e => $s");
    } finally {
      notifyListeners();
    }
  }

  // go to add charges page and refresh data after coming back
  addCharges(context) {
    route
        .pushNamed(context, routeName.addExtraCharges, arg: bookingModel)
        .then((e) {
      getBookingDetailById(context, bookingModel!.id);
    });
  }
}
