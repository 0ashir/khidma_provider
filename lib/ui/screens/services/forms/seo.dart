import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class FormSEO extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController seoTitleController;
  final TextEditingController seoDescriptionController;
  final TextEditingController seoKeywordsController;
  final TextEditingController seoSchemaMarkupController;
  final PickImage pickSeoOgImage;
  final FocusNode seoTitleFocus;
  final FocusNode seoDescriptionFocus;
  final FocusNode seoKeywordsFocus;
  final FocusNode seoSchemaMarkupFocus;
  final String pickedSeoOgImage;
  final Function showCameraAndGalleryOption;
  final ServiceModel? service;
  final BuildContext context;
  final Map<String, dynamic> pickedLocalImages;

  // Multi-language support
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? titleControllers;
  final Map<String, TextEditingController>? descriptionControllers;
  final Map<String, TextEditingController>? keywordsControllers;
  final Map<String, TextEditingController>? schemaMarkupControllers;

  const FormSEO({
    Key? key,
    required this.formKey,
    required this.seoTitleController,
    required this.seoDescriptionController,
    required this.seoKeywordsController,
    required this.seoSchemaMarkupController,
    required this.pickSeoOgImage,
    required this.seoTitleFocus,
    required this.seoDescriptionFocus,
    required this.seoKeywordsFocus,
    required this.seoSchemaMarkupFocus,
    required this.pickedSeoOgImage,
    required this.showCameraAndGalleryOption,
    required this.service,
    required this.context,
    required this.pickedLocalImages,
    // Multi-language support
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.titleControllers,
    this.descriptionControllers,
    this.keywordsControllers,
    this.schemaMarkupControllers,
  }) : super(key: key);

  @override
  State<FormSEO> createState() => _FormSEOState();
}

class _FormSEOState extends State<FormSEO> {
  // Use parent's language data if available, otherwise fallback to internal system
  int get selectedLanguageIndex =>
      widget.selectedLanguageIndex ?? _internalSelectedLanguageIndex;
  int _internalSelectedLanguageIndex = 0;

  // Language-specific controllers - use parent's if available
  Map<String, TextEditingController> get titleControllers =>
      widget.titleControllers ?? _internalTitleControllers;

  Map<String, TextEditingController> get descriptionControllers =>
      widget.descriptionControllers ?? _internalDescriptionControllers;

  Map<String, TextEditingController> get keywordsControllers =>
      widget.keywordsControllers ?? _internalKeywordsControllers;

  Map<String, TextEditingController> get schemaMarkupControllers =>
      widget.schemaMarkupControllers ?? _internalSchemaMarkupControllers;

  // Internal controllers as fallback
  Map<String, TextEditingController> _internalTitleControllers = {};
  Map<String, TextEditingController> _internalDescriptionControllers = {};
  Map<String, TextEditingController> _internalKeywordsControllers = {};
  Map<String, TextEditingController> _internalSchemaMarkupControllers = {};

  // Language-specific keyword lists (similar to tags in Form1)
  Map<String, List<Map<String, dynamic>>> languageKeywordLists = {};

  List<Map<String, String>> languages = [];
  StreamSubscription? _languageListSubscription;

  TextEditingController keywordInputController = TextEditingController();
  List<Map<String, dynamic>> finalKeywordsList = [];

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
  }

  @override
  void didUpdateWidget(FormSEO oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update language index if it actually changed from parent
    if (widget.selectedLanguageIndex != oldWidget.selectedLanguageIndex) {
      // Update internal language index to match parent
      _internalSelectedLanguageIndex = widget.selectedLanguageIndex ?? 0;

      // Load keyword data for the newly selected language
      _loadKeywordDataForCurrentLanguage();

      // Force UI update
      setState(() {});
    }
  }

  void _initializeLanguages() {
    final cubit = context.read<LanguageListCubit>();
    final currentLang = HiveRepository.getCurrentLanguage();

    if (currentLang == null) return;

    // Trigger fetching language list from cubit
    cubit.getLanguageList();

    // Cancel previous subscription if exists
    _languageListSubscription?.cancel();

    // Listen to cubit state once and initialize languages when success
    _languageListSubscription = cubit.stream.listen((state) {
      if (!mounted) return; // Check if widget is still mounted

      if (state is GetLanguageListSuccess) {
        // Put default language first, then other languages
        final defaultLanguage = state.defaultLanguage;
        if (defaultLanguage != null) {
          languages = [
            {
              'code': defaultLanguage.languageCode,
              'name': defaultLanguage.languageName,
            },
            ...state.languages
                .where(
                  (lang) => lang.languageCode != defaultLanguage.languageCode,
                )
                .map(
                  (lang) => {
                    'code': lang.languageCode,
                    'name': lang.languageName.split(' - ').last,
                  },
                )
                .toList(),
          ];
        } else {
          // Fallback to current language first if no default language
          languages = [
            {
              'code': currentLang.languageCode,
              'name': currentLang.languageName,
            },
            ...state.languages
                .where((lang) => lang.languageCode != currentLang.languageCode)
                .map(
                  (lang) => {
                    'code': lang.languageCode,
                    'name': lang.languageName.split(' - ').last,
                  },
                )
                .toList(),
          ];
        }

        // Initialize controllers after languages are loaded
        _initializeControllers();
        if (mounted) {
          setState(
            () {},
          ); // Refresh UI if needed only if widget is still mounted
        }

        // Cancel subscription after successful initialization to prevent memory leaks
        _languageListSubscription?.cancel();
        _languageListSubscription = null;
      }
    });
  }

  void _initializeControllers() {
    // Only initialize internal controllers if parent's controllers are not available
    if (widget.titleControllers == null) {
      _internalTitleControllers.clear();
    }
    if (widget.descriptionControllers == null) {
      _internalDescriptionControllers.clear();
    }
    if (widget.keywordsControllers == null) {
      _internalKeywordsControllers.clear();
    }
    if (widget.schemaMarkupControllers == null) {
      _internalSchemaMarkupControllers.clear();
    }

    languageKeywordLists = {};

    for (int i = 0; i < languages.length; i++) {
      final lang = languages[i];
      final String code = lang['code']!;
      final isDefaultLanguage = i == 0; // First language is default language

      // Only initialize internal controllers if parent's controllers are not available
      if (widget.titleControllers == null) {
        _internalTitleControllers[code] = TextEditingController(
          text: isDefaultLanguage ? widget.seoTitleController.text : '',
        );
      }
      if (widget.descriptionControllers == null) {
        _internalDescriptionControllers[code] = TextEditingController(
          text: isDefaultLanguage ? widget.seoDescriptionController.text : '',
        );
      }
      if (widget.keywordsControllers == null) {
        _internalKeywordsControllers[code] = TextEditingController();
      }
      if (widget.schemaMarkupControllers == null) {
        _internalSchemaMarkupControllers[code] = TextEditingController(
          text: isDefaultLanguage ? widget.seoSchemaMarkupController.text : '',
        );
      }

      // Add listeners to auto-save data for this specific language (with disposal check)
      final titleController = titleControllers[code];
      if (titleController != null) {
        try {
          titleController.addListener(() {
            if (mounted) {
              // For default language, also save to main controller
              if (isDefaultLanguage) {
                widget.seoTitleController.text = titleController.text;
              }
            }
          });
        } catch (e) {
          // Controller might be disposed, skip adding listener
        }
      }

      final descriptionController = descriptionControllers[code];
      if (descriptionController != null) {
        try {
          descriptionController.addListener(() {
            if (mounted) {
              // For default language, also save to main controller
              if (isDefaultLanguage) {
                widget.seoDescriptionController.text =
                    descriptionController.text;
              }
            }
          });
        } catch (e) {
          // Controller might be disposed, skip adding listener
        }
      }

      final schemaMarkupController = schemaMarkupControllers[code];
      if (schemaMarkupController != null) {
        try {
          schemaMarkupController.addListener(() {
            if (mounted) {
              // For default language, also save to main controller
              if (isDefaultLanguage) {
                widget.seoSchemaMarkupController.text =
                    schemaMarkupController.text;
              }
            }
          });
        } catch (e) {
          // Controller might be disposed, skip adding listener
        }
      }

      // Initialize empty keyword list for each language
      languageKeywordLists[code] = [];

      // Populate keywords from parent's keyword controllers if available
      final keywordController = keywordsControllers[code];
      if (keywordController != null &&
          keywordController.text.trim().isNotEmpty) {
        // Convert comma-separated keywords back to keyword objects
        final keywordTexts = keywordController.text
            .split(',')
            .map((keyword) => keyword.trim())
            .where((keyword) => keyword.isNotEmpty)
            .toList();

        languageKeywordLists[code] = keywordTexts
            .asMap()
            .map((index, text) => MapEntry(index, {'id': index, 'text': text}))
            .values
            .toList();
      }
      // Fallback: For default language, copy existing keywords from widget if no controller data
      else if (isDefaultLanguage &&
          widget.seoKeywordsController.text.isNotEmpty) {
        final keywordTexts = widget.seoKeywordsController.text
            .split(',')
            .map((keyword) => keyword.trim())
            .where((keyword) => keyword.isNotEmpty)
            .toList();

        languageKeywordLists[code] = keywordTexts
            .asMap()
            .map((index, text) => MapEntry(index, {'id': index, 'text': text}))
            .values
            .toList();
      }
    }

    // Load keyword data for current language
    _loadKeywordDataForCurrentLanguage();
  }

  // Method to load keyword data for the current language from controllers
  void _loadKeywordDataForCurrentLanguage() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final keywordController = keywordsControllers[currentLangCode];

    if (keywordController != null && keywordController.text.trim().isNotEmpty) {
      // Convert comma-separated keywords back to keyword objects
      final keywordTexts = keywordController.text
          .split(',')
          .map((keyword) => keyword.trim())
          .where((keyword) => keyword.isNotEmpty)
          .toList();

      languageKeywordLists[currentLangCode] = keywordTexts
          .asMap()
          .map((index, text) => MapEntry(index, {'id': index, 'text': text}))
          .values
          .toList();
    } else {
      // If no keywords in controller, check if we already have keywords in languageKeywordLists
      if (!languageKeywordLists.containsKey(currentLangCode)) {
        languageKeywordLists[currentLangCode] = [];
      }
    }
  }

  // Method to save current language data (any language)
  void _saveCurrentLanguageData() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final currentTitleController = titleControllers[currentLangCode];
    final currentDescriptionController =
        descriptionControllers[currentLangCode];
    final currentSchemaMarkupController =
        schemaMarkupControllers[currentLangCode];

    // Save data for current language (no matter which language it is)
    if (currentTitleController != null &&
        currentDescriptionController != null &&
        currentSchemaMarkupController != null) {
      // Only save to main controllers if this is the default language (index 0)
      if (selectedLanguageIndex == 0) {
        widget.seoTitleController.text = currentTitleController.text;
        widget.seoDescriptionController.text =
            currentDescriptionController.text;
        widget.seoSchemaMarkupController.text =
            currentSchemaMarkupController.text;

        // Also save keywords to main keyword controller for default language
        if (languageKeywordLists[currentLangCode] != null) {
          final keywordsString = languageKeywordLists[currentLangCode]!
              .map((keyword) => keyword['text'])
              .join(', ');
          widget.seoKeywordsController.text = keywordsString;
        }
      }

      // Always save to parent's controllers if available
      if (widget.keywordsControllers != null) {
        final keywordController = widget.keywordsControllers![currentLangCode];
        if (keywordController != null &&
            languageKeywordLists[currentLangCode] != null) {
          // Convert keyword objects back to comma-separated string
          final keywordsString = languageKeywordLists[currentLangCode]!
              .map((keyword) => keyword['text'])
              .join(',');
          keywordController.text = keywordsString;
        }
      }
    }
  }

  void _onLanguageChanged(int index) {
    if (index >= 0 && index < languages.length) {
      // Save current language data before switching
      _saveCurrentLanguageData();

      setState(() {
        _internalSelectedLanguageIndex = index;
      });

      // Load keyword data for the newly selected language after a small delay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadKeywordDataForCurrentLanguage();
      });

      // Call parent's onLanguageChanged callback if available
      widget.onLanguageChanged?.call(index);

      // Clear form validation errors when switching languages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only clear validation state, not the field values
        if (widget.formKey.currentState != null) {
          // Force form to revalidate with current values
          widget.formKey.currentState!.validate();
        }
      });
    }
  }

  // Method to add keyword for current language
  void _addKeywordForCurrentLanguage(String keywordText) {
    if (keywordText.trim().isEmpty) return;

    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return;
    }

    final currentLangCode = languages[selectedLanguageIndex]['code'];
    if (currentLangCode == null) return;

    final currentKeywords = languageKeywordLists[currentLangCode] ?? [];

    // Create a new keyword with unique ID
    final newKeyword = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'text': keywordText.trim(),
    };

    // Add keyword to current language list
    languageKeywordLists[currentLangCode] = [...currentKeywords, newKeyword];

    // If this is the default language, also update main controller
    if (selectedLanguageIndex == 0) {
      _updateFinalKeywordsList();
    }

    // Save keywords to parent's controllers
    _saveCurrentLanguageData();

    // Clear the keyword input field
    keywordInputController.clear();

    setState(() {});
  }

  // Method to remove keyword for current language
  void _removeKeywordForCurrentLanguage(int keywordId) {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return;
    }

    final currentLangCode = languages[selectedLanguageIndex]['code'];
    if (currentLangCode == null) return;

    final currentKeywords = languageKeywordLists[currentLangCode] ?? [];

    // Remove from current language list
    languageKeywordLists[currentLangCode] = currentKeywords
        .where((keyword) => keyword['id'] != keywordId)
        .toList();

    // If this is the default language, also update main controller
    if (selectedLanguageIndex == 0) {
      _updateFinalKeywordsList();
    }

    // Save keywords to parent's controllers
    _saveCurrentLanguageData();

    setState(() {});
  }

  void _updateFinalKeywordsList() {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return;
    }

    final currentLangCode = languages[selectedLanguageIndex]['code'];
    if (currentLangCode == null) return;

    final currentKeywords = languageKeywordLists[currentLangCode] ?? [];
    finalKeywordsList.clear();
    finalKeywordsList.addAll(currentKeywords);

    // Update the main controller with comma-separated values (for default language only)
    if (selectedLanguageIndex == 0) {
      widget.seoKeywordsController.text = currentKeywords
          .map((keyword) => keyword['text'])
          .join(', ');
    }
  }

  @override
  void dispose() {
    // Save current language data before disposing
    _saveCurrentLanguageData();

    // Cancel stream subscription to prevent memory leaks
    _languageListSubscription?.cancel();

    keywordInputController.dispose();

    // Only dispose internal controllers if they were created by this widget
    if (widget.titleControllers == null) {
      for (var controller in _internalTitleControllers.values) {
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
    }
    if (widget.descriptionControllers == null) {
      for (var controller in _internalDescriptionControllers.values) {
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
    }
    if (widget.keywordsControllers == null) {
      for (var controller in _internalKeywordsControllers.values) {
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
    }
    if (widget.schemaMarkupControllers == null) {
      for (var controller in _internalSchemaMarkupControllers.values) {
        try {
          controller.dispose();
        } catch (e) {
          // Controller already disposed, ignore
        }
      }
    }

    super.dispose();
  }

  // Method to get language-specific data for saving
  Map<String, Map<String, String>> getLanguageData() {
    final Map<String, Map<String, String>> languageData = {};

    for (var lang in languages) {
      final String code = lang['code']!;
      final titleController = titleControllers[code];
      final descriptionController = descriptionControllers[code];
      final schemaMarkupController = schemaMarkupControllers[code];

      if (titleController != null &&
          descriptionController != null &&
          schemaMarkupController != null) {
        // Get keywords as comma-separated string for this language
        final keywordsList = languageKeywordLists[code] ?? [];
        final keywordsString = keywordsList
            .map((keyword) => keyword['text'])
            .join(',');

        final langData = {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'keywords': keywordsString,
          'schema_markup': schemaMarkupController.text.trim(),
        };

        languageData[code] = langData;
      }
    }

    return languageData;
  }

  // Method to get titles for all languages
  Map<String, String> getTitleData() {
    final Map<String, String> titleData = {};

    // Collect data from all language controllers
    for (var lang in languages) {
      final String code = lang['code']!;
      final controller = titleControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        titleData[code] = controller.text.trim();
      }
    }

    return titleData;
  }

  // Method to get descriptions for all languages
  Map<String, String> getDescriptionData() {
    final Map<String, String> descriptionData = {};

    for (var lang in languages) {
      final String code = lang['code']!;
      final controller = descriptionControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        descriptionData[code] = controller.text.trim();
      }
    }

    return descriptionData;
  }

  // Method to get keywords for all languages
  Map<String, String> getKeywordData() {
    final Map<String, String> keywordData = {};

    for (var lang in languages) {
      final String code = lang['code']!;
      final keywordsList = languageKeywordLists[code] ?? [];
      if (keywordsList.isNotEmpty) {
        final keywordsString = keywordsList
            .map((keyword) => keyword['text'])
            .join(',');
        keywordData[code] = keywordsString;
      }
    }

    return keywordData;
  }

  // Method to get schema markup for all languages
  Map<String, String> getSchemaMarkupData() {
    final Map<String, String> schemaMarkupData = {};

    for (var lang in languages) {
      final String code = lang['code']!;
      final controller = schemaMarkupControllers[code];
      if (controller != null && controller.text.trim().isNotEmpty) {
        schemaMarkupData[code] = controller.text.trim();
      }
    }

    return schemaMarkupData;
  }

  // Method to restore multi-language data from saved data
  void restoreSavedLanguageData(
    Map<String, Map<String, String>> savedLanguageData,
    Map<String, List<Map<String, dynamic>>> savedLanguageKeywordLists,
  ) {
    if (savedLanguageData.isEmpty) return;

    for (var lang in languages) {
      final String code = lang['code']!;
      final languageData = savedLanguageData[code];
      final savedKeywords = savedLanguageKeywordLists[code] ?? [];

      if (languageData != null) {
        // Restore title, description, and schema markup
        titleControllers[code]?.text = languageData['title'] ?? '';
        descriptionControllers[code]?.text = languageData['description'] ?? '';
        schemaMarkupControllers[code]?.text =
            languageData['schema_markup'] ?? '';

        // Restore keywords
        languageKeywordLists[code] = List<Map<String, dynamic>>.from(
          savedKeywords,
        );
      }
    }

    // Sync restored data back to main controllers
    syncLanguageControllersToMainControllers();

    if (mounted) {
      setState(() {});
    }
  }

  // Method to sync language controllers back to main controllers
  void syncLanguageControllersToMainControllers() {
    if (languages.isEmpty) return;

    final defaultLangCode = languages[0]['code']!;

    // Sync default language controller back to main controllers
    if (titleControllers[defaultLangCode] != null) {
      widget.seoTitleController.text = titleControllers[defaultLangCode]!.text;
    }

    if (descriptionControllers[defaultLangCode] != null) {
      widget.seoDescriptionController.text =
          descriptionControllers[defaultLangCode]!.text;
    }

    if (schemaMarkupControllers[defaultLangCode] != null) {
      widget.seoSchemaMarkupController.text =
          schemaMarkupControllers[defaultLangCode]!.text;
    }

    // Sync keywords back to main keyword controller
    if (languageKeywordLists[defaultLangCode] != null) {
      final keywordsString = languageKeywordLists[defaultLangCode]!
          .map((keyword) => keyword['text'])
          .join(', ');
      widget.seoKeywordsController.text = keywordsString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show shimmer effect if languages are not yet loaded
    if (languages.isEmpty) {
      return const ShimmerLoadingContainer(
        child: Column(
          children: [
            CustomShimmerContainer(
              height: 50,
              margin: EdgeInsets.only(bottom: 20),
            ),
            CustomShimmerContainer(
              height: 100,
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
          ],
        ),
      );
    }

    // Ensure selectedLanguageIndex is valid
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      _internalSelectedLanguageIndex = 0;
    }

    // Update finalKeywordsList for current language
    _updateFinalKeywordsList();

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language Tabs (only show if more than one language)
          if (languages.length > 1)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: languages.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<String, String> language = entry.value;
                    final bool isSelected = selectedLanguageIndex == index;

                    return GestureDetector(
                      onTap: () => _onLanguageChanged(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        constraints: const BoxConstraints(minWidth: 80),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.accentColor
                              : Theme.of(context).colorScheme.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.accentColor
                                : Theme.of(context).colorScheme.lightGreyColor,
                          ),
                        ),
                        child: Text(
                          language['name']!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.lightPrimaryColor
                                : Theme.of(context).colorScheme.blackColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          const SizedBox(height: 10),
          CustomTextFormField(
            bottomPadding: 15,
            labelText: selectedLanguageIndex == 0
                ? 'seoTitle'.translate(context: context)
                : '${'seoTitle'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? 'enterSeoTitle'.translate(context: context)
                : '${'enterSeoTitle'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller:
                titleControllers[languages[selectedLanguageIndex]['code']] ??
                widget.seoTitleController,
            currentFocusNode: widget.seoTitleFocus,
            nextFocusNode: widget.seoDescriptionFocus,
          ),
          CustomTextFormField(
            labelText: selectedLanguageIndex == 0
                ? 'seoDescription'.translate(context: context)
                : '${'seoDescription'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? null
                : '${'seoDescription'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller:
                descriptionControllers[languages[selectedLanguageIndex]['code']] ??
                widget.seoDescriptionController,
            expands: true,
            minLines: 5,
            currentFocusNode: widget.seoDescriptionFocus,
            bottomPadding: 20,
            textInputType: TextInputType.multiline,
          ),
          CustomTextFormField(
            labelText: selectedLanguageIndex == 0
                ? 'seoKeywords'.translate(context: context)
                : '${'seoKeywords'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? 'enterSeoKeywords'.translate(context: context)
                : '${'enterSeoKeywords'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller: keywordInputController,
            currentFocusNode: widget.seoKeywordsFocus,
            forceUnFocus: false,
            bottomPadding: finalKeywordsList.isEmpty ? 15 : 0,
            suffixIcon: IconButton(
              onPressed: () {
                if (keywordInputController.text.isNotEmpty) {
                  _addKeywordForCurrentLanguage(keywordInputController.text);
                  FocusScope.of(context).unfocus();
                }
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.accentColor,
              ),
            ),
            onSubmit: () {
              if (keywordInputController.text.isNotEmpty) {
                _addKeywordForCurrentLanguage(keywordInputController.text);
              }
            },
            callback: () {},
          ),
          Wrap(
            children: finalKeywordsList.map((Map<String, dynamic> item) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 10, top: 5),
                child: SizedBox(
                  height: 35,
                  child: Chip(
                    backgroundColor: Theme.of(context).colorScheme.primaryColor,
                    label: Text(item['text']),
                    onDeleted: () {
                      _removeKeywordForCurrentLanguage(item['id']);
                    },
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        UiUtils.borderRadiusOf10,
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.lightGreyColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (finalKeywordsList.isNotEmpty) const SizedBox(height: 15),
          CustomText(
            'seoKeywordsHint'.translate(context: context),
            fontSize: 12,
            color: context.colorScheme.lightGreyColor,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 15),
          CustomTextFormField(
            bottomPadding: 15,
            labelText: selectedLanguageIndex == 0
                ? 'seoSchemaMarkup'.translate(context: context)
                : '${'seoSchemaMarkup'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? 'enterSeoSchemaMarkup'.translate(context: context)
                : '${'enterSeoSchemaMarkup'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller:
                schemaMarkupControllers[languages[selectedLanguageIndex]['code']] ??
                widget.seoSchemaMarkupController,
            currentFocusNode: widget.seoSchemaMarkupFocus,
            textInputType: TextInputType.multiline,
            minLines: 4,
            expands: true,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Expanded(child: Divider(thickness: 0.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomText(
                  'seoOgImage'.translate(context: context),
                  color: Theme.of(context).colorScheme.blackColor,
                ),
              ),
              const Expanded(child: Divider(thickness: 0.5)),
            ],
          ),
          const SizedBox(height: 15),
          CustomText(
            'SEOImageRecommend'.translate(context: context),
            color: Theme.of(context).colorScheme.blackColor,
            fontSize: 12,
          ),
          const SizedBox(height: 5),
          _seoOgImagePicker(
            context,
            imageController: widget.pickSeoOgImage,
            oldImage: widget.service?.seoOgImage ?? '',
            hintLabel: 'uploadSeoOgImage'.translate(context: context),
            imageType: 'seoOgImage',
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _seoOgImagePicker(
    BuildContext context, {
    required PickImage imageController,
    required String oldImage,
    required String hintLabel,
    required String imageType,
  }) {
    return imageController.ListenImageChange((BuildContext context, image) {
      if (image == null) {
        // Check if there's a locally picked image first
        if (widget.pickedLocalImages[imageType] != null &&
            widget.pickedLocalImages[imageType] != '') {
          return GestureDetector(
            onTap: () {
              widget.showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              );
            },
            child: CustomContainer(
              borderRadius: UiUtils.borderRadiusOf10,
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(UiUtils.borderRadiusOf10),
                ),
                child: Image.file(
                  File(widget.pickedLocalImages[imageType]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        if (oldImage.isNotEmpty && oldImage != 'null') {
          return GestureDetector(
            onTap: () {
              widget.showCameraAndGalleryOption(
                imageController: imageController,
                title: hintLabel,
              );
            },
            child: Stack(
              children: [
                // Background image
                CustomContainer(
                  borderRadius: UiUtils.borderRadiusOf10,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
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
                // Transparent overlay with upload UI
                CustomContainer(
                  borderRadius: UiUtils.borderRadiusOf10,
                  color: context.colorScheme.accentColor.withAlpha(2),
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  border: Border.all(
                    color: context.colorScheme.accentColor,
                    width: 1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvgPicture(
                        svgImage: AppAssets.camera,
                        color: context.colorScheme.accentColor,
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return CustomInkWellContainer(
          onTap: () {
            widget.showCameraAndGalleryOption(
              imageController: imageController,
              title: hintLabel,
            );
          },
          child: CustomContainer(
            borderRadius: UiUtils.borderRadiusOf10,
            color: context.colorScheme.accentColor.withAlpha(20),
            height: 150,
            width: MediaQuery.of(context).size.width,
            border: Border.all(
              color: context.colorScheme.accentColor,
              width: 1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgPicture(
                  svgImage: AppAssets.camera,
                  color: context.colorScheme.accentColor,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(height: 10),
                CustomText(
                  hintLabel,
                  color: context.colorScheme.accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        );
      }

      // Update pickedLocalImages when new image is selected
      widget.pickedLocalImages[imageType] = image?.path;

      return GestureDetector(
        onTap: () {
          widget.showCameraAndGalleryOption(
            imageController: imageController,
            title: hintLabel,
          );
        },
        child: CustomContainer(
          borderRadius: UiUtils.borderRadiusOf10,
          height: 150,
          width: MediaQuery.of(context).size.width,
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
}
