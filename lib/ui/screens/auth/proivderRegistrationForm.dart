import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../app/generalImports.dart';
import 'widgets/form_widgets.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, required this.isEditing});

  final bool isEditing;

  @override
  RegistrationFormState createState() => RegistrationFormState();

  static Route<RegistrationForm> route(RouteSettings routeSettings) {
    final Map<String, dynamic> parameters =
        routeSettings.arguments as Map<String, dynamic>;

    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<EditProviderDetailsCubit>(
            create: (BuildContext context) => EditProviderDetailsCubit(),
          ),
          BlocProvider<GetCustomFieldsCubit>(
            create: (BuildContext context) =>
                GetCustomFieldsCubit()..fetchCustomFields(),
          ),
        ],
        child: RegistrationForm(isEditing: parameters['isEditing']),
      ),
    );
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  int currentIndex = 1;

  Map<String, dynamic> documentsCustomLocalValues = {};
  Map<String, dynamic> bankDetailsCustomLocalValues = {};
  List<Map<String, dynamic>> documentsCustomFieldSubmissions = [];
  List<Map<String, dynamic>> bankDetailsCustomFieldSubmissions = [];

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<CustomFieldsFormState> documentsFormKey =
      GlobalKey<CustomFieldsFormState>();
  final GlobalKey<CustomFieldsFormState> bankDetailsFormKey =
      GlobalKey<CustomFieldsFormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey7 = GlobalKey<FormState>();
  final GlobalKey<Form2CompanyInfoState> form2CompanyInfoKey =
      GlobalKey<Form2CompanyInfoState>();

  ScrollController scrollController = ScrollController();
  HtmlEditorController htmlController = HtmlEditorController();

  ///form1
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode userNmFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobNoFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  Map<String, dynamic> pickedLocalImages = {
    'nationalIdImage': '',
    'addressIdImage': '',
    'passportIdImage': '',
    'logoImage': '',
    'bannerImage': '',
    'seoOgImage': '',
  };

  ///form2
  TextEditingController cityController = TextEditingController();
  // View-only: country/region are chosen at registration and not editable.
  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController taxRegistrationNumberController =
      TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController aboutCompanyController = TextEditingController();
  TextEditingController visitingChargesController = TextEditingController();
  TextEditingController advanceBookingDaysController = TextEditingController();
  TextEditingController maxServiceableDistanceController =
      TextEditingController();
  TextEditingController numberOfMemberController = TextEditingController();

  // Multi-language support for company name, about, and description
  int selectedLanguageIndex = 0;
  Map<String, TextEditingController> companyNameControllers = {};
  Map<String, TextEditingController> aboutCompanyControllers = {};
  Map<String, TextEditingController> longDescriptionControllers = {};
  Map<String, TextEditingController> seoTitleControllers = {};
  Map<String, TextEditingController> seoDescriptionControllers = {};
  Map<String, TextEditingController> seoKeywordsControllers = {};
  Map<String, TextEditingController> seoSchemaMarkupControllers = {};
  List<AppLanguage> languages = [];
  AppLanguage? defaultLanguage;
  StreamSubscription? _languageListSubscription;

  Map<String, TextEditingController> userNameControllers = {};
  Map<String, String> savedUserNameData = {};
  Map<String, String> savedCompanyNameData = {};
  Map<String, String> savedAboutCompanyData = {};
  Map<String, String> savedLongDescriptionData = {};
  Map<String, String> savedSeoTitleData = {};
  Map<String, String> savedSeoDescriptionData = {};
  Map<String, String> savedSeoKeywordsData = {};
  Map<String, String> savedSeoSchemaMarkupData = {};

  FocusNode aboutCompanyFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode latitudeFocus = FocusNode();
  FocusNode longitudeFocus = FocusNode();
  FocusNode companyNmFocus = FocusNode();
  FocusNode visitingChargeFocus = FocusNode();
  FocusNode advanceBookingDaysFocus = FocusNode();
  FocusNode maxServiceableDistanceFocus = FocusNode();
  FocusNode numberOfMemberFocus = FocusNode();
  Map? selectCompanyType;
  Map companyType = {'0': 'Individual', '1': 'Organisation'};

  ///form3
  List<bool> isChecked = List<bool>.generate(
    7,
    (int index) => false,
  ); //7 = daysOfWeek.length
  List<TimeOfDay> selectedStartTime = [];
  List<TimeOfDay> selectedEndTime = [];

  late List<String> daysOfWeek = [
    'monLbl'.translate(context: context),
    'tueLbl'.translate(context: context),
    'wedLbl'.translate(context: context),
    'thuLbl'.translate(context: context),
    'friLbl'.translate(context: context),
    'satLbl'.translate(context: context),
    'sunLbl'.translate(context: context),
  ];

  late List<String> daysInWeek = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  late List<String> _participant;

  // When editing, SEO (step 4) and Working Days (step 5) are hidden.
  // Maps visual step index → actual form index.
  int _actualFormIndex(int stepIndex) {
    if (stepIndex <= 3) return stepIndex;
    if (stepIndex == 4) return 6; // bankAccount
    if (stepIndex == 5) return 7; // location
    return stepIndex;
  }

  ///form4 - SEO
  TextEditingController seoTitleController = TextEditingController();
  TextEditingController seoDescriptionController = TextEditingController();
  TextEditingController seoKeywordsController = TextEditingController();
  TextEditingController seoSchemaMarkupController = TextEditingController();

  FocusNode seoTitleFocus = FocusNode();
  FocusNode seoDescriptionFocus = FocusNode();
  FocusNode seoKeywordsFocus = FocusNode();
  FocusNode seoSchemaMarkupFocus = FocusNode();

  ///form5 - previously form4
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController taxNameController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();

  FocusNode bankNameFocus = FocusNode();
  FocusNode bankCodeFocus = FocusNode();
  FocusNode bankAccountNumberFocus = FocusNode();
  FocusNode accountNameFocus = FocusNode();
  FocusNode accountNumberFocus = FocusNode();
  FocusNode taxNameFocus = FocusNode();
  FocusNode taxNumberFocus = FocusNode();
  FocusNode swiftCodeFocus = FocusNode();

  PickImage pickLogoImage = PickImage();
  PickImage pickBannerImage = PickImage();
  PickImage pickAddressProofImage = PickImage();
  PickImage pickPassportImage = PickImage();
  PickImage pickNationalIdImage = PickImage();
  PickImage pickSeoOgImage = PickImage();

  PickImage pickOtherImage = PickImage();

  ProviderDetails? providerData;
  bool? isIndividualType;

  String? isPreBookingChatAllowed;
  String? isPostBookingChatAllowed;
  String? atDoorstepAllowed;
  String? atStore;
  String? longDescription;

  ValueNotifier<List<String>> selectedOtherImages = ValueNotifier([]);
  ValueNotifier<List<String>> previouslyAddedOtherImages = ValueNotifier([]);

  Set<String> deletedPreviouslyAddedImages = {};

  @override
  void initState() {
    super.initState();

    _participant = widget.isEditing
        ? ["personal", "company", "description", "bankAccount", "location"]
        : [
            "personal",
            "company",
            "description",
            // "seo",
            // "workingDaysLbl",
            "bankAccount",
            "location",
          ];

    initializeData();
    _initializeLanguages();
    // The main activity, which loads these, has not started yet after login.
    context.read<FetchCountrySettingsCubit>().fetch();
  }

  void _initializeLanguages() {
    final cubit = context.read<LanguageListCubit>();
    final currentLang = HiveRepository.getCurrentLanguage();

    if (currentLang == null) return;

    // Trigger fetching language list from cubit
    cubit.getLanguageList();

    _languageListSubscription?.cancel();

    _languageListSubscription = cubit.stream.listen((state) {
      if (!mounted) return;

      if (state is GetLanguageListSuccess) {
        languages = state.languages;
        defaultLanguage = state.defaultLanguage;

        if (defaultLanguage != null && languages.isNotEmpty) {
          final defaultIndex = languages.indexWhere(
            (lang) => lang.languageCode == defaultLanguage!.languageCode,
          );
          if (defaultIndex > 0) {
            final defaultLang = languages.removeAt(defaultIndex);
            languages.insert(0, defaultLang);
          }
        }

        _initializeControllers();
        if (mounted) {
          setState(() {});
        }

        _languageListSubscription?.cancel();
        _languageListSubscription = null;
      }
    });
  }

  void _initializeControllers() {
    companyNameControllers = {};
    aboutCompanyControllers = {};
    longDescriptionControllers = {};
    userNameControllers = {};
    seoTitleControllers = {};
    seoDescriptionControllers = {};
    seoKeywordsControllers = {};
    seoSchemaMarkupControllers = {};

    savedUserNameData = {};
    savedCompanyNameData = {};
    savedAboutCompanyData = {};
    savedLongDescriptionData = {};
    savedSeoTitleData = {};
    savedSeoDescriptionData = {};
    savedSeoKeywordsData = {};
    savedSeoSchemaMarkupData = {};

    final String? defaultLangCode = defaultLanguage?.languageCode;

    for (var lang in languages) {
      final String code = lang.languageCode;
      final bool isDefaultLanguage =
          defaultLangCode != null && code == defaultLangCode;

      final String companyNameText =
          providerData?.providerInformation?.getTranslatedCompanyName(code) ??
          '';
      companyNameControllers[code] = TextEditingController(
        text: companyNameText,
      );
      savedCompanyNameData[code] = companyNameText;

      final String aboutText =
          providerData?.providerInformation?.getTranslatedAbout(code) ?? '';
      aboutCompanyControllers[code] = TextEditingController(text: aboutText);
      savedAboutCompanyData[code] = aboutText;

      final String longDescText =
          providerData?.providerInformation?.getTranslatedLongDescription(
            code,
          ) ??
          '';
      longDescriptionControllers[code] = TextEditingController(
        text: longDescText,
      );
      savedLongDescriptionData[code] = longDescText;

      final String usernameText =
          providerData?.providerInformation?.getTranslatedUsername(code) ?? '';
      userNameControllers[code] = TextEditingController(text: usernameText);
      savedUserNameData[code] = usernameText;

      final String seoTitleText =
          _getTranslatedFieldValue('seo_title', code) ??
          (isDefaultLanguage ? seoTitleController.text : '');
      final String seoDescriptionText =
          _getTranslatedFieldValue('seo_description', code) ??
          (isDefaultLanguage ? seoDescriptionController.text : '');
      final String seoKeywordsText = _normalizeCommaSeparated(
        _getTranslatedFieldValue('seo_keywords', code) ??
            (isDefaultLanguage ? seoKeywordsController.text : ''),
      );
      final String seoSchemaMarkupText =
          _getTranslatedFieldValue('seo_schema_markup', code) ??
          (isDefaultLanguage ? seoSchemaMarkupController.text : '');

      if (isDefaultLanguage) {
        seoTitleController.text = seoTitleText;
        seoDescriptionController.text = seoDescriptionText;
        seoKeywordsController.text = seoKeywordsText;
        seoSchemaMarkupController.text = seoSchemaMarkupText;

        seoTitleControllers[code] = seoTitleController;
        seoDescriptionControllers[code] = seoDescriptionController;
        seoKeywordsControllers[code] = seoKeywordsController;
        seoSchemaMarkupControllers[code] = seoSchemaMarkupController;
      } else {
        seoTitleControllers[code] = TextEditingController(text: seoTitleText);
        seoDescriptionControllers[code] = TextEditingController(
          text: seoDescriptionText,
        );
        seoKeywordsControllers[code] = TextEditingController(
          text: seoKeywordsText,
        );
        seoSchemaMarkupControllers[code] = TextEditingController(
          text: seoSchemaMarkupText,
        );
      }

      savedSeoTitleData[code] = seoTitleText;
      savedSeoDescriptionData[code] = seoDescriptionText;
      savedSeoKeywordsData[code] = seoKeywordsText;
      savedSeoSchemaMarkupData[code] = seoSchemaMarkupText;
    }
  }

  String? _getTranslatedFieldValue(String key, String languageCode) {
    final dynamic data =
        providerData?.providerInformation?.translatedFields?[key];
    if (data == null) {
      return null;
    }

    if (data is Map) {
      final value = data[languageCode];
      if (value == null) return null;
      if (value is List) {
        return value
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .join(', ');
      }
      return value.toString();
    }

    if (data is List) {
      return data
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .join(', ');
    }

    return data.toString();
  }

  String _normalizeCommaSeparated(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    return value
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .join(', ');
  }

  void _updateControllersAfterApiResponse(ProviderDetails newProviderData) {
    providerData = newProviderData;

    final hasUserData =
        savedUserNameData.isNotEmpty ||
        savedCompanyNameData.isNotEmpty ||
        savedAboutCompanyData.isNotEmpty ||
        savedLongDescriptionData.isNotEmpty ||
        savedSeoTitleData.isNotEmpty ||
        savedSeoDescriptionData.isNotEmpty ||
        savedSeoKeywordsData.isNotEmpty ||
        savedSeoSchemaMarkupData.isNotEmpty;

    if (hasUserData) {
      final currentLangCode =
          HiveRepository.getCurrentLanguage()?.languageCode ?? 'en';
      final defaultLangCode = defaultLanguage?.languageCode ?? 'en';

      userNameController.text =
          savedUserNameData[currentLangCode] ??
          savedUserNameData[defaultLangCode] ??
          '';
      companyNameController.text =
          savedCompanyNameData[currentLangCode] ??
          savedCompanyNameData[defaultLangCode] ??
          '';
      aboutCompanyController.text =
          savedAboutCompanyData[currentLangCode] ??
          savedAboutCompanyData[defaultLangCode] ??
          '';
      longDescription =
          savedLongDescriptionData[currentLangCode] ??
          savedLongDescriptionData[defaultLangCode];

      seoTitleController.text =
          savedSeoTitleData[currentLangCode] ??
          savedSeoTitleData[defaultLangCode] ??
          seoTitleController.text;
      seoDescriptionController.text =
          savedSeoDescriptionData[currentLangCode] ??
          savedSeoDescriptionData[defaultLangCode] ??
          seoDescriptionController.text;
      seoKeywordsController.text = _normalizeCommaSeparated(
        savedSeoKeywordsData[currentLangCode] ??
            savedSeoKeywordsData[defaultLangCode] ??
            seoKeywordsController.text,
      );
      seoSchemaMarkupController.text =
          savedSeoSchemaMarkupData[currentLangCode] ??
          savedSeoSchemaMarkupData[defaultLangCode] ??
          seoSchemaMarkupController.text;

      if (languages.isNotEmpty) {
        final fallbackCode =
            defaultLanguage?.languageCode ?? languages.first.languageCode;
        seoTitleControllers[fallbackCode]?.text = seoTitleController.text;
        seoDescriptionControllers[fallbackCode]?.text =
            seoDescriptionController.text;
        seoKeywordsControllers[fallbackCode]?.text = seoKeywordsController.text;
        seoSchemaMarkupControllers[fallbackCode]?.text =
            seoSchemaMarkupController.text;
      }

      return;
    }

    final currentLangCode =
        HiveRepository.getCurrentLanguage()?.languageCode ?? 'en';
    final defaultLangCode = defaultLanguage?.languageCode ?? 'en';

    userNameController.text =
        providerData?.providerInformation?.getTranslatedUsername(
          currentLangCode,
        ) ??
        providerData?.providerInformation?.getTranslatedUsername(
          defaultLangCode,
        ) ??
        '';
    companyNameController.text =
        providerData?.providerInformation?.getTranslatedCompanyName(
          currentLangCode,
        ) ??
        providerData?.providerInformation?.getTranslatedCompanyName(
          defaultLangCode,
        ) ??
        '';
    aboutCompanyController.text =
        providerData?.providerInformation?.getTranslatedAbout(
          currentLangCode,
        ) ??
        providerData?.providerInformation?.getTranslatedAbout(
          defaultLangCode,
        ) ??
        '';
    longDescription =
        providerData?.providerInformation?.getTranslatedLongDescription(
          currentLangCode,
        ) ??
        providerData?.providerInformation?.getTranslatedLongDescription(
          defaultLangCode,
        );

    seoTitleController.text =
        providerData?.providerInformation?.seoTitle ?? seoTitleController.text;
    seoDescriptionController.text =
        providerData?.providerInformation?.seoDescription ??
        seoDescriptionController.text;
    seoKeywordsController.text = _normalizeCommaSeparated(
      providerData?.providerInformation?.seoKeywords ??
          seoKeywordsController.text,
    );
    seoSchemaMarkupController.text =
        providerData?.providerInformation?.seoSchemaMarkup ??
        seoSchemaMarkupController.text;

    savedSeoTitleData[defaultLangCode] = seoTitleController.text;
    savedSeoDescriptionData[defaultLangCode] = seoDescriptionController.text;
    savedSeoKeywordsData[defaultLangCode] = seoKeywordsController.text;
    savedSeoSchemaMarkupData[defaultLangCode] = seoSchemaMarkupController.text;

    for (var lang in languages) {
      final String code = lang.languageCode;

      if (userNameControllers.containsKey(code)) {
        final String usernameText = code == defaultLanguage?.languageCode
            ? userNameController.text
            : (providerData?.providerInformation?.getTranslatedUsername(code) ??
                  '');
        userNameControllers[code]!.text = usernameText;
        savedUserNameData[code] = usernameText;
      }

      if (companyNameControllers.containsKey(code)) {
        final String companyNameText = code == defaultLanguage?.languageCode
            ? companyNameController.text
            : (providerData?.providerInformation?.getTranslatedCompanyName(
                    code,
                  ) ??
                  '');
        companyNameControllers[code]!.text = companyNameText;
        savedCompanyNameData[code] = companyNameText;
      }

      if (aboutCompanyControllers.containsKey(code)) {
        final String aboutText = code == defaultLanguage?.languageCode
            ? aboutCompanyController.text
            : (providerData?.providerInformation?.getTranslatedAbout(code) ??
                  '');
        aboutCompanyControllers[code]!.text = aboutText;
        savedAboutCompanyData[code] = aboutText;
      }

      if (longDescriptionControllers.containsKey(code)) {
        final String longDescText = code == defaultLanguage?.languageCode
            ? (longDescription ?? '')
            : (providerData?.providerInformation?.getTranslatedLongDescription(
                    code,
                  ) ??
                  '');
        longDescriptionControllers[code]!.text = longDescText;
        savedLongDescriptionData[code] = longDescText;
      }

      if (seoTitleControllers.containsKey(code)) {
        final String seoTitleText = code == defaultLanguage?.languageCode
            ? seoTitleController.text
            : (_getTranslatedFieldValue('seo_title', code) ?? '');
        seoTitleControllers[code]!.text = seoTitleText;
        savedSeoTitleData[code] = seoTitleText;
      }

      if (seoDescriptionControllers.containsKey(code)) {
        final String seoDescriptionText = code == defaultLanguage?.languageCode
            ? seoDescriptionController.text
            : (_getTranslatedFieldValue('seo_description', code) ?? '');
        seoDescriptionControllers[code]!.text = seoDescriptionText;
        savedSeoDescriptionData[code] = seoDescriptionText;
      }

      if (seoKeywordsControllers.containsKey(code)) {
        final String seoKeywordsText = code == defaultLanguage?.languageCode
            ? seoKeywordsController.text
            : _normalizeCommaSeparated(
                _getTranslatedFieldValue('seo_keywords', code),
              );
        seoKeywordsControllers[code]!.text = seoKeywordsText;
        savedSeoKeywordsData[code] = seoKeywordsText;
      }

      if (seoSchemaMarkupControllers.containsKey(code)) {
        final String seoSchemaMarkupText = code == defaultLanguage?.languageCode
            ? seoSchemaMarkupController.text
            : (_getTranslatedFieldValue('seo_schema_markup', code) ?? '');
        seoSchemaMarkupControllers[code]!.text = seoSchemaMarkupText;
        savedSeoSchemaMarkupData[code] = seoSchemaMarkupText;
      }
    }
  }

  Future<void> _saveCurrentHtmlContent() async {
    if (selectedLanguageIndex >= 0 &&
        selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = longDescriptionControllers[currentLangCode];
      if (controller != null) {
        await _getHtmlContentWithRetry(controller);
      }
    }
  }

  Future<void> _getHtmlContentWithRetry(
    TextEditingController controller, {
    int maxRetries = 3,
    int currentRetry = 0,
  }) async {
    try {
      final text = await htmlController.getText();
      if (text.trim().isNotEmpty) {
        controller.text = text;
      }
    } catch (e) {
      if (currentRetry < maxRetries) {
        // Wait longer with each retry
        final delay = Duration(milliseconds: 500 * (currentRetry + 1));

        Future.delayed(delay, () {
          _getHtmlContentWithRetry(
            controller,
            maxRetries: maxRetries,
            currentRetry: currentRetry + 1,
          );
        });
      }
    }
  }

  bool _canSwitchLanguage(int targetIndex) {
    if (targetIndex == 0) {
      return true;
    }

    if (selectedLanguageIndex > 0 && targetIndex > 0) {
      return true;
    }

    if (selectedLanguageIndex == 0 && targetIndex > 0) {
      if (currentIndex == 2) {
        if (!_areCompanyInfoRequiredFieldsFilled()) {
          UiUtils.showMessage(
            context,
            'pleaseCompleteDefaultLanguageFieldsFirst',
            ToastificationType.warning,
          );
          return false;
        }
      }
    }

    return true;
  }

  bool _areCompanyInfoRequiredFieldsFilled() {
    final hasCompanyName = companyNameController.text.trim().isNotEmpty;
    final hasPhone = mobileNumberController.text.trim().isNotEmpty;

    return hasCompanyName && hasPhone;
  }

  Future<void> _onLanguageChanged(int index) async {
    if (index >= 0 && index < languages.length) {
      if (!_canSwitchLanguage(index)) {
        return;
      }

      _saveCurrentUserName();
      _saveCurrentCompanyName();
      _saveCurrentAboutCompany();
      if (currentIndex != 3) {
        _saveCurrentLongDescription();
      }

      if (currentIndex == 3 && selectedLanguageIndex < languages.length) {
        final previousLangCode = languages[selectedLanguageIndex].languageCode;
        final controller = longDescriptionControllers[previousLangCode];
        if (controller != null) {
          try {
            final text = await htmlController.getText();
            if (text.trim().isNotEmpty) {
              controller.text = text;
              savedLongDescriptionData[previousLangCode] = text;
            }
          } catch (_) {}
        }
      }

      if (_actualFormIndex(currentIndex) == 4) {
        _saveCurrentSeoTitle();
        _saveCurrentSeoDescription();
        _saveCurrentSeoKeywords();
        _saveCurrentSeoSchemaMarkup();
      }

      setState(() {
        selectedLanguageIndex = index;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (formKey2.currentState != null) {
          formKey2.currentState!.validate();
        }
      });

      if (index < languages.length) {
        final newLangCode = languages[index].languageCode;
        final controller = longDescriptionControllers[newLangCode];

        _setHtmlContentWithRetry(controller, maxRetries: 3);
      }
    }
  }

  Future<void> _setHtmlContentWithRetry(
    TextEditingController? controller, {
    int maxRetries = 3,
    int currentRetry = 0,
  }) async {
    if (controller == null) {
      return;
    }

    try {
      if (controller.text.isNotEmpty) {
        htmlController.setText(controller.text);
      } else {
        try {
          final currentText = await htmlController.getText();
          if (currentText.trim().isNotEmpty) {
            htmlController.clear();
          }
          // ignore: empty_catches
        } catch (_) {}
      }
    } catch (e) {
      if (currentRetry < maxRetries) {
        final delay = Duration(milliseconds: 1000 * (currentRetry + 1));

        Future.delayed(delay, () {
          _setHtmlContentWithRetry(
            controller,
            maxRetries: maxRetries,
            currentRetry: currentRetry + 1,
          );
        });
      }
    }
  }

  String? _getCompanyNameValidator(String? value) {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return null;
    }

    final currentLanguage = languages[selectedLanguageIndex];
    final isDefaultLanguage =
        currentLanguage.languageCode == defaultLanguage?.languageCode;

    if (isDefaultLanguage) {
      return Validator.nullCheck(context, value);
    }

    return null;
  }

  String? _getAboutCompanyValidator(String? value) {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return null;
    }

    final currentLanguage = languages[selectedLanguageIndex];
    final isDefaultLanguage =
        currentLanguage.languageCode == defaultLanguage?.languageCode;

    if (isDefaultLanguage) {
      return Validator.nullCheck(context, value);
    }

    return null;
  }

  String? _getLongDescriptionValidator(String? value) {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return null;
    }

    final currentLanguage = languages[selectedLanguageIndex];
    final isDefaultLanguage =
        currentLanguage.languageCode == defaultLanguage?.languageCode;

    if (isDefaultLanguage) {
      return Validator.nullCheck(context, value);
    }

    return null;
  }

  String? _getUserNameValidator(String? value) {
    if (languages.isEmpty ||
        selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return null;
    }

    final currentLanguage = languages[selectedLanguageIndex];
    final isDefaultLanguage =
        currentLanguage.languageCode == defaultLanguage?.languageCode;

    if (isDefaultLanguage) {
      return Validator.nullCheck(context, value);
    }

    return null;
  }

  void _saveCurrentUserName() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = userNameControllers[currentLangCode];
      if (controller != null) {
        savedUserNameData[currentLangCode] = controller.text;
      }
    }
  }

  void _saveCurrentCompanyName() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = companyNameControllers[currentLangCode];
      if (controller != null) {
        savedCompanyNameData[currentLangCode] = controller.text;
      }
    }
  }

  void _saveCurrentAboutCompany() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = aboutCompanyControllers[currentLangCode];
      if (controller != null) {
        savedAboutCompanyData[currentLangCode] = controller.text;
      }
    }
  }

  void _saveCurrentLongDescription() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = longDescriptionControllers[currentLangCode];
      if (controller != null) {
        savedLongDescriptionData[currentLangCode] = controller.text;
      }
    }
  }

  void _saveCurrentSeoTitle() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = seoTitleControllers[currentLangCode];
      if (controller != null) {
        savedSeoTitleData[currentLangCode] = controller.text;
      }
    }
  }

  void _saveCurrentSeoDescription() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = seoDescriptionControllers[currentLangCode];
      if (controller != null) {
        savedSeoDescriptionData[currentLangCode] = controller.text;
      }
    }
  }

  void _saveCurrentSeoKeywords() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = seoKeywordsControllers[currentLangCode];
      if (controller != null) {
        savedSeoKeywordsData[currentLangCode] = _normalizeCommaSeparated(
          controller.text,
        );
      }
    }
  }

  void _saveCurrentSeoSchemaMarkup() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final controller = seoSchemaMarkupControllers[currentLangCode];
      if (controller != null) {
        savedSeoSchemaMarkupData[currentLangCode] = controller.text;
      }
    }
  }

  Map<String, String> getUserNameData() {
    _saveCurrentUserName();

    final Map<String, String> userNameData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedUserNameData[code] ?? '';
        userNameData[code] = value.trim();
      }
    }

    return userNameData;
  }

  Map<String, String> getCompanyNameData() {
    _saveCurrentCompanyName();

    final Map<String, String> companyNameData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedCompanyNameData[code] ?? '';
        companyNameData[code] = value.trim();
      }
    }

    return companyNameData;
  }

  Map<String, String> getAboutCompanyData() {
    _saveCurrentAboutCompany();

    final Map<String, String> aboutCompanyData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedAboutCompanyData[code] ?? '';
        aboutCompanyData[code] = value.trim();
      }
    }

    return aboutCompanyData;
  }

  Map<String, String> getLongDescriptionData() {
    _saveCurrentLongDescription();

    final Map<String, String> longDescriptionData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedLongDescriptionData[code] ?? '';
        longDescriptionData[code] = value.trim();
      }
    }

    return longDescriptionData;
  }

  Map<String, String> getSeoTitleData() {
    _saveCurrentSeoTitle();

    final Map<String, String> seoTitleData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedSeoTitleData[code]?.trim() ?? '';
        if (value.isNotEmpty) {
          seoTitleData[code] = value;
        }
      }
    }

    return seoTitleData;
  }

  Map<String, String> getSeoDescriptionData() {
    _saveCurrentSeoDescription();

    final Map<String, String> seoDescriptionData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedSeoDescriptionData[code]?.trim() ?? '';
        if (value.isNotEmpty) {
          seoDescriptionData[code] = value;
        }
      }
    }

    return seoDescriptionData;
  }

  Map<String, String> getSeoKeywordsData() {
    _saveCurrentSeoKeywords();

    final Map<String, String> seoKeywordsData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = _normalizeCommaSeparated(
          savedSeoKeywordsData[code]?.trim() ?? '',
        );
        if (value.isNotEmpty) {
          seoKeywordsData[code] = value;
        }
      }
    }

    return seoKeywordsData;
  }

  Map<String, String> getSeoSchemaMarkupData() {
    _saveCurrentSeoSchemaMarkup();

    final Map<String, String> seoSchemaMarkupData = {};

    if (languages.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final value = savedSeoSchemaMarkupData[code]?.trim() ?? '';
        if (value.isNotEmpty) {
          seoSchemaMarkupData[code] = value;
        }
      }
    }

    return seoSchemaMarkupData;
  }

  void _resetToDefaultLanguageIfNeeded(int newCurrentIndex) {
    if ((newCurrentIndex == 2 ||
            newCurrentIndex == 3 ||
            newCurrentIndex == 4) &&
        languages.isNotEmpty &&
        defaultLanguage != null) {
      final defaultIndex = languages.indexWhere(
        (lang) => lang.languageCode == defaultLanguage!.languageCode,
      );
      if (defaultIndex >= 0) {
        selectedLanguageIndex = defaultIndex;
      }
    }
  }

  void initializeData() {
    Future.delayed(Duration.zero).then((value) {
      providerData = context.read<ProviderDetailsCubit>().providerDetails;

      final currentLangCode =
          HiveRepository.getCurrentLanguage()?.languageCode ?? 'en';
      final defaultLangCode = defaultLanguage?.languageCode ?? 'en';

      userNameController.text =
          providerData?.providerInformation?.getTranslatedUsername(
            currentLangCode,
          ) ??
          providerData?.providerInformation?.getTranslatedUsername(
            defaultLangCode,
          ) ??
          '';
      emailController.text = providerData?.user?.email ?? '';
      mobileNumberController.text = providerData?.user?.phone ?? '';

      // Initialize country code cubit with user's country code
      _setCountryCodeFromProviderData();
      companyNameController.text =
          providerData?.providerInformation?.getTranslatedCompanyName(
            currentLangCode,
          ) ??
          providerData?.providerInformation?.getTranslatedCompanyName(
            defaultLangCode,
          ) ??
          '';
      aboutCompanyController.text =
          providerData?.providerInformation?.getTranslatedAbout(
            currentLangCode,
          ) ??
          providerData?.providerInformation?.getTranslatedAbout(
            defaultLangCode,
          ) ??
          '';

      isPostBookingChatAllowed =
          providerData?.providerInformation?.isPostBookingChatAllowed ?? "0";
      isPreBookingChatAllowed =
          providerData?.providerInformation?.isPreBookingChatAllowed ?? "0";

      atDoorstepAllowed = providerData?.providerInformation?.atDoorstep ?? "0";

      atStore = providerData?.providerInformation?.atStore ?? "0";

      // SEO fields initialization
      seoTitleController.text =
          providerData?.providerInformation?.seoTitle ?? '';
      seoDescriptionController.text =
          providerData?.providerInformation?.seoDescription ?? '';
      seoKeywordsController.text =
          providerData?.providerInformation?.seoKeywords ?? '';
      seoSchemaMarkupController.text =
          providerData?.providerInformation?.seoSchemaMarkup ?? '';

      countryController.text = providerData?.providerInformation?.country ?? '';
      regionController.text = providerData?.providerInformation?.region ?? '';
      taxRegistrationNumberController.text =
          providerData?.providerInformation?.taxRegistrationNumber ?? '';
      cityController.text = providerData?.locationInformation?.city ?? '';
      addressController.text = providerData?.locationInformation?.address ?? '';
      latitudeController.text =
          providerData?.locationInformation?.latitude ?? '';
      longitudeController.text =
          providerData?.locationInformation?.longitude ?? '';
      companyNameController.text =
          providerData?.providerInformation?.getTranslatedCompanyName(
            currentLangCode,
          ) ??
          providerData?.providerInformation?.getTranslatedCompanyName(
            defaultLangCode,
          ) ??
          '';
      aboutCompanyController.text =
          providerData?.providerInformation?.getTranslatedAbout(
            currentLangCode,
          ) ??
          providerData?.providerInformation?.getTranslatedAbout(
            defaultLangCode,
          ) ??
          '';
      visitingChargesController.text =
          providerData?.providerInformation?.visitingCharges ?? '';
      advanceBookingDaysController.text =
          providerData?.providerInformation?.advanceBookingDays ?? '';
      maxServiceableDistanceController.text =
          providerData?.providerInformation?.maxServiceableDistance ?? '';
      numberOfMemberController.text =
          providerData?.providerInformation?.numberOfMembers ?? '';
      selectCompanyType = providerData?.providerInformation?.type == '0'
          ? {'title': 'Individual', 'value': '0'}
          : {'title': 'Organization', 'value': '1'};
      isIndividualType = providerData?.providerInformation?.type == '0';
      //add elements in TimeOfDay List

      List<WorkingDay>? data = providerData?.workingDays?.reversed.toList();
      if (data?.isEmpty ?? false) {
        data = null;
      }
      for (int i = 0; i < daysInWeek.length; i++) {
        //assign Default time @ start
        final List<String> startTime = (data?[i].startTime ?? '09:00:00').split(
          ':',
        );
        final List<String> endTime = (data?[i].endTime ?? '18:00:00').split(
          ':',
        );

        final int startTimeHour = int.parse(startTime[0]);
        final int startTimeMinute = int.parse(startTime[1]);
        selectedStartTime.insert(
          i,
          TimeOfDay(hour: startTimeHour, minute: startTimeMinute),
        );

        final int endTimeHour = int.parse(endTime[0]);
        final int endTimeMinute = int.parse(endTime[1]);
        selectedEndTime.insert(
          i,
          TimeOfDay(hour: endTimeHour, minute: endTimeMinute),
        );
        isChecked[i] = data?[i].isOpen == 1;
      }

      longDescription =
          providerData?.providerInformation?.getTranslatedLongDescription(
            currentLangCode,
          ) ??
          providerData?.providerInformation?.getTranslatedLongDescription(
            defaultLangCode,
          );
      previouslyAddedOtherImages.value = [
        ...?providerData?.providerInformation?.otherImages,
      ];

      if (languages.isNotEmpty) {
        _populateTranslatedControllers();
      }

      setState(() {});
    });
  }

  void _populateTranslatedControllers() {
    if (languages.isEmpty) {
      return;
    }

    for (var lang in languages) {
      final String code = lang.languageCode;

      final translatedCompanyName = providerData?.providerInformation
          ?.getTranslatedCompanyName(code);
      if (translatedCompanyName != null) {
        companyNameControllers[code]?.text = translatedCompanyName;
        savedCompanyNameData[code] = translatedCompanyName;
      }

      final translatedAbout = providerData?.providerInformation
          ?.getTranslatedAbout(code);
      if (translatedAbout != null) {
        aboutCompanyControllers[code]?.text = translatedAbout;
        savedAboutCompanyData[code] = translatedAbout;
      }

      final translatedLongDesc = providerData?.providerInformation
          ?.getTranslatedLongDescription(code);
      if (translatedLongDesc != null) {
        longDescriptionControllers[code]?.text = translatedLongDesc;
        savedLongDescriptionData[code] = translatedLongDesc;
      }

      final translatedUsername = providerData?.providerInformation
          ?.getTranslatedUsername(code);
      if (translatedUsername != null) {
        userNameControllers[code]?.text = translatedUsername;
        savedUserNameData[code] = translatedUsername;
      }

      final translatedSeoTitle = _getTranslatedFieldValue('seo_title', code);
      if (translatedSeoTitle != null) {
        seoTitleControllers[code]?.text = translatedSeoTitle;
        savedSeoTitleData[code] = translatedSeoTitle;
        if (code == defaultLanguage?.languageCode) {
          seoTitleController.text = translatedSeoTitle;
        }
      }

      final translatedSeoDescription = _getTranslatedFieldValue(
        'seo_description',
        code,
      );
      if (translatedSeoDescription != null) {
        seoDescriptionControllers[code]?.text = translatedSeoDescription;
        savedSeoDescriptionData[code] = translatedSeoDescription;
        if (code == defaultLanguage?.languageCode) {
          seoDescriptionController.text = translatedSeoDescription;
        }
      }

      final translatedSeoKeywords = _normalizeCommaSeparated(
        _getTranslatedFieldValue('seo_keywords', code),
      );
      if (translatedSeoKeywords.isNotEmpty) {
        seoKeywordsControllers[code]?.text = translatedSeoKeywords;
        savedSeoKeywordsData[code] = translatedSeoKeywords;
        if (code == defaultLanguage?.languageCode) {
          seoKeywordsController.text = translatedSeoKeywords;
        }
      }

      final translatedSeoSchema = _getTranslatedFieldValue(
        'seo_schema_markup',
        code,
      );
      if (translatedSeoSchema != null) {
        seoSchemaMarkupControllers[code]?.text = translatedSeoSchema;
        savedSeoSchemaMarkupData[code] = translatedSeoSchema;
        if (code == defaultLanguage?.languageCode) {
          seoSchemaMarkupController.text = translatedSeoSchema;
        }
      }
    }
  }

  void _setCountryCodeFromProviderData() {
    final cubitState = context.read<CountryCodeCubit>().state;
    if (cubitState is CountryCodeFetchSuccess) {
      final userCountryCode = providerData?.user?.countryCode;
      if (userCountryCode != null && userCountryCode.isNotEmpty) {
        // Countries share calling codes (+1: United States, Canada), so the
        // provider's country id comes first.
        final String countryId =
            providerData?.providerInformation?.countryId ?? '';
        final country = cubitState.countryList?.firstWhere(
          (c) =>
              countryId.isNotEmpty &&
              c.id == countryId &&
              c.callingCode == userCountryCode,
          orElse: () => cubitState.countryList!.firstWhere(
            (c) => c.callingCode == userCountryCode,
            orElse: () => cubitState.selectedCountry!,
          ),
        );
        if (country != null) {
          context.read<CountryCodeCubit>().selectCountryCode(country);
        }
      }
    }
  }

  @override
  void dispose() {
    _languageListSubscription?.cancel();

    _saveCurrentHtmlContent();

    userNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyNameController.dispose();
    visitingChargesController.dispose();
    advanceBookingDaysController.dispose();
    maxServiceableDistanceController.dispose();
    numberOfMemberController.dispose();
    aboutCompanyController.dispose();
    cityController.dispose();
    countryController.dispose();
    regionController.dispose();
    taxRegistrationNumberController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    addressController.dispose();
    bankNameController.dispose();
    bankCodeController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    taxNumberController.dispose();
    taxNameController.dispose();
    swiftCodeController.dispose();

    // SEO controllers disposal
    seoTitleController.dispose();
    seoDescriptionController.dispose();
    seoKeywordsController.dispose();
    seoSchemaMarkupController.dispose();

    companyNameControllers.values.forEach((controller) => controller.dispose());
    aboutCompanyControllers.values.forEach(
      (controller) => controller.dispose(),
    );
    longDescriptionControllers.values.forEach(
      (controller) => controller.dispose(),
    );
    userNameControllers.values.forEach((controller) => controller.dispose());
    seoTitleControllers.values.forEach((controller) {
      if (controller != seoTitleController) {
        controller.dispose();
      }
    });
    seoDescriptionControllers.values.forEach((controller) {
      if (controller != seoDescriptionController) {
        controller.dispose();
      }
    });
    seoKeywordsControllers.values.forEach((controller) {
      if (controller != seoKeywordsController) {
        controller.dispose();
      }
    });
    seoSchemaMarkupControllers.values.forEach((controller) {
      if (controller != seoSchemaMarkupController) {
        controller.dispose();
      }
    });

    pickedLocalImages.clear();
    previouslyAddedOtherImages.dispose();
    selectedOtherImages.dispose();

    confirmPasswordFocus.dispose();
    passwordFocus.dispose();
    mobNoFocus.dispose();
    emailFocus.dispose();
    userNmFocus.dispose();
    numberOfMemberFocus.dispose();
    advanceBookingDaysFocus.dispose();
    maxServiceableDistanceFocus.dispose();
    visitingChargeFocus.dispose();
    companyNmFocus.dispose();
    longitudeFocus.dispose();
    latitudeFocus.dispose();
    addressFocus.dispose();
    cityFocus.dispose();
    aboutCompanyFocus.dispose();
    swiftCodeFocus.dispose();
    taxNumberFocus.dispose();
    taxNameFocus.dispose();
    accountNumberFocus.dispose();
    accountNameFocus.dispose();
    bankAccountNumberFocus.dispose();
    bankCodeFocus.dispose();
    bankNameFocus.dispose();

    // SEO focus nodes disposal
    seoTitleFocus.dispose();
    seoDescriptionFocus.dispose();
    seoKeywordsFocus.dispose();
    seoSchemaMarkupFocus.dispose();

    pickNationalIdImage.dispose();
    pickPassportImage.dispose();
    pickAddressProofImage.dispose();
    pickBannerImage.dispose();
    pickLogoImage.dispose();
    pickSeoOgImage.dispose();

    scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveCurrentFormData() async {
    try {
      final actualIndex = _actualFormIndex(currentIndex);
      if (actualIndex == 1) {
        _saveCurrentUserName();
        if (documentsFormKey.currentState != null) {
          documentsCustomLocalValues.addAll(
            documentsFormKey.currentState!.getKeyValueMap(),
          );
          documentsCustomFieldSubmissions = documentsFormKey.currentState!
              .getValues();
        }
      } else if (actualIndex == 2) {
        _saveCurrentCompanyName();
        _saveCurrentAboutCompany();
      } else if (actualIndex == 3) {
        _saveCurrentLongDescription();
        // } else if (actualIndex == 4) {
        //   _saveCurrentSeoTitle();
        //   _saveCurrentSeoDescription();
        //   _saveCurrentSeoKeywords();
        //   _saveCurrentSeoSchemaMarkup();
      } else if (actualIndex == 6) {
        if (bankDetailsFormKey.currentState != null) {
          bankDetailsCustomLocalValues.addAll(
            bankDetailsFormKey.currentState!.getKeyValueMap(),
          );
          bankDetailsCustomFieldSubmissions = bankDetailsFormKey.currentState!
              .getValues();
        }
      }

      if (actualIndex == 3) {
        final tempText = await htmlController.getText();
        if (tempText.trim().isNotEmpty) {
          if (selectedLanguageIndex < languages.length) {
            final langCode = languages[selectedLanguageIndex].languageCode;
            longDescriptionControllers[langCode]?.text = tempText;
            savedLongDescriptionData[langCode] = tempText;
          }
        }
      }

      switch (actualIndex) {
        case 2:
          formKey2.currentState?.save();
          break;
        case 3:
          break;
        // case 4:
        //   formKey4.currentState?.save();
        //   break;
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if ((currentIndex == 1 || currentIndex == 2 || currentIndex == 3) &&
        languages.isEmpty) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: CustomText(
              widget.isEditing
                  ? 'completeRegistration'.translate(context: context)
                  : 'completeKYCDetails'.translate(context: context),
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            leading: widget.isEditing
                ? InkWell(
                    onTap: () async {
                      await _saveCurrentFormData();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: context.colorScheme.blackColor,
                    ),
                  )
                : null,
            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
            surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: ShimmerLoadingContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const CustomShimmerContainer(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  if (currentIndex == 1) ...const [
                    CustomShimmerContainer(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                    CustomShimmerContainer(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                    CustomShimmerContainer(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomShimmerContainer(
                            height: 40,
                            margin: EdgeInsets.only(right: 5),
                          ),
                        ),
                        Expanded(
                          child: CustomShimmerContainer(
                            height: 40,
                            margin: EdgeInsets.only(left: 5),
                          ),
                        ),
                      ],
                    ),
                  ] else if (currentIndex == 2) ...const [
                    CustomShimmerContainer(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                    CustomShimmerContainer(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                    CustomShimmerContainer(
                      height: 100,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomShimmerContainer(
                            height: 60,
                            margin: EdgeInsets.only(right: 5),
                          ),
                        ),
                        Expanded(
                          child: CustomShimmerContainer(
                            height: 60,
                            margin: EdgeInsets.only(left: 5),
                          ),
                        ),
                      ],
                    ),
                  ] else if (currentIndex == 3) ...const [
                    CustomShimmerContainer(
                      height: 50,
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    CustomShimmerContainer(
                      height: 200,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (languages.isNotEmpty &&
        (selectedLanguageIndex < 0 ||
            selectedLanguageIndex >= languages.length)) {
      selectedLanguageIndex = 0;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: PopScope(
        canPop: currentIndex == 1,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          } else {
            if (currentIndex > 1) {
              await _saveCurrentFormData();
              currentIndex--;
              pickedLocalImages = pickedLocalImages;
              setState(() {});
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: CustomText(
              widget.isEditing
                  ? 'completeRegistration'.translate(context: context)
                  : 'completeKYCDetails'.translate(context: context),
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            leading: widget.isEditing
                ? InkWell(
                    onTap: () async {
                      await _saveCurrentFormData();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: context.colorScheme.blackColor,
                    ),
                  )
                : null,
            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
            surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 70),
              child: SizedBox(
                height: 70,
                child: EasyStepper(
                  internalPadding: 0,
                  borderThickness: 0,
                  stepBorderRadius: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  showStepBorder: false,
                  activeStep: currentIndex - 1,
                  lineStyle: LineStyle(
                    lineSpace: 0,
                    finishedLineColor: context.colorScheme.accentColor,
                    defaultLineColor: context.colorScheme.primaryColor,
                    lineLength: 100,
                    lineType: LineType.normal,
                    lineThickness: 2,
                    lineWidth: 30,
                    progress: 0.5,
                    progressColor: context.colorScheme.accentColor,
                  ),
                  stepRadius: 11,
                  finishedStepBackgroundColor:
                      context.colorScheme.secondaryColor,
                  finishedStepIconColor: context.colorScheme.accentColor,
                  finishedStepBorderColor: context.colorScheme.accentColor,
                  finishedStepBorderType: BorderType.normal,
                  showLoadingAnimation: false,
                  onStepReached: (index) async {
                    if (index + 1 != currentIndex) {
                      FormState? form = formKey1.currentState;
                      switch (_actualFormIndex(currentIndex)) {
                        case 2:
                          form = formKey2.currentState;
                          break;
                        case 4:
                          form = formKey4.currentState;
                          break;
                        case 5:
                          form = formKey5.currentState;
                          break;
                        case 6:
                          form = formKey6.currentState;
                          break;
                        case 7:
                          form = formKey7.currentState;
                          break;
                        default:
                          form = formKey1.currentState;
                          break;
                      }

                      if (form != null) {
                        form.save();
                        if (form.validate()) {
                          await _saveCurrentFormData();
                          if (!mounted) return;
                          setState(() {
                            currentIndex = index + 1;
                            _resetToDefaultLanguageIfNeeded(index + 1);
                          });
                          scrollController.jumpTo(0);
                        }
                      } else {
                        setState(() {
                          currentIndex = index + 1;
                          _resetToDefaultLanguageIfNeeded(index + 1);
                        });
                        scrollController.jumpTo(0);
                      }
                    }
                  },
                  unreachedStepBackgroundColor: context.colorScheme.primaryColor
                      .withValues(alpha: 0.2),
                  steps: List<EasyStep>.generate(
                    _participant.length,
                    (index) => EasyStep(
                      customStep: CustomSvgPicture(
                        svgImage: AppAssets.bClock,
                        color: index <= currentIndex - 1
                            ? context.colorScheme.accentColor
                            : context.colorScheme.lightGreyColor,
                      ),
                      customTitle: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 4,
                          right: index == _participant.length - 1 ? 0 : 4,
                        ),
                        child: CustomText(
                          _participant[index].translate(context: context),
                          textAlign: index == 0
                              ? TextAlign.right
                              : index == _participant.length - 1
                              ? TextAlign.left
                              : TextAlign.center,
                          color: index == currentIndex - 1
                              ? context.colorScheme.accentColor
                              : context.colorScheme.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomNavigation(currentIndex: currentIndex),
          body: widget.isEditing
              ? Column(
                  children: [
                    approvalWarningBanner(context),
                    Expanded(child: screenBuilder(currentIndex)),
                  ],
                )
              : screenBuilder(currentIndex),
        ),
      ),
    );
  }

  Widget approvalWarningBanner(BuildContext context) {
    final providerInfo = context
        .watch<ProviderDetailsCubit>()
        .providerDetails
        .providerInformation;
    final String? isApproved = providerInfo?.isApproved;

    // Approved — hide banner
    if (isApproved == '1') {
      return const SizedBox.shrink();
    }

    // Pending — show orange warning
    if (isApproved == '0') {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.orangeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
          border: Border.all(color: AppColors.orangeColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.orangeColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomText(
                'providerNotApprovedWarning'.translate(context: context),
                color: context.colorScheme.blackColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // Disapproved (isApproved == '2') — show red disapproval reason card
    final String disapprovalReason =
        providerInfo?.disapprovalReason?.trim() ?? '';

    if (disapprovalReason.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        border: Border.all(color: Colors.red.shade300, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red.shade600, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'disapprovalReasonTitle'.translate(context: context),
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                const SizedBox(height: 2),
                CustomText(
                  disapprovalReason,
                  color: context.colorScheme.blackColor,
                  fontSize: 12,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigation({required int currentIndex}) {
    return CustomContainer(
      color: context.colorScheme.secondaryColor,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 10,
        top: 10,
        right: 15,
        left: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentIndex > 1) ...[
            Expanded(
              flex: 1,
              child: nextPrevBtnWidget(
                isNext: false,
                currentIndex: currentIndex,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            flex: 5,
            child:
                BlocListener<
                  EditProviderDetailsCubit,
                  EditProviderDetailsState
                >(
                  listener:
                      (
                        BuildContext context,
                        EditProviderDetailsState state,
                      ) async {
                        if (state is EditProviderDetailsSuccess) {
                          UiUtils.showMessage(
                            context,
                            'detailsUpdatedSuccessfully',
                            ToastificationType.success,
                          );

                          if (widget.isEditing) {
                            context.read<ProviderDetailsCubit>().setUserInfo(
                              state.providerDetails,
                            );

                            _updateControllersAfterApiResponse(
                              state.providerDetails,
                            );

                            Future.delayed(const Duration(seconds: 1)).then((
                              value,
                            ) {
                              Navigator.pop(context);
                            });
                          } else {
                            Future.delayed(Duration.zero, () {
                              HiveRepository.setUserLoggedIn = false;
                              HiveRepository.clearBoxValues(
                                boxName: HiveRepository.userDetailBoxKey,
                              );
                              context
                                  .read<AuthenticationCubit>()
                                  .setUnAuthenticated();
                              AppQuickActions.clearShortcutItems();
                            });

                            Future.delayed(const Duration(seconds: 1)).then((
                              value,
                            ) {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.successScreen,
                                arguments: {
                                  'title': 'detailsSubmitted'.translate(
                                    context: context,
                                  ),
                                  'message':
                                      'detailsHasBeenSubmittedWaitForAdminApproval'
                                          .translate(context: context),
                                  'imageName': AppAssets.registration,
                                },
                              );
                            });
                          }
                        } else if (state is EditProviderDetailsFailure) {
                          UiUtils.showMessage(
                            context,
                            state.errorMessage,
                            ToastificationType.error,
                          );
                        }
                      },
                  child: nextPrevBtnWidget(
                    isNext: true,
                    currentIndex: currentIndex,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<EditProviderDetailsCubit, EditProviderDetailsState>
  nextPrevBtnWidget({required bool isNext, required int currentIndex}) {
    return BlocBuilder<EditProviderDetailsCubit, EditProviderDetailsState>(
      builder: (BuildContext context, EditProviderDetailsState state) {
        Widget? child;
        if (state is EditProviderDetailsInProgress) {
          child = CustomCircularProgressIndicator(color: AppColors.whiteColors);
        } else if (state is EditProviderDetailsSuccess ||
            state is EditProviderDetailsFailure) {
          child = null;
        }
        return CustomRoundedButton(
          textSize: 16,
          widthPercentage: isNext ? 1 : 0.5,
          backgroundColor: isNext
              ? Theme.of(context).colorScheme.accentColor
              : Theme.of(context).colorScheme.accentColor.withAlpha(20),
          showBorder: false,
          titleColor: isNext
              ? AppColors.whiteColors
              : Theme.of(context).colorScheme.blackColor,
          onTap: () => state is EditProviderDetailsInProgress
              ? () {}
              : onNextPrevBtnClick(isNext: isNext, currentPage: currentIndex),
          buttonTitleWidget: isNext && currentIndex >= _participant.length
              ? CustomText(
                  'submitBtnLbl'.translate(context: context),
                  fontSize: 16.0,
                  color: AppColors.whiteColors,
                )
              : isNext
              ? CustomText(
                  'nxtBtnLbl'.translate(context: context),
                  fontSize: 16.0,
                  color: AppColors.whiteColors,
                )
              : CustomSvgPicture(
                  svgImage: AppAssets.backArrowLight,
                  color: context.colorScheme.accentColor,
                ),
          child: isNext && currentIndex >= _participant.length ? child : null,
        );
      },
    );
  }

  Future<void> onNextPrevBtnClick({
    required bool isNext,
    required int currentPage,
  }) async {
    if (currentPage == 3) {
      try {
        final tempText = await htmlController.getText();

        if (tempText.trim().isNotEmpty) {
          longDescription = tempText;
          await _saveCurrentHtmlContent();
        }
      } catch (e) {
        if (selectedLanguageIndex >= 0 &&
            selectedLanguageIndex < languages.length) {
          final currentLangCode = languages[selectedLanguageIndex].languageCode;
          final controller = longDescriptionControllers[currentLangCode];
          if (controller != null && controller.text.trim().isNotEmpty) {
            longDescription = controller.text;
          }
        }
      }
    }
    if (isNext) {
      FormState? form = formKey1.currentState; //default value
      switch (_actualFormIndex(currentPage)) {
        case 2:
          form = formKey2.currentState;
          break;
        case 4:
          form = formKey4.currentState;
          break;
        case 5:
          form = formKey5.currentState;
          break;
        case 6:
          form = formKey6.currentState;
          break;
        case 7:
          form = formKey7.currentState;
          break;
        default:
          form = formKey1.currentState;
          break;
      }

      if (currentPage != 3) {
        if (form == null) return;
        form.save();
      }

      if (currentPage == 3 || form!.validate()) {
        if (currentPage == 2) {
          final bool imagesValid =
              form2CompanyInfoKey.currentState?.validateImagesPresence(
                context,
              ) ??
              false;
          debugPrint("Image validation result: $imagesValid");
          if (!imagesValid) {
            return; // Stop proceeding if images are not valid
          }
        }

        if (currentPage < _participant.length) {
          // Save current form data before proceeding (next button)
          await _saveCurrentFormData();

          // Reset to default language BEFORE updating currentIndex
          _resetToDefaultLanguageIfNeeded(currentPage + 1);

          currentIndex++;

          if (currentPage != 3) {
            scrollController.jumpTo(0);
          }
          pickedLocalImages = pickedLocalImages;
          setState(() {});
        } else {
          // final List<WorkingDay> workingDays = [];
          // for (int i = 0; i < daysInWeek.length; i++) {
          //   workingDays.add(
          //     WorkingDay(
          //       isOpen: isChecked[i] ? 1 : 0,
          //       endTime:
          //           "${selectedEndTime[i].hour.toString().padLeft(2, "0")}:${selectedEndTime[i].minute.toString().padLeft(2, "0")}:00",
          //       startTime:
          //           "${selectedStartTime[i].hour.toString().padLeft(2, "0")}:${selectedStartTime[i].minute.toString().padLeft(2, "0")}:00",
          //       day: daysInWeek[i],
          //     ),
          //   );
          // }

          final Map<String, String> formCompanyNames = getCompanyNameData();
          final Map<String, String> formAboutProvider = getAboutCompanyData();
          final Map<String, String> formLongDescriptions =
              getLongDescriptionData();
          final Map<String, String> formUserNames = getUserNameData();
          final Map<String, String> formSeoTitles = getSeoTitleData();
          final Map<String, String> formSeoDescriptions =
              getSeoDescriptionData();
          final Map<String, String> formSeoKeywords = getSeoKeywordsData();
          final Map<String, String> formSeoSchemaMarkup =
              getSeoSchemaMarkupData();

          final Map<String, dynamic> translatedFields = {
            'company_name': formCompanyNames,
            'about_provider': formAboutProvider,
            'long_description': formLongDescriptions,
            'username': formUserNames,
            'seo_title': formSeoTitles,
            'seo_description': formSeoDescriptions,
            'seo_keywords': formSeoKeywords,
            'seo_schema_markup': formSeoSchemaMarkup,
          };

          final ProviderDetails editProviderDetails = ProviderDetails(
            workingDays: null,
            user: UserDetails(
              id: providerData?.user?.id,
              email: emailController.text.trim(),
              phone: mobileNumberController.text.trim(),
              countryCode: context
                  .read<CountryCodeCubit>()
                  .getSelectedCountryCode(),
              company: companyNameController.text.trim(),
              image: pickedLocalImages['logoImage'],
            ),
            deletedOtherImages: deletedPreviouslyAddedImages,
            providerInformation: ProviderInformation(
              type: selectCompanyType?['value'],
              visitingCharges: visitingChargesController.text.trim(),
              advanceBookingDays: advanceBookingDaysController.text.trim(),
              maxServiceableDistance: maxServiceableDistanceController.text
                  .trim(),
              numberOfMembers: numberOfMemberController.text.trim(),
              banner: pickedLocalImages['bannerImage'],
              nationalId: pickedLocalImages['nationalIdImage'],
              passport: pickedLocalImages['passportIdImage'],
              addressId: pickedLocalImages['addressIdImage'],
              otherImages: selectedOtherImages.value,
              isPostBookingChatAllowed: isPostBookingChatAllowed,
              isPreBookingChatAllowed: isPreBookingChatAllowed,
              atDoorstep: atDoorstepAllowed,
              atStore: atStore,
              seoTitle: seoTitleController.text.trim(),
              seoDescription: seoDescriptionController.text.trim(),
              seoKeywords: seoKeywordsController.text.trim(),
              seoSchemaMarkup: seoSchemaMarkupController.text.trim(),
              seoOgImage: pickedLocalImages['seoOgImage'],
              translatedFields: translatedFields,
              taxRegistrationNumber: taxRegistrationNumberController.text
                  .trim(),
            ),
            customFields: [
              ...documentsCustomFieldSubmissions,
              ...bankDetailsCustomFieldSubmissions,
            ],
            locationInformation: LocationInformation(
              longitude: longitudeController.text.trim(),
              latitude: latitudeController.text.trim(),
              address: addressController.text.trim(),
              city: cityController.text.trim(),
            ),
          );

          context.read<EditProviderDetailsCubit>().editProviderDetails(
            providerDetails: editProviderDetails,
          );
        }
      }
    } else if (currentPage > 1) {
      await _saveCurrentFormData();
      currentIndex--;
      pickedLocalImages = pickedLocalImages;
      setState(() {});
    }
  }

  Widget screenBuilder(int currentPage) {
    Widget currentForm;
    switch (_actualFormIndex(currentPage)) {
      case 1:
        currentForm = PersonalInfo(
          formKey: formKey1,
          customFieldsKey: documentsFormKey,
          userNameController: userNameController,
          emailController: emailController,
          mobileNumberController: mobileNumberController,
          countryController: countryController,
          regionController: regionController,
          taxRegistrationNumberController: taxRegistrationNumberController,
          userNmFocus: userNmFocus,
          emailFocus: emailFocus,
          mobNoFocus: mobNoFocus,
          atStore: atStore,
          atDoorstepAllowed: atDoorstepAllowed,
          isPreBookingChatAllowed: isPreBookingChatAllowed,
          isPostBookingChatAllowed: isPostBookingChatAllowed,
          onAtStoreChanged: (value) {
            setState(() {
              atStore = value;
            });
          },
          onAtDoorstepChanged: (value) {
            setState(() {
              atDoorstepAllowed = value;
            });
          },
          onPreBookingChatChanged: (value) {
            setState(() {
              isPreBookingChatAllowed = value;
            });
          },
          onPostBookingChatChanged: (value) {
            setState(() {
              isPostBookingChatAllowed = value;
            });
          },
          showCameraAndGalleryOption:
              ({required PickImage imageController, required String title}) {
                return showCameraAndGalleryOption(
                  imageController: imageController,
                  title: title,
                );
              },
          // Multi-language support for username
          languages: languages.isNotEmpty ? languages : null,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          userNameControllers: userNameControllers.isNotEmpty
              ? userNameControllers
              : null,
          getUserNameValidator: _getUserNameValidator,
          // Pass loginType from stored provider data
          loginType: providerData?.user?.loginType,
          customFieldsLocalValues: documentsCustomLocalValues,
        );
        break;
      case 2:
        currentForm = Form2CompanyInfo(
          key: form2CompanyInfoKey,
          formKey: formKey2,
          companyNameController: companyNameController,
          visitingChargesController: visitingChargesController,
          advanceBookingDaysController: advanceBookingDaysController,
          aboutCompanyController: aboutCompanyController,
          numberOfMemberController: numberOfMemberController,
          pickLogoImage: pickLogoImage,
          pickBannerImage: pickBannerImage,
          companyNmFocus: companyNmFocus,
          visitingChargeFocus: visitingChargeFocus,
          advanceBookingDaysFocus: advanceBookingDaysFocus,
          maxServiceableDistanceController: maxServiceableDistanceController,
          maxServiceableDistanceFocus: maxServiceableDistanceFocus,
          aboutCompanyFocus: aboutCompanyFocus,
          numberOfMemberFocus: numberOfMemberFocus,
          selectCompanyType: selectCompanyType,
          isIndividualType: isIndividualType,
          pickedLocalImages: pickedLocalImages,
          selectedOtherImages: selectedOtherImages,
          previouslyAddedOtherImages: previouslyAddedOtherImages,
          selectCompanyTypes: selectCompanyTypes,
          showCameraAndGalleryOption:
              ({required PickImage imageController, required String title}) {
                return showCameraAndGalleryOption(
                  imageController: imageController,
                  title: title,
                );
              },
          onPreviousImageDeleted: (deletedImage) {
            deletedPreviouslyAddedImages.add(deletedImage);
          },
          // Multi-language support for company name, about, and description
          languages: languages,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          companyNameControllers: companyNameControllers,
          aboutCompanyControllers: aboutCompanyControllers,
          descriptionControllers: longDescriptionControllers,
          getCompanyNameValidator: _getCompanyNameValidator,
          getAboutCompanyValidator: _getAboutCompanyValidator,
          getDescriptionValidator: _getLongDescriptionValidator,
        );
        break;
      case 3:
        currentForm = Form3Description(
          htmlController: htmlController,
          initialHTML: longDescription,
          // Multi-language support
          languages: languages,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          longDescriptionControllers: longDescriptionControllers,
        );
        break;
      // case 4:
      //   currentForm = SEO(
      //     formKey: formKey4,
      //     seoTitleController: seoTitleController,
      //     seoDescriptionController: seoDescriptionController,
      //     seoKeywordsController: seoKeywordsController,
      //     seoSchemaMarkupController: seoSchemaMarkupController,
      //     pickSeoOgImage: pickSeoOgImage,
      //     seoTitleFocus: seoTitleFocus,
      //     seoDescriptionFocus: seoDescriptionFocus,
      //     seoKeywordsFocus: seoKeywordsFocus,
      //     seoSchemaMarkupFocus: seoSchemaMarkupFocus,
      //     pickedLocalImages: pickedLocalImages,
      //     showCameraAndGalleryOption:
      //         ({required PickImage imageController, required String title}) {
      //           return showCameraAndGalleryOption(
      //             imageController: imageController,
      //             title: title,
      //           );
      //         },
      //     languages: languages.isNotEmpty ? languages : null,
      //     defaultLanguage: defaultLanguage,
      //     selectedLanguageIndex: selectedLanguageIndex,
      //     onLanguageChanged: _onLanguageChanged,
      //     titleControllers: seoTitleControllers.isNotEmpty
      //         ? seoTitleControllers
      //         : null,
      //     descriptionControllers: seoDescriptionControllers.isNotEmpty
      //         ? seoDescriptionControllers
      //         : null,
      //     keywordsControllers: seoKeywordsControllers.isNotEmpty
      //         ? seoKeywordsControllers
      //         : null,
      //     schemaMarkupControllers: seoSchemaMarkupControllers.isNotEmpty
      //         ? seoSchemaMarkupControllers
      //         : null,
      //   );
      //   break;
      // case 5:
      //   currentForm = Form5WorkingDays(
      //     formKey: formKey5,
      //     isChecked: isChecked,
      //     selectedStartTime: selectedStartTime,
      //     selectedEndTime: selectedEndTime,
      //     daysOfWeek: daysOfWeek,
      //     onTimeSelected: (selectedTime, index, isStartTime) {
      //       _selectTime(
      //         selectedTime: selectedTime,
      //         indexVal: index,
      //         isTimePickerForStarTime: isStartTime,
      //       );
      //     },
      //     onDayToggled: (index, newValue) {
      //       setState(() {
      //         pickedLocalImages = pickedLocalImages;
      //         isChecked[index] = newValue;
      //       });
      //     },
      //   );
      //   break;
      case 6:
        currentForm = Form6BankInfo(
          formKey: formKey6,
          customFieldsKey: bankDetailsFormKey,
          customFieldsLocalValues: bankDetailsCustomLocalValues,
        );
        break;
      case 7:
        currentForm = LocationInfo(
          formKey: formKey7,
          cityController: cityController,
          latitudeController: latitudeController,
          longitudeController: longitudeController,
          addressController: addressController,
          cityFocus: cityFocus,
          latitudeFocus: latitudeFocus,
          longitudeFocus: longitudeFocus,
          addressFocus: addressFocus,
        );
        break;
      default:
        currentForm = PersonalInfo(
          formKey: formKey1,
          customFieldsKey: documentsFormKey,
          userNameController: userNameController,
          emailController: emailController,
          mobileNumberController: mobileNumberController,
          countryController: countryController,
          regionController: regionController,
          taxRegistrationNumberController: taxRegistrationNumberController,
          userNmFocus: userNmFocus,
          emailFocus: emailFocus,
          mobNoFocus: mobNoFocus,
          atStore: atStore,
          atDoorstepAllowed: atDoorstepAllowed,
          isPreBookingChatAllowed: isPreBookingChatAllowed,
          isPostBookingChatAllowed: isPostBookingChatAllowed,
          onAtStoreChanged: (value) {
            setState(() {
              atStore = value;
            });
          },
          onAtDoorstepChanged: (value) {
            setState(() {
              atDoorstepAllowed = value;
            });
          },
          onPreBookingChatChanged: (value) {
            setState(() {
              isPreBookingChatAllowed = value;
            });
          },
          onPostBookingChatChanged: (value) {
            setState(() {
              isPostBookingChatAllowed = value;
            });
          },
          showCameraAndGalleryOption:
              ({required PickImage imageController, required String title}) {
                return showCameraAndGalleryOption(
                  imageController: imageController,
                  title: title,
                );
              },
          // Multi-language support for username
          languages: languages.isNotEmpty ? languages : null,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          userNameControllers: userNameControllers.isNotEmpty
              ? userNameControllers
              : null,
          getUserNameValidator: _getUserNameValidator,
          // Pass loginType from stored provider data
          loginType: providerData?.user?.loginType,
          customFieldsLocalValues: documentsCustomLocalValues,
        );
        break;
    }
    return currentPage == 3
        ? currentForm
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: currentForm,
          );
  }

  // Future<void> _selectTime({
  //   required TimeOfDay selectedTime,
  //   required int indexVal,
  //   required bool isTimePickerForStarTime,
  // }) async {
  //   try {
  //     final Locale currentLocale = LocaleUtils.getCurrentLocale(context);
  //     final TimeOfDay? timeOfDay = await showTimePicker(
  //       context: context,
  //       initialTime: selectedTime,
  //       builder: (BuildContext context, Widget? child) {
  //         return Localizations.override(
  //           context: context,
  //           locale: currentLocale,
  //           child: child,
  //         );
  //       },
  //     );
  //     if (isTimePickerForStarTime) {
  //       final int startTimeInMinutes = timeOfDay!.hour * 60 + timeOfDay.minute;
  //       final int endTimeInMinutes =
  //           selectedEndTime[indexVal].hour * 60 + selectedEndTime[indexVal].minute;
  //       if (startTimeInMinutes < endTimeInMinutes) {
  //         selectedStartTime[indexVal] = timeOfDay;
  //       } else if (mounted) {
  //         UiUtils.showMessage(context, 'startTimeMustBeBeforeEndTime'.translate(context: context), ToastificationType.warning);
  //       }
  //     } else {
  //       final int startTimeInMinutes =
  //           selectedStartTime[indexVal].hour * 60 + selectedStartTime[indexVal].minute;
  //       final int endTimeInMinutes = timeOfDay!.hour * 60 + timeOfDay.minute;
  //       if (endTimeInMinutes > startTimeInMinutes) {
  //         selectedEndTime[indexVal] = timeOfDay;
  //       } else if (mounted) {
  //         UiUtils.showMessage(context, 'endTimeMustBeAfterStartTime'.translate(context: context), ToastificationType.warning);
  //       }
  //     }
  //   } catch (_) {}
  //   setState(() { pickedLocalImages = pickedLocalImages; });
  // }

  Widget idImageWidget({
    required String titleTxt,
    required String imageHintText,
    required PickImage imageController,
    required String imageType,
    required String oldImage,
  }) {
    return CustomContainer(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width / 1.4,
      color: context.colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(titleTxt, fontSize: 16, fontWeight: FontWeight.w500),
              const SizedBox(height: 5),
              pickedLocalImages[imageType] != ''
                  ? CustomText(
                      pickedLocalImages[imageType].split('/').last,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      color: context.colorScheme.lightGreyColor,
                    )
                  : oldImage != 'null'
                  ? CustomText(
                      oldImage.split('/').last,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      color: context.colorScheme.lightGreyColor,
                    )
                  : const SizedBox(height: 12),
              const SizedBox(height: 5),
              imagePicker(
                imageType: imageType,
                imageController: imageController,
                oldImage: oldImage,
                hintLabel: imageHintText,
                width: MediaQuery.of(context).size.width / 1.5,
                onImagePicked: (newImage) {
                  setState(() {
                    pickedLocalImages[imageType] = newImage;
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget bennerPicker({
    required PickImage imageController,
    required String oldImage,
    required String hintLabel,
    required String imageType,
  }) {
    return imageController.ListenImageChange((BuildContext context, image) {
      if (image == null) {
        if (pickedLocalImages[imageType] != '') {
          return GestureDetector(
            onTap: () {
              showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              );
            },
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(UiUtils.borderRadiusOf10),
                ),
                child: Image.file(
                  File(pickedLocalImages[imageType]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        if (oldImage.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              );
            },
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(UiUtils.borderRadiusOf10),
                ),
                child: CustomCachedNetworkImage(
                  imageUrl: oldImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        return CustomInkWellContainer(
          onTap: () {
            showCameraAndGalleryOption(
              imageController: imageController,
              title: hintLabel,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSvgPicture(
                svgImage: AppAssets.camera,
                color: context.colorScheme.accentColor,
                height: 20,
                width: 20,
              ),
              const SizedBox(height: 10),
              CustomText(
                'uploadBannerImage'.translate(context: context),
                color: context.colorScheme.accentColor,
                fontSize: 12,
              ),
            ],
          ),
        );
      }

      pickedLocalImages[imageType] = image?.path;

      return GestureDetector(
        onTap: () {
          showCameraAndGalleryOption(
            imageController: imageController,
            title: hintLabel,
          );
        },
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(UiUtils.borderRadiusOf10),
            ),
            child: Image.file(File(image.path), fit: BoxFit.cover),
          ),
        ),
      );
    });
  }

  Widget logoPicker({
    required PickImage imageController,
    required String oldImage,
    required String hintLabel,
    required String imageType,
  }) {
    return imageController.ListenImageChange((BuildContext context, image) {
      if (image == null) {
        if (pickedLocalImages[imageType] != '') {
          return GestureDetector(
            onTap: () {
              showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              );
            },
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(UiUtils.borderRadiusOf50),
                ),
                child: Image.file(
                  File(pickedLocalImages[imageType]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        if (oldImage.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              );
            },
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(UiUtils.borderRadiusOf50),
                ),
                child: CustomCachedNetworkImage(
                  imageUrl: oldImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        return CustomInkWellContainer(
          onTap: () {
            showCameraAndGalleryOption(
              imageController: imageController,
              title: hintLabel,
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgPicture(
                  svgImage: AppAssets.camera,
                  color: context.colorScheme.accentColor,
                  height: 20,
                  width: 20,
                ),
                CustomText(
                  "logoLbl".translate(context: context),
                  color: context.colorScheme.accentColor,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        );
      }

      pickedLocalImages[imageType] = image?.path;

      return GestureDetector(
        onTap: () {
          showCameraAndGalleryOption(
            imageController: imageController,
            title: hintLabel,
          );
        },
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(UiUtils.borderRadiusOf50),
            ),
            child: Image.file(File(image.path), fit: BoxFit.cover),
          ),
        ),
      );
    });
  }

  Widget imagePicker({
    required PickImage imageController,
    required String oldImage,
    required String hintLabel,
    required String imageType,
    double? width,
    required void Function(String newImagePath) onImagePicked,
  }) {
    return imageController.ListenImageChange((BuildContext context, image) {
      if (image == null) {
        if (pickedLocalImages[imageType] != '') {
          return GestureDetector(
            onTap: () {
              showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              ).then((_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onImagePicked(pickedLocalImages[imageType]!);
                });
              });
            },
            child: CustomContainer(
              color: context.colorScheme.accentColor.withAlpha(20),
              borderRadius: UiUtils.borderRadiusOf10,
              height: 100,
              width: (width ?? MediaQuery.sizeOf(context).width) - 5.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(UiUtils.borderRadiusOf10),
                ),
                child: Image.file(
                  File(pickedLocalImages[imageType]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        if (oldImage.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              ).then((_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onImagePicked(pickedLocalImages[imageType]!);
                });
              });
            },
            child: Stack(
              children: [
                CustomContainer(
                  borderRadius: UiUtils.borderRadiusOf10,
                  height: 100,
                  width: (width ?? MediaQuery.sizeOf(context).width) - 5.0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(UiUtils.borderRadiusOf10),
                    ),
                    child: CustomCachedNetworkImage(
                      imageUrl: oldImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CustomContainer(
                  borderRadius: UiUtils.borderRadiusOf10,
                  color: context.colorScheme.lightGreyColor.withAlpha(40),
                  height: 100,
                  width: (width ?? MediaQuery.sizeOf(context).width) - 5.0,
                  child: Center(
                    child: CustomSvgPicture(
                      svgImage: AppAssets.edit,
                      color: AppColors.whiteColors,
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomInkWellContainer(
          onTap: () {
            showCameraAndGalleryOption(
              imageController: imageController,
              title: hintLabel,
            ).then((_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onImagePicked(pickedLocalImages[imageType]!);
              });
            });
          },
          child: CustomContainer(
            borderRadius: UiUtils.borderRadiusOf10,
            color: context.colorScheme.accentColor.withAlpha(20),
            height: 100,
            width: (width ?? MediaQuery.sizeOf(context).width) - 5.0,
            child: Center(
              child: CustomSvgPicture(
                svgImage: AppAssets.addCircle,
                color: context.colorScheme.accentColor,
                height: 50,
                width: 50,
              ),
            ),
          ),
        );
      }

      pickedLocalImages[imageType] = image?.path;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onImagePicked(image!.path);
      });

      return GestureDetector(
        onTap: () {
          showCameraAndGalleryOption(
            imageController: imageController,
            title: hintLabel,
          ).then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onImagePicked(image.path);
            });
          });
        },
        child: CustomContainer(
          borderRadius: UiUtils.borderRadiusOf10,
          height: 100,
          width: (width ?? MediaQuery.sizeOf(context).width) - 5.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(UiUtils.borderRadiusOf10),
            ),
            child: Image.file(File(image.path), fit: BoxFit.cover),
          ),
        ),
      );
    });
  }

  Widget buildDropDown(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    required String initialValue,
    String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          color: Theme.of(context).colorScheme.blackColor,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(height: 10),
        CustomFormDropdown(
          onTap: () {
            onTap.call();
          },
          initialTitle: initialValue,
          selectedValue: value,
          validator: (String? p0) {
            return Validator.nullCheck(context, p0);
          },
        ),
      ],
    );
  }

  Future showCameraAndGalleryOption({
    required PickImage imageController,
    required String title,
  }) {
    return UiUtils.showModelBottomSheets(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      context: context,
      child: ShowImagePickerOptionBottomSheet(
        title: title,
        onCameraButtonClick: () {
          imageController.pick(source: ImageSource.camera);
        },
        onGalleryButtonClick: () {
          imageController.pick(source: ImageSource.gallery);
        },
      ),
    );
  }

  Future<void> selectCompanyTypes() async {
    final List<Map<String, dynamic>> itemList = [
      {
        'title': 'individual'.translate(context: context),
        'id': '0',
        "isSelected": selectCompanyType?['value'] == "0",
      },
      {
        'title': 'organisation'.translate(context: context),
        'id': '1',
        "isSelected": selectCompanyType?['value'] == "1",
      },
    ];
    UiUtils.showModelBottomSheets(
      context: context,
      child: SelectableListBottomSheet(
        bottomSheetTitle: "selectType",
        itemList: itemList,
      ),
    ).then((value) {
      if (value != null) {
        selectCompanyType = {
          'title': value["selectedItemName"],
          'value': value["selectedItemId"],
        };

        if (value?['selectedItemName'] == 'Individual') {
          numberOfMemberController.text = '1';
          isIndividualType = true;
        } else {
          isIndividualType = false;
        }
        setState(() {
          pickedLocalImages = pickedLocalImages;
        });
      }
    });
  }
}
