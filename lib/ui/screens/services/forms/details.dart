import 'package:flutter/material.dart';
import 'package:edemand_partner/app/generalImports.dart';

class Form1 extends StatefulWidget {
  const Form1({
    super.key,
    required this.formKey1,
    required this.serviceTitleController,
    required this.surviceSlugController,
    required this.serviceTagController,
    required this.serviceDescrController,
    required this.cancelBeforeController,
    required this.serviceTitleFocus,
    required this.serviceSlugFocus,
    required this.serviceTagFocus,
    required this.serviceDescrFocus,
    required this.cancelBeforeFocus,
    required this.selectedCategoryTitle,
    required this.selectedTaxTitle,
    required this.isPayLaterAllowed,
    required this.isStoreAllowed,
    required this.isDoorStepAllowed,
    required this.serviceStatus,
    required this.isCancelAllowed,
    required this.finalTagList,
    required this.tagsList,
    required this.onCategorySelect,
    required this.onTaxSelect,
    required this.onPayLaterChanged,
    required this.onStoreAllowedChanged,
    required this.onDoorStepAllowedChanged,
    required this.onStatusChanged,
    required this.onCancelAllowedChanged,
    required this.onTagAdded,
    required this.onTagRemoved,
    required this.context,
    // Multi-language support
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.titleControllers,
    this.descriptionControllers,
    this.tagControllers,
  });

  final GlobalKey<FormState> formKey1;
  final TextEditingController serviceTitleController;
  final TextEditingController surviceSlugController;
  final TextEditingController serviceTagController;
  final TextEditingController serviceDescrController;
  final TextEditingController cancelBeforeController;
  final FocusNode serviceTitleFocus;
  final FocusNode serviceSlugFocus;
  final FocusNode serviceTagFocus;
  final FocusNode serviceDescrFocus;
  final FocusNode cancelBeforeFocus;
  final String? selectedCategoryTitle;
  final String selectedTaxTitle;
  final bool isPayLaterAllowed;
  final bool isStoreAllowed;
  final bool isDoorStepAllowed;
  final bool serviceStatus;
  final bool isCancelAllowed;
  final List<Map<String, dynamic>> finalTagList;
  final List<String> tagsList;
  final VoidCallback onCategorySelect;
  final VoidCallback onTaxSelect;
  final Function(bool) onPayLaterChanged;
  final Function(bool) onStoreAllowedChanged;
  final Function(bool) onDoorStepAllowedChanged;
  final Function(bool) onStatusChanged;
  final Function(bool) onCancelAllowedChanged;
  final Function(String) onTagAdded;
  final Function(int) onTagRemoved;
  final BuildContext context;

  // Multi-language support
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? titleControllers;
  final Map<String, TextEditingController>? descriptionControllers;
  final Map<String, TextEditingController>? tagControllers;

  @override
  State<Form1> createState() => Form1State();
}

class Form1State extends State<Form1> {
  // Use parent's language data if available, otherwise fallback to internal system
  int get selectedLanguageIndex =>
      widget.selectedLanguageIndex ?? _internalSelectedLanguageIndex;
  int _internalSelectedLanguageIndex = 0;

  // Language-specific controllers - use parent's if available
  Map<String, TextEditingController> get titleControllers =>
      widget.titleControllers ?? _internalTitleControllers;

  Map<String, TextEditingController> get descriptionControllers =>
      widget.descriptionControllers ?? _internalDescriptionControllers;

  Map<String, TextEditingController> get tagControllers =>
      widget.tagControllers ?? _internalTagControllers;

  // Internal controllers as fallback
  Map<String, TextEditingController> _internalTitleControllers = {};
  Map<String, TextEditingController> _internalDescriptionControllers = {};
  Map<String, TextEditingController> _internalTagControllers = {};

  // Language-specific tag lists
  Map<String, List<Map<String, dynamic>>> languageTagLists = {};

  List<Map<String, String>> languages = [];
  StreamSubscription? _languageListSubscription;

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
  }

  @override
  void didUpdateWidget(Form1 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update language index if it actually changed from parent
    if (widget.selectedLanguageIndex != oldWidget.selectedLanguageIndex) {
      // Update internal language index to match parent
      _internalSelectedLanguageIndex = widget.selectedLanguageIndex ?? 0;

      // Force UI update
      setState(() {});
    }
  }

  // Method to sync current language tags to main widget
  void _syncCurrentLanguageTagsToMainWidget() {
    if (languages.isEmpty) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final currentTags = languageTagLists[currentLangCode] ?? [];

    // Update main widget's tag list with current language tags
    widget.finalTagList.clear();
    widget.finalTagList.addAll(currentTags);
  }

  // Public method that forces UI update after restoration
  void forceRestoreAndUpdateUI(
    Map<String, Map<String, String>> savedLanguageData,
    Map<String, List<Map<String, dynamic>>> savedLanguageTagLists,
  ) {
    restoreSavedLanguageData(savedLanguageData, savedLanguageTagLists);

    // Sync current language tags to main widget after restoration
    _syncCurrentLanguageTagsToMainWidget();

    // Force immediate UI rebuild
    if (mounted) {
      setState(() {});
    }
  }

  // Method to refresh data from parent's controllers
  void refreshFromParentControllers() {
    if (languages.isEmpty) return;

    // Refresh tag data from parent's controllers
    for (var lang in languages) {
      final String code = lang['code']!;
      final tagController = tagControllers[code];

      if (tagController != null && tagController.text.trim().isNotEmpty) {
        // Convert comma-separated tags back to tag objects
        final tagTexts = tagController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();

        languageTagLists[code] = tagTexts
            .asMap()
            .map((index, text) => MapEntry(index, {'id': index, 'text': text}))
            .values
            .toList();

        // Don't clear the tag controller here - let parent handle it
        // tagController.clear();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // Method to check if controllers are fully ready
  bool _areControllersReady() {
    if (languages.isEmpty || titleControllers.isEmpty) {
      return false;
    }

    // Check if all language controllers exist
    for (var lang in languages) {
      final code = lang['code']!;
      if (!titleControllers.containsKey(code) ||
          !descriptionControllers.containsKey(code) ||
          titleControllers[code] == null ||
          descriptionControllers[code] == null) {
        return false;
      }
    }
    return true;
  }

  // Method to restore saved multi-language data
  void restoreSavedLanguageData(
    Map<String, Map<String, String>> savedLanguageData,
    Map<String, List<Map<String, dynamic>>> savedLanguageTagLists,
  ) {
    // Check if we're ready for restoration
    if (!_areControllersReady()) {
      // Try again after a short delay
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          restoreSavedLanguageData(savedLanguageData, savedLanguageTagLists);
        }
      });
      return;
    }

    if (savedLanguageData.isEmpty) {
      return;
    }

    for (var lang in languages) {
      final String code = lang['code']!;
      final languageData = savedLanguageData[code];
      final savedTags = savedLanguageTagLists[code] ?? [];

      if (languageData != null && titleControllers.containsKey(code)) {
        // Restore title, tab, and description
        if (titleControllers[code] != null) {
          titleControllers[code]!.text = languageData['title'] ?? '';
        }
        // Note: Slug is not multi-language, so no need to restore tab data
        if (descriptionControllers[code] != null) {
          descriptionControllers[code]!.text =
              languageData['description'] ?? '';
        }

        // Restore tags
        languageTagLists[code] = List<Map<String, dynamic>>.from(savedTags);
      }
    }

    // Sync restored data back to main controllers
    syncLanguageControllersToMainControllers();

    if (mounted) {
      setState(() {});
    }
  }

  // Method to load tag data for the current language from controllers
  void _loadTagDataForCurrentLanguage() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final tagController = tagControllers[currentLangCode];

    if (tagController != null && tagController.text.trim().isNotEmpty) {
      // Convert comma-separated tags back to tag objects
      final tagTexts = tagController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      languageTagLists[currentLangCode] = tagTexts
          .asMap()
          .map((index, text) => MapEntry(index, {'id': index, 'text': text}))
          .values
          .toList();

      // Don't clear the tag controller here - let parent handle it
      // tagController.clear();
    } else {
      // If no tags in controller, check if we already have tags in languageTagLists
      if (!languageTagLists.containsKey(currentLangCode)) {
        languageTagLists[currentLangCode] = [];
      }
    }

    // Update main widget's finalTagList if this is the default language
    if (selectedLanguageIndex == 0) {
      final currentTags = languageTagLists[currentLangCode] ?? [];
      widget.finalTagList.clear();
      widget.finalTagList.addAll(currentTags);
    }
  }

  // Method to save current language data (any language)
  void _saveCurrentLanguageData() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final currentTitleController = titleControllers[currentLangCode];
    final currentDescriptionController =
        descriptionControllers[currentLangCode];

    // Save data for current language (no matter which language it is)
    if (currentTitleController != null &&
        currentDescriptionController != null) {
      // Only save to main controllers if this is the default language (index 0)
      // This follows the provider registration pattern
      if (selectedLanguageIndex == 0) {
        widget.serviceTitleController.text = currentTitleController.text;
        widget.serviceDescrController.text = currentDescriptionController.text;

        // Also save tags to main tag list for default language
        if (languageTagLists[currentLangCode] != null) {
          widget.finalTagList.clear();
          widget.finalTagList.addAll(languageTagLists[currentLangCode]!);
        }
      }

      // Always save to parent's controllers if available
      if (widget.tagControllers != null) {
        final tagController = widget.tagControllers![currentLangCode];
        if (tagController != null &&
            languageTagLists[currentLangCode] != null) {
          // Convert tag objects back to comma-separated string
          final tagsString = languageTagLists[currentLangCode]!
              .map((tag) => tag['text'])
              .join(',');
          tagController.text = tagsString;
        }
      }
    }
  }

  // Method to save current language data back to main controllers (backward compatibility)
  // Method to sync main controllers to language controllers
  void syncMainControllersToLanguageControllers() {
    if (languages.isEmpty) return;

    // Sync main controllers to the currently selected language controller
    final currentLangCode = languages[selectedLanguageIndex]['code']!;

    // Sync main title controller to current language controller
    if (titleControllers[currentLangCode] != null) {
      titleControllers[currentLangCode]!.text =
          widget.serviceTitleController.text;
    }

    // Sync main description controller to current language controller
    if (descriptionControllers[currentLangCode] != null) {
      descriptionControllers[currentLangCode]!.text =
          widget.serviceDescrController.text;
    }

    // Sync main slug controller to current language tab controller
    // Note: Slug is not multi-language, so no need to sync tab data
  }

  // Method to sync language controllers back to main controllers
  void syncLanguageControllersToMainControllers() {
    if (languages.isEmpty) return;

    final defaultLangCode = languages[0]['code']!;

    // Sync default language controller back to main controllers
    if (titleControllers[defaultLangCode] != null) {
      widget.serviceTitleController.text =
          titleControllers[defaultLangCode]!.text;
    }

    if (descriptionControllers[defaultLangCode] != null) {
      widget.serviceDescrController.text =
          descriptionControllers[defaultLangCode]!.text;
    }

    // Note: Slug is not multi-language, so no need to sync tab data

    // Sync tags back to main tag list
    if (languageTagLists[defaultLangCode] != null) {
      widget.finalTagList.clear();
      widget.finalTagList.addAll(languageTagLists[defaultLangCode]!);
    }
  }

  void saveCurrentLanguageDataToMainControllers() {
    if (languages.isNotEmpty) {
      final defaultLangCode = languages[0]['code']!;

      // Save default language data back to main controllers
      final defaultTitleController = titleControllers[defaultLangCode];
      final defaultDescriptionController =
          descriptionControllers[defaultLangCode];

      if (defaultTitleController != null &&
          defaultDescriptionController != null) {
        widget.serviceTitleController.text = defaultTitleController.text;
        widget.serviceDescrController.text = defaultDescriptionController.text;
      }
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
    if (widget.tagControllers == null) {
      _internalTagControllers.clear();
    }

    languageTagLists = {};

    for (int i = 0; i < languages.length; i++) {
      final lang = languages[i];
      final String code = lang['code']!;
      final isDefaultLanguage = i == 0; // First language is default language

      // Only initialize internal controllers if parent's controllers are not available
      if (widget.titleControllers == null) {
        _internalTitleControllers[code] = TextEditingController(
          text: isDefaultLanguage ? widget.serviceTitleController.text : '',
        );
      }
      if (widget.descriptionControllers == null) {
        _internalDescriptionControllers[code] = TextEditingController(
          text: isDefaultLanguage ? widget.serviceDescrController.text : '',
        );
      }
      if (widget.tagControllers == null) {
        _internalTagControllers[code] = TextEditingController();
      }

      // Add listeners to auto-save data for this specific language (with disposal check)
      final titleController = titleControllers[code];
      if (titleController != null) {
        try {
          titleController.addListener(() {
            if (mounted) {
              // For default language, also save to main controller
              if (isDefaultLanguage) {
                widget.serviceTitleController.text = titleController.text;
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
                widget.serviceDescrController.text = descriptionController.text;
              }
            }
          });
        } catch (e) {
          // Controller might be disposed, skip adding listener
        }
      }

      // Add focus listener to save data when focus is lost (for default language only)
      if (isDefaultLanguage) {
        try {
          widget.serviceDescrFocus.addListener(() {
            if (mounted && !widget.serviceDescrFocus.hasFocus) {
              // Save current language data when focus is lost (keyboard closed)
              _saveCurrentLanguageData();
            }
          });
        } catch (e) {
          // Focus node might be disposed, skip adding listener
        }
      }

      // Initialize empty tag list for each language
      languageTagLists[code] = [];

      // Populate tags from parent's tag controllers if available
      final tagController = tagControllers[code];
      if (tagController != null && tagController.text.trim().isNotEmpty) {
        // Convert comma-separated tags back to tag objects
        final tagTexts = tagController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();

        languageTagLists[code] = tagTexts
            .asMap()
            .map((index, text) => MapEntry(index, {'id': index, 'text': text}))
            .values
            .toList();

        // Don't clear the tag controller here - let parent handle it
        // tagController.clear();
      }
      // Fallback: For default language, copy existing tags from widget if no controller data
      else if (isDefaultLanguage && widget.finalTagList.isNotEmpty) {
        languageTagLists[code] = List<Map<String, dynamic>>.from(
          widget.finalTagList,
        );
      }
    }
  }

  void _onLanguageChanged(int index) {
    if (index >= 0 && index < languages.length) {
      // Check if can switch from default language to other languages
      if (!_canSwitchLanguage(index)) {
        return;
      }

      // Save current language data before switching (from any language)
      _saveCurrentLanguageData();

      setState(() {
        _internalSelectedLanguageIndex = index;
      });

      // Load tag data for the newly selected language after a small delay
      // This ensures the parent's refreshFromParentControllers call completes first
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTagDataForCurrentLanguage();
      });

      // Call parent's onLanguageChanged callback if available
      widget.onLanguageChanged?.call(index);

      // Clear form validation errors when switching languages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only clear validation state, not the field values
        if (widget.formKey1.currentState != null) {
          // Force form to revalidate with current values, which will clear
          // validation errors for non-default languages
          widget.formKey1.currentState!.validate();
        }
      });
    }
  }

  // Check if language tab should be visually enabled (no message shown)
  bool _isLanguageTabEnabled(int targetIndex) {
    // Always show default language as enabled
    if (targetIndex == 0) {
      return true;
    }

    // Show other languages as enabled if already on non-default language
    if (selectedLanguageIndex > 0) {
      return true;
    }

    // Show other languages as disabled if on default language and required fields not filled
    if (selectedLanguageIndex == 0) {
      return _areDefaultLanguageRequiredFieldsFilled();
    }

    return true;
  }

  // Check if user can switch languages (validate default language required fields)
  bool _canSwitchLanguage(int targetIndex) {
    // Always allow switching to default language (index 0)
    if (targetIndex == 0) {
      return true;
    }

    // Always allow switching between non-default languages if already on non-default
    if (selectedLanguageIndex > 0 && targetIndex > 0) {
      return true;
    }

    // Switching from default (0) to other language - validate required fields
    if (selectedLanguageIndex == 0 && targetIndex > 0) {
      // Check required fields for default language
      if (!_areDefaultLanguageRequiredFieldsFilled()) {
        UiUtils.showMessage(
          context,
          'pleaseCompleteDefaultLanguageFieldsFirst',
          ToastificationType.warning,
        );
        return false;
      }
    }

    return true;
  }

  // Check if default language required fields are filled
  bool _areDefaultLanguageRequiredFieldsFilled() {
    // Use the same logic as getDefaultLanguageData for consistency
    final defaultData = getDefaultLanguageData();

    final hasTitle = defaultData['title']?.isNotEmpty ?? false;
    final hasDescription = defaultData['description']?.isNotEmpty ?? false;
    final hasTags = defaultData['tags']?.isNotEmpty ?? false;

    return hasTitle && hasDescription && hasTags;
  }

  String? _getValidator(String? value, String fieldName) {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return null;
    }

    final languageCode = languages[selectedLanguageIndex]['code'];
    if (languageCode == null) return null;

    // Only validate required fields for Default language (first language in list)
    if (selectedLanguageIndex == 0) {
      return Validator.nullCheck(widget.context, value);
    }

    // For other languages, fields are optional
    return null;
  }

  @override
  void dispose() {
    // Save current language data before disposing
    _saveCurrentLanguageData();

    // Cancel stream subscription to prevent memory leaks
    _languageListSubscription?.cancel();

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
    if (widget.tagControllers == null) {
      for (var controller in _internalTagControllers.values) {
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
      // Note: Slug is not multi-language, so no tab controller needed
      final descriptionController = descriptionControllers[code];
      final tagController = tagControllers[code];

      if (titleController != null &&
          descriptionController != null &&
          tagController != null) {
        // Get tags as comma-separated string for this language
        final tagsList = languageTagLists[code] ?? [];
        final tagsString = tagsList.map((tag) => tag['text']).join(',');

        final langData = {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'tags': tagsString,
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

  // Method to get tags for all languages
  Map<String, String> getTagData() {
    final Map<String, String> tagData = {};

    for (var lang in languages) {
      final String code = lang['code']!;
      final tagsList = languageTagLists[code] ?? [];
      if (tagsList.isNotEmpty) {
        final tagsString = tagsList.map((tag) => tag['text']).join(',');
        tagData[code] = tagsString;
      }
    }

    // Only add fallback data for languages that don't have any data at all
    // This ensures we preserve language-specific data when it exists
    for (var lang in languages) {
      final String code = lang['code']!;
      if (!tagData.containsKey(code) || tagData[code]!.isEmpty) {
        // Only use fallback if the language has no data at all
        if (widget.finalTagList.isNotEmpty) {
          final tagsString = widget.finalTagList
              .map((tag) => tag['text'])
              .join(',');
          tagData[code] = tagsString;
        }
      }
    }

    return tagData;
  }

  // Method to get language tag lists for all languages
  Map<String, List<Map<String, dynamic>>> getLanguageTagLists() {
    return Map<String, List<Map<String, dynamic>>>.from(languageTagLists);
  }

  // Method to restore multi-language data from saved data
  void restoreLanguageData(
    Map<String, Map<String, String>> savedLanguageData,
    Map<String, List<Map<String, dynamic>>> savedLanguageTagLists,
  ) {
    if (savedLanguageData.isEmpty) return;

    for (var lang in languages) {
      final String code = lang['code']!;
      final languageData = savedLanguageData[code];
      final savedTags = savedLanguageTagLists[code] ?? [];

      if (languageData != null) {
        // Restore title, tab, and description
        titleControllers[code]?.text = languageData['title'] ?? '';
        // Note: Slug is not multi-language, so no need to restore tab data
        descriptionControllers[code]?.text = languageData['description'] ?? '';

        // Restore tags
        languageTagLists[code] = List<Map<String, dynamic>>.from(savedTags);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // Method to add tag for current language
  void _addTagForCurrentLanguage(String tagText) {
    if (tagText.trim().isEmpty) return;

    final currentLangCode = languages[selectedLanguageIndex]['code'];
    if (currentLangCode == null) return;

    final currentTags = languageTagLists[currentLangCode] ?? [];

    // Create a new tag with unique ID
    final newTag = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'text': tagText.trim(),
    };

    // Add tag to current language list
    languageTagLists[currentLangCode] = [...currentTags, newTag];

    // Don't update the tag controller with comma-separated text
    // Tags are displayed as individual chips at the bottom, not as text in the controller

    // If this is the default language, also add to parent's tag list
    if (selectedLanguageIndex == 0) {
      widget.onTagAdded(tagText.trim());
    }

    // Save tags to parent's controllers
    _saveCurrentLanguageData();

    // Clear the tag input field after adding the tag (clear whichever controller is being displayed)
    final displayController = _getTagController();
    displayController.clear();

    setState(() {});
  }

  // Method to remove tag for current language
  void _removeTagForCurrentLanguage(int tagId) {
    final currentLangCode = languages[selectedLanguageIndex]['code'];
    if (currentLangCode == null) return;

    final currentTags = languageTagLists[currentLangCode] ?? [];

    // Find the tag to remove for notification to parent
    Map<String, dynamic>? tagToRemove;
    try {
      tagToRemove = currentTags.firstWhere((tag) => tag['id'] == tagId);
    } catch (e) {
      tagToRemove = null;
    }

    // Remove from current language list
    languageTagLists[currentLangCode] = currentTags
        .where((tag) => tag['id'] != tagId)
        .toList();

    // Don't update the tag controller with comma-separated text
    // Tags are displayed as individual chips at the bottom, not as text in the controller

    // If this is the default language, also notify parent
    if (selectedLanguageIndex == 0 && tagToRemove != null) {
      // Find the index in the original tag list to remove
      final tagText = tagToRemove['text'] as String;
      // Find and remove from parent's tag list
      final parentTagIndex = widget.tagsList.indexWhere(
        (tag) => tag == tagText,
      );
      if (parentTagIndex != -1) {
        widget.onTagRemoved(parentTagIndex);
      }
    }

    // Save tags to parent's controllers
    _saveCurrentLanguageData();

    setState(() {});
  }

  // Method to get current language's tag list
  List<Map<String, dynamic>> _getCurrentLanguageTagList() {
    final currentLangCode = languages[selectedLanguageIndex]['code'];
    if (currentLangCode == null) return [];
    return languageTagLists[currentLangCode] ?? [];
  }

  // Method to get appropriate tag controller based on whether chips exist
  TextEditingController _getTagController() {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return widget.serviceTagController;
    }

    final currentLangCode = languages[selectedLanguageIndex]['code'];
    _getCurrentLanguageTagList();

    // Fallback to actual controller when no parent controllers exist
    return widget.tagControllers?[currentLangCode] ??
        widget.serviceTagController;
  }

  // Method to get the default language data (for backward compatibility)
  Map<String, String> getDefaultLanguageData() {
    // Use the first language as default language (index 0)
    if (languages.isEmpty) return {};

    final defaultLangCode = languages[0]['code']!;
    final titleController = titleControllers[defaultLangCode];
    final descriptionController = descriptionControllers[defaultLangCode];

    // Get tags as comma-separated string from the widget's tagsList
    final tagsString = widget.tagsList.join(',');

    if (titleController != null && descriptionController != null) {
      return {
        'title': titleController.text.trim(),
        'tab': widget.surviceSlugController.text
            .trim(), // Use the main slug controller
        'description': descriptionController.text.trim(),
        'tags': tagsString,
      };
    }

    return {};
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
            CustomShimmerContainer(
              height: 60,
              margin: EdgeInsets.only(bottom: 15),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomShimmerContainer(
                    height: 40,
                    margin: EdgeInsets.only(right: 10),
                  ),
                ),
                Expanded(
                  child: CustomShimmerContainer(
                    height: 40,
                    margin: EdgeInsets.only(left: 10),
                  ),
                ),
              ],
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

    return Form(
      key: widget.formKey1,
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
                    // Only show visual disabled state for non-default languages when validation would fail
                    final bool isEnabled = _isLanguageTabEnabled(index);

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
                              : (isEnabled
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.secondaryColor
                                    : AppColors.grey.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.accentColor
                                : (isEnabled
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.lightGreyColor
                                      : AppColors.grey.withValues(alpha: 0.5)),
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
                                : (isEnabled
                                      ? Theme.of(context).colorScheme.blackColor
                                      : AppColors.grey),
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

          // Language-specific fields
          CustomTextFormField(
            bottomPadding: 10,
            labelText: selectedLanguageIndex == 0
                ? '${'serviceTitleLbl'.translate(context: context)} *'
                : '${'serviceTitleLbl'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? null
                : '${'serviceTitleLbl'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller:
                widget
                    .titleControllers?[languages[selectedLanguageIndex]['code']] ??
                widget.serviceTitleController,
            currentFocusNode: widget.serviceTitleFocus,
            validator: (String? value) => _getValidator(value, 'title'),
            nextFocusNode: widget.serviceSlugFocus,
          ),

          CustomTextFormField(
            bottomPadding: 10,
            labelText: 'serviceSlug'.translate(context: context),
            controller: widget.surviceSlugController,
            currentFocusNode: widget.serviceSlugFocus,
            validator: (String? value) => null,
            nextFocusNode: widget.serviceTagFocus,
          ),
          CustomTextFormField(
            labelText: selectedLanguageIndex == 0
                ? 'serviceTagLbl'.translate(context: context)
                : '${'serviceTagLbl'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? null
                : '${'serviceTagLbl'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller: _getTagController(),
            currentFocusNode: widget.serviceTagFocus,
            forceUnFocus: false,
            bottomPadding: _getCurrentLanguageTagList().isEmpty ? 15 : 0,
            suffixIcon: IconButton(
              onPressed: () {
                final controller = _getTagController();
                if (controller.text.isNotEmpty) {
                  _addTagForCurrentLanguage(controller.text);
                  FocusScope.of(context).unfocus();
                }
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.accentColor,
              ),
            ),
            onSubmit: () {
              final controller = _getTagController();
              if (controller.text.isNotEmpty) {
                _addTagForCurrentLanguage(controller.text);
              }
            },
            callback: () {},
          ),

          Wrap(
            children: _getCurrentLanguageTagList().map((
              Map<String, dynamic> item,
            ) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 10, top: 5),
                child: SizedBox(
                  height: 35,
                  child: Chip(
                    backgroundColor: Theme.of(context).colorScheme.primaryColor,
                    label: Text(item['text']),
                    onDeleted: () {
                      _removeTagForCurrentLanguage(item['id']);
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

          if (_getCurrentLanguageTagList().isNotEmpty)
            const SizedBox(height: 15),

          CustomTextFormField(
            labelText: selectedLanguageIndex == 0
                ? '${'serviceDescrLbl'.translate(context: context)} *'
                : '${'serviceDescrLbl'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            hintText: selectedLanguageIndex == 0
                ? null
                : '${'serviceDescrLbl'.translate(context: context)} (${languages[selectedLanguageIndex]['name']})',
            controller:
                widget
                    .descriptionControllers?[languages[selectedLanguageIndex]['code']] ??
                widget.serviceDescrController,
            expands: true,
            minLines: 5,
            currentFocusNode: widget.serviceDescrFocus,
            validator: (String? value) => _getValidator(value, 'description'),
            bottomPadding: 20,
            textInputType: TextInputType.multiline,
          ),

          _selectDropdown(
            label: 'selectCategoryLbl'.translate(context: context),
            title: widget.selectedCategoryTitle ?? '',
            onSelect: widget.onCategorySelect,
            validator: (String? value) {
              if (widget.selectedCategoryTitle == null) {
                return 'pleaseChooseCategory'.translate(context: context);
              }
              return null;
            },
          ),

          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              if (context.isPayLaterAvailable)
                CustomCheckIconTextButton(
                  title: 'payLaterAllowedLbl'.translate(context: context),
                  isSelected: widget.isPayLaterAllowed,
                  onTap: () =>
                      widget.onPayLaterChanged(!widget.isPayLaterAllowed),
                ),
              if (context
                  .read<FetchSystemSettingsCubit>()
                  .isStoreOptionAvailable)
                CustomCheckIconTextButton(
                  title: 'atStoreAllowed'.translate(context: context),
                  isSelected: widget.isStoreAllowed,
                  onTap: () =>
                      widget.onStoreAllowedChanged(!widget.isStoreAllowed),
                ),
              if (context
                  .read<FetchSystemSettingsCubit>()
                  .isDoorstepOptionAvailable)
                CustomCheckIconTextButton(
                  title: 'atDoorstepAllowed'.translate(context: context),
                  isSelected: widget.isDoorStepAllowed,
                  onTap: () => widget.onDoorStepAllowedChanged(
                    !widget.isDoorStepAllowed,
                  ),
                ),
              CustomCheckIconTextButton(
                title: 'statusLbl'.translate(context: context),
                isSelected: widget.serviceStatus,
                onTap: () => widget.onStatusChanged(!widget.serviceStatus),
              ),
              CustomCheckIconTextButton(
                title: 'isCancelableLbl'.translate(context: context),
                isSelected: widget.isCancelAllowed,
                onTap: () =>
                    widget.onCancelAllowedChanged(!widget.isCancelAllowed),
              ),
            ],
          ),

          if (widget.isCancelAllowed) ...[
            const SizedBox(height: 10),
            CustomTextFormField(
              labelText: 'cancelableBeforeLbl'.translate(context: context),
              controller: widget.cancelBeforeController,
              currentFocusNode: widget.cancelBeforeFocus,
              textInputType: TextInputType.number,
              inputFormatters: UiUtils.allowOnlyDigits(),
              hintText: '30',
              validator: (String? value) {
                return Validator.nullCheck(context, value);
              },
              prefix: minutesPrefixWidget(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _selectDropdown({
    required String title,
    required String label,
    VoidCallback? onSelect,
    String? Function(String?)? validator,
  }) {
    return CustomTextFormField(
      controller: TextEditingController(text: title),
      suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
      validator: validator,
      callback: onSelect,
      isReadOnly: true,
      hintText: label,
      labelText: label,
    );
  }

  Widget minutesPrefixWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              'minutesLbl'.translate(context: context),
              fontSize: 15.0,
              color: Theme.of(context).colorScheme.blackColor,
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.blackColor.withAlpha(150),
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
          ],
        ),
      ),
    );
  }
}
