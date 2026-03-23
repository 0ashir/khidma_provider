// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../config.dart';
import '../../widgets/country_picker_custom/layouts/country_list_layout.dart';

class ProfileDetailProvider with ChangeNotifier {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  TextEditingController description = TextEditingController();

  String? dialCode;
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode location = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  XFile? imageFile;
  List<ValueItem<int>> languageSelect = [];

  SharedPreferences? preferences;
  PrimaryAddress? address;
  String? chosenValue;
  final FocusNode experienceFocus = FocusNode();
  TextEditingController experience = TextEditingController();

  onDropDownChange(choseVal) {
    chosenValue = choseVal;
    notifyListeners();
  }

  //page init data fetch
  getArgument(context) async {
    log("message=-==-=-=-=-=-=-=-");
    preferences = await SharedPreferences.getInstance();
    txtName.text = userModel!.name ?? "";
    txtEmail.text = userModel!.email ?? "";
    txtPhone.text = userModel!.phone != null ? userModel!.phone.toString() : "";
    // "experience_interval": chosenValue ?? "year",
    // "experience_duration": experience.text,

    experience.text = userModel!.experienceDuration.toString();
    chosenValue = userModel?.experienceInterval;
    if (userModel!.primaryAddress != null) {
      address = userModel!.primaryAddress!;
    }

    // log("dialCode userModel!.code ${userModel!.code}");
    // dialCode ="+${userModel!.code!}";
    log("dialCode sdsdsd $dialCode");
    log("dialCode sdsdsd ${userModel!.code}");
    "${userModel!.code != null && userModel!.code!.contains("+") ? "" : "+"}${userModel!.code}";
    description.text = userModel!.description ?? "";
    log("userModel!.knownLanguages! :${userModel!.knownLanguages}");
    userModel!.knownLanguages!.asMap().entries.forEach((element) {
      ValueItem<int> valueItem =
          ValueItem(label: element.value.key!, value: element.value.id);

      if (!languageSelect.contains(valueItem)) {
        languageSelect.add(valueItem);
      }
      notifyListeners();
    });
    if (userModel!.code != null) {
      int index = countriesEnglish.indexWhere((element) =>
          element['dial_code'] ==
          "${userModel!.code.toString().contains("+") ? "" : "+"}${userModel!.code!}" /* "+${userModel!.code!}" */);
      // log("index :$index");
      if (index >= 0) {
        dialCode = countriesEnglish[index]['dial_code'];
      }
      log("dialCode :$dialCode");
    } else {
      dialCode = "+${appSettingModel?.general?.countryCode ?? 1}" /*  "+1" */;
      /*  int index = countriesEnglish.indexWhere(
              (element) => element['dial_code'] == "+${userModel!.code!}");
      // log("index :$index");
      if (index >= 0) {
        dialCode = countriesEnglish[index]['dial_code'];
      }
      log("dialCode :$dialCode"); */
    }
    if (address != null) {
      final locationProvider =
          Provider.of<NewLocationProvider>(context, listen: false);

      log("message=-==-=-=-=-=-=-=-${userModel?.primaryAddress?.address /* locationProvider.locationList.last.toString() */}");
      locationCtrl.text = userModel?.primaryAddress?.address.toString() ?? "";
      // locationCtrl.text =   "${address!.address} - ${address!.country!.name} - ${address!.state!.name}";
    }
    notifyListeners();
    log("languageSelect :$languageSelect");
  }

  onBack(context, isBack) {
    imageFile = null;
    txtName.text = "";
    txtEmail.text = "";
    txtPhone.text = "";
    notifyListeners();
    if (isBack == true) {
      route.pop(context);
    }
  }

  //update profile as per role
  onUpdate(context) {
    if (isServiceman) {
      editServiceman(context);
    } else {
      updateProfile(context);
    }
  }

  //edit serviceman
  editServiceman(context) async {
    showLoading(context);
    notifyListeners();
    List langList = [];

    for (var d in languageSelect) {
      if (!langList.contains(d.value)) {
        langList.add(d.value);
      }
    }
    dynamic mimeTypeData;
    if (imageFile != null) {
      mimeTypeData = lookupMimeType(imageFile!.path, headerBytes: [0xFF, 0xD8])!
          .split('/');
    }

    var body = {
      if (imageFile != null)
        "profile_image": await dio.MultipartFile.fromFile(
            imageFile!.path.toString(),
            filename: imageFile!.name.toString(),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
      "provider_id": userModel!.id,
      "name": txtName.text,
      "email": txtEmail.text,
      "phone": txtPhone.text,
      "code": dialCode,
      "known_languages": langList,
      "address": address!.address,
      "_method": "PUT"
    };

    log("EDIT :$body");

    dio.FormData formData = dio.FormData.fromMap(body);
    try {
      await apiServices
          .postApi("${api.serviceman}/${userModel!.id}", formData,
              isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH ");
        if (value.isSuccess!) {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);
          snackBarMessengers(context,
              message: value.message.isEmpty
                  ? "Successfully Edit Serviceman"
                  : value.message,
              color: appColor(context).appTheme.green);

          notifyListeners();

          route.pop(context);
        } else {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("CATCH editServiceman: $e");
    }
  }

  //language selection
  onLanguageSelect(options) {
    languageSelect = options;

    notifyListeners();
  }

  changeDialCode(CountryCodeCustom country) {
    dialCode = country.dialCode!;
    notifyListeners();
  }

// GET IMAGE FROM GALLERY
  Future getImage(context, source) async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus galleryStatus = await Permission.photos.status;
    log("Camera Permission Status: ${cameraStatus.isGranted}");
    log("Gallery Permission Status: ${galleryStatus.isGranted}");

    /* if (cameraStatus.isPermanentlyDenied || galleryStatus.isPermanentlyDenied) {
      log("Permission Permanently Denied - Opening App Settings...");
      await openAppSettings(); // ✅ Open App Settings
      return;
    }

    if (cameraStatus.isDenied || galleryStatus.isDenied) {
      log("Permission Denied - Requesting Again...");
      await openAppSettings();
      return;
    } */
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: source, imageQuality: 70));
    notifyListeners();
    if (imageFile != null) {
      // updateProfile(context);
      // route.pop(context);
    }
  }

  showLayout(context) async {
    showDialog(
      context: context,
      builder: (context1) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.r12))),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, translations!.selectOne),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText)),
                const Icon(CupertinoIcons.multiply)
                    .inkWell(onTap: () => route.pop(context))
              ]),
              const VSpace(Sizes.s20),
              ...appArray.selectList
                  .asMap()
                  .entries
                  .map((e) => SelectOptionLayout(
                      data: e.value,
                      index: e.key,
                      list: appArray.selectList,
                      onTap: () {
                        if (e.key == 0) {
                          getImage(context, ImageSource.gallery);
                        } else {
                          getImage(context, ImageSource.camera);
                        }
                        route.pop(context);
                      }))
            ]));
      },
    );
  }

  //update profile
  bool isUpdate = false;

  updateProfile(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    isUpdate = true;
    showLoading(context);
    notifyListeners();
    dynamic mimeTypeData;
    if (imageFile != null) {
      mimeTypeData = lookupMimeType(imageFile!.path, headerBytes: [0xFF, 0xD8])!
          .split('/');
    }

    var body = {
      "name": txtName.text,
      "email": txtEmail.text,
      "code": dialCode,
      "phone": txtPhone.text,
      "_method": "PUT",
      "experience_interval": chosenValue,
      "experience_duration": experience.text,
      if (imageFile != null)
        'profile_image': imageFile != null
            ? await dio.MultipartFile.fromFile(imageFile!.path.toString(),
                filename: imageFile!.name.toString(),
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
            : null
    };

    dio.FormData formData = dio.FormData.fromMap(body);

    log("BBBBB :$body");
    try {
      await apiServices
          .postApi(api.updateProfile, formData, isToken: true)
          .then((value) async {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);
          isUpdate = false;
          commonApi.notifyListeners();
          notifyListeners();
          showDialog(
              context: context,
              builder: (context) => AlertDialogCommon(
                  title: translations!.updateSuccessfully,
                  height: Sizes.s140,
                  image: eGifAssets.successGif,
                  subtext: language(context, translations!.hurrayUpdateProfile),
                  bText1: language(context, translations!.okay),
                  b1OnTap: () {
                    route.pop(context);
                    route.pop(context);
                  }));
        } else {
          isUpdate = false;
          hideLoading(context);
          log("value.message :${value.message}");
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.red);
        }
      });
    } catch (e) {
      log("EEEE updateProfile:$e");
      hideLoading(context);
      notifyListeners();
    }
  }
}
