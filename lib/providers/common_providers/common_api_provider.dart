import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../config.dart';
import '../../model/dash_board_model.dart'
    show
        Booking,
        Chart,
        DashboardModel,
        LatestBlog,
        LatestServiceRequest,
        PopularService;
import '../../services/api_service.dart';
import '../../services/environment.dart';

class CommonApiProvider extends ChangeNotifier {
  Dio dioo = Dio();

  getGooglePlanIds(context) async {
    await dioo.get(api.subscriptionPlansIds).then((value) {
      subscriptionIds = value.data;
      // hideLoading(context);
    });
  }

  //self api
  Future<void> selfApi(BuildContext context) async {
    log("ajksfhajksfhasfjkahsfas fa      ----   user_${!context.mounted}}");
    /*  if (!context.mounted) return; */ // Check if widget is still mounted

    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await apiServices.getApi(api.self, [], isToken: true).then((value) async {
        if (value.isSuccess == true) {
          log("ajksfhajksfhasfjkahsfas fa      ----   user_${value.isSuccess}}");
          userModel = null;
          userModel = UserModel.fromJson(value.data);
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          messaging.subscribeToTopic("user_${userModel?.id}");
          messaging.subscribeToTopic("providers");
          messaging.subscribeToTopic("createProvider_${userModel?.id}");
          log("ajksfhajksfhasfjkahsfas fa      ----   user_${userModel?.id}");
          log("value.data::${value.data}");
          pref.setString(
              session.user, json.encode(UserModel.fromJson(value.data)));
          notifyListeners();
          log("SelfApi User Status : ${userModel!.id}");
          pref.setInt('UserId', userModel!.id!);

          log("SelfApi User Role : ${userModel!.role}///${pref.getInt("UserId")}");
          if (userModel?.status == 0) {
            route.pushReplacementNamed(context, routeName.loginProvider);
          }
          if (isServiceman) {
            log("isServiceman:$isServiceman");

            await getProviderById(context, userModel!.providerId);
            notifyListeners();
          }
          // Check if widget is still mounted before interacting with context
          if (context.mounted) {
            isServiceman = userModel!.role == "provider" ? false : true;
            isFreelancer = userModel!.type == "freelancer" ? true : false;
            notifyListeners();

            log("message=-=-=-=-=-=-==-=-=-=-= isFreelancer:${userModel!.type}");
            isSubscription =
                userModel!.activeSubscription == null ? false : true;

            if (isSubscription) {
              activeSubscription = userModel!.activeSubscription;
            }

            pref.setBool(session.isFreelancer, isFreelancer);
            pref.setBool(session.isServiceman, isServiceman);
            notifyListeners();

            pref.setString(
                session.user, json.encode(UserModel.fromJson(value.data)));
            notifyListeners();
          }
        } else {
          if (value.message.contains("Unauthenticated.") ||
                  value.message ==
                      "Unauthenticated." /* ||
              value.isSuccess == false*/
              ) {
            log("value.message::${value.message}///${userModel}");
            log("userModel.status: ${userModel?.status}");
            if (context.mounted) {
              final dash =
                  Provider.of<DashboardProvider>(context, listen: false);
              dash.selectIndex = 0;
              dash.notifyListeners();

              route.pushNamedAndRemoveUntil(context, routeName.intro);
            }

            pref.clear();
            userModel = null;
            notifyListeners();
          }
        }
      });
    } catch (e, s) {
      log("SELF :$e==========> $s");
      notifyListeners();
    }
  }

  //KnownLanguage list
  getKnownLanguage({search}) async {
    try {
      String apiURL = api.language;
      if (search != null) {
        apiURL = "${api.language}?search=$search";
        log("apiURL::;$apiURL");
      } else {
        apiURL = api.language;
      }

      await apiServices.getApi(apiURL, []).then((value) {
        if (value.isSuccess!) {
          List language = value.data;
          knownLanguageList = [];
          for (var data in language) {
            knownLanguageList.add(KnownLanguageModel.fromJson(data));
            notifyListeners();
          }

          notifyListeners();
        }
      });
    } catch (e) {
      log("EEE apiURL::;$e");
      notifyListeners();
    }
  }

  Future<void> getDashBoardApi(BuildContext context) async {
    // final lang = Provider.of<LanguageProvider>(context, listen: false);
    // String selectedLocale = lang.selectedLocaleService;
    // print("Selected Locale: $selectedLocale");

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);
    String? lang = pref.getString("selectedLocale") ?? "en";
    if (token == null || token.isEmpty) {
      log(" missing!");

      return; // Stop execution if the token is missing
    }

    var header = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Accept-Lang": lang,
      "Authorization": "Bearer $token",
    };

    try {
      DateTime startTime = DateTime.now();

      final response =
          await dioo.get(api.dashBoard, options: Options(headers: header));
      log("apiUrl CAll Name::${response.realUri}");
      if (response.statusCode == 200) {
        log("Dashboard API Response: ${response.data}");

        dashBoardModel = DashboardModel.fromJson(response.data);

        DateTime endTime = DateTime.now();
        Duration apiDuration = endTime.difference(startTime);
        log("API call took: ${apiDuration.inSeconds} seconds");

        updateDashboardData(response.data);
      } else {
        log("Unauthorized: Token might be expired.");

        // await refreshTokenAndRetry(context);
      }
    } catch (e, s) {
      var apiData = await apiServices.dioException(e);
      log("Dashboard API Error: $e\nStackTrace: $s/////$apiData");
    }
  }

  updateDashboardData(data) {
    if (isServiceman) {
      appArray.serviceManEarningList.asMap().entries.forEach((element) {
        if (element.value['title'] == translations!.totalEarning) {
          element.value["price"] = dashBoardModel!.totalRevenue.toString();
        }
        if (element.value['title'] == translations!.totalBooking) {
          element.value["price"] = dashBoardModel!.totalBookings.toString();
        }
        if (element.value['title'] == translations!.totalService) {
          element.value["price"] = dashBoardModel!.totalServices.toString();
        }

        log("HOME L${element.value["price"]}");
        notifyListeners();
      });
    } else {
      //HomeScreen grid layout data stored
      appArray.earningList.asMap().entries.forEach((element) {
        // log("element.value::${dashBoardModel!.totalRevenue}");
        if (element.value['title'] == translations!.totalEarning) {
          element.value["price"] = dashBoardModel!.totalRevenue!.toString();
        }
        if (element.value['title'] == translations!.totalBooking) {
          element.value["price"] = dashBoardModel!.totalBookings.toString();
        }
        if (element.value['title'] == translations!.totalService) {
          element.value["price"] = dashBoardModel!.totalServices.toString();
        }
        if (element.value['title'] == translations!.totalCategory) {
          element.value["price"] = dashBoardModel!.totalCategories.toString();
        }
        if (element.value['title'] == translations!.totalServiceman) {
          element.value["price"] = dashBoardModel!.totalCategories.toString();
        }
        notifyListeners();
      });

      // Custom Job request
      List category = data['latestServiceRequests'];
      log("value.data['latestServiceRequests']::${category}");
      latestServiceRequest = [];
      for (var data in category.reversed.toList()) {
        LatestServiceRequest latestServiceRequestModel =
            LatestServiceRequest.fromJson(data);
        if (!latestServiceRequest.contains(latestServiceRequestModel)) {
          latestServiceRequest.add(latestServiceRequestModel);
        }
        notifyListeners();
      }
      // popular service request
      List popService = data['popularServices'];
      popularServiceHome = [];
      for (var data in popService.toList()) {
        PopularService popularServiceModel = PopularService.fromJson(data);
        if (!popularServiceHome.contains(popularServiceModel)) {
          popularServiceHome.add(popularServiceModel);
        }
        notifyListeners();
      }

      notifyListeners();
    }
    //Recent Booking data stored
    List<dynamic> newBookings =
        (data['booking']).map((json) => Booking.fromJson(json)).toList();
    booking = newBookings;

    //chart layout data stored
    appArray.weekData = [];
    appArray.monthData = [];
    appArray.yearData = [];
    chart = Chart.fromJson(data['chart']);
    notifyListeners();

    for (var d in chart!.weekdayRevenues!) {
      appArray.weekData.add(ChartData(x: d.x, y: d.y!));
    }
    for (var d in chart!.monthlyRevenues!) {
      appArray.monthData.add(ChartData(x: d.x, y: d.y!));
    }
    for (var d in chart!.yearlyRevenues!) {
      appArray.yearData.add(ChartData(x: d.x, y: d.y!));
    }
    notifyListeners();
    // blog data
    List blog = data['latestBlogs'];
    latestBlogs = [];
    for (var data in blog.toList()) {
      LatestBlog latestBlogsModel = LatestBlog.fromJson(data);
      if (!latestBlogs.contains(latestBlogsModel)) {
        latestBlogs.add(latestBlogsModel);
      }
      notifyListeners();
    }
  }

  //plan list
  getSubscriptionPlanList(context) async {
    try {
      await apiServices.getApi(api.subscriptionPlans, []).then((value) {
        if (value.isSuccess!) {
          List planList = value.data;
          subscriptionList = [];
          log("getSubscriptionPlanList :${planList.first}");
          Provider.of<LanguageProvider>(context, listen: false);
          for (var data in planList) {
            notifyListeners();
            SubscriptionModel subscriptionModel =
                SubscriptionModel.fromJson(data);
            List<String> benefits = [];
            for (var d in appArray.benefits) {
              if (d == "service") {
                benefits.add(appFonts.addUpToServicePlan(
                    context, subscriptionModel.maxServices.toString()));
              } else if (d == "servicemen") {
                benefits.add(appFonts.addUpToServicemanPlan(
                    context, subscriptionModel.maxServicemen.toString()));
              } else if (d == "serviceLocation") {
                benefits.add(appFonts.addUpToLocationPlan(
                    context, subscriptionModel.maxAddresses.toString()));
              } else if (d == "packages") {
                benefits.add(appFonts.addUpToServicePackagePlan(
                    context, subscriptionModel.maxServicePackages.toString()));
              }
              notifyListeners();
            }
            if (!subscriptionList.contains(subscriptionModel)) {
              subscriptionModel.benefits = benefits;
              notifyListeners();
              subscriptionList.add(subscriptionModel);
            }
            notifyListeners();
          }
          log("subscriptionList:${subscriptionList.length}");
          notifyListeners();
        }
      });
    } catch (e) {
      log("EEEE getSubscriptionPlanList :$e");
      notifyListeners();
    }
  }

  //Document list
  Future<void> getDocument() async {
    try {
      await apiServices.getApi(api.document, []).then((value) {
        if (value.isSuccess!) {
          log(" getDocument : ${value.isSuccess}");
          List language = value.data;
          documentList = [];
          for (var data in language) {
            documentList.add(DocumentModel.fromJson(data));
            notifyListeners();
          }

          notifyListeners();
        }
      });
    } catch (e) {
      notifyListeners();
      log("EEEE getDocument : $e");
    }
  }

  // country state list
  getCountryState() async {
    countryStateList = [];
    notifyListeners();
    try {
      await apiServices.getApi(api.country, []).then((value) {
        if (value.isSuccess!) {
          log("COUNTRY::::${value.data}");
          List co = value.data;
          for (var data in value.data) {
            if (!countryStateList.contains(CountryStateModel.fromJson(data))) {
              countryStateList.add(CountryStateModel.fromJson(data));
            }
            notifyListeners();
          }

          stateList = countryStateList[0].state!;

          notifyListeners();
        }
      });
    } catch (e,s) {
      log("ERRROEEE getCountryState $e -=-=-= $s");
      notifyListeners();
    }
  }

  // zone list
  getZoneList() async {
    zoneList = [];
    notifyListeners();
    try {
      await apiServices.getApi(api.zone, []).then((value) {
        if (value.isSuccess!) {
          for (var data in value.data) {
            if (!zoneList.contains(ZoneModel.fromJson(data))) {
              zoneList.add(ZoneModel.fromJson(data));
            }
            notifyListeners();

            log("=-=-=-=-=-Currancy${/* zoneIds */ zoneList.asMap().entries.map((e) => e.value.id)}");
          }
          log(" getCountryState ${zoneList}");
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE getCountryState $e");
      notifyListeners();
    }
  }

  //setting list
  getPaymentMethodList() async {
    String apiUrl;
    if (zoneIds.isNotEmpty) {
      apiUrl = "${api.paymentMethod}?zone_ids=$zoneIds";
    } else {
      apiUrl = api.paymentMethod;
    }
    try {
      log("VALUE  PAYMENT:${apiUrl}");
      await apiServices.getApi(apiUrl, []).then((value) {
        //log("VALUE  PAYMENT:${value.data}");
        if (value.isSuccess!) {
          paymentMethods = [];
          for (var d in value.data) {
            paymentMethods.add(PaymentMethods.fromJson(d));
          }
          notifyListeners();
        }

        notifyListeners();
      });
    } catch (e) {
      log("EEEE getPaymentMethodList:$e");
      notifyListeners();
    }
  }

  ProviderModel? providerData;

  //get provider detail id
  getProviderById(context, id) async {
    notifyListeners();
    try {
      log("message----------${api.provider}/$id");
      await apiServices
          .getApi("${api.provider}/$id", [], isData: true)
          .then((value) {
        if (value.isSuccess == true) {
          notifyListeners();
          provider = ProviderModel.fromJson(value.data['data']);
          providerData = ProviderModel.fromJson(value.data['data']);
          notifyListeners();
          log(" getProviderById : ${value.data['data']}");

          notifyListeners();
        }
      });
    } catch (e, s) {
      log("ERRROEEE getProviderById : $e=======> $s");
      notifyListeners();
    }
  }

  //currency list
  getCurrency() async {
    try {
      await apiServices.getApi(api.currency, []).then((value) {
        log("value :R::${value.data}");
        if (value.isSuccess!) {
          currencyList = [];
          for (var data in value.data) {
            currencyList.add(CurrencyModel.fromJson(data));
            log("fbhgfvhg:${currencyList.length}");
            log("fbhgfvhgSA:${data}");
            notifyListeners();
          }
        }
      });
    } catch (e) {
      log("EEEE getCurrency::$e}");

      notifyListeners();
    }
  }

  /*//getLanguage list
  getLanguage() async {
    try {
      await apiServices.getApi(api.language, []).then((value) {
        // log("value :R$value");
        if (value.isSuccess!) {
          for (var data in value.data) {
            currencyList = [];
            currencyList.add(CurrencyModel.fromJson(data));
            notifyListeners();
          }
        }
      });
    } catch (e) {
      log("EEEE getCurrency ::$e}");

      notifyListeners();
    }
  }*/

  //blog list

  bool isBlogList = false;

  Future getBlog({dynamic id}) async {
    isBlogList = true;
    log("id::$id");
    try {
      await apiServices.getApi(api.blog, []).then((value) {
        // log("value.isSuccess::bllloooggg${value.data}");
        if (value.isSuccess!) {
          isBlogList = false;
          blogList = [];
          List service = value.data;
          for (var data in service.reversed.toList()) {
            blogList.add(BlogModel.fromJson(data));
            notifyListeners();
          }

          notifyListeners();
        }
      });
    } catch (e, s) {
      isBlogList = false;
      log("EEEE getBlog : $e////$s");
      notifyListeners();
    }
  }

  /*getBlog(context) async {
    try {
      final lang = Provider.of<LanguageProvider>(context, listen: false);
      String selectedLocale = lang.selectedLocaleService;
      print("Selected Locale: $selectedLocale");
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      await dioo
          .get(api.blog,
              data: [],
              options: Options(
                  headers: headersToken(
                token,
                localLang: selectedLocale */ /* lang.selectedLocaleService */ /*,
                isLang: true,
              )))
          .then((value) {
        if (value.statusCode == 200) {
          log("value.data['data']::${value.data['data']}");
          var service = value.data['data'];
          blogList = [];
          for (var data in service.reversed.toList()) {
            blogList.add(BlogModel.fromJson(data));
            notifyListeners();
          }
          log("blogList::${blogList}");
          if (blogList.length >= 6) {
            firstTwoBlogList = blogList.getRange(0, 6).toList();
          }
          notifyListeners();
        }
      });
    } catch (e) {
      log("EEEE getBlog : $e");
      notifyListeners();
    }
  }*/

  //booking status list
  getBookingStatus() async {
    try {
      await apiServices
          .getApi(api.bookingStatus, [], isToken: true)
          .then((value) {
        log("VALUE :$value");
        if (value.isSuccess!) {
          bookingStatusList = [];
          for (var data in value.data) {
            bookingStatusList.add(BookingStatusModel.fromJson(data));
            notifyListeners();
          }
        }
      });
      int cancelIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "cancel" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "cancelled");
      if (cancelIndex >= 0) {
        translations!.cancel = bookingStatusList[cancelIndex].slug!;
      }
      int acceptedIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "accepted" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "accept");
      if (acceptedIndex >= 0) {
        translations!.accepted = bookingStatusList[acceptedIndex].slug!;
      }

      int assignedIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "assign" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "assigned");
      if (assignedIndex >= 0) {
        translations!.assigned = bookingStatusList[assignedIndex].slug!;
      }

      int onTheWayIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "ontheway");
      if (onTheWayIndex >= 0) {
        appFonts.ontheway = bookingStatusList[onTheWayIndex].slug!;
      }

      int onGoingIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "ongoing");
      if (onGoingIndex >= 0) {
        appFonts.onGoing = bookingStatusList[onGoingIndex].slug!;
      }

      int onHoldIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "onhold");
      if (onHoldIndex >= 0) {
        appFonts.onHold = bookingStatusList[onHoldIndex].slug!;
      }

      int restartIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "restart");
      if (restartIndex >= 0) {
        appFonts.restart = bookingStatusList[restartIndex].slug!;
      }

      int startAgainIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
              .toLowerCase()
              .replaceAll("-", "")
              .replaceAll(" ", "")
              .replaceAll("_", "") ==
          "startagain");
      if (startAgainIndex >= 0) {
        appFonts.startAgain = bookingStatusList[startAgainIndex].slug!;
      }

      int completedIndex = bookingStatusList.indexWhere((element) =>
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "completed" ||
          element.slug!
                  .toLowerCase()
                  .replaceAll("-", "")
                  .replaceAll(" ", "")
                  .replaceAll("_", "") ==
              "complete");
      if (completedIndex >= 0) {
        translations!.completed = bookingStatusList[completedIndex].slug!;
      }
    } catch (e) {
      notifyListeners();
      log("EEEE getBookingStatus :$e");
    }
  }

  //all category list
  getAllCategory({search}) async {
    // notifyListeners();
    try {
      await apiServices.getApi(api.categoryList, []).then((value) {
        if (value.isSuccess!) {
          allCategoryList = [];

          List category = value.data;
          for (var data in category.reversed.toList()) {
            if (!allCategoryList.contains(CategoryModel.fromJson(data))) {
              allCategoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
          log("allCategoryList::$allCategoryList");
        }
      });
    } catch (e) {
      log("EEEE AllCategory:::$e");
      notifyListeners();
    }
  }

  //tax list
  Future<void> getTax(zoneId) async {
    // notifyListeners();
    try {
      await apiServices.getApi("${api.tax}?zone_id=$zoneId", []).then((value) {
        if (value.isSuccess!) {
          taxList = [];
          List tax = value.data;
          for (var data in tax.reversed.toList()) {
            if (!taxList.contains(TaxModel.fromJson(data))) {
              taxList.add(TaxModel.fromJson(data));
            }
            log("taxList ${taxList.first.rate}");
            notifyListeners();
          }
        }
        //  log("taxList :$taxList");
      });
    } catch (e) {
      log("EEEE getTax $e");
      notifyListeners();
    }
  }

  //all data is necessary in the app
  commonApi(context) {
    /*   final provider = Provider.of<CommonApiProvider>(context); */
    // getBlog();
    /*  provider.selfApi(context); */
    // getAllCategory();
    // getDashBoardApi(context);
    // getPaymentMethodList();
    // getBookingStatus();
    // getDocument();
    // getCurrency();
    // getKnownLanguage();
    // getTax();

    // getSubscriptionPlanList(context);
  }

  Future<bool> checkForAuthenticate() async {
    bool isAuth = false;
    try {
      await apiServices
          .getApi(api.statisticCount, [], isToken: true)
          .then((value) {
        //log("sdhfjsdkhf :${value.data}");
        if (value.isSuccess!) {
          isAuth = true;
          notifyListeners();
          return isAuth;
        } else {
          if (value.message.toLowerCase() == "unauthenticated.") {
            isAuth = false;
            notifyListeners();
            return isAuth;
          } else {
            isAuth = false;
            notifyListeners();
            return isAuth;
          }
        }
      });
    } catch (e) {
      log("EEE homeStatisticApi :$e");
      return isAuth;
    }
    log("isAuth:$isAuth");
    return isAuth;
  }
}
