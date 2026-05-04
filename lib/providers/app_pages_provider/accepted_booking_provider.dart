import 'dart:developer';

import 'package:fixit_provider/config.dart';

class AcceptedBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  int selectIndex = 0;
  List statusList = [];
  String amount = "0", id = '';
  bool? isAssign = false;

  TextEditingController amountCtrl = TextEditingController();

  FocusNode amountFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onReady(context) {
    isLoading == true;
    selectIndex = 0;
    final args = ModalRoute.of(context)!.settings.arguments;
    id = (args ?? '').toString();
    log("messageData:${args}");
    if (isFreelancer != true) {
      /*       if(data != ""){
          amount = data["amount"] ?? "0";
          isAssign = data["assign_me"] ?? false;
        }*/
    }

    log("ididid:$isFreelancer");
    Future.microtask(() {
      notifyListeners();
    });
    getBookingDetailById(context, id);
  }

  onServicemenChange(index) {
    selectIndex = index;
    notifyListeners();
  }

  onAssignTap(context, {BookingModel? bookingModel}) {
    // log("bookingModel!.requiredServicemen::${bookingModel!.requiredServicemen}");
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
                log("Assign to me ${bookingModel?.id}");
                assignServiceman(context, [userModel!.id],
                    bookingId: bookingModel?.id.toString());
              },
              firstBTap: () {
                // log("firstBTap  Booking Provider");
                route.pop(context);
              }));
    } else {
      log("message=-=-=-=-=-=-=-=-=-=-=-=-= ${bookingModel?.requiredServicemen}");
      if ((bookingModel?.requiredServicemen ?? 1) > 1) {
        log("DDDD ");
        route.pushNamed(context, routeName.bookingServicemenList, arg: {
          "servicemen": bookingModel?.requiredServicemen ?? 1,
          "data": bookingModel
        }).then((e) {
          log(" :$e");
          if (e != null) {
            List<ServicemanModel> serMan = e;
            List ids = [];
            for (var d in serMan) {
              ids.add(d.id);
            }
            log("SSS :$ids");

            assignServiceman(context, ids,
                bookingId: bookingModel?.id.toString());
          }
        });
      } else {
        route.pushNamed(context, routeName.bookingServicemenList, arg: {
          "servicemen": bookingModel?.requiredServicemen ?? 1,
          "data": bookingModel
        }).then((e) {
          log(" :$bookingModel");
          if (e != null) {
            List<ServicemanModel> serMan = e;
            List ids = [];
            for (var d in serMan) {
              ids.add(d.id);
            }
            log("SSS :$ids");

            assignServiceman(context, ids,
                bookingId: bookingModel?.id.toString());
          }
        });
        // log("bookingModel!.requiredServicemen::${bookingModel?.requiredServicemen}");
        // showModalBottomSheet(
        //     isScrollControlled: true,
        //     context: context,
        //     builder: (context1) {
        //       return SelectServicemenSheet(
        //           arguments: bookingModel?.requiredServicemen ?? 1);
        //     });
      }
    }
  }

  onTapContinue(context, arguments) {
    if (selectIndex == 0) {
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
                log("message=-=-=-=-=-=-= ${bookingModel?.id}");
                /* assignServiceman(context, [userModel!.id],
                    isDirectBack: true, bookingId: bookingModel?.id.toString()); */
              },
              firstBTap: () {
                route.pop(context);
                route.pop(context);
              }));
    } else {
      log("ARGSSSSMGVHF $arguments");
      route.pushNamed(context, routeName.bookingServicemenList,
          arg: {"servicemen": arguments, "data": bookingModel!}).then((e) {
        log("ee onTapContinue:$bookingModel");
        if (e != null) {
          List<ServicemanModel> serMan = e;
          List ids = [];
          for (var d in serMan) {
            ids.add(d.id);
          }

          log("SSS :$ids");
          assignServiceman(context, ids);
        }
      });
    }
  }

  //assign serviceman

  bool isAssignServiceman = false;
  assignServiceman(context, List val,
      {isDirectBack = false, String? bookingId}) async {
    /* route.pop(context);
    route.pushNamed(context, routeName.assignBooking, arg: bookingModel!.id); */
    try {
      isAssignServiceman = true;
      log("message-=-=-=-=-=-= $bookingId");
      await getBookingDetailById(context, bookingId);

// Show loading using safe context
      if (navigatorKey.currentContext != null) {
        showLoading(navigatorKey.currentContext!);
      }

      var body = {"booking_id": bookingModel!.id, "servicemen_ids": val};
      log("ASSIGN BODY : $body");

      final value = await apiServices.postApi(api.assignBooking, body,
          isToken: true, isData: true);
      isAssignServiceman = false;
      notifyListeners();

      if (value.isSuccess!) {
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        route.pop(context);
        route.pop(context);
        /* route.pop(context); */
        getBookingDetailById(context, bookingModel!.id);
        route.pushNamed(context, routeName.assignBooking,
            arg: bookingModel!.id);
        final common = Provider.of<UserDataApiProvider>(
          context,
          /*   navigatorKey.currentContext!, */
          listen: false,
        );
        common.getBookingHistory(context /* navigatorKey.currentContext! */);

        BookingModel book = bookingModel!;

        if (isDirectBack) {
          navigatorKey.currentState?.pop();
          navigatorKey.currentState?.pop();
          hideLoading(navigatorKey.currentContext!);
          navigatorKey.currentState
              ?.pushNamed(routeName.assignBooking, arguments: book.id);
        } else {
          if (selectIndex == 0) {
            await Future.delayed(const Duration(milliseconds: 150));
            navigatorKey.currentState?.pop();
            hideLoading(context /* navigatorKey.currentContext! */);

            log("message-=-=-=-=-=-= ${book.id}");
            /*  navigatorKey.currentState
                ?.pushNamed(routeName.assignBooking, arguments: book.id); */
          } else {
            hideLoading(navigatorKey.currentContext!);
            await Future.delayed(const Duration(milliseconds: 150));
            navigatorKey.currentState?.pop();
            navigatorKey.currentState?.pop();
          }
        }
      } else {
        isAssignServiceman = false;
        // hideLoading(navigatorKey.currentContext!);
        navigatorKey.currentState?.pop();
        navigatorKey.currentState?.pop();
        snackBarMessengers(
          navigatorKey.currentContext,
          color: appColor(navigatorKey.currentContext!).appTheme.red,
          message: value.message,
        );
      }
    } catch (e, s) {
      isAssignServiceman = false;
      log("EEEE assignServiceman Accepted : $e====> $s");
      /* route.pop(context); */
      // hideLoading(context);
      notifyListeners();
      log("EEEE assignServiceman Accepted : $e====> $s");
    }
  }

  onBack(context, isBack) async {
    bookingModel = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
    /*  await getBookingDetailById(context, bookingModel!.id); */
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context, bookingModel!.id);
    hideLoading(context);
    notifyListeners();
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
          // log("DHRUVU :${value.data}");
          notifyListeners();
          bookingModel = BookingModel.fromJson(value.data['data']);
          notifyListeners();
        } else {
          isLoading = false;
          snackBarMessengers(context, message: value.message);
          notifyListeners();
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}
