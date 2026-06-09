import 'dart:developer';
import 'package:fixit_provider/config.dart';
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
    final args = ModalRoute.of(context)!.settings.arguments;
    isServicemen = userModel!.role == "provider" ? false : true;
    id = (args ?? '').toString();
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
    notifyListeners();
    try {
      final response = await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true);
      if (response.isSuccess == true && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          bookingModel = BookingModel.fromJson(data);
          log("bookingModel::$bookingModel");
        }
      }
    } catch (e, s) {
      log("EEEE getBookingDetailById assign: $e////$s");
    } finally {
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
      final response = await apiServices.putApi(
          "${api.booking}/${bookingModel!.id}", data,
          isToken: true, isData: true);

      hideLoading(context);
      notifyListeners();

      if (response.isSuccess == true) {
        final currentId = bookingModel!.id;
        Provider.of<UserDataApiProvider>(context, listen: false)
            .loadBookingsFromLocal(context);
        if (isCancel) {
          route.pop(context);
          route.pop(context);
          route.pop(context);
          route.pushNamed(context, routeName.cancelledBooking, arg: currentId);
        } else {
          route.pop(context);
          route.pushNamed(context, routeName.ongoingBooking, arg: currentId);
        }
      } else {
        snackBarMessengers(context, message: response.message);
      }
    } catch (e, s) {
      log("EEEE update : $e==========> $s");
      hideLoading(context);
      notifyListeners();
    }
  }

// Reassign booking to a different serviceman (or self)
  onReassignTap(context) {
    if (isFreelancer) {
      showDialog(
          context: context,
          builder: (context1) => AppAlertDialogCommon(
                height: Sizes.s145,
                title: translations!.assignToMe,
                firstBText: translations!.cancel,
                secondBText: translations!.yes,
                image: eImageAssets.assignMe,
                subtext: translations!.areYouSureYourself,
                secondBTap: () {
                  route.pop(context);
                  _doReassign(context, [userModel!.id]);
                },
                firstBTap: () => route.pop(context),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context1) => AlertDialogCommon(
                title: translations!.assignBooking,
                subtext: translations!.doYouWant,
                image: eGifAssets.dateGif,
                isTwoButton: true,
                firstBText: translations!.assignToMe,
                secondBText: translations!.assignToServicemen,
                height: Sizes.s145,
                firstBTap: () {
                  route.pop(context);
                  _doReassign(context, [userModel!.id]);
                },
                secondBTap: () {
                  route.pop(context);
                  route.pushNamed(context, routeName.bookingServicemenList,
                      arg: {
                        "servicemen": bookingModel?.requiredServicemen ?? 1,
                        "data": bookingModel
                      }).then((e) {
                    if (e != null) {
                      final ids =
                          (e as List<ServicemanModel>).map((s) => s.id).toList();
                      _doReassign(context, ids);
                    }
                  });
                },
              ));
    }
  }

  Future<void> _doReassign(BuildContext context, List ids) async {
    try {
      showLoading(context);
      final body = {"booking_id": bookingModel!.id, "servicemen_ids": ids};
      log("REASSIGN BODY: $body");
      final result = await apiServices.postApi(api.reassignBooking, body,
          isToken: true, isData: true);
      if (!context.mounted) return;
      hideLoading(context);
      if (result.isSuccess == true) {
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        await getBookingDetailById(context);
        if (!context.mounted) return;
        Provider.of<UserDataApiProvider>(context, listen: false)
            .getBookingHistory(context);
      } else {
        snackBarMessengers(context, message: result.message);
      }
    } catch (e, s) {
      log("EEEE _doReassign: $e => $s");
      if (context.mounted) hideLoading(context);
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
