import 'dart:developer';
import '../../config.dart';
import '../../model/dash_board_model.dart' show Booking;
import '../../widgets/year_dialog.dart';

class BookingProvider with ChangeNotifier {
  final List<String> options = [
    'All',
    'Today',
    'Tomorrow',
    'Upcoming',
    'Past',
    'Scheduled'
  ];
  String selectedValue = 'All';

  TextEditingController searchCtrl = TextEditingController();
  FocusNode searchFocus = FocusNode();
  FocusNode categoriesFocus = FocusNode();

  String? month;
  List<BookingModel> bookingList = [];
  List freelancerBookingList = [];
  List selectedCategoryList = [];
  bool isExpand = false, isAssignMe = false, isSearchData = false;
  int selectIndex = 0;
  int? statusIndex;
  dynamic slotChosenValue;
  DateTime? slotSelectedDay;
  double widget1Opacity = 0.0;
  DateTime slotSelectedYear = DateTime.now();
  dynamic chosenValue;
  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.month;
  int demoInt = 0;
  PageController pageController = PageController();
  TextEditingController categoryCtrl = TextEditingController();
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime currentDate = DateTime.now();
  String showYear = 'Select Year';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode reasonFocus = FocusNode();
  TextEditingController reasonCtrl = TextEditingController();
  bool isLodingForAssignMe = false;
  int currentPage = 1;
  bool hasMoreData = true;
  bool isLoadingMore = false;
  bool isLoadingForBookingHistory = false;
  bool isInitialLoading = true;

  void setInitialLoading(bool value) {
    isInitialLoading = value;
    notifyListeners();
  }

  void setLoadingMore(
    bool value,
  ) {
    isLoadingMore = value;
    notifyListeners();
  }

  void resetPagination({bool? clearList}) {
    currentPage = 1;
    hasMoreData = true;
    if (clearList == true) bookingList = []; // only clear if explicitly asked
    notifyListeners();
  }

  void setFilter(String? value) {
    selectedValue = value!;
    notifyListeners();
  }

  void resetFilter() {
    selectedValue = 'All';
    notifyListeners();
  }

  onReady(context) {
    /*  final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    userApi.getBookingHistory(context); */
    notifyListeners();
    onInit();
    notifyListeners();
  }

  clearTap(context, {isBack = true}) {
    final common = Provider.of<UserDataApiProvider>(context, listen: false);
    statusIndex = null;
    selectedCategoryList = [];
    rangeEnd = null;
    rangeStart = null;
    selectIndex = 0;
    notifyListeners();
    common.getBookingHistory(context);
    if (isBack) {
      route.pop(context, arg: "clear");
    }
  }

  String totalCountFilter() {
    int count = 0;

    if (selectedCategoryList.isNotEmpty) {
      count++;
    }
    if (rangeStart != null || rangeEnd != null) {
      count++;
    }
    if (statusIndex != null) {
      count++;
    }

    return count.toString();
  }

  onRejectBooking(context, id) {
    showDialog(
        context: context,
        builder: (context1) => AppAlertDialogCommon(
            isField: true,
            validator: (value) => validation.commonValidation(context, value),
            focusNode: reasonFocus,
            controller: reasonCtrl,
            title: translations!.reasonOfRejectBooking,
            singleText: translations!.send,
            globalKey: formKey,
            singleTap: () {
              if (formKey.currentState!.validate()) {
                final bookingProvider =
                    Provider.of<PendingBookingProvider>(context, listen: false);

                bookingProvider.updateStatus(context, id,
                    isCancel: true, isBack: true);
              }
              notifyListeners();
            })).then((value) {
      reasonCtrl.text = "";
      notifyListeners();
    });
  }

  onAssignTap(context, {BookingModel? bookingModel, Booking? booking}) {
    log("bookingModel!.requiredServicemen::${bookingModel!.requiredServicemen}");
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
                assignServiceman(context, [userModel!.id], bookingModel.id);
              },
              firstBTap: () {
                // log("firstBTap  Booking Provider");
                route.pop(context);
              }));
    } else {
      if ((bookingModel.requiredServicemen ?? 1) > 1) {
        log("DDDD ");
        route.pushNamed(context, routeName.bookingServicemenList, arg: {
          "servicemen": bookingModel.requiredServicemen ?? 1,
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

            assignServiceman(context, ids, bookingModel.id);
          }
        });
      } else {
        log("bookingModel!.requiredServicemen::${bookingModel.requiredServicemen}");
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context1) {
              return SelectServicemenSheet(
                  arguments: bookingModel.requiredServicemen ?? 1);
            });
      }
    }
  }

  //assign serviceman
  assignServiceman(context, List val, id) async {
    try {
      showLoading(context);
      notifyListeners();

      var body = {"booking_id": id, "servicemen_ids": val};
      log("ASSSIGN BODY : $body");
      await apiServices
          .postApi(api.assignBooking, body, isToken: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.loadBookingsFromLocal(context);
          if (selectIndex == 0) {
            route.pushNamed(context, routeName.assignBooking, arg: id);
          } else {
            route.pushNamed(context, routeName.assignBooking, arg: id);
          }
        } else {
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE assignServiceman : $e");
    }
  }

  onAcceptBooking(context, id) async {
    final bookingProvider =
        Provider.of<PendingBookingProvider>(context, listen: false);
    showLoading(context);
    notifyListeners();
    await bookingProvider.updateStatus(context, id);
    hideLoading(context);
    notifyListeners();
  }

  onTapBookings(BookingModel data, context) {
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);
    log("data.bookingStatus!.slug :${data.bookingStatus!.slug}}");

    if (data.bookingStatus != null) {
      if (data.bookingStatus!.slug == appFonts.pending) {
        //route.pushNamed(context, routeName.packageBookingScreen);
        route
            .pushNamed(context, routeName.pendingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.accepted) {
        if (isFreelancer) {
          route
              .pushNamed(context, routeName.assignBooking, arg: data.id)
              .then((e) {
            dash.loadBookingsFromLocal(context);
          });
        } else {
          log("data.id::${data.id}");
          route
              .pushNamed(context, routeName.acceptedBooking, arg: data.id)
              .then((e) {
            dash.getBookingHistory(context);
          });
        }
        /* {"amount": "0", "assign_me": data.providerId.toString() == userModel!.id.toString()? true: false}*/
      } else if (data.bookingStatus!.slug == appFonts.pendingApproval) {
        route
            .pushNamed(context, routeName.pendingApprovalBooking, arg: data.id)
            .then((e) {
          dash.getBookingHistory(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onHold1) {
        route
            .pushNamed(context, routeName.holdBooking, arg: data.id)
            .then((e) async {
          await Future.wait([
            Future(() {
              dash.loadBookingsFromLocal(context);
            })
          ]);
        });
      } else if (data.bookingStatus!.slug == appFonts.onHold) {
        route
            .pushNamed(context, routeName.holdBooking, arg: data.id)
            .then((e) async {
          await Future.wait([
            Future(() {
              dash.loadBookingsFromLocal(context);
            })
          ]);
        });
      } else if (data.bookingStatus!.slug == appFonts.onGoing.toLowerCase() ||
          data.bookingStatus!.slug == appFonts.ontheway ||
          data.bookingStatus!.slug == appFonts.startAgain) {
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
            .then((e) async {
          await Future.wait([
            Future(() {
              dash.loadBookingsFromLocal(context);
            })
          ]);
        });
      }
    } else {
      route
          .pushNamed(context, routeName.pendingBooking, arg: data.id)
          .then((e) async {
        dash.getBookingHistory(context);
      });
    }
  }

  /*onTapBookings(data,context){
    if(data.status == translations!.pending) {
      //route.pushNamed(context, routeName.packageBookingScreen);
      if(data.servicemanLists.isNotEmpty) {
        route.pushNamed(context, routeName.pendingBooking,arg: true);
      } else {
        route.pushNamed(context, routeName.pendingBooking,arg: false);
      }
    } else if(data.status == translations!.accepted) {
      if(isFreelancer) {
        route.pushNamed(context, routeName.assignBooking);
      } else {
        if(data.assignMe == "Yes") {
          route.pushNamed(context, routeName.acceptedBooking,arg: {"amount": "0","assign_me": true});
        } else {
          route.pushNamed(context, routeName.acceptedBooking,arg: {"amount": "0","assign_me": false});
        }

      }
    } else if(data.status == translations!.pendingApproval) {
      route.pushNamed(context, routeName.pendingApprovalBooking);
    } else if(data.status == translations!.ongoing) {
      if(data.servicemanLists.isNotEmpty) {
        route.pushNamed(context, routeName.ongoingBooking,arg: {
          "bool": false
        });
      } else {
        route.pushNamed(context, routeName.ongoingBooking,arg: {
          "bool": true
        });
      }
    } else if(data.status == translations!.hold) {
      route.pushNamed(context, routeName.holdBooking);
    } else if(data.status == translations!.completed) {
      route.pushNamed(context, routeName.completedBooking);
    } else if(data.status == translations!.cancelled) {
      route.pushNamed(context, routeName.cancelledBooking);
    } else if(data.status == translations!.assigned) {
      if(data.servicemanLists.isNotEmpty) {
        route.pushNamed(context, routeName.assignBooking,arg: {
          "bool": true
        });
      } else {
        route.pushNamed(context, routeName.assignBooking,arg: {
          "bool": false
        });
      }
    }
  }*/

  onTapSwitch(val, context) async {
    isAssignMe = val;
    isLodingForAssignMe = true;

    notifyListeners();
    notifyListeners();
    if (isAssignMe) {
      /* final userApi = Provider.of<UserDataApiProvider>(context, listen: false);

      await Future.wait([
        Future(
          () {
            userApi.getBookingHistory(context);
          },
        )
      ]); */
      isLodingForAssignMe = false;

      notifyListeners();
      log("list :${bookingList.length}");
      bookingList = bookingList
          .where((element) =>
              element.servicemen != null &&
              (element.servicemen!
                  .where((e) => e.id.toString() == userModel!.id.toString())
                  .isNotEmpty))
          .toList();
      notifyListeners();
    } else {
      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
      userApi.loadBookingsFromLocal(context);
    }
    isLodingForAssignMe = false;

    notifyListeners();
  }

  onTapMonth(val) {
    month = val;
    notifyListeners();
  }

  onRangeSelect(start, end, focusedDay) {
    selectedDay = null;
    currentDate = focusedDay;
    rangeStart = start;
    rangeEnd = end;
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    notifyListeners();
  }

  selectYear(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context3) {
          return YearAlertDialog(
              selectedDate: selectedYear,
              onChanged: (DateTime dateTime) {
                selectedYear = dateTime;
                showYear = "${dateTime.year}";
                focusedDay.value = DateTime.utc(selectedYear.year,
                    chosenValue["index"], focusedDay.value.day + 0);
                onDaySelected(focusedDay.value, focusedDay.value);
                notifyListeners();
                route.pop(context);
              });
        });
  }

  onDropDownChange(choseVal) {
    notifyListeners();
    chosenValue = choseVal;
    log("chosenValue::$chosenValue");
    notifyListeners();
    int index = choseVal['index'];
    focusedDay.value =
        DateTime.utc(focusedDay.value.year, index, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
  }

//aa booking nu status par thi screen open thay che
  onRightArrow() {
    pageController.nextPage(
        duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
    final newMonth = focusedDay.value.add(const Duration(days: 30));
    focusedDay.value = newMonth;
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == focusedDay.value.month);
    chosenValue = appArray.monthList[index];
    selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
        focusedDay.value.day + 0);
    notifyListeners();
  }

  onLeftArrow() {
    if (focusedDay.value.month != DateTime.january ||
        focusedDay.value.year != DateTime.now().year) {
      pageController.previousPage(
          duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
      final newMonth = focusedDay.value.subtract(const Duration(days: 30));
      focusedDay.value = newMonth;
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == focusedDay.value.month);
      chosenValue = appArray.monthList[index];
      selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
          focusedDay.value.day + 0);
    }
    notifyListeners();
  }

  void onDaySelected(DateTime selectDay, DateTime fDay) {
    notifyListeners();
    focusedDay.value = selectDay;
  }

  onPageCtrl(dayFocused) {
    focusedDay.value = dayFocused;
    demoInt = dayFocused.year;
    notifyListeners();
  }

  onInit() {
    focusedDay.value = DateTime.utc(focusedDay.value.year,
        focusedDay.value.month, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
    DateTime dateTime = DateTime.now();
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == dateTime.month);
    chosenValue = appArray.monthList[index];
    Future.delayed(const Duration(milliseconds: 150), () {
      widget1Opacity = 1;
      notifyListeners();
    });
    notifyListeners();
  }

  onCalendarCreate(controller) {
    pageController = controller;
  }

  onCategoryChange(context, id) {
    if (!selectedCategoryList.contains(id)) {
      selectedCategoryList.add(id);
    } else {
      selectedCategoryList.remove(id);
    }

    notifyListeners();
  }

  onStatus(index) {
    statusIndex = index;
    notifyListeners();
  }

  onFilter(index) {
    selectIndex = index;
    notifyListeners();
  }

  onExpand(data) {
    data.isExpand = !data.isExpand;
    notifyListeners();
  }

  onTapFilter(context) {
    Future.delayed(DurationsDelay.ms150).then((value) async {
      final userApi = Provider.of<CommonApiProvider>(context, listen: false);
      await userApi.getBookingStatus();
      notifyListeners();
    });
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const BookingFilterLayout();
      },
    );
  }

/* List<dynamic> _data = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  final int _pageSize = 5;
  bool _hasMoreData = true;

  List<dynamic> get data => _data;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreData => _hasMoreData;

  // Fetch initial data
  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiServices.fetchPaginatedData(
          api.assignBooking, _currentPage, _pageSize);
      if (response.isNotEmpty) {
        _data = response;
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch more data for pagination
  Future<void> fetchMoreData() async {
    if (_isFetchingMore || !_hasMoreData) return;

    _isFetchingMore = true;
    _currentPage++;
    notifyListeners();

    try {
      final response = await apiServices.fetchPaginatedData(
          api.assignBooking, _currentPage, _pageSize);
      if (response.isNotEmpty) {
        _data.addAll(response);
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      print('Error fetching more data: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  } */
}
