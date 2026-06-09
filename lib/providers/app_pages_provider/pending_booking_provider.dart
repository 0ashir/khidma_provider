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
  bool isAssigningNow = false; // true while the self-assign API call is in flight

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
    notifyListeners();
    try {
      final response = await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true);
      if (response.isSuccess == true && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          bookingModel = BookingModel.fromJson(data);
          _pendingStatus = null; // real data arrived — stop overriding
        }
      }
    } catch (e, s) {
      log("getBookingDetailById pending error: $e => $s");
    } finally {
      isLoading = false;
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

  // Optimistic status slug — set immediately so the UI updates before the
  // server responds. Cleared once getBookingDetailById brings back real data.
  String? _pendingStatus;
  String get displayStatus =>
      _pendingStatus ?? bookingModel?.bookingStatus?.slug ?? '';

  bool isLoadingStatus = false;
  bool loading = false;

  onAcceptBooking(context) {
    loading = true;
    notifyListeners();
    _updateAcceptStatus(context, bookingModel!.id);
  }

  _updateAcceptStatus(BuildContext context, id) async {
    showLoading(context);
    try {
      final response = await apiServices.putApi(
          "${api.booking}/$id", {"booking_status": appFonts.accepted},
          isToken: true, isData: true);

      hideLoading(context);
      loading = false;

      if (response.isSuccess == true) {
        // Show "Assign Now" button only after server confirms acceptance
        _pendingStatus = appFonts.accepted;
        notifyListeners();
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        // Only refresh this booking's detail — skip full list + dashboard
        // to avoid redundant API calls; those refresh when the user navigates back.
        getBookingDetailById(context, id);
      } else {
        _pendingStatus = null;
        showErrorToast(context, response.message);
        notifyListeners();
      }
    } catch (e) {
      hideLoading(context);
      loading = false;
      _pendingStatus = null;
      showErrorToast(context, e.toString());
      notifyListeners();
    }
  }

  // Reject/cancel — keeps the reason dialog, then pops back on success.
  updateStatus(BuildContext context, id, {bool isCancel = false}) async {
    isLoadingStatus = true;
    notifyListeners();
    try {
      final data = {
        "reason": reasonCtrl.text,
        "booking_status": "cancel",
      };
      final response = await apiServices.putApi(
          "${api.booking}/$id", data,
          isToken: true, isData: true);
      isLoadingStatus = false;

      if (response.isSuccess == true) {
        reasonCtrl.text = "";
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        Provider.of<UserDataApiProvider>(context, listen: false)
            .getBookingHistory(context);
        route.pop(context); // close reason dialog
        route.pop(context); // pop booking detail
      } else {
        showErrorToast(context, response.message);
      }
    } catch (e) {
      isLoadingStatus = false;
      showErrorToast(context, e.toString());
    } finally {
      notifyListeners();
    }
  }

  // Shows the assign dialog from the "Assign Now" button on the detail screen.
  showAssignDialog(BuildContext context) {
    final bookingId = bookingModel?.id;
    if (bookingId == null) return;
    showDialog(
        context: context,
        builder: (ctx) {
          final nav = Navigator.of(ctx);
          if (isFreelancer) {
            return AppAlertDialogCommon(
                height: Sizes.s100,
                title: translations?.assignToMe ?? "Assign to Me",
                image: eImageAssets.assignMe,
                subtext:
                    translations?.areYouSureYourself ?? "Assign to yourself?",
                firstBText: translations?.cancel ?? "Cancel",
                secondBText: translations?.yes ?? "Yes",
                firstBTap: () => nav.pop(),
                secondBTap: () {
                  nav.pop();
                  _assignToSelf(bookingId, nav);
                });
          }
          return AlertDialogCommon(
              isTwoButton: true,
              title: translations?.assignBooking ?? "Assign Booking",
              image: eGifAssets.dateGif,
              subtext: translations?.doYouWant ?? "How to assign?",
              firstBText: translations?.assignToMe ?? "Assign to Me",
              secondBText:
                  translations?.assignToServicemen ?? "Assign to Servicemen",
              height: Sizes.s145,
              firstBTap: () {
                nav.pop();
                isAssigningNow = true;
                notifyListeners();
                _assignToSelf(bookingId, nav);
              },
              secondBTap: () {
                nav.pop();
                // Capture the result from BookingServicemenListScreen — the
                // selected servicemen — and actually call the assign API with
                // it. The previous code pushed the screen and discarded its
                // result, so the booking was never assigned on this path
                // (only a manual retry through a different screen worked).
                nav.pushNamed(routeName.bookingServicemenList, arguments: {
                  "servicemen": bookingModel?.requiredServicemen ?? 1,
                  "data": bookingModel,
                }).then((result) {
                  if (result != null) {
                    final serviceman = (result as List).cast<ServicemanModel>();
                    final ids = serviceman.map((d) => d.id).toList();
                    _assignToServicemen(bookingId, ids, nav);
                  }
                });
              });
        });
  }

  // Self-assign: provider assigns themselves after accepting the booking.
  // nav is captured from Navigator.of(context1) before any pops, so it
  // stays valid even after the dialog and booking-detail contexts are gone.
  Future<void> _assignToSelf(int bookingId, NavigatorState nav) async {
    try {
      showLoading(nav.context);

      final body = {
        "booking_id": bookingId,
        "servicemen_ids": [userModel!.id],
      };
      log("SELF ASSIGN BODY: $body");

      final result = await apiServices.postApi(
        api.assignBooking, body,
        isToken: true, isData: true,
      );

      hideLoading(nav.context);

      // Always navigate — assignment itself succeeds even when backend SMTP
      // fails to send the notification email. The assignBooking screen's
      // onReady will fetch fresh data, so no separate getBookingHistory needed.
      createBookingNotification(NotificationType.updateBookingStatusEvent);
      nav.pushNamed(routeName.assignBooking, arguments: bookingId);

      if (result.isSuccess != true) {
        final msg = result.message.toLowerCase();
        // Suppress server-side email/SMTP errors — they don't affect the
        // assignment itself. The backend error contains the SMTP host/port.
        final isEmailError = msg.contains('smtp') ||
            msg.contains('mail') ||
            msg.contains('email') ||
            msg.contains('authentication') ||
            msg.contains('delivery') ||
            msg.contains(':465') ||
            msg.contains(':25') ||
            msg.contains(':587') ||
            msg.contains('ssl://') ||
            msg.contains('connection could not');
        if (!isEmailError) {
          snackBarMessengers(nav.context, message: result.message);
        }
      }
    } catch (e, s) {
      log("EEEE _assignToSelf: $e => $s");
      try { hideLoading(nav.context); } catch (_) {}
    } finally {
      isAssigningNow = false;
      notifyListeners();
    }
  }

  // Assign to servicemen — mirrors _assignToSelf so both paths behave
  // identically: call the API with the chosen servicemen ids, then navigate
  // to the assignBooking screen which fetches the fresh (now-assigned) data.
  Future<void> _assignToServicemen(
      int bookingId, List ids, NavigatorState nav) async {
    try {
      showLoading(nav.context);

      final body = {"booking_id": bookingId, "servicemen_ids": ids};
      log("ASSIGN BODY : $body");

      final result = await apiServices.postApi(
        api.assignBooking, body,
        isToken: true, isData: true,
      );

      hideLoading(nav.context);

      createBookingNotification(NotificationType.updateBookingStatusEvent);
      createBookingNotification(NotificationType.assignBooking);
      nav.pushNamed(routeName.assignBooking, arguments: bookingId);

      if (result.isSuccess != true) {
        snackBarMessengers(nav.context, message: result.message);
      }
    } catch (e, s) {
      log("EEEE _assignToServicemen: $e => $s");
      try { hideLoading(nav.context); } catch (_) {}
    }
  }
}
