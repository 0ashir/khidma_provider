import 'package:flutter/material.dart';
import 'package:edemand_partner/app/generalImports.dart';

class Form3 extends StatefulWidget {
  const Form3({
    super.key,
    required this.formKey3,
    required this.faqQuestionTextEditors,
    required this.faqAnswersTextEditors,
    required this.context,
    // Multi-language support
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.faqQuestionControllers,
    this.faqAnswerControllers,
  });

  final GlobalKey<FormState> formKey3;
  final ValueNotifier<List<TextEditingController>> faqQuestionTextEditors;
  final ValueNotifier<List<TextEditingController>> faqAnswersTextEditors;
  final BuildContext context;

  // Multi-language support
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, List<TextEditingController>>? faqQuestionControllers;
  final Map<String, List<TextEditingController>>? faqAnswerControllers;

  @override
  State<Form3> createState() => Form3State();
}

class Form3State extends State<Form3> {
  // Use parent's language data if available, otherwise fallback to internal system
  int get selectedLanguageIndex =>
      widget.selectedLanguageIndex ?? _internalSelectedLanguageIndex;
  int _internalSelectedLanguageIndex = 0;

  // Language-specific FAQ controllers - use parent's if available
  Map<String, List<TextEditingController>> get questionControllers =>
      widget.faqQuestionControllers ?? _internalQuestionControllers;
  Map<String, List<TextEditingController>> get answerControllers =>
      widget.faqAnswerControllers ?? _internalAnswerControllers;

  // Internal controllers as fallback
  Map<String, List<TextEditingController>> _internalQuestionControllers = {};
  Map<String, List<TextEditingController>> _internalAnswerControllers = {};

  List<Map<String, String>> languages = [];
  StreamSubscription? _languageListSubscription;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
  }

  void _initializeLanguages() {
    // If parent provides language data, use it directly
    if (widget.languages != null && widget.languages!.isNotEmpty) {
      languages = widget.languages!
          .map((lang) => {'code': lang.languageCode, 'name': lang.languageName})
          .toList();

      // Initialize controllers after languages are loaded
      _initializeControllers();

      if (mounted) {
        setState(() {});
      }
      return;
    }

    // Fallback: initialize languages from cubit
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
        // Request data restoration after controllers are initialized
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _requestDataRestorationFromParent();
          }
        });
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
    // Prevent multiple initialization
    if (_controllersInitialized) {
      return;
    }

    // Only initialize internal controllers if parent's controllers are not available
    if (widget.faqQuestionControllers == null) {
      _internalQuestionControllers.clear();
    }
    if (widget.faqAnswerControllers == null) {
      _internalAnswerControllers.clear();
    }

    for (int i = 0; i < languages.length; i++) {
      final lang = languages[i];
      final String code = lang['code']!;
      final isDefaultLanguage = i == 0; // First language is default language

      // Only initialize internal controllers if parent's controllers are not available
      if (widget.faqQuestionControllers == null) {
        _internalQuestionControllers[code] = [];
      }
      if (widget.faqAnswerControllers == null) {
        _internalAnswerControllers[code] = [];
      }

      // Check if controllers already exist for this language
      if (questionControllers[code] != null &&
          questionControllers[code]!.isNotEmpty) {
        continue;
      }

      // Initialize empty controllers for this language
      questionControllers[code] = [];
      answerControllers[code] = [];

      if (isDefaultLanguage) {
        // For default language, use the existing controllers if available
        if (widget.faqQuestionTextEditors.value.isNotEmpty) {
          for (int j = 0; j < widget.faqQuestionTextEditors.value.length; j++) {
            questionControllers[code]!.add(
              widget.faqQuestionTextEditors.value[j],
            );
            answerControllers[code]!.add(widget.faqAnswersTextEditors.value[j]);
          }
        } else {
          // If no existing controllers, create one empty FAQ pair for adding
          final newQuestionController = TextEditingController();
          final newAnswerController = TextEditingController();

          // Add listeners to sync data when user types
          newQuestionController.addListener(() {
            syncCurrentLanguageToMainControllers();
          });
          newAnswerController.addListener(() {
            syncCurrentLanguageToMainControllers();
          });

          questionControllers[code]!.add(newQuestionController);
          answerControllers[code]!.add(newAnswerController);

          // Also update the main widget controllers for default language
          widget.faqQuestionTextEditors.value = [newQuestionController];
          widget.faqAnswersTextEditors.value = [newAnswerController];
        }
      } else {
        // For other languages, start with one empty FAQ pair only if no data exists
        final newQuestionController = TextEditingController();
        final newAnswerController = TextEditingController();

        // Add listeners to sync data when user types
        newQuestionController.addListener(() {
          syncCurrentLanguageToMainControllers();
        });
        newAnswerController.addListener(() {
          syncCurrentLanguageToMainControllers();
        });

        questionControllers[code]!.add(newQuestionController);
        answerControllers[code]!.add(newAnswerController);
      }
    }

    // Mark controllers as initialized
    _controllersInitialized = true;
  }

  void _onLanguageChanged(int index) {
    if (index >= 0 && index < languages.length) {
      // Check if can switch from default language to other languages
      if (!_canSwitchLanguage(index)) {
        return;
      }

      // Save current language data before switching
      saveCurrentLanguageData();

      setState(() {
        _internalSelectedLanguageIndex = index;
      });

      // Call parent's onLanguageChanged callback if available
      widget.onLanguageChanged?.call(index);
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

    // For FAQs, show other languages as disabled only if there are incomplete FAQ pairs
    if (selectedLanguageIndex == 0) {
      return _canSwitchFromDefaultLanguage();
    }

    return true;
  }

  // Check if user can switch languages (FAQs are optional, so less strict validation)
  bool _canSwitchLanguage(int targetIndex) {
    // Always allow switching to default language (index 0)
    if (targetIndex == 0) {
      return true;
    }

    // Always allow switching between non-default languages if already on non-default
    if (selectedLanguageIndex > 0 && targetIndex > 0) {
      return true;
    }

    // For FAQs, we only prevent switching if there's incomplete FAQ data in default language
    if (selectedLanguageIndex == 0 && targetIndex > 0) {
      if (!_canSwitchFromDefaultLanguage()) {
        UiUtils.showMessage(
          context,
          'pleaseCompleteTheIncompleteDefaultLanguageFAQs',
          ToastificationType.warning,
        );
        return false;
      }
    }

    return true;
  }

  // Check if can switch from default language (ensure no incomplete FAQs)
  bool _canSwitchFromDefaultLanguage() {
    final defaultLangCode = languages[0]['code']!;
    final questions = questionControllers[defaultLangCode] ?? [];
    final answers = answerControllers[defaultLangCode] ?? [];

    // Check that any existing FAQs are complete (both question and answer filled)
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i].text.trim();
      final answer = (i < answers.length) ? answers[i].text.trim() : '';

      // If one field is filled but the other is empty, it's incomplete
      if ((question.isNotEmpty && answer.isEmpty) ||
          (question.isEmpty && answer.isNotEmpty)) {
        return false;
      }
    }

    return true;
  }

  void _addFaq() {
    // Get current language code
    if (selectedLanguageIndex >= 0 &&
        selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex]['code'];
      final currentQuestions = questionControllers[currentLangCode!] ?? [];
      final currentAnswers = answerControllers[currentLangCode] ?? [];

      // Check if the last FAQ pair is incomplete
      if (currentQuestions.isNotEmpty && currentAnswers.isNotEmpty) {
        final lastQuestion = currentQuestions.last;
        final lastAnswer = currentAnswers.last;

        if (lastQuestion.text.trim().isEmpty ||
            lastAnswer.text.trim().isEmpty) {
          UiUtils.showMessage(
            context,
            "fillLastFAQToAddMore",
            ToastificationType.warning,
          );
          return;
        }
      }

      // Add FAQ only to the current language - completely independent
      final isDefaultLanguage = selectedLanguageIndex == 0;

      final newQuestionController = TextEditingController();
      final newAnswerController = TextEditingController();

      // Add listeners to sync data when user types
      newQuestionController.addListener(() {
        syncCurrentLanguageToMainControllers();
      });
      newAnswerController.addListener(() {
        syncCurrentLanguageToMainControllers();
      });

      // Add to language-specific controllers
      questionControllers[currentLangCode]?.add(newQuestionController);
      answerControllers[currentLangCode]?.add(newAnswerController);

      if (isDefaultLanguage) {
        // For default language, also add to the main widget lists
        widget.faqQuestionTextEditors.value = List.from(
          widget.faqQuestionTextEditors.value,
        )..add(newQuestionController);
        widget.faqAnswersTextEditors.value = List.from(
          widget.faqAnswersTextEditors.value,
        )..add(newAnswerController);
      }
    }

    // Sync data after adding FAQ
    syncCurrentLanguageToMainControllers();
    setState(() {});
  }

  void _removeFaq(int index) {
    if (selectedLanguageIndex >= 0 &&
        selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex]['code']!;
      final isDefaultLanguage = selectedLanguageIndex == 0;

      if (isDefaultLanguage) {
        // For default language, only remove from default language and update widget lists
        if (index < (questionControllers[currentLangCode]?.length ?? 0)) {
          questionControllers[currentLangCode]?.removeAt(index);
          answerControllers[currentLangCode]?.removeAt(index);

          // Update the original controllers (these will be disposed by the parent widget)
          if (index < widget.faqQuestionTextEditors.value.length) {
            widget.faqQuestionTextEditors.value = List.from(
              widget.faqQuestionTextEditors.value,
            )..removeAt(index);
          }
          if (index < widget.faqAnswersTextEditors.value.length) {
            widget.faqAnswersTextEditors.value = List.from(
              widget.faqAnswersTextEditors.value,
            )..removeAt(index);
          }
        }
      } else {
        // For other languages, only remove from that specific language
        if (index < (questionControllers[currentLangCode]?.length ?? 0)) {
          final questionController =
              questionControllers[currentLangCode]![index];
          final answerController = answerControllers[currentLangCode]![index];

          // Dispose the controllers since we created them
          questionController.dispose();
          answerController.dispose();

          questionControllers[currentLangCode]?.removeAt(index);
          answerControllers[currentLangCode]?.removeAt(index);
        }
      }
    }

    // Sync data after removing FAQ
    syncCurrentLanguageToMainControllers();
    setState(() {});
  }

  // Method to request data restoration from parent
  void _requestDataRestorationFromParent() {
    // Force a rebuild to ensure UI is updated after any data restoration
    if (mounted) {
      setState(() {});
    }
  }

  // Method to check if controllers are fully ready
  bool _areControllersReady() {
    if (languages.isEmpty || questionControllers.isEmpty) {
      return false;
    }

    // Check if all language controllers exist
    for (var lang in languages) {
      final code = lang['code']!;
      if (!questionControllers.containsKey(code) ||
          !answerControllers.containsKey(code) ||
          questionControllers[code] == null ||
          answerControllers[code] == null) {
        return false;
      }
    }
    return true;
  }

  // Public method that forces UI update after restoration
  void forceRestoreAndUpdateUI(
    Map<String, List<Map<String, String>>> savedFaqData,
  ) {
    restoreSavedFaqData(savedFaqData);
    // Force immediate UI rebuild
    if (mounted) {
      setState(() {});
    }
  }

  // Method to restore saved FAQ data
  void restoreSavedFaqData(
    Map<String, List<Map<String, String>>> savedFaqData,
  ) {
    // Check if we're ready for restoration
    if (!_areControllersReady()) {
      // Try again after a short delay
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          restoreSavedFaqData(savedFaqData);
        }
      });
      return;
    }

    if (savedFaqData.isEmpty) {
      return;
    }

    for (var lang in languages) {
      final String code = lang['code']!;
      final List<Map<String, String>> faqList = savedFaqData[code] ?? [];

      if (faqList.isNotEmpty &&
          questionControllers.containsKey(code) &&
          answerControllers.containsKey(code)) {
        // Dispose existing controllers first to prevent memory leaks
        for (var controller in questionControllers[code] ?? []) {
          try {
            controller.dispose();
          } catch (e) {
            // Controller already disposed, ignore
          }
        }
        for (var controller in answerControllers[code] ?? []) {
          try {
            controller.dispose();
          } catch (e) {
            // Controller already disposed, ignore
          }
        }

        // Clear existing controllers
        questionControllers[code]?.clear();
        answerControllers[code]?.clear();

        // Add controllers for each FAQ
        for (int i = 0; i < faqList.length; i++) {
          final faq = faqList[i];
          final questionController = TextEditingController(
            text: faq['question'] ?? '',
          );
          final answerController = TextEditingController(
            text: faq['answer'] ?? '',
          );

          // Add listeners to sync data when user types
          questionController.addListener(() {
            syncCurrentLanguageToMainControllers();
          });
          answerController.addListener(() {
            syncCurrentLanguageToMainControllers();
          });

          questionControllers[code]!.add(questionController);
          answerControllers[code]!.add(answerController);
        }

        // If this is the default language, also update the main widget controllers
        if (code == languages[0]['code']) {
          // Clear existing main widget controllers
          widget.faqQuestionTextEditors.value.clear();
          widget.faqAnswersTextEditors.value.clear();

          // Add all FAQs to main widget controllers
          for (int i = 0; i < faqList.length; i++) {
            final faq = faqList[i];
            widget.faqQuestionTextEditors.value.add(
              TextEditingController(text: faq['question'] ?? ''),
            );
            widget.faqAnswersTextEditors.value.add(
              TextEditingController(text: faq['answer'] ?? ''),
            );
          }
        }
      } else {
        if (faqList.isEmpty) {
          // Ensure there's at least one empty FAQ pair for adding
          if (questionControllers[code]?.isEmpty ?? true) {
            final newQuestionController = TextEditingController();
            final newAnswerController = TextEditingController();

            // Add listeners to sync data when user types
            newQuestionController.addListener(() {
              syncCurrentLanguageToMainControllers();
            });
            newAnswerController.addListener(() {
              syncCurrentLanguageToMainControllers();
            });

            questionControllers[code]!.add(newQuestionController);
            answerControllers[code]!.add(newAnswerController);
          }
        } else {}
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // Method to save current language data before switching
  void _saveCurrentLanguageData() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final questions = questionControllers[currentLangCode] ?? [];
    final answers = answerControllers[currentLangCode] ?? [];

    // Save current language FAQ data
    final List<Map<String, String>> currentFaqs = [];
    for (int i = 0; i < questions.length && i < answers.length; i++) {
      final question = questions[i].text.trim();
      final answer = answers[i].text.trim();
      if (question.isNotEmpty && answer.isNotEmpty) {
        currentFaqs.add({'question': question, 'answer': answer});
      }
    }

    if (currentFaqs.isNotEmpty) {
      // Store in a temporary storage for this language
      if (!_tempFaqData.containsKey(currentLangCode)) {
        _tempFaqData[currentLangCode] = [];
      }
      _tempFaqData[currentLangCode] = currentFaqs;
    }
  }

  // Temporary storage for FAQ data
  Map<String, List<Map<String, String>>> _tempFaqData = {};

  // Method to sync current language data back to main controllers
  void syncCurrentLanguageToMainControllers() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final isDefaultLanguage = selectedLanguageIndex == 0;

    if (isDefaultLanguage) {
      // For default language, sync to main widget controllers
      final questions = questionControllers[currentLangCode] ?? [];
      final answers = answerControllers[currentLangCode] ?? [];

      // Clear and rebuild main widget controllers
      widget.faqQuestionTextEditors.value.clear();
      widget.faqAnswersTextEditors.value.clear();

      for (int i = 0; i < questions.length && i < answers.length; i++) {
        widget.faqQuestionTextEditors.value.add(
          TextEditingController(text: questions[i].text),
        );
        widget.faqAnswersTextEditors.value.add(
          TextEditingController(text: answers[i].text),
        );
      }
    }
  }

  // Method to get FAQ data for all languages
  Map<String, List<Map<String, String>>> getFaqData() {
    // Force save current language data before collecting all languages
    _saveCurrentLanguageData();

    final Map<String, List<Map<String, String>>> faqData = {};

    // Collect FAQ data for each language independently
    for (var lang in languages) {
      final String code = lang['code']!;
      final questions = questionControllers[code] ?? [];
      final answers = answerControllers[code] ?? [];

      final List<Map<String, String>> langFaqs = [];

      // Only collect FAQs that have both question and answer filled
      for (int i = 0; i < questions.length && i < answers.length; i++) {
        final question = questions[i].text.trim();
        final answer = answers[i].text.trim();

        if (question.isNotEmpty && answer.isNotEmpty) {
          langFaqs.add({'question': question, 'answer': answer});
        }
      }

      // Only add to faqData if there are actual FAQs for this language
      if (langFaqs.isNotEmpty) {
        faqData[code] = langFaqs;
        for (int i = 0; i < langFaqs.length; i++) {}
      } else {}
    }

    return faqData;
  }

  String? _getValidator(String? value, String fieldName) {
    if (selectedLanguageIndex < 0 ||
        selectedLanguageIndex >= languages.length) {
      return null;
    }

    // FAQs are now optional for all languages including the default language
    return null;
  }

  // Method to save current language data before navigation
  void saveCurrentLanguageData() {
    if (languages.isEmpty || selectedLanguageIndex >= languages.length) return;

    // Sync current language data to main controllers before saving
    syncCurrentLanguageToMainControllers();

    // Also save current language data to temporary storage
    _saveCurrentLanguageData();
  }

  // Public method to save data (called from parent)
  void saveData() {
    saveCurrentLanguageData();
  }

  @override
  void dispose() {
    // Save current language data before disposing
    saveCurrentLanguageData();

    // Cancel stream subscription to prevent memory leaks
    _languageListSubscription?.cancel();

    // Only dispose internal controllers if they were created by this widget
    if (widget.faqQuestionControllers == null) {
      for (var controllerList in _internalQuestionControllers.values) {
        for (var controller in controllerList) {
          try {
            controller.dispose();
          } catch (e) {
            // Controller already disposed, ignore
          }
        }
      }
    }
    if (widget.faqAnswerControllers == null) {
      for (var controllerList in _internalAnswerControllers.values) {
        for (var controller in controllerList) {
          try {
            controller.dispose();
          } catch (e) {
            // Controller already disposed, ignore
          }
        }
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show shimmer effect if languages are not yet loaded
    if (languages.isEmpty) {
      return ShimmerLoadingContainer(
        child: Column(
          children: [
            const CustomShimmerContainer(
              height: 50,
              margin: EdgeInsets.only(bottom: 20),
            ),
            ...List.generate(
              2,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    CustomShimmerContainer(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    CustomShimmerContainer(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Ensure selectedLanguageIndex is valid
    int validLanguageIndex = selectedLanguageIndex;
    if (validLanguageIndex < 0 || validLanguageIndex >= languages.length) {
      validLanguageIndex = 0;
      _internalSelectedLanguageIndex = 0;
    }

    final currentLangCode = languages[validLanguageIndex]['code']!;
    final currentQuestions = questionControllers[currentLangCode] ?? [];
    final currentAnswers = answerControllers[currentLangCode] ?? [];

    return Form(
      key: widget.formKey3,
      onChanged: () {
        // Sync data when form changes
        syncCurrentLanguageToMainControllers();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            'faqs'.translate(context: context),
            color: Theme.of(context).colorScheme.blackColor,
          ),
          const SizedBox(height: 15),

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

          // FAQ Items for selected language
          ...List.generate(currentQuestions.length, (index) {
            return _singleQuestionItem(
              index: index,
              questionController: currentQuestions[index],
              answerController: currentAnswers[index],
            );
          }),
        ],
      ),
    );
  }

  Widget _singleQuestionItem({
    required int index,
    required TextEditingController questionController,
    required TextEditingController answerController,
  }) {
    final currentLangCode = languages[selectedLanguageIndex]['code']!;
    final currentQuestions = questionControllers[currentLangCode] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextFormField(
                  bottomPadding: 0,
                  labelText: selectedLanguageIndex == 0
                      ? "${'question'.translate(context: context)} ${index + 1}"
                      : "${'question'.translate(context: context)} ${index + 1} (${languages[selectedLanguageIndex]['name']})",
                  hintText: selectedLanguageIndex == 0
                      ? null
                      : "${'question'.translate(context: context)} ${index + 1} (${languages[selectedLanguageIndex]['name']})",
                  controller: questionController,
                  validator: (String? value) =>
                      _getValidator(value, 'question'),
                ),
              ),
              index == 0
                  ? IconButton(
                      onPressed: _addFaq,
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.blackColor,
                      ),
                    )
                  : IconButton(
                      onPressed: () => _removeFaq(index),
                      icon: const Icon(
                        Icons.close_outlined,
                        color: AppColors.redColor,
                      ),
                    ),
            ],
          ),
        ),
        CustomTextFormField(
          expands: true,
          labelText: selectedLanguageIndex == 0
              ? "${'answer'.translate(context: context)} ${index + 1}"
              : "${'answer'.translate(context: context)} ${index + 1} (${languages[selectedLanguageIndex]['name']})",
          hintText: selectedLanguageIndex == 0
              ? null
              : "${'answer'.translate(context: context)} ${index + 1} (${languages[selectedLanguageIndex]['name']})",
          bottomPadding: 10,
          controller: answerController,
          textInputType: TextInputType.multiline,
          validator: (String? value) => _getValidator(value, 'answer'),
        ),
        if (index != currentQuestions.length - 1) const CustomDivider(),
        const SizedBox(height: 10),
      ],
    );
  }
}
