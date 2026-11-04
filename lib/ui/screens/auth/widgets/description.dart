import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../../../../app/generalImports.dart';

class Form3Description extends StatefulWidget {
  final HtmlEditorController htmlController;
  final String? initialHTML;

  // Multi-language support
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? longDescriptionControllers;

  const Form3Description({
    Key? key,
    required this.htmlController,
    this.initialHTML,
    // Multi-language support
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.longDescriptionControllers,
  }) : super(key: key);

  @override
  State<Form3Description> createState() => _Form3DescriptionState();
}

class _Form3DescriptionState extends State<Form3Description> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, left: 15, right: 15, top: 10),
      child: Column(
        children: [
          // Language Tabs (only show if more than one language)
          if (widget.languages != null && widget.languages!.length > 1) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.languages!.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final AppLanguage language = entry.value;
                    final bool isSelected =
                        widget.selectedLanguageIndex == index;

                    return GestureDetector(
                      onTap: () => widget.onLanguageChanged?.call(index),
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
                          language.languageName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.lightPrimaryColor
                                : Theme.of(context).colorScheme.blackColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 20,
              ),
              child: CustomHTMLEditor(
                key: const ValueKey('stable_html_editor'),
                controller: widget.htmlController,
                initialHTML: _getCurrentLanguageContent(),
                hint:
                    widget.languages != null &&
                        widget.languages!.isNotEmpty &&
                        widget.selectedLanguageIndex != null
                    ? (widget
                                  .languages![widget.selectedLanguageIndex!]
                                  .languageCode ==
                              widget.defaultLanguage?.languageCode
                          ? 'describeCompanyInDetail'.translate(
                              context: context,
                            )
                          : '${'describeCompanyInDetail'.translate(context: context)} (${widget.languages![widget.selectedLanguageIndex!].languageName})')
                    : 'describeCompanyInDetail'.translate(context: context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _getCurrentLanguageContent() {
    if (widget.languages == null ||
        widget.languages!.isEmpty ||
        widget.selectedLanguageIndex == null) {
      return widget.initialHTML;
    }

    final languageCode =
        widget.languages![widget.selectedLanguageIndex!].languageCode;

    final controller = widget.longDescriptionControllers?[languageCode];
    if (controller != null) {
      return controller.text.isNotEmpty ? controller.text : widget.initialHTML;
    }

    return widget.initialHTML;
  }
}
