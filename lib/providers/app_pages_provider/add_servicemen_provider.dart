import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/add_serviceman_screen/layouts/known_language_sheet.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:mime/mime.dart' as mime;
import 'package:dio/dio.dart' as dio;

class AddServicemenProvider with ChangeNotifier {
  String dialCode = "+${appSettingModel?.general?.countryCode ?? 1}";
  String? identityValue;
  GlobalKey<FormState> addServiceManFormKey = GlobalKey<FormState>();

  PrimaryAddress? address;
  String? addressId;
  String? chosenValue;
  XFile? imageFile, profileFile;
  final List<Color> colorCollection = <Color>[];
  List<KnownLanguageModel> languageSelect = [];
  ServicemanModel? servicemanModel;

  TextEditingController filterSearchCtrl = TextEditingController();
  final FocusNode filterSearchFocus = FocusNode();

  TextEditingController userName = TextEditingController();
  TextEditingController phoneName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController identityNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController reEnterPassword = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();

  final FocusNode userNameFocus = FocusNode();
  final FocusNode phoneNameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode experienceFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode providerNumberFocus = FocusNode();
  final FocusNode identityNumberFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode rePasswordFocus = FocusNode();
  final FocusNode location = FocusNode();

  bool isNewPassword = true, isConfirmPassword = true;

  //add color to array
  addColorToArray() {
    //Here you can add color as your requirement and call it in initState
    colorCollection.add(Colors.green);
    colorCollection.add(Colors.red);
    colorCollection.add(Colors.pink);
    colorCollection.add(Colors.yellow);
    colorCollection.add(Colors.blue);
    colorCollection.add(Colors.brown);
    colorCollection.add(Colors.lightGreen);
    colorCollection.add(Colors.cyan);
    colorCollection.add(Colors.deepOrange);
    notifyListeners();
  }

//language selection
  onLanguageSelect(options) {
    if (!languageSelect.contains(options)) {
      languageSelect.add(options);
      log("languageSelect::${languageSelect}");
    } else {
      languageSelect.remove(options);
    }
    notifyListeners();
  }

  bool isLanguageSelected(language) {
    return languageSelect.any((selected) => selected.key == language.key);
  }

  clearTap(context) {
    final common = Provider.of<CommonApiProvider>(context, listen: false);
    common.getKnownLanguage();
    languageSelect = [];
    filterSearchCtrl.text = "";
    notifyListeners();
    route.pop(context);
  }

  onBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const KnownLanguageBottomSheet();
      },
    ).then((value) {
      log("SSS");
      final common = Provider.of<CommonApiProvider>(context, listen: false);
      common.getKnownLanguage();
      filterSearchCtrl.text = "";
      notifyListeners();
    });
  }

  //new password see tap
  newPasswordSeenTap() {
    isNewPassword = !isNewPassword;
    notifyListeners();
  }

  //confirm password see tap
  confirmPasswordSeenTap() {
    isConfirmPassword = !isConfirmPassword;
    notifyListeners();
  }

  //on page initialize data fetch
  onReady(context) {
    addColorToArray();
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    if (data != null) {
      servicemanModel = data;
      userName.text = servicemanModel!.name!;
      number.text = servicemanModel!.phone!.toString();
      email.text = servicemanModel!.email!;
      experience.text = servicemanModel!.experienceDuration!.toString();
      chosenValue = servicemanModel!.experienceInterval!;
      address = servicemanModel!.primaryAddress!;
      addressId = servicemanModel!.primaryAddress?.id.toString();
      locationCtrl.text =
          "${address!.address} - ${address!.country!.name} - ${address!.state!.name}";
      description.text = servicemanModel!.description?.toString() ?? "";
      servicemanModel!.knownLanguages!.asMap().entries.forEach((element) {
        if (!languageSelect.contains(element.value)) {
          languageSelect.add(element.value);
        }
        notifyListeners();
      });
      log("valueItem :${address?.id}");

      dialCode = servicemanModel!.code ?? "+91";
    } else {
      identityValue = null;
    }

    descriptionFocus.addListener(() {
      notifyListeners();
    });
    notifyListeners();
  }

  //select dial code
  changeDialCode(CountryCodeCustom country) {
    dialCode = country.dialCode!;
    notifyListeners();
  }

  //experience duration selection option
  onDropDownChange(choseVal) {
    chosenValue = choseVal;
    notifyListeners();
  }

  //select identity option
  onChangeIdentity(val) {
    identityValue = val.toString();
    notifyListeners();
  }

  // GET IMAGE FROM GALLERY
  Future getImage(context, source, isProfile) async {
    final ImagePicker picker = ImagePicker();
    if (isProfile == true) {
      route.pop(context);
      profileFile = (await picker.pickImage(source: source, imageQuality: 70));
    } else {
      route.pop(context);
      imageFile = (await picker.pickImage(source: source, imageQuality: 70));
      appArray.servicemanDocImageList.add(imageFile!);
    }
    notifyListeners();
  }

  //on image selection option
  onImagePick(context, isProfile) {
    showLayout(context, onTap: (index) {
      log("INDEX : $index");
      if (index == 0) {
        getImage(context, ImageSource.gallery, isProfile);
      } else {
        getImage(context, ImageSource.camera, isProfile);
      }
    });
  }

  //add data validation and call api
  addData(context) {
    log("LANG :$languageSelect");
    FocusScope.of(context).requestFocus(FocusNode());
    if (addServiceManFormKey.currentState!.validate()) {
      if (profileFile != null) {
        if (appArray.servicemanDocImageList.isNotEmpty) {
          if (identityValue != null) {
            if (languageSelect.isNotEmpty) {
              if (address != null) {
                if (isSubscription) {
                  if (servicemanList.length <
                      (activeSubscription!.allowedMaxServicemen ?? "0")) {
                    addServiceman(context);
                  } else {
                    snackBarMessengers(context,
                        message: appFonts.addUpToServiceman(
                            context,
                            activeSubscription!.allowedMaxServicemen
                                .toString()));
                  }
                } else {
                  if (servicemanList.length <
                      int.parse(appSettingModel!
                              .defaultCreationLimits!.allowedMaxServicemen ??
                          "0")) {
                    addServiceman(context);
                  } else {
                    showErrorToast(
                        context,
                        appFonts.addUpToServiceman(
                            context,
                            appSettingModel!
                                .defaultCreationLimits!.allowedMaxServicemen
                                .toString()));
                  }
                }
              } else {
                showErrorToast(
                    context, translations!.pleaseSelectLocation.toString());
              }
            } else {
              showErrorToast(
                  context, translations!.pleaseSelectLanguage.toString());
            }
          } else {
            showErrorToast(
                context, translations!.pleaseSelectIdentityType.toString());
          }
        } else {
          showErrorToast(
              context, translations!.pleaseUploadDocument.toString());
        }
      } else {
        showErrorToast(
            context, translations!.pleaseUploadProfilePhoto.toString());
      }
    }
  }

  //edit data validation and api call

  editData(context) {
    log("message :${userModel!.media}");
    FocusScope.of(context).requestFocus(FocusNode());
    if (addServiceManFormKey.currentState!.validate()) {
      if (servicemanModel!.media != null &&
          servicemanModel!.media!.isNotEmpty) {
        if (languageSelect.isNotEmpty) {
          if (address != null) {
            editServiceman(context);
          } else {
            snackBarMessengers(context,
                message: language(context, translations!.pleaseSelectLocation));
          }
        } else {
          if (profileFile != null) {
            if (languageSelect.isNotEmpty) {
              if (address != null) {
                editServiceman(context);
              } else {
                snackBarMessengers(context,
                    message:
                        language(context, translations!.pleaseSelectLocation));
              }
            }
          }
        }
      } else {
        snackBarMessengers(context,
            message: language(context, translations!.pleaseUploadProfilePhoto));
      }
    }
  }

//add serviceman
  bool isAddressServiceman = false;
  addServiceman(context) async {
    showLoading(context);
    notifyListeners();
    List langList = [];

    for (var d in languageSelect) {
      if (!langList.contains(d.value)) {
        langList.add(d.value);
      }
    }
    dynamic mimeTypeData;
    if (profileFile != null) {
      mimeTypeData = mime.lookupMimeType(profileFile!.path,
          headerBytes: [0xFF, 0xD8])!.split('/');
    }

    var body = {
      if (profileFile != null)
        "image": await dio.MultipartFile.fromFile(profileFile!.path.toString(),
            filename: profileFile!.name.toString(),
            contentType: http.MediaType(mimeTypeData[0], mimeTypeData[1])),
      "provider_id": userModel!.id,
      "name": userName.text,
      "email": email.text,
      "phone": number.text,
      "code": dialCode,
      "experience_interval": chosenValue ?? "year",
      "experience_duration": experience.text,
      "password": password.text,
      "confirm_password": reEnterPassword.text,
      for (var i = 0; i < languageSelect.length; i++)
        "known_languages[$i]": languageSelect[i].id,
      "document_id": identityValue!,
      "identity_no": identityNumber.text,
      "latitude": address!.latitude,
      "longitude": address!.longitude,
      "type": address!.type,
      "address": locationCtrl.text /* address!.address */,
      "country_id": address!.country?.id ?? 356,
      "state_id": address!.state?.id ?? 12,
      "city": address!.city,
      "area": address!.area,
      "postal_code": address!.postalCode,
      "description": description.text,
      "status": "1",
      "availability_radius": 0
    };
    dio.FormData formData = dio.FormData.fromMap(body);

    for (var file in appArray.servicemanDocImageList) {
      formData.files.addAll([
        MapEntry(
            "documents_images[]",
            await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last)),
      ]);
    }
    log("BODU GGGG:$body");

    try {
      isAddressServiceman = true;
      await apiServices
          .postApi(api.serviceman, formData, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH  : ${value.data} //${value.message}");
        if (value.isSuccess!) {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          commonApi.getDashBoardApi(context);
          final userApi =
              Provider.of<ServicemanListProvider>(context, listen: false);
          await userApi.getServicemenByProviderId(context);
          isAddressServiceman = false;

          showSuccessToast(
            context,
            value.message ?? "Something went wrong",
          );

          notifyListeners();

          imageFile = null;

          userName.text = "";
          email.text = "";
          number.text = "";
          chosenValue = null;
          experience.text = "";
          password.text = "";
          reEnterPassword.text = "";
          locationCtrl.text = "";
          langList = [];
          identityValue = null;
          profileFile = null;
          identityNumber.text = "";

          appArray.servicemanDocImageList = [];
          address = null;
          description.text = "";
          route.pop(context);
        } else {
          showErrorToast(context, value.message);
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicemenByProviderId();
          isAddressServiceman = false;
          notifyListeners();
        }
      });
    } catch (e, s) {
      isAddressServiceman = false;
      hideLoading(context);
      notifyListeners();
      log("EEEE addServiceman : $e====> $s");
    }
  }

//edit serviceman
  bool isEditServiceman = false;
  editServiceman(context) async {
    showLoading(context);
    notifyListeners();
    List langList = [];

    /*  for (var d in languageSelect) {
      log("LANGUAGE : ${languageSelect}");
      if (!langList.contains(d.value)) {
        log("LANGUAGE : ${d.value}");
        langList.add(d.value);
      }
    } */
    for (var d in languageSelect) {
      if (!langList.contains(d.value)) {
        langList.add(d.value);
      }
    }
    dynamic mimeTypeData;
    if (profileFile != null) {
      mimeTypeData = mime.lookupMimeType(profileFile!.path,
          headerBytes: [0xFF, 0xD8])!.split('/');
    }
    log("address!.id:::${addressId}");
    var body = {
      if (profileFile != null)
        "image": await dio.MultipartFile.fromFile(profileFile!.path.toString(),
            filename: profileFile!.name.toString(),
            contentType: http.MediaType(mimeTypeData[0], mimeTypeData[1])),
      "provider_id": userModel!.id,
      "name": userName.text,
      "email": email.text,
      "phone": number.text,
      "code": dialCode,
      "experience_interval": chosenValue ?? "year",
      "experience_duration": experience.text,
      for (var i = 0; i < languageSelect.length; i++)
        "known_languages[$i]": languageSelect[i].id,
      "latitude": address!.latitude,
      "longitude": address!.longitude,
      "type": "company" /* address!.type */,
      "address": address!.address,
      "country_id": address!.country!.id,
      "state_id": address!.state!.id,
      "city": address!.city,
      "area": address!.area,
      "postal_code": address!.postalCode,
      "description": description.text,
      "status": "1",
      "availability_radius": 0,
      "address_id": addressId,
      "_method": "PUT"
    };

    log("EDIT :$body");

    dio.FormData formData = dio.FormData.fromMap(body);
    log("message LINK FOR API ${api.serviceman}/${servicemanModel!.id}");
    try {
      isEditServiceman = true;
      await apiServices
          .postApi("${api.serviceman}/${servicemanModel!.id}", formData,
              isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH ");
        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicemenByProviderId();
          isEditServiceman = false;
          snackBarMessengers(context,
              message: "Successfully Edit Serviceman",
              color: appColor(context).appTheme.primary);
          servicemanList;
          notifyListeners();
          route.pop(context);
        } else {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicemenByProviderId();
          snackBarMessengers(context,
              message: value.message ?? "Something went wrong",
              color: appColor(context).appTheme.red);
          isEditServiceman = false;
          route.pop(context);
          imageFile = null;

          userName.text = "";
          email.text = "";
          number.text = "";
          chosenValue = null;
          experience.text = "";
          password.text = "";
          reEnterPassword.text = "";
          locationCtrl.text = "";
          langList = [];
          identityValue = null;
          profileFile = null;
          identityNumber.text = "";
          addressId = '';
          appArray.servicemanDocImageList = [];
          address = null;
          description.text = "";
        }
      });
    } catch (e, s) {
      isEditServiceman = false;
      hideLoading(context);
      servicemanList;
      notifyListeners();
      log("CATCH editServiceman: $e ==> $s");
    }
  }

  //add address with routing
  addAddressWithRouting(context, isEdit) {
    if (isEdit) {
      route.pushNamed(context, routeName.location, arg: {
        "isServiceman": userModel!.role == "provider" ? false : true,
        "data": address,
        'isAddressServiceman': true
      }).then((e) {
        log("EE addAddressWithRouting:$e");
      });
    } else {
      route.pushNamed(context, routeName.location, arg: {
        "isServiceman": userModel!.role == "provider" ? false : true,
        'isAddressServiceman': true
      }).then((e) {
        log("EE addAddressWithRouting:$e");
      });
    }
  }

/*
onReady(){
    servicePackageModel = ServicePackageModel.fromJson(appArray.packageDetailList);
    notifyListeners();
}*/

  onBack(context, isBack) {
    servicemanModel = null;
    imageFile = null;
    userName.text = "";
    email.text = "";
    number.text = "";
    chosenValue = null;
    experience.text = "";
    password.text = "";
    reEnterPassword.text = "";
    locationCtrl.text = "";
    languageSelect = [];
    identityValue = null;
    profileFile = null;
    identityNumber.text = "";

    appArray.servicemanDocImageList = [];
    address = null;
    description.text = "";
    if (isBack) {
      route.pop(context);
    }
  }
}
