import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:edemand_partner/app/generalImports.dart';

class Form4 extends StatefulWidget {
  const Form4({
    super.key,
    required this.serviceId,
    required this.controller,
    required this.longDescription,
    // Multi-language support
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.longDescriptionControllers,
  });

  final HtmlEditorController controller;
  final String? longDescription;
  final String? serviceId;

  // Multi-language support
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? longDescriptionControllers;

  @override
  State<Form4> createState() => Form4State();
}

class Form4State extends State<Form4> with WidgetsBindingObserver {
  Timer? _autoSaveTimer;
  Timer? _contentChangeDebounceTimer;
  bool _isChangingLanguage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAutoSaveTimer();

    // Load initial content after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentLanguageContent();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoSaveTimer?.cancel();
    _contentChangeDebounceTimer?.cancel();
    _saveCurrentContent();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveCurrentContent();
    }
  }

  void _startAutoSaveTimer() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isChangingLanguage) {
        _saveCurrentContent();
      }
    });
  }

  // Debounced content change
  void _debounceContentChange(String? content) {
    _contentChangeDebounceTimer?.cancel();

    _contentChangeDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && !_isChangingLanguage) {
        if (widget.languages != null &&
            widget.selectedLanguageIndex != null &&
            widget.selectedLanguageIndex! < widget.languages!.length &&
            widget.longDescriptionControllers != null) {
          final langCode =
              widget.languages![widget.selectedLanguageIndex!].languageCode;
          widget.longDescriptionControllers![langCode]?.text = content ?? '';
        }
      }
    });
  }

  // Method to handle widget updates
  @override
  void didUpdateWidget(Form4 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if language selection changed
    if (oldWidget.selectedLanguageIndex != widget.selectedLanguageIndex) {
      _isChangingLanguage = true;
      _contentChangeDebounceTimer?.cancel();
      _loadCurrentLanguageContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateServiceCubit, CreateServiceCubitState>(
      listener: (BuildContext context, CreateServiceCubitState state) {
        if (state is CreateServiceFailure) {
          UiUtils.showMessage(
            context,
            state.errorMessage,
            ToastificationType.error,
          );
        }

        if (state is CreateServiceSuccess) {
          widget.serviceId != null
              ? context.read<FetchServicesCubit>().editService(state.service)
              : context.read<FetchServicesCubit>().addServiceToCubit(
                  state.service,
                );
          // context.read<FetchServicesCubit>().editService(state.service);
          UiUtils.showMessage(
            context,
            'serviceSavedSuccessfully',
            ToastificationType.success,
            onMessageClosed: () {
              Navigator.pop(context, state.service);
            },
          );
        }
      },
      builder: (BuildContext context, CreateServiceCubitState state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Language Tabs (only show if more than one language)
                if (widget.languages != null &&
                    widget.languages!.length > 1) ...[
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      left: 15,
                      right: 15,
                      top: 15,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.languages!.asMap().entries.map((
                          entry,
                        ) {
                          final int index = entry.key;
                          final AppLanguage language = entry.value;
                          final bool isSelected =
                              widget.selectedLanguageIndex == index;
                          final bool isEnabled = _isLanguageTabEnabled(index);

                          return GestureDetector(
                            onTap: () async {
                              if (widget.selectedLanguageIndex != index &&
                                  !_isChangingLanguage &&
                                  isEnabled) {
                                // Save current content before switching
                                await _saveCurrentContent();

                                // Change language in parent
                                widget.onLanguageChanged?.call(index);
                              }
                            },
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
                                          : AppColors.grey.withValues(
                                              alpha: 0.3,
                                            )),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.accentColor
                                      : (isEnabled
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.lightGreyColor
                                            : AppColors.grey.withValues(
                                                alpha: 0.5,
                                              )),
                                ),
                              ),
                              child: Text(
                                language.languageName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.lightPrimaryColor
                                      : (isEnabled
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.blackColor
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
                ],

                // HTML Editor
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 0,
                      left: 0,
                      right: 0,
                      top: 0,
                    ),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          _saveCurrentContent();
                        }
                      },
                      child: CustomHTMLEditor(
                        key: const ValueKey('html_editor_stable'),
                        controller: widget.controller,
                        initialHTML: _getCurrentLanguageContent(),
                        hint: 'describeServiceInDetail'.translate(
                          context: context,
                        ),
                        onContentChanged: (content) {
                          _debounceContentChange(content);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper methods for multi-language support
  String? _getCurrentLanguageContent() {
    if (widget.languages == null ||
        widget.languages!.isEmpty ||
        widget.selectedLanguageIndex == null ||
        widget.longDescriptionControllers == null) {
      return widget.longDescription;
    }

    final languageCode =
        widget.languages![widget.selectedLanguageIndex!].languageCode;
    final content =
        widget.longDescriptionControllers?[languageCode]?.text ?? '';
    return content;
  }

  Future<void> _saveCurrentContent() async {
    if (_isChangingLanguage) return;

    try {
      final currentContent = await widget.controller.getText();

      if (widget.languages != null &&
          widget.selectedLanguageIndex != null &&
          widget.selectedLanguageIndex! < widget.languages!.length &&
          widget.longDescriptionControllers != null) {
        final langCode =
            widget.languages![widget.selectedLanguageIndex!].languageCode;
        widget.longDescriptionControllers![langCode]?.text = currentContent;
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _loadCurrentLanguageContent() async {
    try {
      if (widget.languages != null &&
          widget.languages!.isNotEmpty &&
          widget.selectedLanguageIndex != null &&
          widget.selectedLanguageIndex! < widget.languages!.length &&
          widget.longDescriptionControllers != null) {
        final langCode =
            widget.languages![widget.selectedLanguageIndex!].languageCode;
        final content =
            widget.longDescriptionControllers?[langCode]?.text ?? '';

        widget.controller.setText(content);
        _isChangingLanguage = false;

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      _isChangingLanguage = false;
    }
  }

  // Check if language tab should be visually enabled (similar to faqs.dart)
  bool _isLanguageTabEnabled(int targetIndex) {
    // Default language is always enabled
    if (targetIndex == 0) {
      return true;
    }

    // If already on non-default language, allow switching between non-defaults
    if (widget.selectedLanguageIndex != null &&
        widget.selectedLanguageIndex! > 0) {
      return true;
    }

    // When on default language, enable other tabs only if default description is filled
    if (widget.selectedLanguageIndex == 0 && targetIndex > 0) {
      return _isDefaultLanguageLongDescriptionFilled();
    }

    return true;
  }

  // Check if default language long description is filled
  bool _isDefaultLanguageLongDescriptionFilled() {
    if (widget.languages == null || widget.languages!.isEmpty) {
      return false;
    }

    final defaultLangCode =
        widget.defaultLanguage?.languageCode ??
        widget.languages![0].languageCode;

    // Check in the language-specific controller first
    final defaultLangController =
        widget.longDescriptionControllers?[defaultLangCode];
    if (defaultLangController != null &&
        defaultLangController.text.trim().isNotEmpty) {
      return true;
    }

    // Check in the main longDescription variable as fallback
    if (widget.longDescription != null &&
        widget.longDescription!.trim().isNotEmpty) {
      return true;
    }

    return false;
  }
}
