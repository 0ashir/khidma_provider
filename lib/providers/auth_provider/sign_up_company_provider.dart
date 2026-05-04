import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/auth_screens/sign_up_company_screen/layouts/zone_list_sheet.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../firebase/firebase_api.dart';

class SignUpCompanyProvider with ChangeNotifier {
  GlobalKey<FormState> signupFormKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> signupFormKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> signupFormKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> signupFreelanceFormKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> signupFreelanceFormKey2 = GlobalKey<FormState>();
  double slider = 0.0;
  String dialCode = "+${appSettingModel?.general?.countryCode ?? 1}" /* "+1" */;
  String providerDialCode =
      "+${appSettingModel?.general?.countryCode ?? 1}" /* "+1" */;
  List<ValueItem<int>> languageSelect = [];
  List<ZoneModel> zoneSelect = [];
  String? chosenValue;
  List<CountryStateModel> countryList = [];
  List<ZoneModel> zonesList = [];
  List<StateModel> statesList = [];
  int countryValue = -1, stateValue = -1;
  bool isNewPassword = true, isConfirmPassword = true;
  bool isPassword = true;
  bool isConfirmPasswordobscure = true;

  passwordSeenTap() {
    isPassword = !isPassword;
    notifyListeners();
  }

  confirmPasswordObscureSeenTap() {
    isConfirmPasswordobscure = !isConfirmPasswordobscure;
    notifyListeners();
  }

  //String? identityValue;
  int pageIndex = 0;
  int fPageIndex = 0;
  CountryModel? countryCompany, countryProvider, stateCompany, stateProvider;
  CountryStateModel? country;
  ZoneModel? zone;
  StateModel? state;

  ScrollController controller = ScrollController();

  TextEditingController companyName = TextEditingController();
  TextEditingController companyPhone = TextEditingController();
  TextEditingController companyMail = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController identityNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController reEnterPassword = TextEditingController();

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();

  TextEditingController countryCtrl = TextEditingController();
  TextEditingController zoneCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();

  TextEditingController ownerName = TextEditingController();
  TextEditingController providerEmail = TextEditingController();
  TextEditingController providerNumber = TextEditingController();
  TextEditingController referralCode = TextEditingController();

  final FocusNode companyNameFocus = FocusNode();
  final FocusNode phoneNameFocus = FocusNode();
  final FocusNode companyMailFocus = FocusNode();
  final FocusNode experienceFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode providerNumberFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode langFocus = FocusNode();
  final FocusNode referralCodeFocus = FocusNode();

  final FocusNode identityNumberFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode reEnterPasswordFocus = FocusNode();

  TextEditingController filterSearchCtrl = TextEditingController();
  final FocusNode filterSearchFocus = FocusNode();

  FocusNode latFocus = FocusNode();
  FocusNode longFocus = FocusNode();
  FocusNode areaFocus = FocusNode();
  FocusNode streetFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode countryFocus = FocusNode();

  dynamic areaData;
  String? selectedRole;

  void onRoleChanged(String? val) {
    selectedRole = val;

    log("jkahdfjas ${selectedRole?.toLowerCase()}");
    notifyListeners();
  }

  category(context, value) {
    selectedCategory = value;
    getProviderById(context, selectedCategory?.id);

    notifyListeners();
  }

  List<CategoryModel> _categoryList = [];
  CategoryModel? _selectedCategory;

  List<CategoryModel> get categoryList => _categoryList;

  CategoryModel? get selectedCategory => _selectedCategory;

  set selectedCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> getAllCategory() async {
    try {
      final response = await apiServices.getApi(api.categoryList, []);
      if (response.isSuccess!) {
        final List data = response.data;

        // Only include top-level categories
        _categoryList =
            data.map((json) => CategoryModel.fromJson(json)).toList();
      }
    } catch (e) {
      log("Error fetching categories: $e");
    }

    notifyListeners();
  }

  List<ProviderModel> providerList = [];
  ProviderModel? selectedProvider;

  void setSelectedProvider(ProviderModel? provider) {
    selectedProvider = provider;
    notifyListeners();
  }

  int? selectedProviderId;

  providerListing(value) {
    selectedProvider = value;
    selectedProviderId = selectedProvider?.id;
    notifyListeners();
  }

  getProviderById(context, id) async {
    try {
      final response =
          await apiServices.getApi("${api.provider}?category_ids=$id", []);
      if (response.isSuccess == true) {
        final List data = response.data;
        providerList =
            data.map((json) => ProviderModel.fromJson(json)).toList();

        // Reset selected provider (optional)
        selectedProvider = null;

        notifyListeners();
        log("getProviderById success: $providerList");
      }
    } catch (e, s) {
      log("ERROR getProviderById: $e\nStack: $s");
      notifyListeners();
    }
  }

  FocusNode ownerNameFocus = FocusNode();
  FocusNode providerPhoneNumberFocus = FocusNode();
  FocusNode providerEmailFocus = FocusNode();

  String documentModel = '';
  XFile? imageFile, docFile;

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

  // GET IMAGE FROM GALLERY
  Future getImage(context, source, {isLogo = true}) async {
    final ImagePicker picker = ImagePicker();
    XFile image = (await picker.pickImage(source: source, imageQuality: 70))!;
    route.pop(context);
    if (isLogo) {
      imageFile = image;
    } else {
      docFile = image;
    }
    notifyListeners();
  }

  //country selection function
  onChangeCountryCompany(context, val, CountryStateModel c) {
    countryValue = val;

    country = c;

    int index = countryList.indexWhere((element) => element.id == c.id);
    log("countryList :${index}");
    if (index >= 0) {
      state = null;
      statesList = countryList[index].state!;
      notifyListeners();
      /*   stateValue = locationCtrl.stateList[0].id!;
      state = locationCtrl.stateList[stateValue!]*/
    }
    log("countryList :${statesList.length}");
    notifyListeners();
  }

  // state selection function
  onChangeStateCompany(val, StateModel c) {
    stateValue = val;
    state = c;
    notifyListeners();
  }

  //image picker option
  onImagePick(context, {isLogo = true}) {
    showLayout(context, onTap: (index) {
      if (index == 0) {
        getImage(context, ImageSource.gallery, isLogo: isLogo);
      } else {
        getImage(context, ImageSource.camera, isLogo: isLogo);
      }
      notifyListeners();
    });
  }

  getLocation(context) async {
    route.pushNamed(context, routeName.location, arg: {"isSignUp": true}).then(
        (e) {
      log("EEEE :$e");
      if (e != null) {
        final loc = Provider.of<LocationProvider>(context, listen: false);
        log("loc.street :${loc.place!}");
        int ind = countryList.indexWhere((element) =>
            element.name!.toLowerCase() == loc.place!.country!.toLowerCase());
        log("DDD :$ind");
        areaData = loc.street;
        if (ind >= 0) {
          country = countryList[ind];
          countryValue = ind;

          statesList = countryList[ind].state!;
        }
        int stateIndex = statesList.indexWhere((element) =>
            element.name!.toLowerCase() ==
            loc.place!.administrativeArea!.toLowerCase());
        log("stateIndex :$stateIndex");
        if (stateIndex >= 0) {
          state = statesList[stateIndex];
          stateValue = stateIndex;
        }
        notifyListeners();
        log("STATT:#$state");
        street.text = loc.place!.street ?? "";
        area.text = (loc.place!.locality != null ? loc.place!.locality! : "") +
            (loc.place!.subLocality != null
                ? ", ${loc.place!.subLocality}"
                : "");
        latitude.text = loc.position!.latitude.toString();
        longitude.text = loc.position!.longitude.toString();
        city.text = loc.place!.country!;
        zipCode.text = loc.place!.postalCode!;
        countryCtrl.text = loc.place!.country!;
        stateCtrl.text = loc.place!.administrativeArea!;
        notifyListeners();
      }
    });
    /* showLoading(context);
    notifyListeners();
    final loc = Provider.of<LocationProvider>(context, listen: false);

    await loc.getUserCurrentLocation(context);
    await Future.delayed(Durations.short4);
    notifyListeners();
    areaData = loc.street;
    latitude.text = loc.position!.latitude.toString();
    longitude.text = loc.position!.longitude.toString();
    city.text = loc.place!.postalCode!;
    zipCode.text = loc.place!.street!;
    hideLoading(context);
    notifyListeners();
    log("AREA :$areaData");*/
  }

  getAddressFromLatLng(context) async {
    await placemarkFromCoordinates(position!.latitude, position!.longitude)
        .then((List<Placemark> placeMarks) async {
      Placemark? place = placeMarks[0];

      String data =
          '${place.name}, ${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      areaData = data;
      latitude.text = position!.latitude.toString();
      longitude.text = position!.longitude.toString();
      city.text = place.postalCode!;
      zipCode.text = place.street!;

      await Future.delayed(Durations.short4);
      hideLoading(context);
      notifyListeners();
    }).catchError((e) {
      hideLoading(context);
      notifyListeners();
      debugPrint("ee getAddressFromLatLng : $e");
    });
  }

  //language selection
  onLanguageSelect(options) {
    log("options :$options");
    languageSelect = options;
    notifyListeners();
  }

  //zone selection
  onZoneSelect(options) {
    int index = zoneSelect.indexWhere((element) => element.id == options.id);
    if (index >= 0) {
      zoneSelect.removeAt(index);
    } else {
      zoneSelect.add(options);
    }
    notifyListeners();
  }

  onBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const ZoneBottomSheet();
      },
    );
  }

  //on location delete tap
  onLocationDelete(index, context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(sync, context, eImageAssets.location,
        translations!.delete, translations!.areYiuSureDeleteLocation, () {
      appArray.serviceAvailableAreaList.removeAt(index);
      route.pop(context);
      notifyListeners();
    });
    value.notifyListeners();
  }

  freelancerClearDataForSignUp() {
    languageSelect = [];
    countryCompany = null;
    country = null;
    countryProvider = null;
    stateCompany = null;
    stateProvider = null;
    chosenValue = null;
    countryValue = -1;
    stateValue = -1;
    slider = 0.0;
    imageFile = null;
    docFile = null;
    documentModel = '';

    companyName.text = "";
    companyPhone.text = "";
    companyMail.text = "";
    experience.text = "";
    description.text = "";
    identityNumber.text = "";
    password.text = "";
    reEnterPassword.text = "";
    latitude.text = "";
    longitude.text = "";
    area.text = "";
    street.text = "";
    city.text = "";
    zipCode.text = "";
    countryCtrl.text = "";
    stateCtrl.text = "";
    ownerName.text = "";
    providerEmail.text = "";
    providerNumber.text = "";
    referralCode.text = "";
    areaData = "";
    notifyListeners();
  }

  //on page initialize
  void onReady(context) {
    pageIndex = 0;
    fPageIndex = 0;
    notifyListeners();
    freelancerClearDataForSignUp();

    getAllCategory();
    // Assign lists and handle null values
    countryList = countryStateList ?? [];
    statesList = stateList ?? [];
    zonesList = zoneList ?? [];
    selectedRole = '';

    // Check list lengths before accessing elements
    if (countryList.isNotEmpty) {
      countryValue = countryList[0].id!;
    } else {
      countryValue = -1; // Fallback value
    }

    country = null;
    stateValue = -1;
    state = null;

    descriptionFocus.addListener(() {
      notifyListeners();
    });

    log("signup.countryList : ${countryList.length}");
    notifyListeners();
  }

  //phone dial code selection
  changeDialCode(CountryCodeCustom country) {
    dialCode = country.dialCode!;
    notifyListeners();
  }

  //provider phone dial code selection

  changeProviderDialCode(CountryCodeCustom country) {
    providerDialCode = country.dialCode!;
    notifyListeners();
  }

  //experience duration select
  onDropDownChange(choseVal) {
    chosenValue = choseVal;
    notifyListeners();
  }

  //location range selection
  slidingValue(newValue) {
    slider = newValue;
    notifyListeners();
  }

  onIdentityChange(val) {
    if (val != null) {
      log("SS ::4 $val"); // Log the value for debugging
      documentModel = val.toString(); // Update the document model
      notifyListeners(); // Notify listeners about the change
    } else {
      log("SS ::4 Received a null value"); // Log null value for debugging
    }
  }

  scrollAnimated(double position) {
    controller.animateTo(position,
        duration: const Duration(seconds: 1), curve: Curves.ease);
    notifyListeners();
  }

//freelancer on save tap validation
  onFreelancerTap(context) async {
    log("fPageIndex ;$fPageIndex");

    if (fPageIndex == 0) {
      if (signupFreelanceFormKey1.currentState!.validate()) {
        // if (languageSelect.isNotEmpty) {
        //   if (documentModel != "") {
        if (docFile != null) {
          // if (chosenValue != null) {
          signUpAsFreelance(context);
          /*   scrollAnimated(1);
                fPageIndex++;*/
        } else {
          snackBarMessengers(context,
              message:
                  language(context, translations!.pleaseUploadProfilePhoto));
        }
        // } else {
        //   snackBarMessengers(context,
        //       message:
        //           language(context, translations!.pleaseUploadProfilePhoto));
        // }
        // } else {
        //   snackBarMessengers(context,
        //       message:
        //           language(context, translations!.pleaseSelectIdentityType));
        // }
        // } else {
        //   snackBarMessengers(context,
        //       message: language(context, translations!.pleaseSelectLanguage));
        // }
      }
    } /*else if (fPageIndex == 1) {
      if (signupFreelanceFormKey2.currentState!.validate()) {
        if (country != null) {
          if (state != null) {
            if (zonesList.isNotEmpty) {
              scrollAnimated(1);
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              fPageIndex++;

              if (fPageIndex == 2) {
                log("fghj");
                prefs.setBool(session.isLogin, true);
                prefs.setBool(session.isFreelancer, true);
                signUpAsFreelance(context);
                isFreelancer = true;
              }
            } else {
              snackBarMessengers(context,
                  message: language(context, translations!.selectZone));
            }
          } else {
            snackBarMessengers(context,
                message: language(context, translations!.pleaseSelectState));
          }
        } else {
          snackBarMessengers(context,
              message: language(context, translations!.pleaseSelectCountry));
        }
      }
    }*/
  }

  //on next button tap with validation
  onNext(context) async {
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    log("INDEX :$pageIndex");
    if (signupFormKey3.currentState!.validate()) {
      signUp(context);
    }

    // if (pageIndex == 0) {
    //   if (signupFormKey1.currentState!.validate()) {
    //     if (imageFile != null) {
    //       scrollAnimated(1);
    //       pageIndex++;
    //     } else {
    //       snackBarMessengers(context,
    //           message: language(context, translations!.addCompanyLogo));
    //     }
    //   }
    // } else if (pageIndex == 1) {
    //   if (signupFormKey2.currentState!.validate()) {
    //     if (country != null) {
    //       if (state != null) {
    //         if (zonesList.isNotEmpty) {
    //           log("company locations::${latitude.text}//${longitude.text}//${area.text}//${street.text}//${country!.id}//${state!.id}//${city.text}//${zipCode.text}");
    //
    //           scrollAnimated(1);
    //           pageIndex++;
    //         } else {
    //           snackBarMessengers(context,
    //               message: language(context, translations!.selectZone));
    //         }
    //       } else {
    //         snackBarMessengers(context,
    //             message: language(context, translations!.selectState));
    //       }
    //     } else {
    //       snackBarMessengers(context,
    //           message: language(context, translations!.selectCountry));
    //     }
    //   }
    // } else if (pageIndex == 2) {
    //   if (signupFormKey3.currentState!.validate()) {
    //     if (languageSelect.isNotEmpty) {
    //       if (documentModel != null) {
    //         if (docFile != null) {
    //           scrollAnimated(1);
    //
    //           pageIndex++;
    //           if (pageIndex == 3) {
    //             signUp(context);
    //             // route.pushReplacementNamed(context, routeName.dashboard);
    //           }
    //         } else {
    //           snackBarMessengers(context,
    //               message:
    //                   language(context, translations!.pleaseUploadDocument));
    //         }
    //       } else {
    //         snackBarMessengers(context,
    //             message:
    //                 language(context, translations!.pleaseSelectIdentityType));
    //       }
    //     } else {
    //       snackBarMessengers(context,
    //           message: language(context, translations!.pleaseSelectLanguage));
    //     }
    //   }
    // }

    log("INDEXEPAGE $pageIndex");
    notifyListeners();
  }

  //sign up as company
  signUp(context) async {
    try {
      showLoading(context);
      notifyListeners();
      // List langList = [];
      //
      // for (var d in languageSelect) {
      //   if (!langList.contains(d.value)) {
      //     langList.add(d.value);
      //   }
      // }
      //
      // log("langList: ${langList.length}");
       String token = await getFcmToken();
      final mimeTypeData =
          lookupMimeType(imageFile!.path, headerBytes: [0xFF, 0xD8])!
              .split('/');
      // final docMimeType =
      //     lookupMimeType(docFile!.path, headerBytes: [0xFF, 0xD8])!.split('/');
      // final uploadList = <dio.MultipartFile>[];
      // //
      // uploadList.add(await dio.MultipartFile.fromFile(docFile!.path.toString(),
      //     filename: docFile!.name.toString(),
      //     contentType: MediaType(docMimeType[0], docMimeType[1])));

      log("isFreelancer asdasdasdasd${isFreelancer}");
      var body = {
        "profile_image": await dio.MultipartFile.fromFile(
            imageFile!.path.toString(),
            filename: imageFile!.name.toString(),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "name": ownerName.text,
        "email": providerEmail.text,
        "phone": providerNumber.text,
        "code": providerDialCode ??
            "+${appSettingModel?.general?.countryCode ?? 1}" /* "+1" */,
        "password": password.text,
        "password_confirmation": reEnterPassword.text,
        "role": selectedRole?.toLowerCase(),
        if (selectedRole?.toLowerCase() != "provider")
          "provider_id": selectedProviderId,
        for (var i = 0; i < zoneSelect.length; i++)
          "zoneIds[$i]": zoneSelect[i].id,
        "type": "company",
        "referral_code": referralCode.text,
         "fcm_token": token,

        // 'company_logo': await dio.MultipartFile.fromFile(
        //     imageFile!.path.toString(),
        //     filename: imageFile!.name.toString(),
        //     contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        // "company_name": companyName.text,
        // "company_email": companyMail.text,
        // "company_code": dialCode,
        // "company_phone": companyPhone.text,
        // "description": description.text,

        // "experience_interval": /*  "year" */ chosenValue ?? "Years",
        // "experience_duration": experience.text,

        // "known_languages": langList,
        // "document_id": documentModel,
        // 'identity_no': identityNumber.text,
        // 'document_images': uploadList,

        // "company_address": {
        //   "latitude": latitude.text,
        //   "longitude": longitude.text,
        //   "area": area.text,
        //   "address": street.text,
        //   "country_id": country!.id,
        //   "state_id": state!.id,
        //   "city": city.text,
        //   "postal_code": zipCode.text,
        //   "is_primary": "1"
        // }
      };

      log("BODU body body:$body");

      dio.FormData formData = dio.FormData.fromMap(body);
      await apiServices.postApi(api.register, formData).then((value) async {
        notifyListeners();
        log("ISS :${value.isSuccess}");
        if (value.isSuccess!) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(session.token, true);
          log("isLogin :${prefs.getBool(session.token)}");
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);

          notifyListeners();
          SharedPreferences? pref = await SharedPreferences.getInstance();
          dynamic userData = pref.getString(session.user);
          snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);
          showLoading(context).then((value) {
            route.pushReplacementNamed(context, routeName.dashboard);
            companyName.text = '';
            companyPhone.text = '';
            companyMail.text = '';
            experience.text = '';
            description.text = '';
            // areaData.clear();
            latitude.text = '';
            longitude.text = '';
            area.text = '';
            city.text = '';
          });
          if (userData != null) {
            FirebaseMessaging messaging = FirebaseMessaging.instance;
            for (var i = 0; i < zoneSelect.length; i++) {
              messaging.subscribeToTopic("zone_${zoneSelect[i].id}");
            }
            createBookingNotification(NotificationType.createProvider);
            /*   final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            await commonApi.selfApi(context); */
            final userApi =
                Provider.of<UserDataApiProvider>(context, listen: false);
            final prefs = await SharedPreferences.getInstance();

            await prefs.remove('booking_history');
            await userApi.getBookingHistory(context);
            commonApi.getDashBoardApi(context);

            if (!isFreelancer) {
              await userApi.getServicemenByProviderId();
            }
            final locationCtrl =
                Provider.of<LocationProvider>(context, listen: false);

            locationCtrl.getUserCurrentLocation(context);
            await userApi.getBankDetails();
            // await userApi.getDocumentDetails();
            await userApi.getAddressList(context);
            await userApi.getJobRequest(context);
            // await userApi.getNotificationList();
            // await userApi.getServicePackageList();
            await userApi.getPopularServiceList();
            await userApi.getAllServiceList();

            await userApi.getBookingHistory(context);
            FirebaseApi().onlineActiveStatusChange(false);
          }
          hideLoading(context);
          /* snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);
          showLoading(context).then((value) {
            route.pushReplacementNamed(context, routeName.dashboard);
            companyName.text = '';
            companyPhone.text = '';
            companyMail.text = '';
            experience.text = '';
            description.text = '';
            // areaData.clear();
            latitude.text = '';
            longitude.text = '';
            area.text = '';
            city.text = '';
          }); */
          pageIndex = 0;
          notifyListeners();
        } else {
          pageIndex = 2;
          hideLoading(context);
          notifyListeners();
          snackBarMessengers(context,
              message: language(context, value.message));
        }
      });
    } catch (e) {
      pageIndex = 2;
      notifyListeners();
      hideLoading(context);
      notifyListeners();
      log("EEEE signUp : $e");
    }
  }

  //sign up as freelance
  signUpAsFreelance(context) async {
    try {
      showLoading(context);
      notifyListeners();
      final newLoc = Provider.of<NewLocationProvider>(context, listen: false);
      List newAddressList = [];
      for (var a in newLoc.locationList) {
        log("asdhjaklsda ${a['type'].toString().toLowerCase()}");
        newAddressList.add({
          "type": a['type'].toString().toLowerCase(),
          "address": a['address'],
          "latitude": a['latitude'],
          "longitude": a['longitude'],
          "city": a['city'],
          "postal_code": a['postal_code'],
          "area": a['area'],
          "country_id": country!.id,
          "state_id": state!.id,
          "is_primary": "1",
          "status": "1",
          "availability_radius": slider,
        });
      }
      List langList = [];

      for (var d in languageSelect) {
        if (!langList.contains(d.value)) {
          langList.add(d.value);
        }
      }
      notifyListeners();
      String token = await getFcmToken();

      final docMimeType =
          lookupMimeType(docFile!.path, headerBytes: [0xFF, 0xD8])!.split('/');
      final uploadList = <dio.MultipartFile>[];

      uploadList.add(await dio.MultipartFile.fromFile(docFile!.path.toString(),
          filename: docFile!.name.toString(),
          contentType: MediaType(docMimeType[0], docMimeType[1])));

      var body = {
        "type": "freelancer",
        "name": ownerName.text,
        "email": providerEmail.text,
        "phone": providerNumber.text,
        "code": providerDialCode,
        // "experience_interval": chosenValue ?? "year",
        // "experience_duration": experience.text,
        "password": password.text,
        // "known_languages": langList,
        "password_confirmation": reEnterPassword.text,
        // "document_id": documentModel,
        // 'identity_no': identityNumber.text,
        'profile_image': uploadList,
        // "addresses": newAddressList,
        "role": "provider",
        for (var i = 0; i < zoneSelect.length; i++)
          "zoneIds[$i]": zoneSelect[i].id,
        "fcm_token": token,
        "referral_code": referralCode.text,
        // if (!isFreelancer)
        //   "company_address": {
        //     "latitude": latitude.text,
        //     "longitude": longitude.text,
        //     "area": area.text,
        //     "address": street.text,
        //     "country_id": country!.id,
        //     "state_id": state!.id,
        //     "city": city.text,
        //     "postal_code": zipCode.text,
        //     "is_primary": "1"
        //   }
      };

      log("BODU :$body");

      dio.FormData formData = dio.FormData.fromMap(body);
      await apiServices.postApi(api.register, formData).then((value) async {
        notifyListeners();
        if (value.isSuccess!) {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          for (var i = 0; i < zoneSelect.length; i++) {
            messaging.subscribeToTopic("zone_${zoneSelect[i].id}");
          }
          createBookingNotification(NotificationType.createProvider);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(session.token, true);
          log("isLogin :${prefs.getBool(session.token)}");
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);

          notifyListeners();
          SharedPreferences? pref = await SharedPreferences.getInstance();
          dynamic userData = pref.getString(session.user);
          if (userData != null) {
            final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            await commonApi.selfApi(context);
            final userApi =
                Provider.of<UserDataApiProvider>(context, listen: false);
            commonApi.getDashBoardApi(context);
            if (!isFreelancer) {
              await userApi.getServicemenByProviderId();
            }
            final locationCtrl =
                Provider.of<LocationProvider>(context, listen: false);

            locationCtrl.getUserCurrentLocation(context);
            await userApi.getBankDetails();
            // await userApi.getDocumentDetails();
            await userApi.getAddressList(context);
            // await userApi.getNotificationList();
            // await userApi.getServicePackageList();
            await userApi.getJobRequest(context);
            await userApi.getPopularServiceList();
            await userApi.getAllServiceList();
            await userApi.getBookingHistory(context);
            // userApi.statisticDetailChart();
            FirebaseApi().onlineActiveStatusChange(false);
          }
          hideLoading(context);
          snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);
          route.pushReplacementNamed(context, routeName.dashboard);
          fPageIndex = 0;
          notifyListeners();
        } else {
          fPageIndex = 1;
          hideLoading(context);
          snackBarMessengers(context,
              message: language(context, value.message));
          notifyListeners();
        }
      });
    } catch (e) {
      fPageIndex = 1;
      notifyListeners();
      hideLoading(context);
      notifyListeners();
      log("EEEE signUp : $e");
    }
  }

  popInvokeFree(didPop, context) async {
    hideLoading(context);
    scrollAnimated(1);
    fPageIndex--;
    log("context :$fPageIndex");
    if (fPageIndex == -1) {
      languageSelect = [];
      countryCompany = null;
      country = null;
      countryProvider = null;
      stateCompany = null;
      stateProvider = null;
      chosenValue = null;
      countryValue = -1;
      stateValue = -1;
      slider = 0.0;
      imageFile = null;
      docFile = null;
      documentModel = '';

      companyName.text = "";
      companyPhone.text = "";
      companyMail.text = "";
      experience.text = "";
      description.text = "";
      identityNumber.text = "";
      password.text = "";
      reEnterPassword.text = "";
      latitude.text = "";
      longitude.text = "";
      area.text = "";
      street.text = "";
      city.text = "";
      zipCode.text = "";
      countryCtrl.text = "";
      stateCtrl.text = "";
      ownerName.text = "";
      providerEmail.text = "";
      providerNumber.text = "";
      referralCode.text = "";
      areaData = "";
      route.pop(context);
    }

    notifyListeners();
  }

  onBack(context) {
    if (pageIndex == 0) {
      route.pop(context);
    } else {
      pageIndex--;
      scrollAnimated(1);
    }
    notifyListeners();
  }

  popInvoke(didPop, context) async {
    scrollAnimated(1);
    pageIndex--;
    if (pageIndex == -1) {
      languageSelect = [];
      countryCompany = null;
      country = null;
      countryProvider = null;
      stateCompany = null;
      stateProvider = null;
      chosenValue = null;
      countryValue = -1;
      stateValue = -1;
      slider = 0.0;
      imageFile = null;
      docFile = null;
      documentModel = '';
      selectedRole = '';

      companyName.text = "";
      companyPhone.text = "";
      companyMail.text = "";
      experience.text = "";
      description.text = "";
      identityNumber.text = "";
      password.text = "";
      reEnterPassword.text = "";
      latitude.text = "";
      longitude.text = "";
      area.text = "";
      street.text = "";
      city.text = "";
      zipCode.text = "";
      countryCtrl.text = "";
      stateCtrl.text = "";
      ownerName.text = "";
      providerEmail.text = "";
      providerNumber.text = "";
      referralCode.text = "";
      route.pop(context);
    }
    notifyListeners();
  }
}
