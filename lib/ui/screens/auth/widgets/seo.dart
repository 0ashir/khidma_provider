import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class SEO extends StatefulWidget {
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
  final Map<String, dynamic> pickedLocalImages;
  final Function showCameraAndGalleryOption;

  // Multi-language support
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? titleControllers;
  final Map<String, TextEditingController>? descriptionControllers;
  final Map<String, TextEditingController>? keywordsControllers;
  final Map<String, TextEditingController>? schemaMarkupControllers;
  final String? existingOgImageUrl;

  const SEO({
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
    required this.pickedLocalImages,
    required this.showCameraAndGalleryOption,
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.titleControllers,
    this.descriptionControllers,
    this.keywordsControllers,
    this.schemaMarkupControllers,
    this.existingOgImageUrl,
  }) : super(key: key);

  @override
  State<SEO> createState() => _SEOState();
}

class _SEOState extends State<SEO> {
  final TextEditingController keywordInputController = TextEditingController();

  bool get _hasLanguages =>
      widget.languages != null && widget.languages!.isNotEmpty;

  int get _selectedIndex {
    if (!_hasLanguages) return 0;
    final int index = widget.selectedLanguageIndex ?? 0;
    if (index < 0) return 0;
    if (index >= widget.languages!.length) {
      return widget.languages!.length - 1;
    }
    return index;
  }

  AppLanguage? get _currentLanguage =>
      _hasLanguages ? widget.languages![_selectedIndex] : null;

  String get _currentLanguageCode =>
      _currentLanguage?.languageCode ?? 'default';

  String get _currentLanguageName => _currentLanguage?.languageName ?? '';

  bool get _isDefaultLanguage =>
      !_hasLanguages ||
      (widget.defaultLanguage != null &&
          _currentLanguage?.languageCode ==
              widget.defaultLanguage!.languageCode);

  TextEditingController _controllerFor(
    Map<String, TextEditingController>? map,
    TextEditingController fallback,
  ) {
    if (_hasLanguages && map != null) {
      return map[_currentLanguageCode] ?? fallback;
    }
    return fallback;
  }

  List<String> _parseKeywords(String value) {
    if (value.trim().isEmpty) return [];
    return value
        .split(',')
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .toList();
  }

  void _setKeywords(TextEditingController controller, List<String> keywords) {
    final joined = keywords.join(', ');
    controller.text = joined;
    if (_isDefaultLanguage && controller != widget.seoKeywordsController) {
      widget.seoKeywordsController.text = joined;
    }
    setState(() {});
  }

  void _addKeyword(TextEditingController controller) {
    final text = keywordInputController.text.trim();
    if (text.isEmpty) return;

    final keywords = _parseKeywords(controller.text);
    keywords.add(text);
    keywordInputController.clear();
    FocusScope.of(context).unfocus();
    _setKeywords(controller, keywords);
  }

  void _removeKeyword(TextEditingController controller, int index) {
    final keywords = _parseKeywords(controller.text);
    if (index < 0 || index >= keywords.length) return;

    keywords.removeAt(index);
    _setKeywords(controller, keywords);
  }

  void _handleLanguageTap(int index) {
    if (!_hasLanguages) return;
    keywordInputController.clear();
    widget.onLanguageChanged?.call(index);
    setState(() {});
  }

  @override
  void dispose() {
    keywordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = _controllerFor(
      widget.titleControllers,
      widget.seoTitleController,
    );
    final TextEditingController descriptionController = _controllerFor(
      widget.descriptionControllers,
      widget.seoDescriptionController,
    );
    final TextEditingController keywordsController = _controllerFor(
      widget.keywordsControllers,
      widget.seoKeywordsController,
    );
    final TextEditingController schemaController = _controllerFor(
      widget.schemaMarkupControllers,
      widget.seoSchemaMarkupController,
    );

    final List<String> keywords = _parseKeywords(keywordsController.text);

    final String seoTitleLabel = _isDefaultLanguage
        ? 'seoTitle'.translate(context: context)
        : '${'seoTitle'.translate(context: context)} ($_currentLanguageName)';
    final String seoDescriptionLabel = _isDefaultLanguage
        ? 'seoDescription'.translate(context: context)
        : '${'seoDescription'.translate(context: context)} ($_currentLanguageName)';
    final String seoKeywordsLabel = _isDefaultLanguage
        ? 'seoKeywords'.translate(context: context)
        : '${'seoKeywords'.translate(context: context)} ($_currentLanguageName)';
    final String seoSchemaLabel = _isDefaultLanguage
        ? 'seoSchemaMarkup'.translate(context: context)
        : '${'seoSchemaMarkup'.translate(context: context)} ($_currentLanguageName)';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Language Tabs (only show if more than one language)
            if (_hasLanguages && widget.languages!.length > 1)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.languages!.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final AppLanguage language = entry.value;
                      final bool isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () => _handleLanguageTap(index),
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
                                  : Theme.of(
                                      context,
                                    ).colorScheme.lightGreyColor,
                            ),
                          ),
                          child: Text(
                            language.languageName,
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
            CustomTextFormField(
              bottomPadding: 15,
              labelText: seoTitleLabel,
              hintText: 'enterSeoTitle'.translate(context: context),
              controller: titleController,
              currentFocusNode: widget.seoTitleFocus,
              nextFocusNode: widget.seoDescriptionFocus,
              prefix: CustomSvgPicture(
                svgImage: AppAssets.search,
                color: context.colorScheme.accentColor,
                boxFit: BoxFit.scaleDown,
              ),
            ),
            CustomTextFormField(
              bottomPadding: 15,
              labelText: seoDescriptionLabel,
              controller: descriptionController,
              currentFocusNode: widget.seoDescriptionFocus,
              nextFocusNode: widget.seoKeywordsFocus,
              textInputType: TextInputType.multiline,
              minLines: 2,
              expands: true,
              prefix: CustomSvgPicture(
                svgImage: AppAssets.pQuestion,
                color: context.colorScheme.accentColor,
                boxFit: BoxFit.scaleDown,
              ),
              hintText: 'enterSeoDescription'.translate(context: context),
            ),
            CustomTextFormField(
              labelText: seoKeywordsLabel,
              controller: keywordInputController,
              currentFocusNode: widget.seoKeywordsFocus,
              forceUnFocus: false,
              bottomPadding: keywords.isEmpty ? 15 : 0,
              prefix: CustomSvgPicture(
                svgImage: AppAssets.star,
                color: context.colorScheme.accentColor,
                boxFit: BoxFit.scaleDown,
              ),
              hintText: 'enterSeoKeywords'.translate(context: context),
              suffixIcon: IconButton(
                onPressed: () => _addKeyword(keywordsController),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.accentColor,
                ),
              ),
              onSubmit: () => _addKeyword(keywordsController),
              callback: () {},
            ),
            Wrap(
              children: List<Widget>.generate(keywords.length, (index) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10, top: 5),
                  child: SizedBox(
                    height: 35,
                    child: Chip(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryColor,
                      label: Text(keywords[index]),
                      onDeleted: () =>
                          _removeKeyword(keywordsController, index),
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
              }),
            ),
            if (keywords.isNotEmpty) const SizedBox(height: 15),
            CustomText(
              'seoKeywordsHint'.translate(context: context),
              fontSize: 12,
              color: context.colorScheme.lightGreyColor,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              bottomPadding: 15,
              labelText: seoSchemaLabel,
              controller: schemaController,
              currentFocusNode: widget.seoSchemaMarkupFocus,
              textInputType: TextInputType.multiline,
              minLines: 4,
              expands: true,
              prefix: CustomSvgPicture(
                svgImage: AppAssets.note,
                color: context.colorScheme.accentColor,
                boxFit: BoxFit.scaleDown,
              ),
              hintText: 'enterSeoSchemaMarkup'.translate(context: context),
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
            _seoOgImagePicker(
              context,
              imageController: widget.pickSeoOgImage,
              oldImage:
                  widget.existingOgImageUrl ??
                  context
                      .read<ProviderDetailsCubit>()
                      .providerDetails
                      .providerInformation
                      ?.seoOgImage ??
                  '',
              hintLabel: 'uploadSeoOgImage'.translate(context: context),
              imageType: 'seoOgImage',
            ),
            const SizedBox(height: 20),
          ],
        ),
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
