import 'package:fixit_provider/config.dart';

class NotificationProvider with ChangeNotifier {
  bool isNotification = false;
  AnimationController? animationController;
  List<NotificationModel> notificationList = [];

  //on refresh data fetch
  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    await userApi.getNotificationList();
    hideLoading(context);
    notifyListeners();
  }

  // page init animation start
  onAnimate(TickerProvider sync, context) async {
    animationController = AnimationController(
        vsync: sync, duration: const Duration(milliseconds: 1200));
    _runAnimation();
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    await userApi.getNotificationList();
    notifyListeners();
  }

  // page init animation start
  void _runAnimation() async {
    for (int i = 0; i < 300; i++) {
      await animationController!.forward();
      await animationController!.reverse();
    }
  }

  //notification delete confirmation
  onDeleteNotification(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(
        sync,
        context,
        eImageAssets.notificationBell,
        translations!.deleteNotification,
        translations!.areYouDeleteNotification, () {
      route.pop(context);
      deleteNotification(context);
    });
    value.notifyListeners();
  }

  onTap(NotificationModel model, context) {
    //log("TY{PE : ${model.data!.type}");
    if (model.data!.type == "provider") {
      route.pushNamed(context, routeName.providerDetail,
          arg: {'providerId': model.data!.providerId});
    } else if (model.data!.type == "booking") {
      // log("DNH :${model.data!.toJson()}");
      if (model.data!.message!.toLowerCase().contains(translations!.pending!)) {
        route.pushNamed(context, routeName.pendingBooking,
            arg: model.data!.bookingId);
      } else if (model.data!.message!
          .toLowerCase()
          .contains(translations!.accepted!)) {
        route.pushNamed(context, routeName.acceptedBooking,
            arg: model.data!.bookingId);
      } else if (model.data!.message!.toLowerCase().contains(appFonts.onHold)) {
        route.pushNamed(context, routeName.ongoingBooking,
            arg: model.data!.bookingId);
      } else if (model.data!.message!
              .toLowerCase()
              .contains(translations!.ongoing!) ||
          model.data!.message!.toLowerCase().contains(appFonts.ontheway) ||
          model.data!.message!.toLowerCase().contains(appFonts.startAgain) ||
          model.data!.message!.toLowerCase().contains(appFonts.onHold)) {
        route.pushNamed(context, routeName.ongoingBooking,
            arg: model.data!.bookingId);
      } else if (model.data!.message!
          .toLowerCase()
          .contains(translations!.completed!)) {
        route.pushNamed(context, routeName.completedBooking,
            arg: model.data!.bookingId);
      } else if (model.data!.message!
          .toLowerCase()
          .contains(translations!.assigned!)) {
        route.pushNamed(context, routeName.acceptedBooking,
            arg: model.data!.bookingId);
      } else if (model.data!.message!
          .toLowerCase()
          .contains(translations!.cancel!)) {
        route.pushNamed(navigatorKey.currentContext, routeName.cancelledBooking,
            arg: model.data!.bookingId);
      }
    }
  }

  //delete
  deleteNotification(context) async {
    try {
      await apiServices
          .getApi(api.deleteNotification, [], isToken: true)
          .then((value) async {
        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getNotificationList();
          final de = Provider.of<DeleteDialogProvider>(context, listen: false);
          de.onResetPass(
              context,
              language(context, translations!.hurrayNotificationCleared),
              language(context, translations!.okay),
              () => route.pop(context));
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }

  //unread notification total count
  totalCount() {
    int count = 0;
    for (var data in notificationList) {
      if (data.readAt == null) {
        count++;
      }
    }
    return count;
  }

  //on back animation dispose
  onBack() {
    animationController!.dispose();
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController!.dispose();
    super.dispose();
  }
}
