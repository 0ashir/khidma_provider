import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../app/generalImports.dart';
import 'forms/details.dart';
import 'forms/media.dart';
import 'forms/seo.dart';
import 'forms/faqs.dart';
import 'forms/description.dart';
import 'widgets/categorySelectorBottomSheet.dart';

class ManageService extends StatefulWidget {
  const ManageService({super.key, this.service});

  final ServiceModel? service;

  @override
  ManageServiceState createState() => ManageServiceState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final Map? arguments = routeSettings.arguments as Map?;

    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (BuildContext context) => CreateServiceCubit(),
        child: ManageService(service: arguments?['service']),
      ),
    );
  }
}

class ManageServiceState extends State<ManageService> {
  int currIndex = 1;
  int totalForms = 5;

  //form 1
  bool isOnSiteAllowed = false;
  bool isPayLaterAllowed = true;
  bool isCancelAllowed = false;
  bool isDoorStepAllowed = false;
  bool isStoreAllowed = false;
  bool serviceStatus = true;

  // Multi-language support
  List<AppLanguage> languages = [];
  AppLanguage? defaultLanguage;
  int selectedLanguageIndex = 0;
  StreamSubscription? _languageListSubscription;
  Map<String, TextEditingController> titleControllers = {};
  Map<String, TextEditingController> descriptionControllers = {};
  Map<String, TextEditingController> tagsControllers = {};
  Map<String, TextEditingController> longDescriptionControllers = {};
  Map<String, List<TextEditingController>> faqQuestionControllers = {};
  Map<String, List<TextEditingController>> faqAnswerControllers = {};
  Map<String, TextEditingController> seoTitleControllers = {};
  Map<String, TextEditingController> seoDescriptionControllers = {};
  Map<String, TextEditingController> seoKeywordsControllers = {};
  Map<String, TextEditingController> seoSchemaMarkupControllers = {};

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<Form1State> form1StateKey = GlobalKey<Form1State>();

  late List<String> _participant = [
    "details",
    "media",
    "seo",
    "faqs",
    "descriptionLbl",
  ];

  ScrollController scrollController = ScrollController();

  late TextEditingController serviceTitleController = TextEditingController();
  late TextEditingController surviceSlugController = TextEditingController(
    text: widget.service?.slug,
  );
  late TextEditingController serviceTagController = TextEditingController();
  late TextEditingController serviceDescrController = TextEditingController();

  late TextEditingController cancelBeforeController = TextEditingController(
    text: widget.service?.cancelableTill,
  );
  FocusNode serviceTitleFocus = FocusNode();
  FocusNode serviceSlugFocus = FocusNode();
  FocusNode serviceTagFocus = FocusNode();
  FocusNode serviceDescrFocus = FocusNode();

  FocusNode cancelBeforeFocus = FocusNode();

  late int selectedCategory = 0;
  String? selectedCategoryTitle;
  late int selectedTax = 0;
  String selectedTaxTitle = '';
  late int selectedSubCategory = 0;
  Map? selectedPriceType;
  Map? selectedDurationType;

  //form 2
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  late TextEditingController priceController = TextEditingController(
    text: widget.service?.price,
  );
  late TextEditingController discountPriceController = TextEditingController(
    text: widget.service?.discountedPrice,
  );
  late TextEditingController memReqTaskController = TextEditingController(
    text: widget.service?.numberOfMembersRequired,
  );
  late TextEditingController durationTaskController = TextEditingController(
    text: widget.service?.duration,
  );
  late TextEditingController qtyAllowedTaskController = TextEditingController(
    text: widget.service?.maxQuantityAllowed,
  );

  FocusNode priceFocus = FocusNode();
  FocusNode discountPriceFocus = FocusNode();
  FocusNode memReqTaskFocus = FocusNode();
  FocusNode durationTaskFocus = FocusNode();
  FocusNode qtyAllowedTaskFocus = FocusNode();

  List<String> tagsList = [];
  List<Map<String, dynamic>> finalTagList = [];
  PickImage imagePicker = PickImage();

  void _addTag(String tag) {
    setState(() {
      tagsList.add(tag);
      _updateFinalTagList();
      serviceTagController.text = tagsList.join(', ');
    });
  }

  void _removeTag(int index) {
    setState(() {
      if (tagsList.isNotEmpty) {
        tagsList.removeAt(index);
        _updateFinalTagList();
        serviceTagController.text = tagsList.join(', ');
      }
    });
  }

  void _updateFinalTagList() {
    finalTagList.clear();
    for (int i = 0; i < tagsList.length; i++) {
      finalTagList.add({'id': i, 'text': tagsList[i]});
    }
  }

  //SEO form
  final GlobalKey<FormState> formKeySEO = GlobalKey<FormState>();
  late TextEditingController seoTitleController = TextEditingController(
    text: widget.service?.seoTitle,
  );
  late TextEditingController seoDescriptionController = TextEditingController(
    text: widget.service?.seoDescription,
  );
  late TextEditingController seoKeywordsController = TextEditingController(
    text: widget.service?.seoKeywords,
  );
  late TextEditingController seoSchemaMarkupController = TextEditingController(
    text: widget.service?.seoSchemaMarkup,
  );

  FocusNode seoTitleFocus = FocusNode();
  FocusNode seoDescriptionFocus = FocusNode();
  FocusNode seoKeywordsFocus = FocusNode();
  FocusNode seoSchemaMarkupFocus = FocusNode();

  PickImage pickSeoOgImage = PickImage();
  String pickedSeoOgImagePath = '';
  Map<String, dynamic> pickedLocalImages = {'seoOgImage': ''};

  Map priceTypeFilter = {'0': 'included', '1': 'excluded'};
  String pickedServiceImage = '';

  bool fileTapLoading = false;

  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<Form3State> form3StateKey = GlobalKey<Form3State>();
  final GlobalKey<Form4State> form4StateKey = GlobalKey<Form4State>();
  ValueNotifier<List<TextEditingController>> faqQuestionTextEditors =
      ValueNotifier([]);
  ValueNotifier<List<TextEditingController>> faqAnswersTextEditors =
      ValueNotifier([]);

  final HtmlEditorController controller = HtmlEditorController();
  String? longDescription;

  ValueNotifier<List<String>> selectedOtherImages = ValueNotifier([]);
  ValueNotifier<List<String>> previouslyAddedOtherImages = ValueNotifier([]);
  Set<String> deletedPreviouslyAddedImages = {};

  ValueNotifier<List<String>> selectedFiles = ValueNotifier([]);
  ValueNotifier<List<String>> previouslyAddedFiles = ValueNotifier([]);
  Set<String> deletedPreviouslyAddedFiles = {};

  @override
  void dispose() {
    _languageListSubscription?.cancel();

    selectedOtherImages.dispose();
    previouslyAddedOtherImages.dispose();
    selectedFiles.dispose();
    previouslyAddedFiles.dispose();
    faqAnswersTextEditors.dispose();
    faqQuestionTextEditors.dispose();
    serviceTitleController.dispose();
    surviceSlugController.dispose();
    serviceTagController.dispose();
    serviceDescrController.dispose();
    cancelBeforeController.dispose();
    serviceTitleFocus.dispose();
    serviceSlugFocus.dispose();
    serviceTagFocus.dispose();
    serviceDescrFocus.dispose();
    cancelBeforeFocus.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    memReqTaskController.dispose();
    durationTaskController.dispose();
    qtyAllowedTaskController.dispose();
    priceFocus.dispose();
    discountPriceFocus.dispose();
    memReqTaskFocus.dispose();
    durationTaskFocus.dispose();
    qtyAllowedTaskFocus.dispose();
    seoTitleController.dispose();
    seoDescriptionController.dispose();
    seoKeywordsController.dispose();
    seoSchemaMarkupController.dispose();
    seoTitleFocus.dispose();
    seoDescriptionFocus.dispose();
    seoKeywordsFocus.dispose();
    seoSchemaMarkupFocus.dispose();
    pickSeoOgImage.dispose();
    super.dispose();
  }

  void _initializeLanguages() {
    final cubit = context.read<LanguageListCubit>();
    final currentLang = HiveRepository.getCurrentLanguage();

    if (currentLang == null) return;

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

        if (widget.service != null) {
          _processServiceData();
        }

        _populateTranslatedControllers();

        _refreshForm1WithTranslatedData();

        if (mounted) {
          setState(() {});
        }

        _languageListSubscription?.cancel();
        _languageListSubscription = null;
      }
    });
  }

  /// Price and discounted price of the edited service, with the provider's
  /// decimal places (country setting, else system). Refills only while the
  /// fields still hold what was filled here, so typing is never overwritten.
  String? _filledPrice;
  String? _filledDiscountPrice;

  String _withDecimals(final String? amount) {
    final double? value = double.tryParse((amount ?? '').replaceAll(',', ''));
    return value == null
        ? (amount ?? '')
        : value.toStringAsFixed(context.providerDecimalPlaces);
  }

  void _fillPrices() {
    final ServiceModel? service = widget.service;
    if (service == null) return;

    final bool untouched =
        (_filledPrice == null || priceController.text == _filledPrice) &&
        (_filledDiscountPrice == null ||
            discountPriceController.text == _filledDiscountPrice);
    if (!untouched) return;

    _filledPrice = priceController.text = _withDecimals(service.price);
    _filledDiscountPrice = discountPriceController.text = _withDecimals(
      service.discountedPrice,
    );
  }

  void _initializeEmptyControllers() {
    titleControllers = {};
    descriptionControllers = {};
    tagsControllers = {};
    longDescriptionControllers = {};
    faqQuestionControllers = {};
    faqAnswerControllers = {};
    seoTitleControllers = {};
    seoDescriptionControllers = {};
    seoKeywordsControllers = {};
    seoSchemaMarkupControllers = {};
  }

  void _initializeControllers() {
    titleControllers.clear();
    descriptionControllers.clear();
    tagsControllers.clear();
    longDescriptionControllers.clear();
    faqQuestionControllers.clear();
    faqAnswerControllers.clear();
    seoTitleControllers.clear();
    seoDescriptionControllers.clear();
    seoKeywordsControllers.clear();
    seoSchemaMarkupControllers.clear();

    for (var lang in languages) {
      final String code = lang.languageCode;

      titleControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? serviceTitleController.text
            : '',
      );

      descriptionControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? serviceDescrController.text
            : '',
      );

      tagsControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? serviceTagController.text
            : '',
      );

      longDescriptionControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? (longDescription ?? '')
            : '',
      );

      faqQuestionControllers[code] = [];
      faqAnswerControllers[code] = [];

      seoTitleControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? seoTitleController.text
            : '',
      );

      seoDescriptionControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? seoDescriptionController.text
            : '',
      );

      seoKeywordsControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? seoKeywordsController.text
            : '',
      );

      seoSchemaMarkupControllers[code] = TextEditingController(
        text: code == defaultLanguage?.languageCode
            ? seoSchemaMarkupController.text
            : '',
      );
    }
  }

  void _processServiceData() {
    if (widget.service == null) return;

    serviceTitleController.text = widget.service?.title ?? '';
    serviceDescrController.text = widget.service?.description ?? '';
    serviceTagController.text = widget.service?.tags ?? '';
    surviceSlugController.text = widget.service?.slug ?? '';
    cancelBeforeController.text = widget.service?.cancelableTill ?? '';
    longDescription = widget.service?.longDescription ?? '';

    if (widget.service?.isPayLaterAllowed != null) {
      isPayLaterAllowed = widget.service?.isPayLaterAllowed == '0'
          ? false
          : true;
    }
    if (widget.service?.isDoorStepAllowed != null) {
      isDoorStepAllowed = widget.service?.isDoorStepAllowed == '0'
          ? false
          : true;
    }
    if (widget.service?.isCancelable != null) {
      isCancelAllowed = widget.service?.isCancelable == '0' ? false : true;
    }
    if (widget.service?.isStoreAllowed != null) {
      isStoreAllowed = widget.service?.isStoreAllowed == '0' ? false : true;
    }
    if (widget.service?.status != null || widget.service?.status != '') {
      serviceStatus = widget.service?.status == "deactive" ? false : true;
    }

    if (languages.isNotEmpty) {
      for (final language in languages) {
        final langCode = language.languageCode;
        final langTags = widget.service!.getTranslatedTags(langCode);
        if (langTags?.isNotEmpty == true) {
          tagsControllers[langCode]?.text = langTags!;
        }
      }

      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final currentTags = widget.service!.getTranslatedTags(currentLangCode);
      if (currentTags?.isEmpty ?? true) {
        tagsList = [];
      } else {
        tagsList = currentTags!
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      }
    } else {
      tagsList = [];
    }
    _updateFinalTagList();

    _refreshForm1WithTranslatedData();

    if (languages.isNotEmpty) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      final currentLongDesc = widget.service!.getTranslatedLongDescription(
        currentLangCode,
      );
      if (currentLongDesc != null) {
        longDescription = currentLongDesc;
      }
    }

    if (faqQuestionTextEditors.value.isEmpty ||
        faqAnswersTextEditors.value.isEmpty) {
      faqQuestionTextEditors.value.add(TextEditingController());
      faqAnswersTextEditors.value.add(TextEditingController());
    }

    previouslyAddedOtherImages.value = [...?widget.service?.otherImages];
    previouslyAddedFiles.value = [...?widget.service?.files];
  }

  void _populateTranslatedControllers() {
    if (languages.isEmpty) return;

    if (widget.service?.translatedFields?['title'] != null) {
      final titleData = widget.service!.translatedFields!['title'];
      if (titleData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = titleData[code];
          if (translatedValue != null) {
            titleControllers[code]?.text = translatedValue.toString();
          }
        }
      } else if (titleData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          titleControllers[defaultLangCode]?.text = titleData.join(',');
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          titleControllers[defaultLangCode]?.text = titleData.toString();
        }
      }
    }

    if (widget.service?.translatedFields?['description'] != null) {
      final descriptionData = widget.service!.translatedFields!['description'];
      if (descriptionData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = descriptionData[code];
          if (translatedValue != null) {
            descriptionControllers[code]?.text = translatedValue.toString();
          }
        }
      } else if (descriptionData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          descriptionControllers[defaultLangCode]?.text = descriptionData.join(
            ',',
          );
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          descriptionControllers[defaultLangCode]?.text = descriptionData
              .toString();
        }
      }
    }

    if (widget.service?.translatedFields?['tags'] != null) {
      final tagsData = widget.service!.translatedFields!['tags'];
      if (tagsData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = tagsData[code];
          if (translatedValue != null) {
            if (translatedValue is List) {
              tagsControllers[code]?.text = translatedValue.join(',');
            } else {
              tagsControllers[code]?.text = translatedValue.toString();
            }
          }
        }
      } else if (tagsData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          tagsControllers[defaultLangCode]?.text = tagsData.join(',');
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          tagsControllers[defaultLangCode]?.text = tagsData.toString();
        }
      }
    }

    _refreshForm1WithTranslatedData();

    if (widget.service?.translatedFields?['long_description'] != null) {
      final longDescriptionData =
          widget.service!.translatedFields!['long_description'];
      if (longDescriptionData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = longDescriptionData[code];
          if (translatedValue != null) {
            longDescriptionControllers[code]?.text = translatedValue.toString();
          }
        }
      } else if (longDescriptionData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          longDescriptionControllers[defaultLangCode]?.text =
              longDescriptionData.join(',');
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          longDescriptionControllers[defaultLangCode]?.text =
              longDescriptionData.toString();
        }
      }
    }

    if (widget.service?.translatedFields?['faqs'] != null) {
      final faqsData = widget.service!.translatedFields!['faqs'];
      if (faqsData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final faqData = faqsData[code];
          if (faqData is List && faqData.isNotEmpty) {
            faqQuestionControllers[code] = [];
            faqAnswerControllers[code] = [];

            for (final faq in faqData) {
              faqQuestionControllers[code]!.add(
                TextEditingController(text: faq['question']?.toString() ?? ''),
              );
              faqAnswerControllers[code]!.add(
                TextEditingController(text: faq['answer']?.toString() ?? ''),
              );
            }
          }
        }
      } else if (faqsData is List) {
        if (languages.isNotEmpty && faqsData.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          faqQuestionControllers[defaultLangCode] = [];
          faqAnswerControllers[defaultLangCode] = [];

          for (final faq in faqsData) {
            faqQuestionControllers[defaultLangCode]!.add(
              TextEditingController(text: faq['question']?.toString() ?? ''),
            );
            faqAnswerControllers[defaultLangCode]!.add(
              TextEditingController(text: faq['answer']?.toString() ?? ''),
            );
          }
        }
      }
    } else if (widget.service?.faqs != null &&
        widget.service!.faqs!.isNotEmpty) {
      final defaultLangCode = languages.isNotEmpty
          ? languages[0].languageCode
          : 'en';
      faqQuestionControllers[defaultLangCode] = [];
      faqAnswerControllers[defaultLangCode] = [];

      for (final faq in widget.service!.faqs!) {
        faqQuestionControllers[defaultLangCode]!.add(
          TextEditingController(text: faq.question ?? ''),
        );
        faqAnswerControllers[defaultLangCode]!.add(
          TextEditingController(text: faq.answer ?? ''),
        );
      }
    }

    _syncFaqDataToMainControllers();

    if (widget.service?.translatedFields?['seo_title'] != null) {
      final seoTitleData = widget.service!.translatedFields!['seo_title'];
      if (seoTitleData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = seoTitleData[code];
          if (translatedValue != null) {
            seoTitleControllers[code]?.text = translatedValue.toString();
          }
        }
      } else if (seoTitleData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoTitleControllers[defaultLangCode]?.text = seoTitleData.join(',');
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoTitleControllers[defaultLangCode]?.text = seoTitleData.toString();
        }
      }
    }

    if (widget.service?.translatedFields?['seo_description'] != null) {
      final seoDescriptionData =
          widget.service!.translatedFields!['seo_description'];
      if (seoDescriptionData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = seoDescriptionData[code];
          if (translatedValue != null) {
            seoDescriptionControllers[code]?.text = translatedValue.toString();
          }
        }
      } else if (seoDescriptionData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoDescriptionControllers[defaultLangCode]?.text = seoDescriptionData
              .join(',');
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoDescriptionControllers[defaultLangCode]?.text = seoDescriptionData
              .toString();
        }
      }
    }

    if (widget.service?.translatedFields?['seo_keywords'] != null) {
      final seoKeywordsData = widget.service!.translatedFields!['seo_keywords'];
      if (seoKeywordsData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = seoKeywordsData[code];
          if (translatedValue != null) {
            if (translatedValue is List) {
              seoKeywordsControllers[code]?.text = translatedValue.join(',');
            } else {
              seoKeywordsControllers[code]?.text = translatedValue.toString();
            }
          }
        }
      } else if (seoKeywordsData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoKeywordsControllers[defaultLangCode]?.text = seoKeywordsData.join(
            ',',
          );
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoKeywordsControllers[defaultLangCode]?.text = seoKeywordsData
              .toString();
        }
      }
    }

    if (widget.service?.translatedFields?['seo_schema_markup'] != null) {
      final seoSchemaMarkupData =
          widget.service!.translatedFields!['seo_schema_markup'];
      if (seoSchemaMarkupData is Map) {
        for (var lang in languages) {
          final String code = lang.languageCode;
          final translatedValue = seoSchemaMarkupData[code];
          if (translatedValue != null) {
            seoSchemaMarkupControllers[code]?.text = translatedValue.toString();
          }
        }
      } else if (seoSchemaMarkupData is List) {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoSchemaMarkupControllers[defaultLangCode]?.text =
              seoSchemaMarkupData.join(',');
        }
      } else {
        if (languages.isNotEmpty) {
          final defaultLangCode = languages[0].languageCode;
          seoSchemaMarkupControllers[defaultLangCode]?.text =
              seoSchemaMarkupData.toString();
        }
      }
    }
  }

  void _syncFaqDataToMainControllers() {
    if (languages.isEmpty) return;

    final defaultLangCode = languages[0].languageCode;
    final defaultQuestions = faqQuestionControllers[defaultLangCode] ?? [];
    final defaultAnswers = faqAnswerControllers[defaultLangCode] ?? [];

    faqQuestionTextEditors.value.clear();
    faqAnswersTextEditors.value.clear();

    for (
      int i = 0;
      i < defaultQuestions.length && i < defaultAnswers.length;
      i++
    ) {
      faqQuestionTextEditors.value.add(
        TextEditingController(text: defaultQuestions[i].text),
      );
      faqAnswersTextEditors.value.add(
        TextEditingController(text: defaultAnswers[i].text),
      );
    }
  }

  void _refreshForm1WithTranslatedData() {
    if (form1StateKey.currentState != null) {
      try {
        form1StateKey.currentState!.refreshFromParentControllers();
        // ignore: empty_catches
      } catch (_) {}
    }
  }

  Future<void> _setHtmlEditorTextWithRetry(
    String text, {
    int attempt = 0,
  }) async {
    if (!mounted || attempt >= 10) {
      return;
    }

    final delay = attempt == 0
        ? const Duration(milliseconds: 2000)
        : attempt == 1
        ? const Duration(milliseconds: 3000)
        : Duration(milliseconds: 2000 * attempt);

    await Future.delayed(delay);

    if (!mounted) return;

    try {
      controller.setText(text);
      return;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('html editor is still loading') ||
          errorMessage.contains('please wait')) {
        if (attempt < 9) {
          Future.delayed(
            Duration(milliseconds: 2000 * (attempt + 2)),
            () => _setHtmlEditorTextWithRetry(text, attempt: attempt + 1),
          );
        }
      }
    }
  }

  Future<void> _clearHtmlEditorWithRetry({int attempt = 0}) async {
    if (!mounted || attempt >= 10) {
      return;
    }

    final delay = attempt == 0
        ? const Duration(milliseconds: 2000)
        : attempt == 1
        ? const Duration(milliseconds: 3000)
        : Duration(milliseconds: 2000 * attempt);

    await Future.delayed(delay);

    if (!mounted) return;

    try {
      controller.clear();
      return;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('html editor is still loading') ||
          errorMessage.contains('please wait')) {
        if (attempt < 9) {
          Future.delayed(
            Duration(milliseconds: 2000 * (attempt + 2)),
            () => _clearHtmlEditorWithRetry(attempt: attempt + 1),
          );
        }
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
      if (currIndex == 1) {
        if (!_areServiceRequiredFieldsFilled()) {
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

  bool _areServiceRequiredFieldsFilled() {
    final hasTitle = serviceTitleController.text.trim().isNotEmpty;
    final hasDescription = serviceDescrController.text.trim().isNotEmpty;
    final hasCategory = selectedCategory > 0;

    return hasTitle && hasDescription && hasCategory;
  }

  bool _isDefaultLanguageLongDescriptionFilled() {
    if (languages.isEmpty) return false;

    final defaultLangCode = languages[0].languageCode;

    final defaultLangController = longDescriptionControllers[defaultLangCode];
    if (defaultLangController != null &&
        defaultLangController.text.trim().isNotEmpty) {
      return true;
    }

    if (longDescription != null && longDescription!.trim().isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<void> _onLanguageChanged(int index) async {
    if (index >= 0 && index < languages.length) {
      if (!_canSwitchLanguage(index)) {
        return;
      }

      if (selectedLanguageIndex < languages.length) {
        final previousLangCode = languages[selectedLanguageIndex].languageCode;
        final textController = longDescriptionControllers[previousLangCode];
        if (textController != null) {
          try {
            final text = await controller.getText();
            if (text.trim().isNotEmpty) {
              textController.text = text;
            }
          } catch (_) {}
        }
      }

      setState(() {
        selectedLanguageIndex = index;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (form1StateKey.currentState != null) {
          form1StateKey.currentState!.refreshFromParentControllers();
        }

        if (formKey1.currentState != null) {
          formKey1.currentState!.validate();
        }
      });

      if (index < languages.length) {
        final newLangCode = languages[index].languageCode;
        final textController = longDescriptionControllers[newLangCode];

        try {
          if (textController != null && textController.text.isNotEmpty) {
            _setHtmlEditorTextWithRetry(textController.text);
          } else {
            _clearHtmlEditorWithRetry();
          }
        } catch (_) {}
      }
    }
  }

  Map<String, String> getTitleData() {
    final Map<String, String> titleData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = titleControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        titleData[code] = controller.text.trim();
      }
    }

    return titleData;
  }

  Map<String, String> getDescriptionData() {
    final Map<String, String> descriptionData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = descriptionControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        descriptionData[code] = controller.text.trim();
      }
    }

    return descriptionData;
  }

  void _syncTagDataFromForm1() {
    if (form1StateKey.currentState != null) {
      try {
        final form1TagData = form1StateKey.currentState!.getTagData();

        for (var lang in languages) {
          final String code = lang.languageCode;
          if (form1TagData.containsKey(code)) {
            tagsControllers[code]?.text = form1TagData[code]!;
          }
        }
        // ignore: empty_catches
      } catch (_) {}
    }
  }

  Map<String, String> getTagsData() {
    final Map<String, String> tagsData = {};

    _syncTagDataFromForm1();

    if (form1StateKey.currentState != null) {
      try {
        final form1TagData = form1StateKey.currentState!.getTagData();
        if (form1TagData.isNotEmpty) {
          return form1TagData;
        }
        // ignore: empty_catches
      } catch (_) {}
    }

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = tagsControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        tagsData[code] = controller.text.trim();
      }
    }

    return tagsData;
  }

  Map<String, String> getLongDescriptionData() {
    final Map<String, String> longDescriptionData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = longDescriptionControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        longDescriptionData[code] = controller.text.trim();
      }
    }

    return longDescriptionData;
  }

  void _syncFaqDataFromForm3() {
    if (form3StateKey.currentState != null) {
      try {
        final form3FaqData = form3StateKey.currentState!.getFaqData();

        for (var lang in languages) {
          final String code = lang.languageCode;
          if (form3FaqData.containsKey(code)) {
            final faqs = form3FaqData[code]!;

            faqQuestionControllers[code]?.forEach(
              (controller) => controller.dispose(),
            );
            faqAnswerControllers[code]?.forEach(
              (controller) => controller.dispose(),
            );

            faqQuestionControllers[code] = [];
            faqAnswerControllers[code] = [];

            for (final faq in faqs) {
              faqQuestionControllers[code]!.add(
                TextEditingController(text: faq['question'] ?? ''),
              );
              faqAnswerControllers[code]!.add(
                TextEditingController(text: faq['answer'] ?? ''),
              );
            }
          }
        }
        // ignore: empty_catches
      } catch (_) {}
    }
  }

  Map<String, List<Map<String, String>>> getFaqData() {
    final Map<String, List<Map<String, String>>> faqData = {};

    if (form3StateKey.currentState != null) {
      try {
        form3StateKey.currentState!.saveData();
      } catch (_) {}
    }

    _syncFaqDataFromForm3();

    if (form3StateKey.currentState != null) {
      try {
        final form3FaqData = form3StateKey.currentState!.getFaqData();
        if (form3FaqData.isNotEmpty) {
          return form3FaqData;
        }
        // ignore: empty_catches
      } catch (_) {}
    }

    if (languages.isNotEmpty && faqQuestionControllers.isNotEmpty) {
      for (var lang in languages) {
        final String code = lang.languageCode;
        final questions = faqQuestionControllers[code] ?? [];
        final answers = faqAnswerControllers[code] ?? [];

        final List<Map<String, String>> langFaqs = [];

        for (int i = 0; i < questions.length && i < answers.length; i++) {
          final question = questions[i].text.trim();
          final answer = answers[i].text.trim();

          if (question.isNotEmpty && answer.isNotEmpty) {
            langFaqs.add({'question': question, 'answer': answer});
          }
        }

        if (langFaqs.isNotEmpty) {
          faqData[code] = langFaqs;
        }
      }
    }

    return faqData;
  }

  Map<String, String> getSeoTitleData() {
    final Map<String, String> seoTitleData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = seoTitleControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        seoTitleData[code] = controller.text.trim();
      }
    }

    return seoTitleData;
  }

  Map<String, String> getSeoDescriptionData() {
    final Map<String, String> seoDescriptionData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = seoDescriptionControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        seoDescriptionData[code] = controller.text.trim();
      }
    }

    return seoDescriptionData;
  }

  Map<String, String> getSeoKeywordsData() {
    final Map<String, String> seoKeywordsData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = seoKeywordsControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        seoKeywordsData[code] = controller.text.trim();
      }
    }

    return seoKeywordsData;
  }

  Map<String, String> getSeoSchemaMarkupData() {
    final Map<String, String> seoSchemaMarkupData = {};

    for (var lang in languages) {
      final String code = lang.languageCode;
      final controller = seoSchemaMarkupControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        seoSchemaMarkupData[code] = controller.text.trim();
      }
    }

    return seoSchemaMarkupData;
  }

  Future showCameraAndGalleryOption({
    required PickImage imageController,
    required String title,
  }) {
    return UiUtils.showModelBottomSheets(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      useSafeArea: true,
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

  @override
  void initState() {
    super.initState();
    _initializeEmptyControllers();
    _initializeLanguages();
    _fillPrices();
    Future.delayed(Duration.zero, () async {
      await context.read<FetchCountrySettingsCubit>().ensureLoaded();
      if (!mounted) return;
      // The country's decimal places may only be known now.
      _fillPrices();
      if (context.read<ProviderDetailsCubit>().getProviderType() == "0") {
        memReqTaskController.text = "1";
      }
    });
    selectedCategory = int.parse(widget.service?.categoryId ?? '0');
    selectedCategoryTitle = widget.service?.categoryName;

    selectedTax = int.parse(widget.service?.taxId ?? '0');
    selectedTaxTitle = widget.service?.taxId == null
        ? ''
        : '${widget.service?.translatedTaxTitle ?? widget.service?.taxTitle}';

    if (widget.service != null) {
      serviceTitleController.text = widget.service!.title ?? '';
      serviceDescrController.text = widget.service!.description ?? '';
      serviceTagController.text = widget.service!.tags ?? '';
      longDescription = widget.service!.longDescription;

      if (widget.service!.faqs != null && widget.service!.faqs!.isNotEmpty) {
        faqQuestionTextEditors.value.clear();
        faqAnswersTextEditors.value.clear();

        for (final faq in widget.service!.faqs!) {
          faqQuestionTextEditors.value.add(
            TextEditingController(text: faq.question ?? ''),
          );
          faqAnswersTextEditors.value.add(
            TextEditingController(text: faq.answer ?? ''),
          );
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (selectedPriceType == null) {
      if (widget.service?.taxType == 'included') {
        selectedPriceType = {
          'title': 'taxIncluded'.translate(context: context),
          'value': '0',
        };
      } else {
        selectedPriceType = {
          'title': 'taxExcluded'.translate(context: context),
          'value': '1',
        };
      }
    }

    if (selectedDurationType == null) {
      final String durationTypeValue =
          widget.service?.durationType ?? 'minutes';
      selectedDurationType = {
        'title':
            (ServiceModel.durationTypeLabelKeys[durationTypeValue] ??
                    'minutesLbl')
                .translate(context: context),
        'value': durationTypeValue,
      };
    }

    super.didChangeDependencies();
  }

  void selectDurationTypeBottomSheet() {
    final List<Map<String, dynamic>> values = ServiceModel
        .durationTypeLabelKeys
        .entries
        .map(
          (entry) => {
            'title': entry.value.translate(context: context),
            'id': entry.key,
            'isSelected': selectedDurationType?['value'] == entry.key,
          },
        )
        .toList();

    UiUtils.showModelBottomSheets(
      context: context,
      child: SelectableListBottomSheet(
        bottomSheetTitle: 'selectDurationType',
        itemList: values,
      ),
    ).then((value) {
      if (value != null) {
        selectedDurationType = {
          'title': value['selectedItemName'],
          'value': value['selectedItemId'],
        };

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
        title: CustomText(
          widget.service?.id != null
              ? 'editServiceBtnLbl'.translate(context: context)
              : 'createServiceTxtLbl'.translate(context: context),
          color: Theme.of(context).colorScheme.blackColor,
          fontWeight: FontWeight.bold,
        ),
        leading: CustomBackArrow(
          onTap: () async {
            if (currIndex != 1) {
              await _saveCurrentFormData();
              setState(() {
                currIndex--;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 85),
          child: SizedBox(
            height: 85,
            child: EasyStepper(
              internalPadding: 0,
              borderThickness: 0,
              stepBorderRadius: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              showStepBorder: false,
              activeStep: currIndex - 1,
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
              finishedStepBackgroundColor: context.colorScheme.secondaryColor,
              finishedStepIconColor: context.colorScheme.accentColor,
              finishedStepBorderColor: context.colorScheme.accentColor,
              finishedStepBorderType: BorderType.normal,
              showLoadingAnimation: false,
              unreachedStepBackgroundColor: context.colorScheme.primaryColor
                  .withValues(alpha: 0.2),
              onStepReached: (index) async {
                if (index + 1 != currIndex) {
                  FormState? form = formKey1.currentState;
                  switch (currIndex) {
                    case 4:
                      form = formKey3.currentState;
                      break;
                    case 3:
                      form = formKeySEO.currentState;
                      break;
                    case 2:
                      form = formKey2.currentState;
                      break;
                    default:
                      form = formKey1.currentState;
                      break;
                  }

                  if (form != null) {
                    form.save();
                    if (form.validate()) {
                      setState(() {
                        currIndex = index + 1;
                      });
                      if (scrollController.hasClients &&
                          scrollController.offset != 0) {
                        scrollController.jumpTo(0);
                      }
                    }
                  } else {
                    setState(() {
                      currIndex = index + 1;
                    });
                    if (scrollController.hasClients &&
                        scrollController.offset != 0) {
                      scrollController.jumpTo(0);
                    }
                  }
                }
              },
              steps: List.generate(
                _participant.length,
                (index) => EasyStep(
                  customStep: CustomSvgPicture(
                    svgImage: AppAssets.bClock,
                    color: index <= currIndex - 1
                        ? context.colorScheme.accentColor
                        : context.colorScheme.lightGreyColor,
                  ),
                  customTitle: index == _participant.length - 1
                      ? Transform.translate(
                          offset: const Offset(-8, 0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 32),
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              _participant[index].translate(context: context),
                              textAlign: TextAlign.left,
                              color: index == currIndex - 1
                                  ? context.colorScheme.accentColor
                                  : context.colorScheme.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              maxLines: 2,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 4,
                            right: 4,
                          ),
                          alignment: index == 0
                              ? Alignment.centerRight
                              : Alignment.center,
                          child: CustomText(
                            _participant[index].translate(context: context),
                            textAlign: index == 0
                                ? TextAlign.right
                                : TextAlign.center,
                            color: index == currIndex - 1
                                ? context.colorScheme.accentColor
                                : context.colorScheme.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            maxLines: 2,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(),
      body: screenBuilder(currIndex),
    );
  }

  Widget screenBuilder(int currentPage) {
    Widget currentForm = Form1(
      key: form1StateKey,
      context: context,
      formKey1: formKey1,
      serviceTitleController: serviceTitleController,
      surviceSlugController: surviceSlugController,
      serviceTagController: serviceTagController,
      serviceDescrController: serviceDescrController,
      cancelBeforeController: cancelBeforeController,
      serviceTitleFocus: serviceTitleFocus,
      serviceSlugFocus: serviceSlugFocus,
      serviceTagFocus: serviceTagFocus,
      serviceDescrFocus: serviceDescrFocus,
      cancelBeforeFocus: cancelBeforeFocus,
      selectedCategoryTitle: selectedCategoryTitle,
      selectedTaxTitle: selectedTaxTitle,
      isPayLaterAllowed: isPayLaterAllowed,
      isStoreAllowed: isStoreAllowed,
      isDoorStepAllowed: isDoorStepAllowed,
      serviceStatus: serviceStatus,
      isCancelAllowed: isCancelAllowed,
      finalTagList: finalTagList,
      tagsList: tagsList,
      onCategorySelect: selectCategoryBottomSheet,
      onTaxSelect: selectTaxesBottomSheet,
      onPayLaterChanged: (value) {
        setState(() {
          isPayLaterAllowed = value;
        });
      },
      onStoreAllowedChanged: (value) {
        setState(() {
          isStoreAllowed = value;
        });
      },
      onDoorStepAllowedChanged: (value) {
        setState(() {
          isDoorStepAllowed = value;
        });
      },
      onStatusChanged: (value) {
        setState(() {
          serviceStatus = value;
        });
      },
      onCancelAllowedChanged: (value) {
        setState(() {
          isCancelAllowed = value;
        });
      },
      onTagAdded: _addTag,
      onTagRemoved: _removeTag,
      // Multi-language support
      languages: languages.isNotEmpty ? languages : null,
      defaultLanguage: defaultLanguage,
      selectedLanguageIndex: selectedLanguageIndex,
      onLanguageChanged: _onLanguageChanged,
      titleControllers: languages.isNotEmpty ? titleControllers : null,
      descriptionControllers: languages.isNotEmpty
          ? descriptionControllers
          : null,
      tagControllers: languages.isNotEmpty ? tagsControllers : null,
    );

    // Per-step padding — override per case as needed
    EdgeInsets stepPadding = const EdgeInsets.all(15);

    switch (currIndex) {
      case 5:
        stepPadding = EdgeInsets.zero;
        currentForm = Form4(
          key: form4StateKey,
          controller: controller,
          longDescription: longDescription,
          serviceId: widget.service?.id,
          // Multi-language support
          languages: languages,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          longDescriptionControllers: longDescriptionControllers,
        );

        break;
      case 4:
        currentForm = Form3(
          key: form3StateKey,
          formKey3: formKey3,
          faqQuestionTextEditors: faqQuestionTextEditors,
          faqAnswersTextEditors: faqAnswersTextEditors,
          context: context,
          // Multi-language support
          languages: languages.isNotEmpty ? languages : null,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          faqQuestionControllers: languages.isNotEmpty
              ? faqQuestionControllers
              : null,
          faqAnswerControllers: languages.isNotEmpty
              ? faqAnswerControllers
              : null,
        );

        break;
      case 3:
        currentForm = FormSEO(
          formKey: formKeySEO,
          seoTitleController: seoTitleController,
          seoDescriptionController: seoDescriptionController,
          seoKeywordsController: seoKeywordsController,
          seoSchemaMarkupController: seoSchemaMarkupController,
          pickSeoOgImage: pickSeoOgImage,
          seoTitleFocus: seoTitleFocus,
          seoDescriptionFocus: seoDescriptionFocus,
          seoKeywordsFocus: seoKeywordsFocus,
          seoSchemaMarkupFocus: seoSchemaMarkupFocus,
          pickedSeoOgImage: pickedSeoOgImagePath,
          showCameraAndGalleryOption: showCameraAndGalleryOption,
          service: widget.service,
          context: context,
          pickedLocalImages: pickedLocalImages,
          // Multi-language support
          languages: languages.isNotEmpty ? languages : null,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          titleControllers: languages.isNotEmpty ? seoTitleControllers : null,
          descriptionControllers: languages.isNotEmpty
              ? seoDescriptionControllers
              : null,
          keywordsControllers: languages.isNotEmpty
              ? seoKeywordsControllers
              : null,
          schemaMarkupControllers: languages.isNotEmpty
              ? seoSchemaMarkupControllers
              : null,
        );
        break;
      case 2:
        stepPadding = EdgeInsets.zero;
        currentForm = Form2(
          formKey2: formKey2,
          priceController: priceController,
          discountPriceController: discountPriceController,
          memReqTaskController: memReqTaskController,
          durationTaskController: durationTaskController,
          qtyAllowedTaskController: qtyAllowedTaskController,
          priceFocus: priceFocus,
          discountPriceFocus: discountPriceFocus,
          memReqTaskFocus: memReqTaskFocus,
          durationTaskFocus: durationTaskFocus,
          qtyAllowedTaskFocus: qtyAllowedTaskFocus,
          selectedPriceType: selectedPriceType,
          selectedTaxTitle: selectedTaxTitle,
          selectedDurationType: selectedDurationType,
          onDurationTypeSelect: selectDurationTypeBottomSheet,
          onPriceTypeSelect: () {
            final List<Map<String, dynamic>> values = [
              {
                'title': 'taxIncluded'.translate(context: context),
                'id': '0',
                "isSelected": selectedPriceType?["value"] == "0",
              },
              {
                'title': 'taxExcluded'.translate(context: context),
                'id': '1',
                "isSelected": selectedPriceType?["value"] == "1",
              },
            ];

            UiUtils.showModelBottomSheets(
              context: context,
              child: SelectableListBottomSheet(
                bottomSheetTitle: "priceType",
                itemList: values,
              ),
            ).then((value) {
              if (value != null) {
                selectedPriceType = {
                  'title': value["selectedItemName"],
                  'value': value["selectedItemId"],
                };

                setState(() {});
              }
            });
          },
          onTaxSelect: selectTaxesBottomSheet,
          imagePicker: imagePicker,
          pickedServiceImage: pickedServiceImage,
          selectedOtherImages: selectedOtherImages,
          previouslyAddedOtherImages: previouslyAddedOtherImages,
          selectedFiles: selectedFiles,
          previouslyAddedFiles: previouslyAddedFiles,
          onPreviousImageDeleted: (deletedImage) {
            deletedPreviouslyAddedImages.add(deletedImage);
          },
          onPreviousFileDeleted: (deletedFile) {
            deletedPreviouslyAddedFiles.add(deletedFile);
          },
          onServiceImagePick: (source) {
            pickedServiceImage = imagePicker.pickedFile?.path ?? '';
          },
          service: widget.service,
          context: context,
        );
        break;
      default:
        currentForm = Form1(
          key: form1StateKey,
          context: context,
          formKey1: formKey1,
          serviceTitleController: serviceTitleController,
          surviceSlugController: surviceSlugController,
          serviceTagController: serviceTagController,
          serviceDescrController: serviceDescrController,
          cancelBeforeController: cancelBeforeController,
          serviceTitleFocus: serviceTitleFocus,
          serviceSlugFocus: serviceSlugFocus,
          serviceTagFocus: serviceTagFocus,
          serviceDescrFocus: serviceDescrFocus,
          cancelBeforeFocus: cancelBeforeFocus,
          selectedCategoryTitle: selectedCategoryTitle,
          selectedTaxTitle: selectedTaxTitle,
          isPayLaterAllowed: isPayLaterAllowed,
          isStoreAllowed: isStoreAllowed,
          isDoorStepAllowed: isDoorStepAllowed,
          serviceStatus: serviceStatus,
          isCancelAllowed: isCancelAllowed,
          finalTagList: finalTagList,
          tagsList: tagsList,
          onCategorySelect: selectCategoryBottomSheet,
          onTaxSelect: selectTaxesBottomSheet,
          onPayLaterChanged: (value) {
            setState(() {
              isPayLaterAllowed = value;
            });
          },
          onStoreAllowedChanged: (value) {
            setState(() {
              isStoreAllowed = value;
            });
          },
          onDoorStepAllowedChanged: (value) {
            setState(() {
              isDoorStepAllowed = value;
            });
          },
          onStatusChanged: (value) {
            setState(() {
              serviceStatus = value;
            });
          },
          onCancelAllowedChanged: (value) {
            setState(() {
              isCancelAllowed = value;
            });
          },
          onTagAdded: _addTag,
          onTagRemoved: _removeTag,
          // Multi-language support
          languages: languages.isNotEmpty ? languages : null,
          defaultLanguage: defaultLanguage,
          selectedLanguageIndex: selectedLanguageIndex,
          onLanguageChanged: _onLanguageChanged,
          titleControllers: titleControllers.isNotEmpty
              ? titleControllers
              : null,
          descriptionControllers: descriptionControllers.isNotEmpty
              ? descriptionControllers
              : null,
          tagControllers: tagsControllers.isNotEmpty ? tagsControllers : null,
        );

        break;
    }
    return currIndex == 5
        ? currentForm
        : SingleChildScrollView(
            clipBehavior: Clip.none,
            padding: stepPadding,
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: currentForm,
          );
  }

  Future selectCategoryBottomSheet() {
    return UiUtils.showModelBottomSheets(
      context: context,
      enableDrag: true,
      child: CategorySelectorBottomSheet(
        categoryId: selectedCategory.toString(),
      ),
    ).then((value) {
      if (value != null && value is Map) {
        final categoryId = value['id'];
        final categoryNameValue = value['name'];
        if (categoryId != null) {
          selectedCategory = int.parse(categoryId.toString());
          selectedCategoryTitle = categoryNameValue?.toString();
          setState(() {});
        }
      }
    });
  }

  Future selectTaxesBottomSheet() {
    return UiUtils.showModelBottomSheets(
      context: context,
      enableDrag: true,
      child: BlocBuilder<FetchTaxesCubit, FetchTaxesState>(
        builder: (BuildContext context, FetchTaxesState state) {
          if (state is FetchTaxesFailure) {
            return Center(
              child: ErrorContainer(
                showRetryButton: false,
                onTapRetry: () {},
                errorMessage: state.errorMessage,
              ),
            );
          }
          if (state is FetchTaxesSuccess) {
            if (state.taxes.isEmpty) {
              return NoDataContainer(
                title: 'noDataFound'.translate(context: context),
                subTitle: 'noDataFoundSubTitle'.translate(context: context),
              );
            }
            final List<Map<String, dynamic>> itemList = [];
            state.taxes.forEach((element) {
              itemList.add({
                "title": "${element.translatedTitle ?? element.title}",
                "id": element.id,
                "isSelected": selectedTax == int.parse(element.id ?? '0'),
              });
            });

            return SelectableListBottomSheet(
              bottomSheetTitle: "chooseTaxes",
              itemList: itemList,
            );
          }
          return Center(
            child: CustomCircularProgressIndicator(
              color: AppColors.whiteColors,
            ),
          );
        },
      ),
    ).then((value) {
      if (value != null) {
        selectedTax = int.parse(value["selectedItemId"]);
        selectedTaxTitle = value["selectedItemName"];
        setState(() {});
      }
    });
  }

  Future<void> _saveCurrentFormData() async {
    try {
      if (currIndex == 5) {
        final tempText = await controller.getText();
        if (tempText.trim().isNotEmpty) {
          longDescription = tempText;
          if (languages.isNotEmpty &&
              selectedLanguageIndex < languages.length) {
            final langCode = languages[selectedLanguageIndex].languageCode;
            longDescriptionControllers[langCode]?.text = tempText;
          }
        }
      }

      switch (currIndex) {
        case 1:
          formKey1.currentState?.save();
          break;
        case 2:
          formKey2.currentState?.save();
          break;
        case 3:
          formKeySEO.currentState?.save();
          break;
        case 4:
          formKey3.currentState?.save();
          if (form3StateKey.currentState != null) {
            form3StateKey.currentState!.saveData();
          }
          break;
        case 5:
          break;
      }
    } catch (_) {}
  }

  Padding bottomNavigation() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomContainer(
        color: context.colorScheme.secondaryColor,
        padding: EdgeInsetsDirectional.only(
          start: 15,
          end: 15,
          top: 10,
          bottom: 10 + MediaQuery.of(context).padding.bottom,
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currIndex > 1) ...[
              Expanded(flex: 1, child: nextPrevBtnWidget(false)),
              const SizedBox(width: 10),
            ],
            Expanded(flex: 5, child: nextPrevBtnWidget(true)),
          ],
        ),
      ),
    );
  }

  CustomRoundedButton nextPrevBtnWidget(bool isNext) {
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
      onTap: () {
        UiUtils.removeFocus();
        onNextPrevBtnClick(isNext: isNext, currentPage: currIndex);
      },
      buttonTitleWidget: isNext && currIndex >= _participant.length
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
      child:
          context.watch<CreateServiceCubit>().state is CreateServiceInProgress
          ? CustomCircularProgressIndicator(color: AppColors.whiteColors)
          : null,
    );
  }

  Future<void> onNextPrevBtnClick({
    required bool isNext,
    required int currentPage,
  }) async {
    UiUtils.removeFocus();

    if (currIndex == 5) {
      try {
        final tempText = await controller.getText();
        longDescription = tempText;
        if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
          final langCode = languages[selectedLanguageIndex].languageCode;
          longDescriptionControllers[langCode]?.text = tempText;
        }
        controller.clearFocus();
      } catch (_) {}
    }
    if (isNext) {
      FormState? form = formKey1.currentState; //default value
      switch (currIndex) {
        case 4:
          form = formKey3.currentState;
          break;
        case 3:
          form = formKeySEO.currentState;
          break;
        case 2:
          form = formKey2.currentState;
          break;
        default:
          form = formKey1.currentState;
          break;
      }
      if (form == null && currIndex != 5) return;

      if (form != null) {
        form.save();
      }

      if (currIndex > 3 || form!.validate()) {
        await _saveCurrentFormData();

        if (currIndex < totalForms) {
          if (currIndex == 1) {
            final defaultLanguageData = form1StateKey.currentState
                ?.getDefaultLanguageData();
            final defaultTags = defaultLanguageData?['tags'] ?? '';
            final hasGlobalTags = finalTagList.isNotEmpty;
            final hasOldTags = tagsList.isNotEmpty;

            if (defaultTags.isEmpty && !hasGlobalTags && !hasOldTags) {
              UiUtils.showMessage(
                context,
                'pleaseAddTags',
                ToastificationType.error,
              );
              return;
            }
          }
          if (currIndex == 2) {
            if (!(imagePicker.pickedFile != null ||
                widget.service?.imageOfTheService != null ||
                pickedServiceImage != '')) {
              FocusScope.of(context).unfocus();
              UiUtils.showMessage(
                context,
                "selectServiceImageToContinue",
                ToastificationType.warning,
              );
              return;
            }
          }
          currIndex++;
          scrollController.jumpTo(0);
          setState(() {});
        } else {
          await _saveCurrentFormData();

          if (form3StateKey.currentState != null) {
            try {
              form3StateKey.currentState!.saveData();
            } catch (_) {}
          }

          if (!_isDefaultLanguageLongDescriptionFilled()) {
            UiUtils.showMessage(
              context,
              'pleaseAddLongDescriptionInDefaultLanguage'.translate(
                context: context,
              ),
              ToastificationType.warning,
            );
            return;
          }

          final Map<String, String> formTitles = getTitleData();
          final Map<String, String> formDescriptions = getDescriptionData();
          final Map<String, String> formTags = getTagsData();
          final Map<String, String> formLongDescriptions =
              getLongDescriptionData();
          final Map<String, List<Map<String, String>>> formFaqs = getFaqData();

          final Map<String, String> formSeoTitles = getSeoTitleData();
          final Map<String, String> formSeoDescriptions =
              getSeoDescriptionData();
          final Map<String, String> formSeoKeywords = getSeoKeywordsData();
          final Map<String, String> formSeoSchemaMarkup =
              getSeoSchemaMarkupData();

          final Map<String, dynamic> translatedFields = {
            'title': formTitles,
            'description': formDescriptions,
            'tags': formTags,
            'long_description': formLongDescriptions,
            'faqs': formFaqs,
            'seo_title': formSeoTitles,
            'seo_description': formSeoDescriptions,
            'seo_keywords': formSeoKeywords,
            'seo_schema_markup': formSeoSchemaMarkup,
          };

          final CreateServiceModel createServiceModel = CreateServiceModel(
            serviceId: widget.service?.id,
            title: serviceTitleController.text,
            slug: surviceSlugController.text,
            description: serviceDescrController.text,
            price: priceController.text,
            members: memReqTaskController.text,
            maxQty: qtyAllowedTaskController.text,
            duration: int.parse(durationTaskController.text),
            durationType: selectedDurationType?['value'] ?? 'minutes',
            cancelableTill: cancelBeforeController.text.trim().toString(),
            iscancelable: isCancelAllowed ? 1 : 0,
            is_pay_later_allowed: isPayLaterAllowed ? 1 : 0,
            isStoreAllowed: isStoreAllowed ? 1 : 0,
            status: serviceStatus ? "active" : "deactive",
            isDoorStepAllowed: isDoorStepAllowed ? 1 : 0,
            discounted_price: discountPriceController.text,
            image: pickedServiceImage,
            categories: selectedCategory.toString(),
            tax_type: priceTypeFilter[selectedPriceType?['value']],
            tags: finalTagList.isNotEmpty
                ? finalTagList.map((tag) => tag['text']).join(',')
                : tagsList.join(','),
            taxId: selectedTax.toString(),
            other_images: selectedOtherImages.value,
            files: selectedFiles.value,
            deletedOtherImages: deletedPreviouslyAddedImages.toList(),
            deletedFiles: deletedPreviouslyAddedFiles.toList(),
            long_description: longDescription,
            seoTitle: seoTitleController.text.trim().isEmpty
                ? null
                : seoTitleController.text.trim(),
            seoDescription: seoDescriptionController.text.trim().isEmpty
                ? null
                : seoDescriptionController.text.trim(),
            seoKeywords: seoKeywordsController.text.trim().isEmpty
                ? null
                : seoKeywordsController.text.trim(),
            seoSchemaMarkup: seoSchemaMarkupController.text.trim().isEmpty
                ? null
                : seoSchemaMarkupController.text.trim(),
            seoOgImage: pickedLocalImages['seoOgImage'],
            translatedFields: translatedFields,
          );

          if (imagePicker.pickedFile != null ||
              widget.service?.imageOfTheService != null ||
              pickedServiceImage != '') {
            if (context.read<CreateServiceCubit>().state
                    is CreateServiceInProgress ||
                context.read<CreateServiceCubit>().state
                    is CreateServiceSuccess) {
              return;
            } else {
              context.read<CreateServiceCubit>().createService(
                createServiceModel,
              );
            }
          } else {
            FocusScope.of(context).unfocus();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('imageRequired'.translate(context: context)),
                  content: Text(
                    'pleaseSelectImage'.translate(context: context),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('ok'.translate(context: context)),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } else if (currIndex > 1) {
      await _saveCurrentFormData();
      currIndex--;
      setState(() {});
    }
  }
}
