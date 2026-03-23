import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:fixit_provider/screens/app_pages_screens/boost_screen/zone_list_sheet.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import '../../config.dart';
import '../../screens/app_pages_screens/add_new_service_screen/layouts/service_bottom_sheet.dart';
import '../../screens/app_pages_screens/boost_screen/boost_category_bottom_sheet.dart';
import '../../screens/app_pages_screens/boost_screen/boost_date_range_picker_layout.dart';
import '../../widgets/year_dialog.dart';

class BoostProvider extends ChangeNotifier {
  XFile? imageFile;
  List bannerImage = [];
  dynamic chosenValue, selectPage;
  dynamic choseValue;
  dynamic serviceBanner;
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController detailsCtrl = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode detailsFocus = FocusNode();
  FocusNode videoFocus = FocusNode();
  ZoneModel? zone;
  bool isSelectedZone = false;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  List zoneSelect = [], zonesList = [];
  Services? services;
  DateTime currentDate = DateTime.now();
  TextEditingController videoCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  //zone update Address
  bool isZoneUpdate = false;

  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.month;
  int demoInt = 0;
  String showYear = 'Select Year';
  PageController pageController = PageController();
  String? month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  TextEditingController filterSearchCtrl = TextEditingController();
  final FocusNode filterSearchFocus = FocusNode();
  List<Services> selectedServices = [];
  List<Services> newServiceList = [];

  onChangeService(Services val, bool isCheck) {
    log("Service id::: ${val.id}");
    if (!selectedServices.contains(val)) {
      selectedServices.add(val);
    } else {
      selectedServices.remove(val);
    }

    newServiceList = selectedServices.map((e) {
      return allServiceList.firstWhere((s) => s.id == e.id, orElse: () => e);
    }).toList();
    notifyListeners();
  }

  Future<void> getAllServiceList({String? search}) async {
    String url = api.providerServices;
    if (search != null && search.isNotEmpty) {
      url = "$url?search=$search";
    }

    try {
      final res = await apiServices.getApi(url, [], isToken: true);
      if (res.isSuccess ?? false) {
        final List list = res.data;
        allServiceList = list.map((e) => Services.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e, s) {
      log("Error in getAllServiceList: $e\n$s");
    }
  }

  getCategory({search}) async {
    // notifyListeners();
    try {
      String apiUrl = "${api.category}?providerId=${userModel!.id}";
      if (search != null) {
        apiUrl = "${api.category}?providerId=${userModel!.id}&search=$search";
      } else {
        apiUrl = "${api.category}?providerId=${userModel!.id}";
      }

      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        if (value.isSuccess!) {
          categoryList = [];
          List category = value.data;
          // log("categorycategory :${category.length}");
          for (var data in category.reversed.toList()) {
            if (!categoryList.contains(CategoryModel.fromJson(data))) {
              categoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }

  List<PaymentMethods> paymentList = [];

  onInit(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";

    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    userApi.getAllServiceList();
    if (paymentMethods.isNotEmpty) {
      paymentList = paymentMethods;
    }

    // wallet = paymentList[0].slug;
    log("PAYE :$paymentMethods");
    notifyListeners();
    log("allServiceList::${zoneList}");
    if (services?.categories != null) {
      services?.categories!.asMap().entries.forEach((element) {
        if (!categories.contains(element.value)) {
          categories.add(element.value);
        }
        notifyListeners();
      });
    }
    if (data != "") {
      if (data["isEdit"] != "") {
        // isEdit = data["isEdit"] ?? false;
      }
    }
    focusedDay.value = DateTime.utc(focusedDay.value.year,
        focusedDay.value.month, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
    DateTime dateTime = DateTime.now();
    // int index = appArray.monthList
    //     .indexWhere((element) => element['index'] == dateTime.month);
    // chosenValue = appArray.monthList[index];
    zonesList = zoneList;
    log("zonesList::$zonesList");
    notifyListeners();
    if (userModel!.zones!.isNotEmpty) {
      for (var d in userModel!.zones!) {
        zoneSelect.add(d);
      }
    }
    notifyListeners();
    clearZoneSelection();
  }

  void clearZoneSelection() {
    zoneSelect.clear();
    isSelectedZone = false; // Reset the selection flag if you have one
    notifyListeners();
  }

  onCalendarCreate(controller) {
    pageController = controller;
  }

  // date selection button and go to back
  onSelect(context) {
    route.pop(context);
    log("rangeStart:$rangeEnd||$rangeStart");
    if (rangeEnd != null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text("opps!! you have not select date yet.",
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.whiteColor)),
          backgroundColor: appColor(context).appTheme.red));
    }
    notifyListeners();
  }

  //on date select from calendar
  onDateSelect(context, {isStart = true}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Consumer<BoostProvider>(builder: (context, value, child) {
                return const BoostDateRangePickerLayout();
              });
            }));
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

  onTapMonth(val) {
    month = val;
    notifyListeners();
  }

  int differenceInDays = 0;
  int totalServices = 0;

  //date range selection
  onRangeSelect(start, end, focusedDay) {
    selectedDay = null;
    currentDate = focusedDay;
    rangeStart = start;
    rangeEnd = end;

    rangeSelectionMode = RangeSelectionMode.toggledOn;
    startDateCtrl.text =
        "${DateFormat("dd-MM-yyyy").format(rangeStart!)}  to  ${rangeEnd != null ? DateFormat("dd-MM-yyyy").format(rangeEnd!) : ""}";
    differenceInDays = rangeEnd?.difference(rangeStart!).inDays ?? 0;
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

  void onZoneSelect(option, context) {
    // If you want to allow blank selection (toggle behavior)
    if (zoneSelect.contains(option)) {
      zoneSelect.clear(); // Deselect if already selected
    } else {
      zoneSelect.clear(); // Clear previous selection
      zoneSelect.add(option); // Add new selection
    }

    isSelectedZone = zoneSelect.isNotEmpty;
    log("Selected option: $option");
    log("Current selection: $zoneSelect");
    route.pop(context);
    notifyListeners();
  }

  List<Services> serviceList = [];
  onServiceBottomSheet(context) {
    serviceList = allServiceList;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return const ServiceBottomSheet();
        });
  }

  onBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const BoostZoneBottomSheet();
      },
    );
  }

  onReady() {
    serviceBanner = null;
    chosenValue = null;
    choseValue = null;
    imageFile = null;
    services = null;
    selectPage = null;
    titleCtrl.text = "";
    detailsCtrl.text = "";
    notifyListeners();
  }

  //get image from source
  Future getImage(context, source) async {
    final ImagePicker picker = ImagePicker();
    route.pop(context);
    imageFile = (await picker.pickImage(source: source, imageQuality: 70))!;
    notifyListeners();
  }

  //after pick image set in value
  onImagePick(context) {
    showLayout(context, onTap: (index) {
      if (index == 0) {
        getImage(context, ImageSource.gallery)
            .then((value) => bannerImage.add(imageFile));

        notifyListeners();
      } else {
        getImage(context, ImageSource.camera)
            .then((value) => bannerImage.add(imageFile));

        notifyListeners();
      }
    });
  }

  selectImageOrTextValue(val) {
    choseValue = val;

    notifyListeners();
  }

  serviceBannerValue(val) {
    serviceBanner = val;
    if (val == appFonts.service) {
      services = null;
    } else {
      choseValue = null;
      imageFile = null;
    }
    notifyListeners();
  }

  onSelectPage(val) {
    selectPage = val;
    notifyListeners();
  }

  onSelectService(val) {
    services = val;
    notifyListeners();
  }

  List<CategoryModel> categories = [], newCatList = [];
  List<CategoryModel> newCategoryList = [];

  //category selection
  onChangeCategory(CategoryModel val, id) {
    newCategoryList = [];
    //categories = val;
    if (!categories.contains(val)) {
      log("val.parentId:: ${val.parentId}");
      if (val.parentId != null) {
        int index = newCatList.indexWhere(
            (element) => element.id.toString() == val.parentId.toString());
        if (index >= 0) {
          if (!categories.contains(newCatList[index])) {
            categories.add(newCatList[index]);
          }
          notifyListeners();
        }
      }
      categories.add(val);
      notifyListeners();
    } else {
      categories.remove(val);
      notifyListeners();
    }

    notifyListeners();
    categories.asMap().entries.forEach((e) {
      int index =
          allCategoryList.indexWhere((element) => element.id == e.value.id);
      if (index >= 0) {
        newCategoryList.add(allCategoryList[index]);
      }
    });
    // notifyListeners();
    if (newCategoryList.isNotEmpty) {
      var largestGeekValue = newCategoryList.reduce((current, next) =>
          double.parse(current.commission!.toString()) >
                  double.parse(next.commission!.toString())
              ? current
              : next);
    }
    notifyListeners();
  }

  onCatBottomSheet(context) {
    log("allCategoryList:${allCategoryList}");
    newCatList = allCategoryList;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const BoostCategoryBottomSheet();
      },
    );
  }

  String? wallet;

//payment method select
  onTapGateway(val) {
    wallet = val;
    notifyListeners();
  }

//create Promotion Plan
  createPromotionPlan(context) async {
    log("serviceBanner::$choseValue}");
    if (serviceBanner != null ||
        bannerImage.isNotEmpty ||
        zoneSelect.isNotEmpty ||
        selectPage != null ||
        choseValue != null ||
        rangeStart != null ||
        rangeEnd != null ||
        newCategoryList.isNotEmpty ||
        videoCtrl.text != '') {
      try {
        showLoading(context);
        notifyListeners();

        dynamic mimeTypeData;
        if (imageFile != null) {
          mimeTypeData =
              lookupMimeType(imageFile!.path, headerBytes: [0xFF, 0xD8])!
                  .split('/');
        }

        log(" -=-=-=-= ${settingAdvertisementModel['home_screen_price']}  ${int.parse((choseValue == "Image" ? bannerImage.length.toString() : choseValue == "Video" ? "1" : categories.length.toString()))}");
        log(" -=-=-=-AAA= ${(int.parse(settingAdvertisementModel['category_screen_price'])) * differenceInDays * int.parse((choseValue == "Image" ? bannerImage.length.toString() : choseValue == "Video" ? "1" : categories.length.toString()))}");
        var price =
            "${serviceBanner == "service" ? ((selectPage == "Home" ? int.parse(settingAdvertisementModel['home_screen_price']) : (int.parse(settingAdvertisementModel['category_screen_price']))) * differenceInDays) : (selectPage == "Home" ? int.parse(settingAdvertisementModel['home_screen_price']) : int.parse(settingAdvertisementModel['category_screen_price'])) * differenceInDays * int.parse((choseValue == "Image" ? bannerImage.length.toString() : choseValue == "Video" ? "1" : categories.length.toString()))}";

        log("price:::${(selectPage == "Home" ? int.parse(settingAdvertisementModel['home_screen_price']) : int.parse(settingAdvertisementModel['category_screen_price'])) * differenceInDays * 1}");
        var body = {
          "type": serviceBanner.toString().toLowerCase(),
          "screen": selectPage == "Home" ? "home" : "category",
          "banner_type": choseValue.toString().toLowerCase(),
          if (serviceBanner == "service")
            for (int i = 0; i < newServiceList.length; i++)
              "service_ids[$i]": newServiceList[i].id,

          for (int i = 0; i < bannerImage.length; i++)
            if (imageFile != null)
              'images[$i]': await dio.MultipartFile.fromFile(
                  imageFile!.path.toString(),
                  filename: imageFile!.name.toString(),
                  contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
          "start_date": DateFormat("yyyy-MM-dd").format(rangeStart!),
          "end_date": DateFormat("yyyy-MM-dd").format(rangeEnd!),
          "zone_id": zoneSelect[0].id,
          "price": price,
          // if (choseValue == "Video")
          "video_link": videoCtrl.text
        };
        log("body ;$body");
        dio.FormData formData = dio.FormData.fromMap(body);

        await apiServices
            .postApi(api.advertisement, formData, isToken: true)
            .then((value) async {
          hideLoading(context);
          notifyListeners();
          log("AA :${value.data} || ${value.message}");
          if (value.isSuccess!) {
            serviceBanner = null;
            choseValue = null;
            imageFile = null;
            services = null;

            selectPage = null;
            titleCtrl.text = "";
            detailsCtrl.text = "";
            notifyListeners();
            route.pop(context);
            snackBarMessengers(context,
                message: value.message,
                color: appColor(context).appTheme.primary);
          } else {
            snackBarMessengers(context,
                message: value.message, color: appColor(context).appTheme.red);
          }
        });
      } catch (e) {
        hideLoading(context);
        notifyListeners();
        showErrorToast(context, e.toString());
        log("hdusifhuih::$e");
      }
    } else {
      snackBarMessengers(context, message: "Please select all required field");
    }
  }

  onBack(context, {isBack}) {
    notifyListeners();
    zoneSelect.clear(); // Clear zone selection
    isSelectedZone = false; // Reset selection flag
    zonesList = [];
    categories = [];
    rangeStart = null;
    rangeEnd = null;
    startDateCtrl.text = '';
    differenceInDays = 0;
    totalServices = 0;
    bannerImage = [];
    videoCtrl.text = '';

    if (isBack) {
      route.pop(context);
      zoneSelect = [];
    }
  }
}
