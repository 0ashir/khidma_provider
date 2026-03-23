import 'dart:developer';

import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/providers/app_pages_provider/app_details_provider.dart';
import 'package:fixit_provider/screens/bottom_screens/profile_screen/layouts/logout_alert.dart';

class ProfileProvider with ChangeNotifier {
  List<ProfileModel> profileLists = [];
  SharedPreferences? preferences;
  ServicemanModel? servicemanModel;
  dynamic timeSlot;

  //on page init data fetch
  onReady(context) async {
    preferences = await SharedPreferences.getInstance();

    profileLists = isServiceman
        ? appArray.profileListAsServiceman
            .map((e) => ProfileModel.fromJson(e))
            .toList()
        : isFreelancer
            ? appSettingModel?.activation?.subscriptionEnable == "1"
                ? appArray.profileListAsFreelance
                    .map((e) => ProfileModel.fromJson(e))
                    .toList()
                : appArray.profileListAsFreelanceWithoutSubscription
                    .map((e) => ProfileModel.fromJson(e))
                    .toList()
            : appSettingModel?.activation?.subscriptionEnable == "1"
                ? appArray.profileList
                    .map((e) => ProfileModel.fromJson(e))
                    .toList()
                : appArray.profileListWithoutSubscription
                    .map((e) => ProfileModel.fromJson(e))
                    .toList();
    notifyListeners();
    Provider.of<AppDetailsProvider>(context, listen: false).getAppPages();
    notifyListeners();
    if (isServiceman) {
      getServicemenById(context);
    }
    // Provider.of<UserDataApiProvider>(context, listen: false)
    //     .getDocumentDetails();
    Provider.of<CommonApiProvider>(context, listen: false).getDocument();
    notifyListeners();
  }

//get serviceman id
  getServicemenById(context) async {
    try {
      await apiServices
          .getApi("${api.serviceman}/${userModel!.id}", [], isData: true)
          .then((value) {
        if (value.isSuccess!) {
          servicemanModel = ServicemanModel.fromJson(value.data);
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE11 getServicemenById : $e");

      notifyListeners();
    }
  }

  onTapSettingTap(context) {
    route.pushNamed(context, routeName.appSetting).then((val) {
      log("sss:");
      notifyListeners();
    });
  }

  //on delete account
  onDeleteAccount(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);
    value.onDeleteAccount(sync, context);
    value.notifyListeners();
  }

  //logout alert confirmation
  onLogout(context) {
    showDialog(
      context: context,
      builder: (context) {
        return LogoutAlert(onTap: () async {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          messaging.unsubscribeFromTopic("user_${userModel?.id}");
          messaging.unsubscribeFromTopic("providers");
          for (var i = 0; i < userModel!.zones!.length; i++) {
            messaging.subscribeToTopic("zone_${userModel!.zones![i].id}");
          }

          log("hydasjdhasd ${userModel?.id}");
          log("message Logout");
          final dash = Provider.of<DashboardProvider>(context, listen: false);
          final booking = Provider.of<BookingProvider>(context, listen: false);
          final serviceReview =
              Provider.of<ServiceReviewProvider>(context, listen: false);
          final signUpCompany =
              Provider.of<SignUpCompanyProvider>(context, listen: false);
          /* final value = Provider.of<AdsDetailProvider>(context); */
          dash.selectIndex = 0;
          dash.notifyListeners();
          hideLoading(context);
          preferences!.remove(session.user);
          preferences!.remove(session.accessToken);
          preferences!.remove(session.token);
          preferences!.remove(session.isLogin);
          preferences!.remove(session.isFreelancer);
          preferences!.remove(session.isServiceman);
          preferences!.remove(session.isLogin);
          preferences!.remove("booking_history");

          userModel = null;
          signUpCompany.zoneSelect.clear();
          userPrimaryAddress = null;
          provider = null;
          position = null;
          statisticModel = null;
          bankDetailModel = null;

          log("ajhdjkasd bank details ${bankDetailModel?.bankName}");
          popularServiceList = [];
          servicePackageList = [];
          serviceReview.reviewList = [];
          providerDocumentList = [];
          notificationList = [];
          notUpdateDocumentList = [];
          addressList = [];
          /* value.advertisingModel = null; */
          dashBoardModel = null;
          booking.bookingList.clear();
          categoryList = [];
          latestBlogs = [];
          notifyListeners();
          route.pop(context);
          log("message Booking List : ${booking.bookingList.length}");
          route.pushNamedAndRemoveUntil(context, routeName.intro);
        });
      },
    );
  }

  bool _isGoing = false;

  //profile list setting tap layout
  onTapOption(data, context, sync) async {
    if (_isGoing) return;
    _isGoing = true;
    try {
      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);

      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      if (data.title == translations!.companyDetails) {
        route.pushNamed(context, routeName.companyDetails);
      } else if (data.title == translations!.bankDetails) {
        userApi.getBankDetails();

        final bankAPI = Provider.of<BankDetailProvider>(context, listen: false);
        bankAPI.getArg();
        route.pushNamed(context, routeName.bankDetails);
      } else if (data.title == translations!.idVerification) {
        userApi.getDocument = true;
        notifyListeners();
        userApi.getDocumentDetails();
        commonApi.getDocument();
        notifyListeners();

        route.pushNamed(context, routeName.idVerification);
      } else if (data.title == translations!.advertisement) {
        route.pushNamed(context, routeName.advertisingScreens);
      } else if (data.title == translations!.timeSlots) {
        route.pushNamed(context, routeName.timeSlot);
      } else if (data.title == translations!.myPackages) {
        userApi.isPackageLoader = true;
        notifyListeners();
        userApi.getServicePackageList();

        /*  Future.delayed(DurationsDelay.ms150).then((value) async {
        await userApi.getServicePackageList();
        notifyListeners();
      }); */
        route.pushNamed(context, routeName.packagesList);
      } else if (data.title == translations!.commissionDetails) {
        userApi.commissionHistory(false, context);
        notifyListeners();

        route.pushNamed(context, routeName.commissionHistory);
      } else if (data.title == appFonts.chatHistory) {
        route.pushNamed(context, routeName.providerChatScreen);
      } else if (data.title == translations!.myReview) {
        Provider.of<ServiceReviewProvider>(context, listen: false)
            .getMyReview(context);
        route.pushNamed(context, routeName.serviceReview,
            arg: {"isSetting": true});
      } else if (data.title == translations!.subscriptionPlan) {
        Future.delayed(DurationsDelay.ms150).then((value) async {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.getSubscriptionPlanList(context);
          notifyListeners();
        });
        !isSubscription
            ? route.pushNamed(context, routeName.subscriptionPlan)
            : route.pushNamed(context, routeName.planDetails);
      } else if (data.title == appFonts.chatWithStaff) {
        route.pushNamed(context, routeName.chatWithStaffScreen);
      } else if (data.title == appFonts.referralId) {
        route.pushNamed(context, routeName.referralScreen);
      } else if (data.title == translations!.deleteAccount) {
        onDeleteAccount(context, sync);
        notifyListeners();
      } else if (data.title == translations!.logOut) {
        onLogout(context);
      } else if (data.title == translations!.serviceLocation) {
        route.pushNamed(context, routeName.companyDetails);
      } else if (data.title == translations!.serviceman) {
        route.pushNamed(context, routeName.servicemanList);
      } else if (data.title == translations!.services) {
        /* Provider.of<ServiceListProvider>(context, listen: false)
          .getCategoryService(isAllService: true); */
        Provider.of<ServiceListProvider>(context, listen: false)
            .getCategoryService(context, isAllService: true);
        // Provider.of<ServiceListProvider>(context, listen: false)
        //     .getService(isAllService: true);
        route.pushNamed(context, routeName.serviceList);
      } else if (data.title == "Service Add-ons") {
        userApi.getServiceAddOnsList();
        route.pushNamed(context, routeName.serviceAddOnList);

        /* Provider.of<ServiceListProvider>(context, listen: false)
          .getCategoryService(isAllService: true); */
        // route.pushNamed(context, routeName.);
      } else if (data.title ==
          appFonts.appDetails /* translations!.services */) {
        /* Provider.of<ServiceListProvider>(context, listen: false)
          .getCategoryService(isAllService: true); */
        route.pushNamed(context, routeName.appDetails);
        /* route.pushNamed(context, routeName.serviceList); */
      }
    } finally {
      _isGoing = false;
    }
  }

  //delete account
  deleteAccount(context) async {
    route.pop(context);
    try {
      await apiServices
          .getApi(api.deleteAccount, [], isToken: true)
          .then((value) {
        if (value.isSuccess!) {
          hideLoading(context);
          final dash = Provider.of<DashboardProvider>(context, listen: false);
          dash.selectIndex = 0;
          dash.notifyListeners();
          preferences!.remove(session.user);
          preferences!.remove(session.accessToken);

          preferences!.remove(session.isLogin);

          preferences!.remove(session.recentSearch);
          preferences!.clear();
          notifyListeners();
          route.pushAndRemoveUntil(context, routeName.loginProvider);
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}
