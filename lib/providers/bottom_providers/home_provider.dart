import 'dart:developer';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/services/environment.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/dash_board_model.dart' show Booking;
import '../../widgets/withdraw_amount_bottom_sheet.dart';

class HomeProvider with ChangeNotifier {
  List<String> wmy = <String>['W', 'M', 'Y'];
  ScrollController scrollController = ScrollController();
  bool isSwitch = true, isToolTip = false;
  int selectedIndex = 0;
  bool isSkeleton = true;
  bool isNavigating = false;
  AnimationStatus status = AnimationStatus.dismissed;

  FocusNode amountFocus = FocusNode();
  FocusNode messageFocus = FocusNode();

  int touchedIndex = -1;

  bool isPlaying = false;
  bool isTouchBar = false;

  final double width = 12;
  String? withdrawValue;

  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;

  int touchedGroupIndex = -1;

  //total weekly revenue count
  double get totalWeeklyRevenue =>
      appArray.weekData.fold(0, (i, j) => i + (j.y ?? 0.0));

  //total monthly revenue count
  double get totalMonthlyRevenue =>
      appArray.monthData.fold(0, (i, j) => i + (j.y ?? 0.0));

  //total yearly revenue count
  double get totalYearlyRevenue =>
      appArray.yearData.fold(0, (i, j) => i + (j.y ?? 0.0));

  // select week, month or year option for graph
  onTapWmy(index) {
    selectedIndex = index;
    isToolTip = false;
    notifyListeners();
  }

  var selectIndex = 0;
  onTapIndexOne(value) {
    selectIndex = 1;
    notifyListeners();
  }

  getAppSettingList(BuildContext context) async {
    try {
      var value = await apiServices.getApi("${api.settings}/advertisement", [],
          isData: true);
      // log("value.data:::${value.data}");
      if (value.isSuccess!) {
        settingAdvertisementModel = value.data;
        //  log("value.data::${value.data}");

        notifyListeners();
      }
    } catch (e) {
      log("EEEE :getAppSettingList $e");
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  onTapHomeBookings(
    Booking data,
    context,
  ) {
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);

    // log("data.bookingStatus!.slug :${data.bookingStatus!.slug}");

    if (data.bookingStatus != null) {
      if (data.bookingStatus!.slug == appFonts.pending) {
        // log("data.bookingStatus!.slug :${appFonts.pending}");
        //route.pushNamed(context, routeName.packageBookingScreen);
        route
            .pushNamed(context, routeName.pendingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.accepted) {
        if (isFreelancer) {
          log("message");
          route.pushNamed(context, routeName.assignBooking, arg: data.id);
        } else {
          route
              .pushNamed(context, routeName.acceptedBooking, arg: data.id)
              .then((e) {
            dash.loadBookingsFromLocal(context);
          });
        }
      } else if (data.bookingStatus!.slug == appFonts.pendingApproval) {
        route
            .pushNamed(context, routeName.pendingApprovalBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.hold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onHold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onGoing.toLowerCase() ||
          data.bookingStatus!.slug == appFonts.ontheway ||
          data.bookingStatus!.slug == appFonts.ontheway1 ||
          data.bookingStatus!.slug == appFonts.startAgain) {
        log("Sh");
        route
            .pushNamed(context, routeName.ongoingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.completed) {
        route
            .pushNamed(context, routeName.completedBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.assigned) {
        route
            .pushNamed(context, routeName.assignBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.cancel ||
          data.bookingStatus!.slug == appFonts.decline) {
        route
            .pushNamed(context, routeName.cancelledBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      }
    } else {
      route
          .pushNamed(context, routeName.pendingBooking, arg: data.id)
          .then((e) {
        dash.getBookingHistory(context);
      });
    }
  }

// on booking tap redirect to page as per booking status
  onTapBookings(
    BookingModel data,
    context,
  ) {
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);

    // log("data.bookingStatus!.slug :${data.bookingStatus!.slug}");

    if (data.bookingStatus != null) {
      if (data.bookingStatus!.slug == appFonts.pending) {
        // log("data.bookingStatus!.slug :${appFonts.pending}");
        //route.pushNamed(context, routeName.packageBookingScreen);
        route
            .pushNamed(context, routeName.pendingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.accepted) {
        if (isFreelancer) {
          log("message");
          route.pushNamed(context, routeName.assignBooking, arg: data.id);
        } else {
          route
              .pushNamed(context, routeName.acceptedBooking, arg: data.id)
              .then((e) {
            dash.loadBookingsFromLocal(context);
          });
        }
      } else if (data.bookingStatus!.slug == appFonts.pendingApproval) {
        route
            .pushNamed(context, routeName.pendingApprovalBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.hold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onHold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onGoing.toLowerCase() ||
          data.bookingStatus!.slug == appFonts.ontheway ||
          data.bookingStatus!.slug == appFonts.ontheway1 ||
          data.bookingStatus!.slug == appFonts.startAgain) {
        log("Sh");
        route
            .pushNamed(context, routeName.ongoingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.completed) {
        route
            .pushNamed(context, routeName.completedBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.assigned) {
        route
            .pushNamed(context, routeName.assignBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.cancel ||
          data.bookingStatus!.slug == appFonts.decline) {
        route
            .pushNamed(context, routeName.cancelledBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      }
    } else {
      route
          .pushNamed(context, routeName.pendingBooking, arg: data.id)
          .then((e) {
        dash.getBookingHistory(context);
      });
    }
  }

  //gridview tap
  // onTapOption(index, context, title, data) async {
  //   // final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
  //   final value = Provider.of<DashboardProvider>(context, listen: false);
  //   if (title == translations!.totalService) {
  //     await Provider.of<ServiceListProvider>(context, listen: false)
  //         .getCategoryService(context, isAllService: true);
  //     // Provider.of<ServiceListProvider>(context, listen: false)
  //     //     .getService(isAllService: true);
  //     route.pushNamed(context, routeName.serviceList);
  //   } else if (title == translations!.totalCategory) {
  //     await Provider.of<UserDataApiProvider>(context, listen: false).getCategory();
  //     route.pushNamed(context, routeName.categories);

  //   } else if (title == translations!.totalEarning) {

  //       await Provider.of<UserDataApiProvider>(context, listen: false)
  //           .getTotalEarningByCategory(context);
  //       await Provider.of<UserDataApiProvider>(context, listen: false).commissionHistory(false, context);
  //       notifyListeners();

  //     route.pushNamed(context, routeName.earnings);
  //   } else if (title == translations!.totalServiceman) {
  //     await Provider.of<UserDataApiProvider>(context, listen: false).getServicemenByProviderId();
  //     route.pushNamed(context, routeName.servicemanList);
  //   } else if (title == translations!.totalBooking) {
  //     value.selectIndex = 1;
  //     final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
  //     final booking = Provider.of<BookingProvider>(context, listen: false);
  //     userApi.bookingPage = 1;
  //     userApi.isLoadingForBookingHistory = true;
  //     booking.isLoadingForBookingHistory = true;
  //     notifyListeners();
  //     userApi.getBookingHistory(context);
  //     value.notifyListeners();
  //   }
  // }
  Future<void> onTapOption(
    int index,
    BuildContext context,
    String title,
    dynamic data,
  ) async {
    if (isNavigating) return; // 🔒 Prevent double tap
    isNavigating = true;

    try {
      final value = Provider.of<DashboardProvider>(context, listen: false);

      if (title == translations!.totalService) {
        await Provider.of<ServiceListProvider>(context, listen: false)
            .getCategoryService(context, isAllService: true);

        await route.pushNamed(context, routeName.serviceList);
      } else if (title == translations!.totalCategory) {
        await Provider.of<UserDataApiProvider>(context, listen: false)
            .getCategory();

        await route.pushNamed(context, routeName.categories);
      } else if (title == translations!.totalEarning) {
        final userApi =
            Provider.of<UserDataApiProvider>(context, listen: false);

        await userApi.getTotalEarningByCategory(context);
        await userApi.commissionHistory(false, context);
        notifyListeners();

        await route.pushNamed(context, routeName.earnings);
      } else if (title == translations!.totalServiceman) {
        await Provider.of<UserDataApiProvider>(context, listen: false)
            .getServicemenByProviderId();

        await route.pushNamed(context, routeName.servicemanList);
      } else if (title == translations!.totalBooking) {
        value.selectIndex = 1;

        final userApi =
            Provider.of<UserDataApiProvider>(context, listen: false);
        final booking = Provider.of<BookingProvider>(context, listen: false);

        userApi.bookingPage = 1;
        userApi.isLoadingForBookingHistory = true;
        booking.isLoadingForBookingHistory = true;

        notifyListeners();

        await userApi.getBookingHistory(context);
        value.notifyListeners();
      }
    } finally {
      isNavigating = false; // ✅ Always reset
    }
  }

  //statistic tap function
  onStatisticTapOption(index, context) {
    final value = Provider.of<DashboardProvider>(context, listen: false);
    /*  if (index == 2) {
      route.pushNamed(context, routeName.serviceList);
    } else*/
    if (index == 0) {
      Future.delayed(DurationsDelay.ms150).then((value) {
        Provider.of<UserDataApiProvider>(context, listen: false)
            .getTotalEarningByCategory(context);
        Provider.of<UserDataApiProvider>(context, listen: false)
            .commissionHistory(false, context);
        notifyListeners();
      });
      route.pushNamed(context, routeName.earnings);
    } else if (index == 1) {
      value.selectIndex = 1;
      value.notifyListeners();
    }
  }

  onReady(context, sync) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;

    final minVersion = int.tryParse(appSettingModel
            ?.appSettings?.providerAppForceUpdate?.minVersionAndroid ??
        "0");
    final currentVersion = int.tryParse(buildNumber);

    print("object=-=-=-=-$minVersion=======$currentVersion");

    if (appSettingModel?.activation?.forceUpdateInApp == "1") {
      if (minVersion != null &&
          currentVersion != null &&
          currentVersion < minVersion) {
        showCustomDialog(context);
      }
    }

    await Future.wait([
      Future(
        () {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          // commonApi.getBlog();
          commonApi.getGooglePlanIds(context);
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          userApi.loadBookingsFromLocal(context);
          // getAppSettingList(context);
        },
      )
    ]);
    messageFocus.addListener(() {
      notifyListeners();
    });

    await Future.delayed(const Duration(milliseconds: 150));
    isSkeleton = false;
    notifyListeners();
    notifyListeners();
  }

  /// Update App Dialog
  void showCustomDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update App'),
          content: const Text(
              'A New version of the app is available. Please update to the latest version.'),
          actions: [
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(providerAppUrl));
                /* Navigator.of(context).pop(); */
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  //on with bottom sheet open
  onWithdraw(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context1) {
        return const WithdrawAmountBottomSheet();
      },
    ).then((value) {
      log("SSSS");
      final wallet = Provider.of<WalletProvider>(context, listen: false);
      wallet.amountCtrl.text = "";
      wallet.withDrawAmountCtrl.text = "";
      wallet.messageCtrl.text = "";
      wallet.showValidationError = false;
    });
  }
}
