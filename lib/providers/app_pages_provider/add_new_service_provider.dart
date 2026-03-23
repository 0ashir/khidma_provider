import 'dart:developer';
import 'package:fixit_provider/model/edit_service_model.dart';
import 'package:fixit_provider/model/location_model.dart';
import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/add_faq.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/category_bottom_sheet.dart';
import 'package:fixit_provider/services/environment.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;

class AddNewServiceProvider with ChangeNotifier {
  CategoryModel? categoryValue;
  CategoryModel? subCategoryValue;
  Services? services;
  List faqList = [];
  List<ServiceFaqModel> serviceFaq = [];
  List<CategoryModel> newCategoryList = [];
  List<CategoryModel> newData = [];
  List<LocationData> locationData = [];
  EditServiceModel? services1;
  bool isDurationValid = true;
  int? selectedIndex;
  LocationData? selectedAddress;

  List<CategoryModel> categories = [], newCatList = [];
  String? durationValue, serviceOption = 'fixed', perServiceman;
  int selectIndex = 0, selected = -1;
  int? taxIndex, zoneIndex;
  bool isSwitch = true, isEdit = false, isAdvancePayment = false;
  final multiSelectKey = GlobalKey<FormFieldState>();
  TextEditingController filterSearchCtrl = TextEditingController();
  final FocusNode filterSearchFocus = FocusNode();
  final dioo = Dio();
  String argData = 'NULL';
  List<CategoryModel> subCategory = [];
  String commission = "";
  dynamic areaData;
  String? street, area, latitude, longitude, city, zipCode;
  List<CountryStateModel> countryList = [];
  List<ZoneModel> zonesList = [];
  List<StateModel> statesList = [];
  int countryValue = -1, stateValue = -1;
  CountryModel? countryCompany, countryProvider, stateCompany, stateProvider;
  CountryStateModel? country;
  ZoneModel? zone;
  StateModel? state;

  TextEditingController serviceName = TextEditingController();
  /* TextEditingController description = TextEditingController(); */

  HtmlEditorController description = HtmlEditorController();
  TextEditingController duration = TextEditingController();
  TextEditingController availableService = TextEditingController();
  TextEditingController minRequired = TextEditingController();
  TextEditingController perServicemanCommission = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController tax = TextEditingController();
  TextEditingController advancePaymentPercentage = TextEditingController();

  FocusNode serviceNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode availableServiceFocus = FocusNode();
  FocusNode minRequiredFocus = FocusNode();
  FocusNode perServicemanCommissionFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode taxFocus = FocusNode();
  FocusNode advancePaymentPercentageFocus = FocusNode();

  XFile? imageFile, thumbFile;
  GlobalKey<FormState> addServiceFormKey = GlobalKey<FormState>();
  String? thumbImage;
  List image = [];
  String _htmlContent = "";

  String get htmlContent => _htmlContent;

  void setHtmlContent(String value) {
    _htmlContent = value;
    notifyListeners();
  }

  // on page initialise data fetch
  onReady(context) async {
    // TODO: implement initState
    log("dfn");
    log("object=-=-=-=-=-=-=->>>>${serviceOption}");
    getServiceDetails(context);
    getServiceDetails(context);

    if (userModel!.company == null ||
        (userModel!.company!.name == null || userModel!.company!.name == "") ||
        (userModel!.company!.email == null ||
            userModel!.company!.email == "")) {
      showDialog(
          context: context,
          builder: (context1) {
            return AlertDialogCommon(
              isTwoButton: true,
              title: translations!.companyDetails,
              subtext: translations?.updateCompanyDetails,
              image: eImageAssets.caution,
              bText1: translations!.cancel,
              firstBText: translations!.cancel,
              secondBText: translations!.update,
              firstBTap: () => route.pop(context1),
              secondBTap: () {
                route.pop(context1);
                route.pushNamed(context, routeName.companyDetailUpdate);
              },
              height: Sizes.s140,
            );
          });
    } else if (userModel!.isVerified == 0) {
      showDialog(
          context: context,
          builder: (context1) {
            return AlertDialogCommon(
              isTwoButton: true,
              title: translations!.idVerification,
              subtext: translations?.verifyAccountToCreateService,
              image: eImageAssets.caution,
              bText1: translations!.cancel,
              firstBText: translations!.cancel,
              secondBText: translations!.pleaseUploadDocument,
              firstBTap: () => route.pop(context1),
              secondBTap: () {
                route.pop(context1);
                route.pushNamed(context, routeName.idVerification);
              },
              height: Sizes.s140,
            );
          });
    }

    final provider = Provider.of<CommonApiProvider>(context, listen: false);
    provider.getAllCategory();

    final allUserApi = Provider.of<UserDataApiProvider>(context, listen: false);
    allUserApi.commonCallApi(context);

    // commonApi.commonApi(context);
    areaData = services?.primaryAddress?.address;
    dynamic data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    newCatList = allCategoryList;
    /*  descriptionFocus.addListener(() {
      notifyListeners();
    }); */

    if (data != "") {
      log("dfnpolk =-=-=-=--==-=-=-=->>> ${data}");
      isEdit = data["isEdit"] ?? false;
      log("isEdit :$isEdit");

      services = Services.fromJson(data["service"]);
      log("dfnpolk =-=-=-=--==-=-=-=->>> isEdit : ${services!.categories} isEdit : ");
      if (data['serviceFaq'] != null) {
        serviceFaq = serviceFaq;
      } else {
        await getServiceFaqId(context, services!.id);
      }

      // log("object=-=-=-=-=-=-=->>>> ${data['serviceFaq']}///${serviceOption}");
      isFeatured = services!.isFeatured == 0 ? false : true;
      // areaData = services!.primaryAddress!.address;
      serviceName.text = "df" /* services!.title! */;
      serviceFaq = data['serviceFaq'];
      serviceOption = services!.type;
      perServicemanCommission.text =
          services!.perServicemanCommission.toString();
      log("services!.categories :${services!.categories}");
      if (services!.categories != null) {
        services!.categories!.asMap().entries.forEach((element) {
          /* ValueItem<int> valueItem =
              ValueItem(label: element.value.title!, value: element.value.id);
*/
          if (!categories.contains(element.value)) {
            categories.add(element.value);
          }
          notifyListeners();
        });
      }

      categories.asMap().entries.forEach((e) {
        int index =
            allCategoryList.indexWhere((element) => element.id == e.value.id);
        if (index >= 0) {
          newCategoryList.add(allCategoryList[index]);
        }
      });
      for (var d in serviceFaq) {
        var a = {
          'question': d.question,
          'answer': d.answer,
        };
        faqList.add(a);
      }
      notifyListeners();
      if (newCategoryList.isNotEmpty) {
        var largestGeekValue = newCategoryList.reduce((current, next) =>
            double.parse(current.commission!.toString()) >
                    double.parse(next.commission!.toString())
                ? current
                : next);

        commission = largestGeekValue.commission!.toString();
      } else {
        commission = "0.0";
      }

      selectIndex =
          services!.discount != null && services!.discount != 0 ? 1 : 0;
      // description.text = services!.description ?? "";
      log("services!.serviceAvailabilities  :${services!.content}");
      /*   WidgetsBinding.instance.addPostFrameCallback((_) {
        description.setText(services?.content ?? "");
      });  */ /* description.setText(services?.content ?? ""); */

      log("message-=-=-=-=-=-=-=-=-=-=-=- ${services!.content}");
      log("message-=-=-=-=-=-=-=-=-=-=-=- ${description}");
      discount.text = (services!.discount!).toStringAsFixed(0).toString();
      duration.text = services!.duration!;
      log("services!.durationUnit! :${services!.durationUnit!} ssss  ${translations?.hour} aaa ${capitalizeFirstLetter(translations?.hour)}");
      // if (services!.durationUnit == capitalizeFirstLetter(translations?.hour)) {
      durationValue = capitalizeFirstLetter(services!.durationUnit);
      // } else {
      //   durationValue = capitalizeFirstLetter(services!.durationUnit == "minutes"
      //       ? "minutes"
      //       : services!.durationUnit!);
      // }

      minRequired.text = services!.requiredServicemen != null
          ? services!.requiredServicemen.toString()
          : "1";
      amount.text = services!.price!.toString();

      selectedIndex = services!.addressId;
      log("message-=--Media : ${services!.addressId}");
      int taxVal = taxList.indexWhere(
          (element) => element.id.toString() == services!.taxId.toString());
      if (taxVal >= 0) {
        taxIndex = int.parse(services!.taxId!.toString());
      }
      isSwitch = services!.status == 1 ? true : false;
      log("message-=--Media : ${services!.media?.first.collectionName}");
      if (services!.media != null && services!.media!.isNotEmpty) {
        for (var d in services!.media!) {
          log("d.collectionName :${d.collectionName}");
          if (d.collectionName == "thumbnail") {
            thumbImage = d.originalUrl!;
          }
          if (d.collectionName == "web_thumbnail") {
            webThumbImage = d.originalUrl!;
          }
        }
      }

      // log("edit screen data:${serviceName.text}//${categories.length}//${perServicemanCommission.text}//${addressList.last}//${description.text}//$durationValue//$duration");

      isAdvancePayment = services!.isAdvancePayment == 1 ? true : false;
      advancePaymentPercentage.text =
          services!.advancePaymentPercentage?.toString() ?? "";

      log("🟡 Advance Payment Data from Route Arguments:");
      log("  - services.isAdvancePayment: ${services!.isAdvancePayment}");
      log("  - services.advancePaymentPercentage: ${services!.advancePaymentPercentage}");
      log("  - isAdvancePayment (bool): $isAdvancePayment");
      log("  - advancePaymentPercentage.text: ${advancePaymentPercentage.text}");

      notifyListeners();
    } else {
      serviceOption = '0';
      taxIndex = null;
      faqList = [];
    }
    addressList = [];
    getServiceDetails(context);
  }

  selectAddress(ind, LocationData address) {
    selectedIndex = ind;
    selectedAddress = address;
    log("xdscuh   $selectedIndex      uisdzx chuvijon bvso");
    notifyListeners();
  }

  Future<void> getServiceDetails(BuildContext context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    String selectedLocale = lang.selectedLocaleService;
    print("Selected Locale: $selectedLocale");

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);
    try {
      log("services?.id::${api.providerServices}?service_id=${services?.id}");

      final response = await dioo.get(
          '${api.providerServices}?service_id=${services?.id}',
          options: Options(
              headers: headersToken(token,
                  localLang: selectedLocale, isLang: true)));

      // log("Headers: ${headersToken(token, localLang: selectedLocale, isLang: true)}");
      // log("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("services?.id:: Response${response.data}");

        if (response.data != null) {
          // services = Services.fromJson(response.data);
          // log("Service Title: ${services!.title}");

          serviceName.text = response.data['data']['title'] ?? "";

          // Fetch and set advance payment data - handle multiple possible API response formats
          var advancePaymentData = response.data['data'];

          // Try different possible key names for advance payment enabled flag
          var advanceEnabled =
              advancePaymentData['is_advance_payment_enabled'] ??
                  advancePaymentData['isAdvancePaymentEnabled'] ??
                  advancePaymentData['isadvancePaymentEnable'] ??
                  0;

          // Handle different value types: int (1/0), bool (true/false), or string ("1"/"0")
          if (advanceEnabled is bool) {
            isAdvancePayment = advanceEnabled;
          } else if (advanceEnabled is int) {
            isAdvancePayment = advanceEnabled == 1;
          } else if (advanceEnabled is String) {
            isAdvancePayment =
                advanceEnabled == "1" || advanceEnabled.toLowerCase() == "true";
          } else {
            isAdvancePayment = false;
          }

          // Set percentage value
          advancePaymentPercentage.text =
              advancePaymentData['advance_payment_percentage']?.toString() ??
                  advancePaymentData['advancePaymentPercentage']?.toString() ??
                  "";

          log("🔵 Advance Payment Data from API:");
          log("  - Raw API data: ${response.data['data']}");
          log("  - Advance enabled key found: $advanceEnabled");
          log("  - Advance percentage: ${advancePaymentData['advance_payment_percentage']}");
          log("  - Parsed isAdvancePayment (bool): $isAdvancePayment");
          log("  - Parsed advancePaymentPercentage.text: ${advancePaymentPercentage.text}");

          WidgetsBinding.instance.addPostFrameCallback((_) {
            description.setText(response.data['data']['content'] ?? "");
          });
          notifyListeners();
          /*   description.setText(response.data['data']['description'] ?? ""); */
          // webThumbImage = response.data['data']['web_img_thumb_url'] ?? "";

          if (response.data['data']['categories'] != null) {
            categories =
                response.data['data']['categories'].map<CategoryModel>((e) {
              return CategoryModel.fromJson(e);
            }).toList();
          }
          notifyListeners();
// //
          categories.asMap().entries.forEach((e) {
            int index = allCategoryList
                .indexWhere((element) => element.id == e.value.id);
            if (index >= 0) {
              newCategoryList.add(allCategoryList[index]);
            }
          });
          // if (data['serviceFaq'] != null) {
          //   serviceFaq = serviceFaq;
          // } else {

          // }
          await getFaqId(context, services!.id);

          notifyListeners();
        } else {
          log("API Response was null");
        }
      } else {
        log("Failed to fetch service details: ${response.statusMessage}");
      }
    } catch (e, stacktrace) {
      log("ERROR in getServiceDetails: $e");
      log("Stacktrace: $stacktrace");
    }
  }

  getFaqId(context, serviceId) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    String selectedLocale = lang.selectedLocaleService;
    // print("Selected Locale: $selectedLocale");

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);
    try {
      final response = await dioo.get("${api.serviceFaq}?service_id=$serviceId",
          options: Options(
              headers: headersToken(token,
                  localLang: selectedLocale, isLang: true)));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("response>DATA::${response.data}");

        // Convert response data into list of ServiceFaqModel
        serviceFaq = (response.data as List)
            .map((e) => ServiceFaqModel.fromJson(e))
            .toList();
        faqList.clear();
        faqList.addAll(serviceFaq.map((d) => {
              'question': d.question,
              'answer': d.answer,
            }));
        log("FAQS :${faqList}");
        notifyListeners();
      } else {
        notifyListeners();
      }
    } catch (e) {
      log("ERRROEEE getServiceFaqId : $e");
      notifyListeners();
    }
  }

  getLocationData(context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    String selectedLocale = lang.selectedLocaleService;
    // print("Selected Locale: $selectedLocale");

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(session.accessToken);
    try {
      final response = await dioo.get("${api.addAddress}",
          options: Options(
              headers: headersToken(token,
                  localLang: selectedLocale, isLang: true)));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("response>DATA::${response.data['data']['data']}");
        locationData = (response.data['data']['data'] as List)
            .map((e) => LocationData.fromJson(e))
            .toList();
        log("FAQS :${locationData}")
            /*   // Convert response data into list of ServiceFaqModel
        serviceFaq = (response.data as List)
            .map((e) => ServiceFaqModel.fromJson(e))
            .toList();
        faqList.clear();
        faqList.addAll(serviceFaq.map((d) => {
              'question': d.question,
              'answer': d.answer,
            }));
        log("FAQS :${faqList}") */
            ;
        notifyListeners();
      } else {
        notifyListeners();
      }
    } catch (e, s) {
      log("ERRROEEE getServiceFaqId : $e -=-=-=-=-=$s");
      notifyListeners();
    }
  }

  //country selection function
  onChangeCountryCompany(context, val, CountryStateModel c) {
    countryValue = val;

    country = c;

    int index = countryList.indexWhere((element) => element.id == c.id);
    log("countryList :$index");
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

  bool isLocationLoader = false;

  Future<void> getLocation(BuildContext context) async {
    isLocationLoader = true;
    notifyListeners();
    final loc = Provider.of<LocationProvider>(context, listen: false);
    // route.pushNamed(context, routeName.location, arg: {"isService": true}).then(
    //     (e) {
    //   log("EEEE :$e");
    // });
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Location permission denied");
      return;
    }
    route.pushNamed(context, routeName.location, arg: {"isService": true}).then(
        (e) {
      log("EEEE :$e");
    });

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocode to get address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      areaData = "${place.street}, ${place.locality}, ${place.country}";

      // Update location fields
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      city = place.locality ?? "";
      zipCode = place.postalCode ?? "";
    }
    isLocationLoader = false;
    notifyListeners();
    /* route.pushNamed(context, routeName.location, arg: {"isService": true}).then(
        (e) {
      log("EEEE :$e");
    }); */

    notifyListeners();
  }

  getServiceFaqId(context, serviceId) async {
    try {
      await apiServices
          .getApi("${api.serviceFaq}?service_id=$serviceId", [],
              isData: true, isMessage: false)
          .then((value) {
        if (value.isSuccess!) {
          for (var d in value.data) {
            if (!serviceFaq.contains(ServiceFaqModel.fromJson(d))) {
              serviceFaq.add(ServiceFaqModel.fromJson(d));
            }
          }
          log("serviceFaq :${serviceFaq.length}");
          notifyListeners();
        } else {
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE getServiceFaqId : $e");
      notifyListeners();
    }
  }

  //add faq
  addFaq(context) {
    route.push(context, AddFaq(faqList: faqList)).then((e) {
      if (e != null) {
        faqList = e;
      }
      notifyListeners();
    });
  }

  onExpansionChange(newState, index) {
    log("dghfdkg:$newState");
    if (newState) {
      const Duration(seconds: 20000);
      selected = index;
      notifyListeners();
    } else {
      selected = -1;
      notifyListeners();
    }
  }

  //on select service type option
  onSelectServiceTypeOption(val) {
    serviceOption = val;
    log("SERVICE TYPE $serviceOption");
    notifyListeners();
  }

  bool isLoading = false;
  DateTime? _lastSearchTime;
  final Duration _throttleDuration = const Duration(milliseconds: 500);

  getCategory({String? search, index}) async {
    // Throttle: Skip if called too soon
    final now = DateTime.now();
    if (_lastSearchTime != null &&
        now.difference(_lastSearchTime!) < _throttleDuration) {
      log("Throttled: Skipping API call");
      return;
    }
    _lastSearchTime = now;

    isLoading = true;
    notifyListeners();

    try {
      // String apiUrl = "${api.category}?zone_id=$index&providerId=${userModel!.id}";
      String apiUrl = "${api.category}?zone_id=$index";
      // if (search != null && search.isNotEmpty) {
      //   apiUrl += "&search=$search";
      // }

      log("apiUrl::: FOR CATEGORY:::$apiUrl");
      final response = await apiServices.getApi(apiUrl, []);

      if (response.isSuccess) {
        // newCatList.clear();
        log("respopafhaf ${response.data}");
        final List<dynamic> categoryData = response.data;
        newCatList = categoryData.reversed
            .map((data) => CategoryModel.fromJson(data))
            .toList();
        log("newCatList updated: ${newCatList}");
      }
    } catch (e) {
      log("Error fetching categories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  onBottomSheet(context) {
    newCatList = allCategoryList;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CategoryBottomSheet();
      },
    );
  }

  //on back data clear
  onBack(isBack) {
    isEdit = false;
    image = [];
    faqList = [];
    serviceFaq = [];
    services = null;
    thumbImage = null;

    webImageFile = null;
    webThumbFile = null;
    webThumbImage = null;
    perServicemanCommission.text = "";
    serviceOption = null;
    isFeatured = false;
    categories = [];
    filterSearchCtrl.text = "";
    appArray.serviceImageList = [];
    categories = [];
    newCatList = [];
    newCategoryList = [];
    serviceName.text = "";
    thumbFile = null;
    imageFile = null;
    categoryValue = null;
    subCategoryValue = null;
    description.setText("");
    duration.text = "";
    availableService.text = "";
    minRequired.text = "";
    discount.text = "";
    selectIndex = 0;
    amount.text = "";
    taxIndex = null;
    thumbImage = "";
    webThumbImage = "";
    isSwitch = false;
    isAdvancePayment = false;
    advancePaymentPercentage.text = "";

    taxIndex = null;
    durationValue = null;
    imageFile = null;
    thumbFile = null;
    webImageFile = null;
    webThumbFile = null;
    image = [];

    appArray.serviceImageList = [];

    description.setText("");
    categories = [];
    notifyListeners();
  }

  //on back button data clear
  onBackButton(context) {
    route.pop(context);
    isEdit = false;
    image = [];
    thumbImage = "";
    webThumbImage = "";
    perServicemanCommission.text = "";
    serviceOption = null;
    isFeatured = false;
    serviceName.text = "";
    categoryValue = null;
    subCategoryValue = null;
    description.setText("");
    duration.text = "";
    availableService.text = "";
    minRequired.text = "";
    amount.text = "";
    taxIndex = null;

    isSwitch = false;
    isAdvancePayment = false;
    advancePaymentPercentage.text = "";

    notifyListeners();
  }

  //updateInformation
  void updateInformation(information) {
    argData = information;
    notifyListeners();
  }

  //on available service tap
  onAvailableServiceTap(context) async {
    var result = await route.push(context, const LocationListScreen());
    availableService.text = result;
    notifyListeners();
  }

  // GET IMAGE FROM GALLERY
  Future getImage(context, source, isThumbnail) async {
    final ImagePicker picker = ImagePicker();
    if (isThumbnail) {
      route.pop(context);
      thumbFile = (await picker.pickImage(source: source, imageQuality: 70))!;
    } else {
      route.pop(context);
      imageFile = (await picker.pickImage(source: source, imageQuality: 70))!;
      appArray.serviceImageList.add(imageFile!);
      notifyListeners();
    }
    notifyListeners();
  }

  //on image pick
  onImagePick(context, isThumbnail) {
    showLayout(context, onTap: (index) {
      if (index == 0) {
        if (isThumbnail) {
          getImage(context, ImageSource.gallery, isThumbnail);
        } else {
          getImage(context, ImageSource.gallery, isThumbnail);
        }
        notifyListeners();
      } else {
        if (isThumbnail) {
          getImage(context, ImageSource.camera, isThumbnail);
        } else {
          getImage(context, ImageSource.camera, isThumbnail);
        }
        notifyListeners();
      }
    });
  }

  // on remove service image
  onRemoveServiceImage(isThumbnail, {index}) {
    if (isThumbnail) {
      thumbFile = null;
      thumbImage = null;
      notifyListeners();
    } else {
      log("message=-=-=-${appArray.serviceImageList.removeAt(index)}");
      // appArray.serviceImageList.removeAt(index);
      services?.media?.removeAt(index);
      log("services!.media::${services?.media}");
      notifyListeners();
    }
  }

  onRemoveNetworkServiceImage(isThumbnail, {index}) {
    if (isThumbnail) {
      thumbFile = null;
      thumbImage = null;
      notifyListeners();
    } else {
      services!.media!.removeAt(index);
      notifyListeners();
    }
  }

  XFile? webImageFile, webThumbFile;
  String? webThumbImage;

  onRemoveWebServiceImage(isWebThumbnail, {index}) {
    log("appArray.webServiceImageList::${appArray.webServiceImageList}");
    log("appArray.webServiceImageList::$index");
    if (isWebThumbnail) {
      webThumbFile = null;
      webThumbImage = null;
      notifyListeners();
    } else {
      appArray.webServiceImageList.removeAt(index);
      notifyListeners();
    }
  }

  onRemoveNetworkWebServiceImage(isWebThumbnail, {index}) {
    log("appArray.webServiceImageList::${appArray.webServiceImageList}");
    log("appArray.webServiceImageList::$index");
    if (isWebThumbnail) {
      webThumbFile = null;
      webThumbImage = null;
      notifyListeners();
    } else {
      services!.media!.removeAt(index);
      notifyListeners();
    }
  }

  Future getWebImage(context, source, isWebThumbnail) async {
    final ImagePicker picker = ImagePicker();
    if (isWebThumbnail) {
      route.pop(context);
      webThumbFile =
          (await picker.pickImage(source: source, imageQuality: 70))!;
    } else {
      route.pop(context);
      webImageFile =
          (await picker.pickImage(source: source, imageQuality: 70))!;
      appArray.webServiceImageList.add(webImageFile!);
      notifyListeners();
    }
    notifyListeners();
  }

  //on image pick
  onWebImagePick(context, isWebThumbnail) {
    showLayout(context, onTap: (index) {
      if (index == 0) {
        if (isWebThumbnail) {
          getWebImage(context, ImageSource.gallery, isWebThumbnail);
        } else {
          getWebImage(context, ImageSource.gallery, isWebThumbnail);
        }
        notifyListeners();
      } else {
        if (isWebThumbnail) {
          getWebImage(context, ImageSource.camera, isWebThumbnail);
        } else {
          getWebImage(context, ImageSource.camera, isWebThumbnail);
        }
        notifyListeners();
      }
    });
  }

  //service available switch
  onTapSwitch(val) {
    isSwitch = val;
    notifyListeners();
  }

  onTapAdvancePayment(val) {
    isAdvancePayment = val;
    notifyListeners();
  }

  bool isFeatured = false;

  onChangeFeature(val) {
    isFeatured = val;
    notifyListeners();
  }

  // tax selection
  onChangeTax(index) {
    log("indtaxIndexex :$index");
    taxIndex = index;
    notifyListeners();
  }

  onChangeZone(context, index) {
    zoneIndex = index;
    newCatList.clear();
    getCategory(index: index);

    Provider.of<CommonApiProvider>(context, listen: false).getTax(index);
    notifyListeners();
  }

  //price change
  onChangePrice(index) {
    selectIndex = index;
    notifyListeners();
  }

  //category selection

  onChangeCategory(CategoryModel val, id, bool isCheck) {
    // getCategory();
    log(" id:::$id");
    newCategoryList = [];

    // check if category already exists by id
    int existingIndex =
        categories.indexWhere((element) => element.id == val.id);

    if (existingIndex == -1) {
      // not in list -> add
      log("val.parentId:: ${val.status}");
      if (val.parentId != null) {
        int index = newCatList.indexWhere(
            (element) => element.id.toString() == val.parentId.toString());
        if (index >= 0 &&
            !categories.any((c) => c.id == newCatList[index].id)) {
          categories.add(newCatList[index]);
        }
      }
      categories.add(val);
      isCheck = true;
      log("Added -> categories::$categories");
    } else {
      // already exists -> remove
      categories.removeAt(existingIndex);
      isCheck = false;
      log("Removed -> categories::$categories");
    }

    notifyListeners();

    // rebuild newCategoryList
    categories.asMap().entries.forEach((e) {
      int index =
          allCategoryList.indexWhere((element) => element.id == e.value.id);
      if (index >= 0) {
        newCategoryList.add(allCategoryList[index]);
      }
    });

    if (newCategoryList.isNotEmpty) {
      var largestGeekValue = newCategoryList.reduce((current, next) =>
          double.parse(current.commission!.toString()) >
                  double.parse(next.commission!.toString())
              ? current
              : next);
      log("Largest commission: ${largestGeekValue.commission}");
    }

    notifyListeners();
  }

  //select duration unit
  onChangeDuration(val) {
    durationValue = val;
    notifyListeners();
  }

  //add data validation
  addData(context) async {
    setHtmlContent(await description.getText());
    log("Debug HTML CODE $htmlContent");
    FocusScope.of(context).requestFocus(FocusNode());
    log("webThumbImage::${description.getText().then((value) => log(value))}");
    if (addServiceFormKey.currentState!.validate()) {
      log("thumbFile:::$thumbFile");
      if (webThumbFile != null) {
        if (appArray.serviceImageList.isNotEmpty) {
          log("thumbFile:::$thumbFile");
          if (thumbFile != null) {
            if (categories.isNotEmpty) {
              if (durationValue != null) {
                /* if (taxIndex != null) { */
                // addServiceApi(context);
                if (isSubscription) {
                  log("message123456789*/");
                  addServiceApi(context);
                  var service =
                      Provider.of<ServiceListProvider>(context, listen: false);
                  service.getCategoryService(context, isAllService: true);
                  service.getService(context, isList: true);
                  /* if (allServiceList.length <
                          activeSubscription!.allowedMaxServices
                      /* int.parse(activeSubscription!.allowedMaxServices ??
                          0 /* "0" */) */
                      ) {
                    addServiceApi(context);
                  } else {
                    snackBarMessengers(context,
                        message: language(
                            context,
                            appFonts.addUpToService(
                                context,
                                activeSubscription!.allowedMaxServices!
                                    .toString())));
                  } */
                } else {
                  /* if (allServiceList.isEmpty) {
                    addServiceApi(context);
                  } else { */
                  if (allServiceList.length <
                      int.parse(appSettingModel!
                              .defaultCreationLimits!.allowedMaxServices ??
                          "0")) {
                    log("message--=-=-=-=-=-=-=-=-=-");
                    addServiceApi(context);
                  } else {
                    snackBarMessengers(context,
                        message: language(
                            context,
                            appFonts.addUpToService(
                                context,
                                appSettingModel!
                                    .defaultCreationLimits!.allowedMaxServices
                                    .toString())));
                  }
                  /*  } */
                }
                /*  } */ /* else {
                snackBarMessengers(context,
                    message: language(context, translations!.pleaseSelectTax));
              } */
              } else {
                snackBarMessengers(context,
                    message: language(
                        context, translations!.pleaseSelectDurationUnit));
              }
            } else {
              snackBarMessengers(context,
                  message:
                      language(context, translations!.pleaseSelectCategory));
            }
          } else {
            snackBarMessengers(context,
                message:
                    language(context, translations!.pleaseUploadThumbPhoto));
          }
        } else {
          snackBarMessengers(context,
              message:
                  language(context, translations!.pleaseUploadServiceImages));
        }
      } else {
        snackBarMessengers(context,
            message: language(context, "Please Upload WebThumbImage"));
      }
    }
  }

  bool isUpdating = false;

  //edit data validation
  editData(context) async {
    setHtmlContent(await description.getText());
    log("Debug HTML CODE $htmlContent");
    // log("message :${userModel!.media![0].originalUrl}");
    FocusScope.of(context).requestFocus(FocusNode());
    editServiceApi(context);
  }

  List<ZoneModel> zoneSelect = [];

  //add service
  bool isAddService = false;

  addServiceApi(context) async {
    notifyListeners();
    try {
      // log("addressList.last.longitude::$addressList///$areaData///$street//$city///$latitude");
      isAddService = true;
      showLoading(context);
      dynamic mimeTypeData;
      if (thumbFile != null) {
        mimeTypeData =
            lookupMimeType(thumbFile!.path, headerBytes: [0xFF, 0xD8])!
                .split('/');
      }
      log("thumbFile:4$selectIndex == 0");
      log("thumbFile:4${thumbFile!.path} //z${thumbFile!.name}");

      final locationVal =
          Provider.of<NewLocationProvider>(context, listen: false);
      log("thumbFile:state${state?.id} //${country?.id}//${latitude}//${longitude}//${area}//$zipCode");
      var bodyremotely = {
        'type': serviceOption,
        "title": serviceName.text,
        if (thumbFile != null)
          'thumbnail': await dio.MultipartFile.fromFile(
              thumbFile!.path.toString(),
              filename: thumbFile!.name.toString(),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        if (webThumbFile != null)
          "web_thumbnail": await dio.MultipartFile.fromFile(
              webThumbFile!.path.toString(),
              filename: webThumbFile!.name.toString(),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        // "provider_id": userModel!.id,
        "price": amount.text,
        "discount": selectIndex == 0
            ? discount.text = '0'
            : discount.text.isNotEmpty
                ? discount.text
                : "0",
        // "tax_id": taxIndex,
        "duration": duration.text,
        "duration_unit": durationValue?.toLowerCase(),
        "content": htmlContent /* description.getText() */,
        "required_servicemen": isFreelancer ? '1' : minRequired.text,
        "is_featured": isFeatured == true ? "1" : "0",
        "per_serviceman_commission": perServicemanCommission.text,
        if (serviceOption == "provider_site") "address_id": selectedIndex,

        "faqs": faqList,
        "isMultipleServiceman": minRequired.length > 1 ? "1" : "0",
        "status": isSwitch == true ? "1" : "0",
        "is_advance_payment_enabled": isAdvancePayment == true ? "1" : "0",
        "advance_payment_percentage":
            isAdvancePayment == true ? advancePaymentPercentage.text : "0",
        for (var i = 0; i < categories.length; i++)
          "category_id[$i]": categories[i].id,
        for (var i = 0; i < taxList.length; i++) "tax_ids[$i]": taxList[i].id,
      };

      var body = {
        'type': serviceOption,
        "title": serviceName.text,
        if (thumbFile != null)
          'thumbnail': await dio.MultipartFile.fromFile(
              thumbFile!.path.toString(),
              filename: thumbFile!.name.toString(),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        if (webThumbFile != null)
          "web_thumbnail": await dio.MultipartFile.fromFile(
              webThumbFile!.path.toString(),
              filename: webThumbFile!.name.toString(),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        // "provider_id": userModel!.id,
        "price": amount.text,
        "discount": selectIndex == 0
            ? discount.text = '0'
            : discount.text.isNotEmpty
                ? discount.text
                : "0",
        // "tax_id": taxIndex,
        "duration": duration.text,
        "duration_unit": durationValue?.toLowerCase(),
        "content": htmlContent /* description.getText() */,
        "required_servicemen": isFreelancer ? '1' : minRequired.text,
        "is_featured": isFeatured == true ? "1" : "0",
        "per_serviceman_commission": perServicemanCommission.text,

        "faqs": faqList,
        "isMultipleServiceman": minRequired.length > 1 ? "1" : "0",
        "status": isSwitch == true ? "1" : "0",
        "is_advance_payment_enabled": isAdvancePayment == true ? "1" : "0",
        "advance_payment_percentage":
            isAdvancePayment == true ? advancePaymentPercentage.text : "0",
        for (var i = 0; i < categories.length; i++)
          "category_id[$i]": categories[i].id,
        for (var i = 0; i < taxList.length; i++) "tax_ids[$i]": taxList[i].id,
      };
      dio.FormData formData = dio.FormData.fromMap(
          /* serviceOption == "remotely" ?  */ bodyremotely /* : body */);
      final lang = Provider.of<LanguageProvider>(context, listen: false);

      log("lang:::${lang.currentLanguage}");
      for (var file in appArray.serviceImageList) {
        log("FILE :$file");
        formData.files.addAll([
          MapEntry(
              "image[]",
              await dio.MultipartFile.fromFile(
                file.path.toString(),
                filename: file.name.toString(),
              ))
        ]);
      }

      for (var file in appArray.webServiceImageList) {
        log("FILE :$file");
        formData.files.addAll([
          MapEntry(
              "web_images[]",
              await dio.MultipartFile.fromFile(
                file.path,
                filename: file.name.toString(),
              )),
        ]);
      }
      log("BODY :$bodyremotely");

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      var dataaa = headersToken(
        token,
        localLang: lang.selectedLocaleService,
        isLang: true,
      );
      log("dataaa::${dataaa}");

      final value = await dioo.post(api.service,
          data: formData,
          options: Options(
              headers: headersToken(
            token,
            localLang: local /* lang.selectedLocaleService */,
            isLang: false,
          )));

      log("jahndjkhasd ${value.statusCode}");
      notifyListeners();
      log("Response Data: ${value.statusCode}");

      log("Response Type: ${value.data.runtimeType}");

      // Check if value.data contains 'success' instead of assuming it's a bool
      if (value.statusCode == 422) {
        showErrorToast(context, value.statusMessage.toString());
      } else if (value.statusCode == 200 || value.statusCode == 201) {
        // isAddService = false;
        final userApi =
            Provider.of<UserDataApiProvider>(context, listen: false);

        await userApi.getAllServiceList();
        final commonApi =
            Provider.of<CommonApiProvider>(context, listen: false);
        commonApi.getDashBoardApi(context);
        var service = Provider.of<ServiceListProvider>(context, listen: false);
        service.getCategoryService(context, isAllService: true);
        service.getService(context, isList: true);
        // await userApi.homeStatisticApi();
        await userApi.getCategory();
        onBack(false);
        snackBarMessengers(context,
            message: value.data["message"] ?? "Success",
            color: appColor(context).appTheme.primary);
        selectedIndex = null;
        // route.pop(context);
        isAddService = false;
        route.pop(context);
        notifyListeners();
      } else {
        isAddService = false;

        showErrorToast(
            context, value.data["message"] ?? "Something went wrong");
      }
    } catch (e, s) {
      isAddService = false;
      hideLoading(context);
      notifyListeners();

      if (e is DioException) {
        if (e.response?.statusCode == 422) {
          showErrorToast(context, e.response!.data["message"]);
        }
      } else {
        showErrorToast(context, e.toString());
      }

      log("EEEE addService : $e=======> $s");
    }
  }

  editServiceApi(context) async {
    try {
      isUpdating = true;
      notifyListeners();

      dynamic mimeTypeData;
      if (thumbFile != null) {
        mimeTypeData = mime.lookupMimeType(thumbFile!.path,
            headerBytes: [0xFF, 0xD8])!.split('/');
      }

      notifyListeners();

      var body = {
        '_method': "PUT",
        'type': serviceOption,
        "title":
            serviceName.text.isNotEmpty ? serviceName.text : "Untitled Service",
        if (thumbFile != null)
          'thumbnail': await dio.MultipartFile.fromFile(
            thumbFile!.path,
            filename: path.basename(thumbFile!.path),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        if (webThumbFile != null)
          "web_thumbnail": await dio.MultipartFile.fromFile(
            webThumbFile!.path,
            filename: path.basename(webThumbFile!.path),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        "price": amount.text.isNotEmpty ? amount.text : "0",
        "discount": selectIndex == 0
            ? "0"
            : (discount.text.isNotEmpty ? discount.text : "0"),
        /*  "taxes": [taxIndex ?? 0], */
        "duration": duration.text.isNotEmpty ? duration.text : "1",
        "duration_unit": durationValue?.toLowerCase() ?? "hour",
        "content": htmlContent,
        "required_servicemen": isFreelancer
            ? '1'
            : (minRequired.text.isNotEmpty ? minRequired.text : '1'),
        "is_featured": isFeatured == true ? "1" : "0",
        "per_serviceman_commission": perServicemanCommission.text.isNotEmpty
            ? perServicemanCommission.text
            : "0",
        if (serviceOption == "provider_site") "address_id": selectedIndex,
        "faqs": faqList ?? [],
        "isMultipleServiceman": minRequired.text.length > 1 ? "1" : "0",
        "status": isSwitch == true ? "1" : "0",
        "is_advance_payment_enabled": isAdvancePayment == true ? "1" : "0",
        "advance_payment_percentage":
            isAdvancePayment == true ? advancePaymentPercentage.text : "0",
        for (var i = 0; i < categories.length; i++)
          "category_id[$i]": categories[i].id,
      };

      dio.FormData formData = dio.FormData.fromMap(body);

      for (var file in appArray.serviceImageList) {
        formData.files.addAll([
          MapEntry(
            "image[]",
            await MultipartFile.fromFile(file.path,
                filename: path.basename(file.path)),
          ),
        ]);
      }

      for (var file in appArray.webServiceImageList) {
        formData.files.addAll([
          MapEntry(
            "web_images[]",
            await MultipartFile.fromFile(file.path,
                filename: path.basename(file.path)),
          ),
        ]);
      }

      var lang = Provider.of<LanguageProvider>(context, listen: false);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);

      var headerdata = headersToken(
        token,
        localLang: lang.selectedLocaleService,
        isLang: true,
      );

      log("akshdajksdhas ${body}");
      log("akshdajksdhas ${api.service}/${services!.id}");

      await dioo
          .post("${api.service}/${services!.id}",
              data: formData, options: Options(headers: headerdata))
          .then((value) async {
        hideLoading(context);
        isUpdating = false;
        notifyListeners();
        log("ahsdjkasdhaskd -= ${value.statusCode}");

        if (value.statusCode == 200 || value.statusCode == 201) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          final serviceDetails =
              Provider.of<ServiceDetailsProvider>(context, listen: false);

          await userApi.getAllServiceList();
          getServiceFaqId(context, services!.id);
          userApi.getCategory();

          onBack(false);

          snackBarMessengers(context,
              message: "Update Service Successfully",
              color: appColor(context).appTheme.primary);

          route.pop(context);

          imageFile = null;
          appArray.servicemanDocImageList = [];
          description.setText("");
        } else {
          snackBarMessengers(context,
              message: value.statusMessage,
              color: appColor(context).appTheme.red);

          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAllServiceList();
        }
      });
    } catch (e, s) {
      hideLoading(context);
      isUpdating = false;
      notifyListeners();

      snackBarMessengers(context,
          message: e.toString(), color: appColor(context).appTheme.red);
      log("EEEE editServiceman : $e ==== > $s");
    }
  }
}
