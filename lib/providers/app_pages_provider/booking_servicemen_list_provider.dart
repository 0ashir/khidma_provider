import 'dart:developer';

import 'package:fixit_provider/config.dart';

class BookingServicemenListProvider with ChangeNotifier {
  List<ServicemanModel> selectService = [];
  List<ServicemanModel> searchList = [];

  TextEditingController searchCtrl = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String? yearValue;
  int? selectedIndex;
  List selectedRates = [];
  bool isAvailable = false, isTap = false, isAssignLoading = false;
  int? required;
  String? amount;

  BookingModel? bookingModel;

  //on page init data fetch
  onReady(context) {
    isTap = false;
    isAssignLoading = false;
    servicemanList = [];

    getServicemenByProviderId(context);
    hideLoading(context);
    selectedIndex = null;
    selectService = [];
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("data :$data");
    if (data != null) {
      required = data["servicemen"] ?? 1;
      bookingModel = data['data'];

      notifyListeners();
    }

    searchFocus.addListener(() {
      if (!searchFocus.hasFocus) {
        isTap = false;
        notifyListeners();
      }
      hideLoading(context);
    });
  }

  //on clear tap
  onClearTap(context) {
    selectedRates = [];
    yearValue = null;

    if (!isFreelancer) {
      getServicemenByProviderId(context);
    }

    route.pop(context);
    notifyListeners();
  }

  //on search submit
  onSearchSubmit(context, v) {
    if (v.isEmpty) {
      getServicemenByProviderId(context, search: searchCtrl.text);
    } else if (v.length >= 3) {
      getServicemenByProviderId(context, search: searchCtrl.text);
    }
    notifyListeners();
  }

  // booking service list status
  onTapSwitch(val) {
    isAvailable = val;
    notifyListeners();
  }

  //on year selection
  onTapYear(val) {
    yearValue = val;
    notifyListeners();
  }

  //rating selection
  onTapRating(id) {
    if (!selectedRates.contains(id)) {
      selectedRates.add(id);
    } else {
      selectedRates.remove(id);
    }
    notifyListeners();
  }

  //serviceman selection or remove
  onTapRadio(index, val) {
    selectedIndex = index;
    if (!selectService.contains(val)) {
      selectService.add(val);
    } else {
      selectService.remove(val);
    }
    notifyListeners();
  }

  //category selection and remove
  void onCategorySelected(index) {
    if (selectService.contains(index)) {
      selectService.remove(index); // unselect
    } else {
      selectService.add(index); // select
    }
    notifyListeners();
  }

  //booking filter bottom sheet
  onTapFilter(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context1) {
        return const BookingServicemenListFilter();
      },
    ).then((value) {});
  }

  //assign serviceman
  onAssignBooking(context) {
    log("messagedfh :$selectService");
    if (required == 1) {
      log("required::$required");
      if (selectedIndex != null) {
        log("required::$required");
        log("selectedIndex::$selectedIndex");

        showDialog(
            context: context,
            builder: (BuildContext context1) {
              return AssignSingleServiceman(selectService: selectService);
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Please select $required servicemen",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.whiteColor)),
            backgroundColor: appColor(context).appTheme.red,
            behavior: SnackBarBehavior.floating));
      }
    } else {
      if (selectService.isNotEmpty) {
        if (required == selectService.length) {
          showDialog(
              context: context,
              builder: (BuildContext context1) {
                return AssignMultipleServiceman(selectService: selectService);
              });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 500),
              content: Text("Please select $required  servicemen",
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.whiteColor)),
              backgroundColor: appColor(context).appTheme.red,
              behavior: SnackBarBehavior.floating));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Please select $required  servicemen",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.whiteColor)),
            backgroundColor: appColor(context).appTheme.red,
            behavior: SnackBarBehavior.floating));
      }
    }
  }

  //apply filter tap
  applyTap(context) async {
    await getServicemenByProviderId(context);
    route.pop(context);
  }

  //get serviceman by provider id
  getServicemenByProviderId(context, {search}) async {
    try {
      showLoading(context);
      notifyListeners();
      String rate = "";
      rate = selectedRates.join(', ');

      String apiUrl = "";
      if (selectedRates.isNotEmpty) {
        log("rate: $rate");
        apiUrl = "${api.serviceman}?provider_id=${userModel!.id}&rating=$rate";
      } else if (searchCtrl.text.isNotEmpty) {
        apiUrl =
            "${api.serviceman}?provider_id=${userModel!.id}&search=${searchCtrl.text}";
      } else if (yearValue != null) {
        apiUrl =
            "${api.serviceman}?provider_id=${userModel!.id}&experience=${yearValue == "highestExperience" ? "high" : "low"}";
      } else if (yearValue != null && selectedRates.isNotEmpty) {
        apiUrl =
            "${api.serviceman}?provider_id=${userModel!.id}&experience=${yearValue == "highestExperience" ? "high" : "low"}&rating=$rate";
      } else if (yearValue != null && searchCtrl.text.isNotEmpty) {
        apiUrl =
            "${api.serviceman}?provider_id=${userModel!.id}&experience=${yearValue == "highestExperience" ? "high" : "low"}&search=${searchCtrl.text}";
      } else if (yearValue != null &&
          searchCtrl.text.isNotEmpty &&
          selectedRates.isNotEmpty) {
        apiUrl =
            "${api.serviceman}?provider_id=${userModel!.id}&experience=${yearValue == "highestExperience" ? "high" : "low"}&search=${searchCtrl.text}&rating=$rate";
      } else {
        apiUrl = "${api.serviceman}?provider_id=${userModel!.id}";
      }

      await apiServices.getApi(apiUrl, []).then((value) {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          List data = value.data;

          if (searchCtrl.text.isNotEmpty) {
            searchList = [];
            for (var list in data) {
              if (!searchList.contains(ServicemanModel.fromJson(list))) {
                searchList.add(ServicemanModel.fromJson(list));
              }
              notifyListeners();
            }
          } else {
            servicemanList = [];
            for (var list in data) {
              if (!servicemanList.contains(ServicemanModel.fromJson(list))) {
                servicemanList.add(ServicemanModel.fromJson(list));
              }
              notifyListeners();
            }
          }
        } else {
          log("Error fetching servicemen: ${value.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.message),
            backgroundColor: appColor(context).appTheme.red,
          ));
        }
      });
    } catch (e, s) {
      log("ERRROEEE getServicemenByProviderId : $e ======> $s");
      hideLoading(context);
      notifyListeners();
    }
  }
}
