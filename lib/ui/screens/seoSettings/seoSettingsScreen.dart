import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';

import '../auth/widgets/seo.dart';

class SeoSettingsScreen extends StatefulWidget {
  const SeoSettingsScreen({super.key});

  @override
  State<SeoSettingsScreen> createState() => _SeoSettingsScreenState();

  static Route<SeoSettingsScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<FetchSeoSettingsCubit>(
            create: (_) => FetchSeoSettingsCubit()..fetchSeoSettings(),
          ),
          BlocProvider<ManageSeoSettingsCubit>(
            create: (_) => ManageSeoSettingsCubit(),
          ),
        ],
        child: const SeoSettingsScreen(),
      ),
    );
  }
}

class _SeoSettingsScreenState extends State<SeoSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController seoTitleController = TextEditingController();
  TextEditingController seoDescriptionController = TextEditingController();
  TextEditingController seoKeywordsController = TextEditingController();
  TextEditingController seoSchemaMarkupController = TextEditingController();

  FocusNode seoTitleFocus = FocusNode();
  FocusNode seoDescriptionFocus = FocusNode();
  FocusNode seoKeywordsFocus = FocusNode();
  FocusNode seoSchemaMarkupFocus = FocusNode();

  PickImage pickSeoOgImage = PickImage();
  Map<String, dynamic> pickedLocalImages = {};

  List<AppLanguage> languages = [];
  AppLanguage? defaultLanguage;
  int selectedLanguageIndex = 0;

  Map<String, TextEditingController> titleControllers = {};
  Map<String, TextEditingController> descriptionControllers = {};
  Map<String, TextEditingController> keywordsControllers = {};
  Map<String, TextEditingController> schemaMarkupControllers = {};

  String existingImageUrl = '';

  @override
  void initState() {
    super.initState();
    _initLanguages();
  }

  void _initLanguages() {
    final cubit = context.read<LanguageListCubit>();
    final currentLang = HiveRepository.getCurrentLanguage();
    if (currentLang == null) return;
    cubit.getLanguageList();
    cubit.stream.listen((state) {
      if (!mounted) return;
      if (state is GetLanguageListSuccess) {
        setState(() {
          languages = state.languages;
          defaultLanguage = state.defaultLanguage;
          if (defaultLanguage != null && languages.isNotEmpty) {
            final idx = languages.indexWhere(
              (l) => l.languageCode == defaultLanguage!.languageCode,
            );
            if (idx > 0) {
              final def = languages.removeAt(idx);
              languages.insert(0, def);
            }
          }
        });
        _initControllers(null);
      }
    });
  }

  void _initControllers(SeoSettingsData? data) {
    if (languages.isEmpty) return;

    for (final lang in languages) {
      final code = lang.languageCode;
      final isDefault =
          defaultLanguage != null && code == defaultLanguage!.languageCode;

      final translation = data?.translations[code];
      final title =
          translation?['seo_title'] ?? (isDefault ? (data?.title ?? '') : '');
      final description =
          translation?['seo_description'] ??
          (isDefault ? (data?.description ?? '') : '');
      final keywords =
          translation?['seo_keywords'] ??
          (isDefault ? (data?.keywords ?? '') : '');
      final schema =
          translation?['seo_schema_markup'] ??
          (isDefault ? (data?.schemaMarkup ?? '') : '');

      if (isDefault) {
        seoTitleController.text = title;
        seoDescriptionController.text = description;
        seoKeywordsController.text = keywords;
        seoSchemaMarkupController.text = schema;
        titleControllers[code] = seoTitleController;
        descriptionControllers[code] = seoDescriptionController;
        keywordsControllers[code] = seoKeywordsController;
        schemaMarkupControllers[code] = seoSchemaMarkupController;
      } else {
        titleControllers[code] = TextEditingController(text: title);
        descriptionControllers[code] = TextEditingController(text: description);
        keywordsControllers[code] = TextEditingController(text: keywords);
        schemaMarkupControllers[code] = TextEditingController(text: schema);
      }
    }

    if (data != null) {
      existingImageUrl = data.image;
    }

    if (mounted) setState(() {});
  }

  void _onDataLoaded(SeoSettingsData data) {
    _initControllers(data);
  }

  void _onLanguageChanged(int index) {
    setState(() {
      selectedLanguageIndex = index;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final translationsMap = <String, dynamic>{};
    for (final lang in languages) {
      final code = lang.languageCode;
      translationsMap[code] = {
        'seo_title': titleControllers[code]?.text.trim() ?? '',
        'seo_description': descriptionControllers[code]?.text.trim() ?? '',
        'seo_keywords': keywordsControllers[code]?.text.trim() ?? '',
        'seo_schema_markup': schemaMarkupControllers[code]?.text.trim() ?? '',
      };
    }

    final Map<String, dynamic> parameters = {
      'translations': jsonEncode(translationsMap),
    };

    final pickedImage = pickSeoOgImage.pickedFile;
    if (pickedImage != null) {
      parameters['meta_image'] = await MultipartFile.fromFile(pickedImage.path);
    }

    if (mounted) {
      context.read<ManageSeoSettingsCubit>().manageSeoSettings(
        parameters: parameters,
      );
    }
  }

  Future<void> _showCameraAndGalleryOption({
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

  @override
  void dispose() {
    seoTitleController.dispose();
    seoDescriptionController.dispose();
    seoKeywordsController.dispose();
    seoSchemaMarkupController.dispose();
    seoTitleFocus.dispose();
    seoDescriptionFocus.dispose();
    seoKeywordsFocus.dispose();
    seoSchemaMarkupFocus.dispose();
    pickSeoOgImage.dispose();
    for (final ctrl in titleControllers.values) ctrl.dispose();
    for (final ctrl in descriptionControllers.values) ctrl.dispose();
    for (final ctrl in keywordsControllers.values) ctrl.dispose();
    for (final ctrl in schemaMarkupControllers.values) ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'seo'.translate(context: context),
        ),
        body: BlocConsumer<FetchSeoSettingsCubit, FetchSeoSettingsState>(
          listener: (context, state) {
            if (state is FetchSeoSettingsSuccess) {
              _onDataLoaded(state.data);
            } else if (state is FetchSeoSettingsFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
          },
          builder: (context, fetchState) {
            if (fetchState is FetchSeoSettingsInProgress) {
              return const Center(child: CustomCircularProgressIndicator());
            }
            if (fetchState is FetchSeoSettingsFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessage: fetchState.errorMessage,
                  onTapRetry: () {
                    context.read<FetchSeoSettingsCubit>().fetchSeoSettings();
                  },
                ),
              );
            }
            return BlocListener<ManageSeoSettingsCubit, ManageSeoSettingsState>(
              listener: (context, state) {
                if (state is ManageSeoSettingsSuccess) {
                  UiUtils.showMessage(
                    context,
                    state.message,
                    ToastificationType.success,
                  );
                } else if (state is ManageSeoSettingsFailure) {
                  UiUtils.showMessage(
                    context,
                    state.errorMessage,
                    ToastificationType.error,
                  );
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SEO(
                      formKey: _formKey,
                      seoTitleController: seoTitleController,
                      seoDescriptionController: seoDescriptionController,
                      seoKeywordsController: seoKeywordsController,
                      seoSchemaMarkupController: seoSchemaMarkupController,
                      pickSeoOgImage: pickSeoOgImage,
                      seoTitleFocus: seoTitleFocus,
                      seoDescriptionFocus: seoDescriptionFocus,
                      seoKeywordsFocus: seoKeywordsFocus,
                      seoSchemaMarkupFocus: seoSchemaMarkupFocus,
                      pickedLocalImages: pickedLocalImages,
                      showCameraAndGalleryOption: _showCameraAndGalleryOption,
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
                      keywordsControllers: keywordsControllers.isNotEmpty
                          ? keywordsControllers
                          : null,
                      schemaMarkupControllers:
                          schemaMarkupControllers.isNotEmpty
                          ? schemaMarkupControllers
                          : null,
                      existingOgImageUrl: existingImageUrl.isNotEmpty
                          ? existingImageUrl
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child:
                          BlocBuilder<
                            ManageSeoSettingsCubit,
                            ManageSeoSettingsState
                          >(
                            builder: (context, state) {
                              return CustomRoundedButton(
                                widthPercentage: 1,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.accentColor,
                                showBorder: false,
                                buttonTitle: 'saveBtn'.translate(
                                  context: context,
                                ),
                                onTap: state is ManageSeoSettingsInProgress
                                    ? () {}
                                    : _submit,
                                child: state is ManageSeoSettingsInProgress
                                    ? CustomCircularProgressIndicator(
                                        color: AppColors.whiteColors,
                                      )
                                    : null,
                              );
                            },
                          ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
