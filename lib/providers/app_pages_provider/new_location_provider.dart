import 'dart:developer';

import '../../config.dart';

class NewLocationProvider with ChangeNotifier {
  List locationList = [];
  int selectIndex = 0;
  int? argIndex;
  bool? status;
  List categoryList = [
    translations!.home,
    translations!.work,
    translations!.other,
  ];
  int? radius;
  bool isCheck = false,
      isEdit = false,
      isCompany = false,
      isServiceman = false,
      isAddressServiceman = false,
      isService = false;
  GlobalKey<FormState> locationFormKey = GlobalKey<FormState>();

  PrimaryAddress? address;
  String dialCode = "+${appSettingModel?.general?.countryCode ?? 1}" /* "+1" */;
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController countryCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController zipCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController numberCtrl = TextEditingController();
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();

  CountryStateModel? country;
  StateModel? state;
  List<CountryStateModel> countryList = [];
  List<StateModel> statesList = [];

  final FocusNode nameFocus = FocusNode();
  final FocusNode numberFocus = FocusNode();
  final FocusNode zipFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode streetFocus = FocusNode();
  final FocusNode latitudeFocus = FocusNode();
  final FocusNode longitudeFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();

  int countryValue = -1, stateValue = -1;

  // page init data fetch
  getOnInitData(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? '';

    isCompany = data["isCompany"] ?? false;
    isAddressServiceman = data["isAddressServiceman"] ?? false;
    isService = data["isService"] ?? false;
    isServiceman = userModel == null
        ? false
        : userModel!.role == "provider"
            ? false
            : true;
    radius = data["radius"] != null ? data["radius"].toInt() : 0;
    countryList = countryStateList;
    statesList = stateList;
    notifyListeners();
    log("isService :$isService");
    if (data != "") {
      if (data['data'] != null) {
        argIndex = data["index"] ?? 0;
        isEdit = data["isEdit"] ?? false;
        address = data['data'];
        notifyListeners();
        selectIndex = categoryList
            .indexWhere((element) => element == (address!.type ?? 0));

        latitudeCtrl.text = address!.latitude ?? '';
        longitudeCtrl.text = address!.longitude ?? '';

        zipCtrl.text = address!.postalCode ?? '';
        streetCtrl.text = address!.address ?? '';
        cityCtrl.text = address!.city ?? '';
        addressCtrl.text = address!.area ?? '';

        status = address!.isPrimary == 0 ? false : true;
        /* int countryIndex = countryList
            .indexWhere((element) => element.name == address!.country!.name); 
        if (countryIndex >= 0) {
          country = countryList[countryIndex];
          stateList = countryList[countryIndex].state!;
          notifyListeners();
        }
        int stateIndex = stateList
            .indexWhere((element) => element.name == address!.state!.name);
        if (stateIndex >= 0) {
          state = stateList[stateIndex];
        }*/

        countryValue = address!.country!.id!;
        int index =
            countryList.indexWhere((element) => element.id == countryValue);
        country = countryList[index];
        statesList = countryList[index].state!;
        stateValue = address!.state!.id!;
        notifyListeners();
        selectIndex = categoryList.indexWhere((element) =>
            element.toString().toLowerCase() == address!.type!.toLowerCase());
        state = statesList[stateValue];
      } else {
        country = null;
        countryValue = -1;
        stateValue = -1;
        state = null;
      }
    } else {
      country = null;
      countryValue = -1;
      stateValue = -1;
      state = null;
    }
    log("countryList :${countryList.length}");
    notifyListeners();
  }

  //country selection function
  onChangeCountryCompany(context, val, CountryStateModel c) {
    countryValue = val;

    country = c;
    int index = countryList.indexWhere((element) => element.id == c.id);

    if (index >= 0) {
      statesList = countryList[index].state!;
      notifyListeners();
      /*   stateValue = locationCtrl.stateList[0].id!;
      state = locationCtrl.stateList[stateValue!]*/
    }
    notifyListeners();
  }

  // state selection function
  onChangeStateCompany(val, StateModel c) {
    stateValue = val;
    state = c;
    notifyListeners();
  }

  //on back data clear
  onBack(context, isBack) {
    streetCtrl.text = "";
    addressCtrl.text = "";
    stateCtrl.text = "";
    countryCtrl.text = "";
    dialCode = "+${appSettingModel?.general?.countryCode ?? 1}" /* "+1" */;
    cityCtrl.text = "";
    zipCtrl.text = "";
    nameCtrl.text = "";
    numberCtrl.text = "";
    countryCtrl.text = "";
    stateCtrl.text = "";
    isEdit = false;
    country = null;
    state = null;
    countryValue = -1;
    stateValue = -1;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

// //dial code selection
//   changeDialCode(CountryCode country) {
//     dialCode = country.dialCode!;
//     notifyListeners();
//   }

  //category selection
  onCategory(index) {
    selectIndex = index;
    notifyListeners();
  }

  //add Address
  addAddressApi(context) async {
    showLoading(context);
    notifyListeners();
    var body = {
      "latitude": latitudeCtrl.text,
      "longitude": longitudeCtrl.text,
      "type": categoryList[selectIndex].toString().toLowerCase(),
      "address": addressCtrl.text +
          (streetCtrl.text.isNotEmpty ? ", ${streetCtrl.text}" : ""),
      "country_id": country!.id,
      "state_id": state!.id,
      "city": cityCtrl.text,
      "area": addressCtrl.text,
      "postal_code": zipCtrl.text,
      "is_primary": "1",
      "role_type": "provider",
      "status": "1",
      "availability_radius": radius
    };

    try {
      await apiServices.postApi(api.address, body, isToken: true).then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final value2 =
              Provider.of<AddNewServiceProvider>(context, listen: false);
          value2.getLocationData(context);
          appArray.serviceAvailableAreaList.add({
            "title": "${streetCtrl.text} - ${country!.name!}",
            "subtext": "${state!.name} - ${zipCtrl.text}"
          });

          notifyListeners();
          locationList.add({
            "type": categoryList[selectIndex],
            "address": addressCtrl.text,
            "latitude": latitudeCtrl.text,
            "longitude": longitudeCtrl.text,
            "country": country!.name,
            "state": state!.name,
            "city": cityCtrl.text,
            "postal_code": zipCtrl.text,
            "area": streetCtrl.text,
            "country_id": country!.id,
            "state_id": state!.id,
            "role_type": "provider",
            "is_primary": "1",
            "status": "1",
            "availability_radius": radius
          });
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          userApi.getAddressList(context);
          final data =
              Provider.of<DeleteDialogProvider>(context, listen: false);
          data.onResetPass(
              context,
              language(context, translations!.congLocationSuccessAdded),
              language(context, translations!.okay), () {
            route.pop(context);
            route.pop(context);
            route.pop(context);
          }, title: translations!.successfullyAdded);
        } else {
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE addAddressApi : $e");
    }
  }

  //edit Address
  editAddressApi(context) async {
    log("selectIndex :$selectIndex");
    if (selectIndex != -1) {
      showLoading(context);

      var body = {
        "latitude": latitudeCtrl.text,
        "longitude": longitudeCtrl.text,
        "type": categoryList[selectIndex].toString().toLowerCase(),
        "address": streetCtrl.text,
        "country_id": country!.id,
        "state_id": state!.id,
        "city": cityCtrl.text,
        "area": addressCtrl.text,
        "postal_code": zipCtrl.text,
        "is_primary": "1",
        "role_type": "provider",
        "status": "1",
        "availability_radius": radius
      };

      log("body : $body");
      try {
        await apiServices
            .putApi("${api.address}/${address!.id}", body, isToken: true)
            .then((value) async {
          hideLoading(context);

          log("VVVV : ${value.isSuccess}");
          notifyListeners();
          if (value.isSuccess!) {
            final userApi =
                Provider.of<UserDataApiProvider>(context, listen: false);
            await userApi.getAddressList(context);
            route.pop(context);
            route.pop(context);
          } else {
            snackBarMessengers(context,
                color: appColor(context).appTheme.red, message: value.message);
          }
        });
      } catch (e) {
        hideLoading(context);
        notifyListeners();
        log("EEE addAddressApi: $e");
      }
    } else {
      snackBarMessengers(context,
          color: appColor(context).appTheme.red, message: "Please Select Type");
    }
  }

  //add location with validation
  onAddLocation(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (locationFormKey.currentState!.validate()) {
      if (isEdit) {
        editAddress(context);
      } else {
        if (!isServiceman) {
          log("dsihjcfsoi =-==-=-=-=-=s v sdvjpsdj");
          addAddress(context);
        } else {
          log("isAddressServiceman L::$isAddressServiceman");
          if (isAddressServiceman) {
            addAddress(context);
          } else {
            if (isSubscription) {
              if (addressList.length <
                  int.parse(activeSubscription!.allowedMaxAddresses ?? "0")) {
                addAddress(context);
              } else {
                snackBarMessengers(context,
                    message: language(
                        context, translations!.youCanAddOnlyMinAddress));
              }
            } else {
              if (addressList.length < 3) {
                addAddress(context);
              } else {
                snackBarMessengers(context,
                    message: language(
                        context, translations!.youCanAddOnlyMinAddress));
              }
            }
          }
        }
      }
    }
  }

  //add Address
  addAddress(context) async {
    if (!isAddressServiceman) {
      final selectedCountryName = countryCtrl.text;

      final selectedCountry = countryList.firstWhere(
        (e) =>
            e.name?.toLowerCase().trim() ==
            selectedCountryName.toLowerCase().trim(),
        orElse: () => CountryStateModel(), // fallback in case not found
      );

      final countryId = selectedCountry.id;
      log("Selected Country ID: $countryId");
      log("country?.id::${country?.id}");
      final loc = Provider.of<AddServicemenProvider>(context, listen: false);
      PrimaryAddress primaryAddress = PrimaryAddress(
          address: /* "" */ addressCtrl.text,
          area: streetCtrl.text,
          availabilityRadius: double.parse(radius.toString()),
          city: cityCtrl.text,
          countryId: country?.id ?? countryId,
          stateId: state?.id,
          isPrimary: 0,
          latitude: latitudeCtrl.text,
          longitude: longitudeCtrl.text,
          country: country,
          state: state,
          status: 1,
          type: categoryList[selectIndex],
          userId: userModel!.id.toString(),
          postalCode: zipCtrl.text);
      loc.address = primaryAddress;
      loc.locationCtrl.text =
          "${streetCtrl.text}, ${loc.address!.address} ${loc.address!.city} ${loc.address!.country == null ? '' : '-'}${loc.address!.country == null ? '' : loc.address!.country?.name ?? ''} ${loc.address!.state == null ? '' : '-'} ${loc.address!.state == null ? '' : loc.address!.state!.name}";
      loc.notifyListeners();
      addressList.add(primaryAddress);
      addAddressApi(context);
      route.pop(context);
      route.pop(context);
    } else {
      if (userModel != null) {
        if (isSubscription) {
          // addAddressApi(context);
          if (addressList.length <
              int.parse(activeSubscription!.allowedMaxAddresses ?? "0")) {
            addAddressApi(context);
          } else {
            snackBarMessengers(context,
                message: appFonts.addUpToLocation(context,
                    activeSubscription!.allowedMaxAddresses.toString()));
          }
        } else {
          if (addressList.length <
              int.parse(
                  appSettingModel!.defaultCreationLimits!.allowedMaxAddresses ??
                      "0")) {
            addAddressApi(context);
          } else {
            snackBarMessengers(context,
                message: appFonts.addUpToLocation(
                    context,
                    appSettingModel!.defaultCreationLimits!.allowedMaxAddresses
                        .toString()));
          }
        }
      } else {
        if (appArray.serviceAvailableAreaList.length <= 3) {
          appArray.serviceAvailableAreaList.add({
            "title": "${streetCtrl.text} - ${country!.name!}",
            "subtext": "${state!.name} - ${zipCtrl.text}"
          });

          notifyListeners();
          locationList.add({
            "type": categoryList[selectIndex],
            "address": addressCtrl.text,
            "latitude": latitudeCtrl.text,
            "longitude": longitudeCtrl.text,
            "country": country!.name,
            "state": state!.name,
            "city": cityCtrl.text,
            "postal_code": zipCtrl.text,
            "area": streetCtrl.text,
            "country_id": country!.id,
            "state_id": state!.id,
            "is_primary": "0",
            "role_type": "provider",
            "status": "1",
            "availability_radius": radius
          });
          route.pop(context);
          route.pop(context);
        } else {
          snackBarMessengers(context,
              message: language(context, "You can add 3 address only"));
        }
      }
      notifyListeners();
    }
  }

  //edit Address
  editAddress(context) async {
    editAddressApi(context);

    notifyListeners();
  }
}
