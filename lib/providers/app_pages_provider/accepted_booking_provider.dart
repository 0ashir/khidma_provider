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
      // Show dialog: assign to self or assign to servicemen
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
                  log("Provider assign to self: ${userModel!.id}");
                  _selfAssignInPlace(context,
                      bookingId: bookingModel?.id.toString());
                },
                secondBTap: () {
                  route.pop(context);
                  _pushServicemenList(context, bookingModel);
                },
              ));
    }
  }

  Future<void> _selfAssignInPlace(BuildContext context, {String? bookingId}) async {
    try {
      showLoading(context);

      final body = {
        "booking_id": bookingModel!.id,
        "servicemen_ids": [userModel!.id],
      };
      log("SELF ASSIGN BODY: $body");

      final result = await apiServices.postApi(
        api.assignBooking, body,
        isToken: true, isData: true,
      );

      if (result.isSuccess == true) {
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        // Refresh the booking that this provider exposes — it's the one the
        // current screen (Consumer2<AcceptedBookingProvider, ...>) actually
        // renders via `value.bookingModel`, so the status updates in place
        // with no navigation/reload, same as the assign-to-servicemen flow.
        await getBookingDetailById(context, bookingId);
        notifyListeners();

        if (context.mounted) {
          Provider.of<UserDataApiProvider>(context, listen: false)
              .getBookingHistory(context);
        }
      } else {
        if (context.mounted) {
          snackBarMessengers(context, message: result.message);
        }
      }

      if (context.mounted) hideLoading(context);
    } catch (e, s) {
      log("EEEE _selfAssignInPlace: $e => $s");
      if (context.mounted) hideLoading(context);
    }
  }

  void _pushServicemenList(context, BookingModel? bm) {
    route.pushNamed(context, routeName.bookingServicemenList, arg: {
      "servicemen": bm?.requiredServicemen ?? 1,
      "data": bm
    }).then((e) {
      log(" :$e");
      if (e != null) {
        List<ServicemanModel> serMan = e;
        List ids = serMan.map((d) => d.id).toList();
        log("SSS :$ids");
        assignServiceman(context, ids, bookingId: bm?.id.toString());
      }
    });
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
  // Mirrors _selfAssignInPlace: call the API, then refresh `this.bookingModel`
  // (the one the screen actually renders via Consumer2<AcceptedBookingProvider,
  // ...>) and notify — no navigation, so the status updates in place exactly
  // like the "assign to me" flow.
  assignServiceman(context, List val, {String? bookingId}) async {
    try {
      isAssignServiceman = true;
      showLoading(context);

      final body = {"booking_id": bookingModel!.id, "servicemen_ids": val};
      log("ASSIGN BODY : $body");

      final result = await apiServices.postApi(api.assignBooking, body,
          isToken: true, isData: true);
      isAssignServiceman = false;

      if (result.isSuccess == true) {
        createBookingNotification(NotificationType.updateBookingStatusEvent);
        await getBookingDetailById(context, bookingModel!.id);
        notifyListeners();

        if (context.mounted) {
          Provider.of<UserDataApiProvider>(context, listen: false)
              .getBookingHistory(context);
        }
      } else {
        notifyListeners();
        if (context.mounted) {
          snackBarMessengers(context, message: result.message);
        }
      }

      if (context.mounted) hideLoading(context);
    } catch (e, s) {
      isAssignServiceman = false;
      log("EEEE assignServiceman Accepted : $e====> $s");
      notifyListeners();
      if (context.mounted) hideLoading(context);
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
    notifyListeners();
    try {
      final response = await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true);
      if (response.isSuccess == true && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          bookingModel = BookingModel.fromJson(data);
        }
      }
    } catch (e) {
      log("EEEE getBookingDetailById accepted: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
