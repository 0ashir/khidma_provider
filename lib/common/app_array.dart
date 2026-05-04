import 'package:fixit_provider/model/array_model.dart';
import 'package:intl/intl.dart';

import '../config.dart';

class AppArray {
  List<String> get themeModeList => [
        translations!.darkTheme!,
        translations!.lightTheme!,
        translations!.systemDefault!
      ];
  List selectHomeCat = ["Home", appFonts.categories];
  List serviceBanner = [appFonts.service, "Banner"];
  List bannerType = ["Image", "Video"];

  // language list
  List<Map<String, dynamic>> get joiningList => [
        {"title": translations!.company, "image": eImageAssets.company},
        {"title": translations!.freelancer, "image": eImageAssets.freelancer}
      ];

  List<String> get experienceList => [
        translations!.month!.toLowerCase(),
        translations!.year!.toLowerCase(),
      ];

  List<String> get adsStatusList => [
        translations?.all ?? '',
        translations?.pending ?? '',
        translations?.approved ?? '',
        translations?.reject ?? '',
        translations?.running ?? '',
        translations?.paused ?? '',
      ];

  List<Map<String, dynamic>> get serviceAvailableAreaList => [];

  List<String> get identityList => [
        translations?.passport ?? '',
        translations?.drivingLicence ?? '',
        translations?.panCard ?? '',
        translations?.aadhaarCard ?? '',
        translations?.bankPassbook ?? '',
        translations?.votingCard ?? '',
      ];

  List<DashboardList> dashboardList() => [
        DashboardList(
            title: translations?.home ?? "Home", // Provide a fallback
            icon: eSvgAssets.homeOut,
            icon2: eSvgAssets.homeFill),
        DashboardList(
            title: translations?.booking ?? "Booking", // Provide a fallback
            icon: eSvgAssets.bookingOut,
            icon2: eSvgAssets.bookingFill),
        DashboardList(
            title: translations?.wallet ?? 'Wallet', // Provide a fallback
            icon: eSvgAssets.wallet,
            icon2: eSvgAssets.walletFill),
        DashboardList(
            title: translations?.profile ?? "Profile", // Provide a fallback
            icon: eSvgAssets.profileOut,
            icon2: eSvgAssets.profileFill),
      ];

  List<String> get socialList =>
      [eSvgAssets.serviceChat, eSvgAssets.phoneBold, eSvgAssets.mailBold];

  List get earningList => [
        {
          "title": translations?.totalEarning,
          "image": eSvgAssets.earning,
          "price":
              dashBoardModel?.totalRevenue?.toString() ?? "0" // Default value
        },
        {
          "title": translations?.totalBooking ?? "",
          "image": eSvgAssets.booking,
          "price": dashBoardModel?.totalBookings?.toString() ?? '0'
        },
        {
          "title": translations?.totalService ?? "",
          "image": eSvgAssets.box,
          "price": dashBoardModel?.totalServices?.toString() ?? "0"
        },
        {
          "title": translations?.totalCategory ?? "",
          "image": eSvgAssets.category,
          "price": dashBoardModel?.totalCategories?.toString() ?? '0'
        },
        {
          "title": translations?.totalServiceman ?? "",
          "image": eSvgAssets.servicemanIconFill,
          "price": dashBoardModel?.totalServicemen?.toString() ?? '0'
        }
      ];

  List<Map<String, String>> get serviceManEarningList => [
        {
          "title": translations?.totalEarning ?? "",
          "image": eSvgAssets.earning,
          "price": dashBoardModel?.totalRevenue?.toString() ?? "0"
        },
        {
          "title": translations?.totalBooking ?? "",
          "image": eSvgAssets.booking,
          "price": dashBoardModel?.totalBookings?.toString() ?? '0'
        },
        {
          "title": translations?.bookingsToday ?? "",
          "image": eSvgAssets.box,
          "price": dashBoardModel?.totalServices?.toString() ?? '0'
        }
      ];

  // List<String> allCategories = [
  //   translations!.allCategory??"",
  //   appFonts.acCleaning,
  //   translations!.cleaning!,
  //   appFonts.painting,
  //   appFonts.cooking
  // ];

  List<Map<String, dynamic>> monthList = [
    {"title": appFonts.january, "index": 1},
    {"title": appFonts.february, "index": 2},
    {"title": appFonts.march, "index": 3},
    {"title": appFonts.april, "index": 4},
    {"title": appFonts.may, "index": 5},
    {"title": appFonts.june, "index": 6},
    {"title": appFonts.july, "index": 7},
    {"title": appFonts.august, "index": 8},
    {"title": appFonts.september, "index": 9},
    {"title": appFonts.october, "index": 10},
    {"title": appFonts.november, "index": 11},
    {"title": appFonts.december, "index": 12}
  ];

  List<String> get durationList => [
        "Hours",
        "Minutes",
      ];

  List<String> get timeSlotsDurationList => [
        "Hours",
        "Minutes",
      ];

  List<Map<String, dynamic>> get priceList => [
        {"title": translations!.onlyPrice, "isSelect": false},
        {"title": translations!.priceWithDiscount, "isSelect": true}
      ];

  var reviewList = [
    {
      "image": eImageAssets.as1,
      "name": "Kurt Bates",
      "service": "Cleaning service",
      "rate": "4.0",
      "review":
          "“I just love their service & the staff nature for work, I’d like to hire them again”",
      "time": "12 min ago",
    },
    {
      "image": eImageAssets.as1,
      "name": "Jane Cooper",
      "service": "Painting service",
      "rate": "4.0",
      "review":
          "This provider has the best staff who assist us until the service is complete. Thank you!",
      "time": "15 days ago",
    },
    {
      "image": eImageAssets.as1,
      "name": "Lorri Warf",
      "service": "Ac cleaning",
      "rate": "4.0",
      "review": "“I love their work with ease, Thank you !”",
      "time": "28 days ago",
    },
  ];

  List<Map<String, dynamic>> reviewRating = [
    {
      "star": translations!.star5,
      "percentage": "84",
    },
    {
      "star": translations!.star4,
      "percentage": "9",
    },
    {
      "star": translations!.star3,
      "percentage": "4",
    },
    {
      "star": translations!.star2,
      "percentage": "2",
    },
    {
      "star": translations!.star1,
      "percentage": 1,
    },
  ];

  List<Map<String, dynamic>> get reviewLowHighList => [
        {"id": "0", "title": translations!.all},
        {"id": 1, "title": translations!.lowestRate},
        {"id": "2", "title": translations!.highestRate}
      ];

  List<String> get servicemanFilterList => [
        translations!.category!,
        translations!.statusMember!,
      ];

  List<String> get jobExperienceList => [
        translations!.highestExperience!,
        translations!.lowestExperience!,
      ];

  // var languagesList = [translations!.english, translations!.spanish, translations!.chines];

  List<Map<String, dynamic>> get selectList => [
        {"image": eSvgAssets.gallery, "title": translations!.chooseFromGallery},
        {"image": eSvgAssets.cameraFill, "title": translations!.openCamera}
      ];

  List<Map<String, dynamic>> get profileList => [
        {
          "title": translations!.companyInfo,
          "data": [
            {
              "icon": eSvgAssets.buildings,
              "title": isFreelancer
                  ? translations!.serviceLocation
                  : translations!.companyDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.bank,
              "title": translations!.bankDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.identity,
              "title": translations!.idVerification,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceIcon,
              "title": translations!.services,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceAddOns,
              "title": "Service Add-ons",
              "isArrow": true
            },
            {
              "icon": eSvgAssets.servicemanIcon,
              "title": translations!.serviceman,
              "isArrow": true
            }
          ],
        },
        {
          "title": translations!.otherDetails,
          "data": [
            {
              "icon": eSvgAssets.mobile,
              "title": translations!.appDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.adsType,
              "title": translations!.advertisement,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.calender,
              "title": translations!.timeSlots,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.commission,
              "title": translations!.commissionDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.gift,
              "title": translations!.myPackages,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.starOut,
              "title": translations!.myReview,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.crown,
              "title": translations!.subscriptionPlan,
              "isArrow": true
            },
            if (appSettingModel!.activation!.referralEnable == "1")
              {
                "icon": eSvgAssets.discount,
                "title": appFonts.referralId,
                "isArrow": true
              },
            {
              "icon": eSvgAssets.chat,
              "title": translations!.staffChat,
              "isArrow": true
            },
          ]
        },
        {
          "title": translations!.alertZone,
          "data": [
            {
              "icon": eSvgAssets.delete,
              "title": translations!.deleteAccount,
              "isArrow": false
            },
            {
              "icon": eSvgAssets.logout,
              "title": translations!.logOut,
              "isArrow": false
            }
          ]
        },
      ];
  List<Map<String, dynamic>> get profileListWithoutSubscription => [
        {
          "title": translations!.companyInfo,
          "data": [
            {
              "icon": eSvgAssets.buildings,
              "title": isFreelancer
                  ? translations!.serviceLocation
                  : translations!.companyDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.bank,
              "title": translations!.bankDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.identity,
              "title": translations!.idVerification,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceIcon,
              "title": translations!.services,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceAddOns,
              "title": appFonts.serviceAddons,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.servicemanIcon,
              "title": translations!.serviceman,
              "isArrow": true
            }
          ],
        },
        {
          "title": translations!.otherDetails,
          "data": [
            {
              "icon": eSvgAssets.mobile,
              "title": translations!.appDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.adsType,
              "title": translations!.advertisement,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.calender,
              "title": translations!.timeSlots,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.commission,
              "title": translations!.commissionDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.gift,
              "title": translations!.myPackages,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.starOut,
              "title": translations!.myReview,
              "isArrow": true
            },
            if (appSettingModel!.activation!.referralEnable == "1")
              {
                "icon": eSvgAssets.discount,
                "title": appFonts.referralId,
                "isArrow": true
              },
            {
              "icon": eSvgAssets.chat,
              "title": translations!.staffChat,
              "isArrow": true
            },
          ]
        },
        {
          "title": translations!.alertZone,
          "data": [
            {
              "icon": eSvgAssets.delete,
              "title": translations!.deleteAccount,
              "isArrow": false
            },
            {
              "icon": eSvgAssets.logout,
              "title": translations!.logOut,
              "isArrow": false
            }
          ]
        },
      ];

  List<Map<String, dynamic>> get profileListAsServiceman => [
        {
          "title": translations!.companyInfo,
          "data": [
            {
              "icon": eSvgAssets.buildings,
              "title": isFreelancer
                  ? translations!.serviceLocation
                  : translations!.companyDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.bank,
              "title": translations!.bankDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.identity,
              "title": translations!.idVerification,
              "isArrow": true
            },
          ],
        },
        {
          "title": translations!.otherDetails,
          "data": [
            {
              "icon": eSvgAssets.mobile,
              "title": translations!.appDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.commission,
              "title": translations!.commissionDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.starOut,
              "title": translations!.myReview,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.chat,
              "title": translations!.staffChat,
              "isArrow": true
            },
          ]
        },
        {
          "title": translations!.alertZone,
          "data": [
            {
              "icon": eSvgAssets.delete,
              "title": translations!.deleteAccount,
              "isArrow": false
            },
            {
              "icon": eSvgAssets.logout,
              "title": translations!.logOut,
              "isArrow": false
            }
          ]
        },
      ];

  List<Map<String, dynamic>> get profileListAsFreelance => [
        {
          "title": translations!.companyInfo,
          "data": [
            {
              "icon": eSvgAssets.buildings,
              "title": translations!.serviceLocation,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.bank,
              "title": translations!.bankDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.identity,
              "title": translations!.idVerification,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceIcon,
              "title": translations!.services,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceAddOns,
              "title": appFonts.serviceAddons,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.gift,
              "title": translations!.myPackages,
              "isArrow": true
            },
          ],
        },
        {
          "title": translations!.otherDetails,
          "data": [
            {
              "icon": eSvgAssets.mobile,
              "title": translations!.appDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.calender,
              "title": translations!.timeSlots,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.commission,
              "title": translations!.commissionDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.starOut,
              "title": translations!.myReview,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.crown,
              "title": translations!.subscriptionPlan,
              "isArrow": true
            },
            if (appSettingModel!.activation!.referralEnable == "1")
              {
                "icon": eSvgAssets.discount,
                "title": appFonts.referralId,
                "isArrow": true
              },
            {
              "icon": eSvgAssets.chat,
              "title": translations!.staffChat,
              "isArrow": true
            },
          ]
        },
        {
          "title": translations!.alertZone,
          "data": [
            {
              "icon": eSvgAssets.delete,
              "title": translations!.deleteAccount,
              "isArrow": false
            },
            {
              "icon": eSvgAssets.logout,
              "title": translations!.logOut,
              "isArrow": false
            }
          ]
        },
      ];
  List<Map<String, dynamic>> get profileListAsFreelanceWithoutSubscription => [
        {
          "title": translations!.companyInfo,
          "data": [
            {
              "icon": eSvgAssets.buildings,
              "title": translations!.serviceLocation,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.bank,
              "title": translations!.bankDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.identity,
              "title": translations!.idVerification,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceIcon,
              "title": translations!.services,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.serviceAddOns,
              "title": appFonts.serviceAddons,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.gift,
              "title": translations!.myPackages,
              "isArrow": true
            },
          ],
        },
        {
          "title": translations!.otherDetails,
          "data": [
            {
              "icon": eSvgAssets.mobile,
              "title": translations!.appDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.calender,
              "title": translations!.timeSlots,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.commission,
              "title": translations!.commissionDetails,
              "isArrow": true
            },
            {
              "icon": eSvgAssets.starOut,
              "title": translations!.myReview,
              "isArrow": true
            },
            if (appSettingModel!.activation!.referralEnable == "1")
              {
                "icon": eSvgAssets.discount,
                "title": appFonts.referralId,
                "isArrow": true
              },
            {
              "icon": eSvgAssets.chat,
              "title": translations!.staffChat,
              "isArrow": true
            },
          ]
        },
        {
          "title": translations!.alertZone,
          "data": [
            {
              "icon": eSvgAssets.delete,
              "title": translations!.deleteAccount,
              "isArrow": false
            },
            {
              "icon": eSvgAssets.logout,
              "title": translations!.logOut,
              "isArrow": false
            }
          ]
        },
      ];

  //app setting
  List appSetting(isTheme) => [
        {
          'title': isTheme ? translations!.lightTheme : translations!.darkTheme,
          'icon': eSvgAssets.dark
        },
        {
          'title': translations!.updateNotification,
          'icon': eSvgAssets.notification
        },
        /*     {'title': translations!.changeCurrency, 'icon': eSvgAssets.currency}, */
        {'title': translations!.changeLanguage, 'icon': eSvgAssets.translate},
        {'title': translations!.changePassword, 'icon': eSvgAssets.lock}
      ];

  List<Map<String, dynamic>> get currencyList => [
        {
          'title': translations!.usDollar,
          'icon': eSvgAssets.usCurrency,
          "code": "USD",
          "symbol": "\$",
          'USD': 1,
          'INR': 83.24,
          'POU': 0.83,
          'EUR': 0.96,
        },
        {
          'title': translations!.euro,
          'icon': eSvgAssets.euroCurrency,
          "code": "EUR",
          "symbol": '€',
          'USD': 1.05,
          'INR': 87.10,
          'POU': 0.87,
          'EUR': 1,
        },
        {
          'title': translations!.inr,
          'icon': eSvgAssets.inCurrency,
          "code": "INR",
          "symbol": '₹',
          'USD': 0.012,
          'INR': 1,
          'POU': 0.010,
          'EUR': 0.011,
        },
        {
          'title': translations!.pound,
          'icon': eSvgAssets.ukCurrency,
          "code": "POU",
          "symbol": "£",
          'USD': 1.22,
          'INR': 101.74,
          'POU': 1,
          'EUR': 1.15,
        }
      ];

  List<Map<String, dynamic>> companyDetailList = [
    {
      "icon": eSvgAssets.phone,
      "title": translations!.phone,
      "subtitle": "+91 25623 25623"
    },
    {
      "icon": eSvgAssets.locationOut,
      "title": "2118 Thornridge Cir. Syracuse, Connecticut - 35624, USA.",
      "subtitle": ""
    },
    {
      "icon": eSvgAssets.timer,
      "title": translations!.experience,
      "subtitle": "2 years of experience"
    },
    {
      "icon": eSvgAssets.service,
      "title": translations!.noOfCompletedService,
      "subtitle": "234"
    },
  ];

  List<Map<String, dynamic>> get documentsList => [
        {
          "title": translations!.drivingLicence,
          "image": eImageAssets.dl,
          "status": translations!.requestPending
        },
        {
          "title": translations!.panCard,
          "image": eImageAssets.panCard,
          "status": translations!.requestForUpdate
        },
        {
          "title": translations!.aadhaarCard,
          "image": eImageAssets.aadharCard,
          "status": translations!.requestForUpdate
        },
        {
          "title": translations!.votingCard,
          "image": eImageAssets.voterCard,
          "status": translations!.requestForUpdate
        },
      ];

  List<String> get timeSlotStartAtList =>
      [translations!.days!, translations!.startsAt!, translations!.endAt!];

  List<TimeSlots> timeSlotList = [
    TimeSlots(day: 'MONDAY', slots: [], status: 1),
    TimeSlots(day: 'TUESDAY', slots: [], status: 1),
    TimeSlots(day: 'WEDNESDAY', slots: [], status: 1),
    TimeSlots(day: 'THURSDAY', slots: [], status: 1),
    TimeSlots(day: 'FRIDAY', slots: [], status: 1),
    TimeSlots(day: 'SATURDAY', slots: [], status: 1),
    TimeSlots(day: 'SUNDAY', slots: [], status: 1),
  ];

  List<TimeSlots> newTimeSlotList = [
    TimeSlots(day: 'MONDAY', slots: [], status: 1),
    TimeSlots(day: 'TUESDAY', slots: [], status: 1),
    TimeSlots(day: 'WEDNESDAY', slots: [], status: 1),
    TimeSlots(day: 'THURSDAY', slots: [], status: 1),
    TimeSlots(day: 'FRIDAY', slots: [], status: 1),
    TimeSlots(day: 'SATURDAY', slots: [], status: 1),
    TimeSlots(day: 'SUNDAY', slots: [], status: 1),
  ];

  List<String> hourList = List.generate(12, (index) {
    DateTime time = DateTime.now().add(Duration(hours: index + 2));
    String formattedTime = DateFormat('h').format(time);

    return formattedTime;
  });

  List<String> minList = List.generate(60, (index) {
    int minIndex = index + 1;

    return minIndex.toString();
  });

  var amPmList = ["AM", "PM"];

  List<String> get benefits => [
        appFonts.service,
        appFonts.serviceman,
        appFonts.serviceLocation,
        appFonts.packages,
      ];

  List planList(isMonth) => [
        {
          "price": "15",
          "type": isMonth ? "month" : "year",
          "plan_type": "Standard plan",
          "benefits": [
            "Add up to 10 service",
            "Add up to 10 servicemen",
            "Add up to 6 service location",
            "Add up to 6 service in packages",
          ]
        },
        {
          "price": "10",
          "type": isMonth ? "month" : "year",
          "plan_type": "Regular plan",
          "benefits": [
            "Add up to 8 service",
            "Add up to 8 servicemen",
            "Add up to 4 service location",
            "Add up to 4 service in packages",
          ]
        },
        {
          "price": "25",
          "type": isMonth ? "month" : "year",
          "plan_type": "Premium plan",
          "benefits": [
            "Add up to 12 service",
            "Add up to 12 servicemen",
            "Add up to 8 service location",
            "Add up to 4 service in packages",
          ]
        },
      ];

  Map<String, dynamic> get subscriptionPlanList => {
        "title": translations!.try7Days,
        "subtext": translations!.getFreeTrial,
        "benefits": [
          translations!.addUpTo3Service,
          translations!.addUpTo3Servicemen,
          translations!.addUpTo3ServiceLocation,
          translations!.addUpTo3ServicePackages
        ]
      };

  List<String> get bookingFilterList => [
        translations!.status!,
        translations!.date!,
        translations!.category!,
      ];

  List<String> get selectServicemenList =>
      [translations!.assignToMe!, translations!.assignToOther!];

  List<Map<String, dynamic>> get ratingList => [
        {
          "rate": "5 rate",
          "icon": eSvgAssets.star5,
        },
        {
          "rate": "4 rate",
          "icon": eSvgAssets.star4,
        },
        {
          "rate": "3 rate",
          "icon": eSvgAssets.star3,
        },
        {
          "rate": "2 rate",
          "icon": eSvgAssets.star2,
        },
        {
          "rate": "1 rate",
          "icon": eSvgAssets.star1,
        },
      ];

  List<String> get optionList =>
      [translations!.call!, translations!.clearChat!];

  List<String> get chatHistoryOptionList =>
      [translations!.refresh!, translations!.clearChat!];

  List<Map<String, dynamic>> get dashBoardList => [
        {
          "image": eSvgAssets.colorFilter,
          "title": translations!.addNewService,
        },
        {
          "image": eSvgAssets.userTagFill,
          "title": translations!.addNewServicemen,
        },
      ];

  List<XFile> serviceImageList = [];
  List<XFile> webServiceImageList = [];

  List<XFile> servicemanDocImageList = [];

  List<String> get servicemenExperienceList => [
        translations!.allServicemen!,
        translations!.highestExperience!,
        translations!.lowestExperience!,
        translations!.highestServed!,
        translations!.lowestServed!
      ];

  List<ChartData> weekData = [
    /*  ChartData('M', 12),
    ChartData('T', 15),
    ChartData('W', 30),
    ChartData('TH', 6.4),
    ChartData('F', 14),
    ChartData('S', 7),
    ChartData('S', 9),*/
  ];

  List<ChartData> monthData = [
    /* ChartData('Ja', 12),
    ChartData('Fe', 15),
    ChartData('Ma', 30),
    ChartData('Ap', 6.4),
    ChartData('May', 14),
    ChartData('Ju', 7),
    ChartData('Jl', 16),
    ChartData('Au', 19),
    ChartData('Se', 10),
    ChartData('Oc', 15),
    ChartData('No', 10),
    ChartData('De', 9),*/
  ];

  List<ChartData> yearData = [
    /* ChartData('2016', 12),
    ChartData('2017', 15),
    ChartData('2018', 30),
    ChartData('2019', 6.4),
    ChartData('2020', 14),
    ChartData('2021', 7),
    ChartData('2022', 16),
    ChartData('2023', 19),
    ChartData('Se', 10),
    ChartData('2024', 15)*/
  ];

  List<ChartDataColor> earningChartData = [];

  List<Map<String, dynamic>> get serviceType => [
        {"title": translations!.userSite, "val": "fixed"},
        {"title": translations!.providerSite, "val": "provider_site"},
        {"title": translations!.remotely, "val": "remotely"},
        {"title": translations!.scheduled, "val": "scheduled"}
      ];
}
