import 'dart:developer';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  bool isServicemen = false;
  String? amount, id;

  TextEditingController reasonCtrl = TextEditingController();
  FocusNode reasonFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //on page init data fetch
  onReady(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    isServicemen = userModel!.role == "provider" ? false : true;

    id = data.toString();
    notifyListeners();
    getBookingDetailById(context);
  }

  onBack(context, isBack) {
    //todo
    // bookingModel = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context);
    hideLoading(context);
    notifyListeners();
  }

  getMeetingLink({int? bookingId, context}) async {
    try {
      var body = {"booking_id": bookingId};
      log("booking_id : $body");

      final value = await apiServices.postApi(api.generateZoomMeeting, body,
          isToken: true, isData: true);
      log("lkjhgfddssa ${api.generateZoomMeeting}");
      notifyListeners();

      showLoading(context);
      notifyListeners();
      await getBookingDetailById(context);
      hideLoading(context);
      notifyListeners();

      if (value.isSuccess!) {
      } else {}
    } catch (e, s) {
      log("EEEE getMeetingLink : $e====> $s");
    }
  }

  bool isJoin = false;

  openZoom({meetingLink}) async {
    log("meetingLink $meetingLink");
    final Uri zoomUri = Uri.parse(meetingLink);

    if (await canLaunchUrl(zoomUri)) {
      await launchUrl(
        zoomUri,
        mode: LaunchMode.externalApplication,
      );
      isJoin = true;
    } else {
      throw 'Could not launch $meetingLink';
    }
  }

  //service start confirmation
  onStartServicePass(context) {
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
                createBookingNotification(
                    NotificationType.updateBookingStatusEvent);
                Navigator.pop(context1);
                Navigator.pop(context);
                updateStatus(context, isAssign: false);
                final userApi =
                    Provider.of<UserDataApiProvider>(context, listen: false);
                userApi.getBookingHistory(context);
                route.pushNamed(context, routeName.ongoingBooking,
                    arg: bookingModel!.id);
              });
        });
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
          // debugPrint("New BOOKING DATA : ${value.data}");
          bookingModel = BookingModel.fromJson(value.data['data']);
          log("bookingModel::$bookingModel");
          notifyListeners();
        } else {
          isLoading = false;
          snackBarMessengers(context, message: value.message);
          notifyListeners();
        }
      });
    } catch (e, s) {
      log("EEEE :booo :$e////$s");
      isLoading = false;
      notifyListeners();
    }
  }

  //update status
  updateStatus(context, {isCancel = false, isAssign = true}) async {
    try {
      showLoading(context);
      notifyListeners();
      dynamic data;
      if (isCancel) {
        data = {
          "reason": reasonCtrl.text,
          "booking_status": translations!.cancel
        };
      } else {
        data = {"booking_status": appFonts.ontheway};
      }
      log("DATA :$data");
      await apiServices
          .putApi("${api.booking}/${bookingModel!.id}", data,
              isToken: true, isData: true)
          .then((value) {
        log("DATA ss:${value.data} //${value.isSuccess} // ${value.message}");

        showErrorToast(context, value.message);

        route.pop(context);

        notifyListeners();
        if (value.isSuccess!) {
          bookingModel = BookingModel.fromJson(value.data);
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          userApi.loadBookingsFromLocal(context);
          userApi.notifyListeners();
          if (isCancel) {
            route.pop(context);
            route.pop(context);
            route.pushNamed(context, routeName.cancelledBooking,
                arg: bookingModel!.id);
          } else {
            log("isAssign :$isAssign");
            if (isAssign) {
              showDialog(
                  context: context,
                  builder: (context1) => AppAlertDialogCommon(
                      height: Sizes.s100,
                      title: translations!.assignBooking,
                      firstBText: translations!.doItLater,
                      secondBText: translations!.yes,
                      image: eGifAssets.dateGif,
                      subtext: translations!.doYouWant,
                      firstBTap: () => route.pop(context),
                      secondBTap: () {
                        route.pop(context);
                        route.pop(context);
                        route.pop(context);
                        route.pushNamed(context, routeName.ongoingBooking,
                            arg: bookingModel!.id);
                      }));
            } else {
              route.pop(context);
              route.pushNamed(context, routeName.ongoingBooking,
                  arg: bookingModel!.id);
            }
          }
        }
      });
    } catch (e, s) {
      log("EEEE update : $e==========> $s");
      hideLoading(context);
      notifyListeners();
    }
  }

//cancel confirmation dialog
  onCancel(context) {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              isTwoButton: true,
              title: translations!.cancelService,
              image: eGifAssets.error,
              subtext: translations!.areYouSureCancelService,
              height: Sizes.s145,
              firstBTap: () => route.pop(context),
              secondBTap: () {
                route.pop(context);
                showDialog(
                    context: context,
                    builder: (context1) => AppAlertDialogCommon(
                          globalKey: formKey,
                          isField: true,
                          focusNode: reasonFocus,
                          validator: (val) =>
                              validation.commonValidation(context, val),
                          controller: reasonCtrl,
                          title: translations!.reasonOfCancelBooking,
                          singleText: translations!.send,
                          singleTap: () {
                            if (formKey.currentState!.validate()) {
                              updateStatus(context, isCancel: true);
                            }
                          },
                        ));
              },
              secondBText: translations!.yes,
              firstBText: translations!.cancel);
        });
  }
}
