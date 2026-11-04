import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class Form2CompanyInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController companyNameController;
  final TextEditingController visitingChargesController;
  final TextEditingController advanceBookingDaysController;
  final TextEditingController numberOfMemberController;
  final TextEditingController aboutCompanyController;
  final FocusNode companyNmFocus;
  final FocusNode visitingChargeFocus;
  final FocusNode advanceBookingDaysFocus;
  final TextEditingController maxServiceableDistanceController;
  final FocusNode maxServiceableDistanceFocus;
  final FocusNode numberOfMemberFocus;
  final FocusNode aboutCompanyFocus;
  final PickImage pickLogoImage;
  final PickImage pickBannerImage;
  final Map? selectCompanyType;
  final bool? isIndividualType;
  final Map<String, dynamic> pickedLocalImages;
  final Function showCameraAndGalleryOption;
  final Function selectCompanyTypes;
  final ValueNotifier<List<String>> selectedOtherImages;
  final ValueNotifier<List<String>> previouslyAddedOtherImages;
  final Function(String imagePath)? onPreviousImageDeleted;

  // Multi-language support for company name, about, and description
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? companyNameControllers;
  final Map<String, TextEditingController>? aboutCompanyControllers;
  final Map<String, TextEditingController>? descriptionControllers;
  final String? Function(String?)? getCompanyNameValidator;
  final String? Function(String?)? getAboutCompanyValidator;
  final String? Function(String?)? getDescriptionValidator;

  const Form2CompanyInfo({
    Key? key,
    required this.formKey,
    required this.companyNameController,
    required this.visitingChargesController,
    required this.advanceBookingDaysController,
    required this.numberOfMemberController,
    required this.aboutCompanyController,
    required this.companyNmFocus,
    required this.visitingChargeFocus,
    required this.advanceBookingDaysFocus,
    required this.maxServiceableDistanceController,
    required this.maxServiceableDistanceFocus,
    required this.numberOfMemberFocus,
    required this.aboutCompanyFocus,
    required this.pickLogoImage,
    required this.pickBannerImage,
    required this.selectCompanyType,
    required this.isIndividualType,
    required this.pickedLocalImages,
    required this.showCameraAndGalleryOption,
    required this.selectCompanyTypes,
    required this.selectedOtherImages,
    required this.previouslyAddedOtherImages,
    this.onPreviousImageDeleted,
    // Multi-language support for company name, about, and description
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.companyNameControllers,
    this.aboutCompanyControllers,
    this.descriptionControllers,
    this.getCompanyNameValidator,
    this.getAboutCompanyValidator,
    this.getDescriptionValidator,
  }) : super(key: key);

  @override
  State<Form2CompanyInfo> createState() => Form2CompanyInfoState();
}

class Form2CompanyInfoState extends State<Form2CompanyInfo> {
  /// Validates if logo and banner images are present
  bool validateImagesPresence(BuildContext context) {
    bool isValid = true;
    String errorMessage = '';

    // Check if logo image is selected or already exists
    final bool hasLogoImage =
        widget.pickedLocalImages['logoImage'] != '' ||
        (context.read<ProviderDetailsCubit>().providerDetails.user?.image ?? '')
            .isNotEmpty;

    // Check if banner image is selected or already exists
    final bool hasBannerImage =
        widget.pickedLocalImages['bannerImage'] != '' ||
        (context
                    .read<ProviderDetailsCubit>()
                    .providerDetails
                    .providerInformation
                    ?.banner ??
                '')
            .isNotEmpty;

    if (!hasLogoImage && !hasBannerImage) {
      // Try to use translation, fallback to hardcoded message if translation is missing
      final String translated = 'pleaseAddBothLogoAndBannerImages'.translate(
        context: context,
      );
      errorMessage = translated != 'pleaseAddBothLogoAndBannerImages'
          ? translated
          : 'Please add both logo and banner images';
      isValid = false;
    } else if (!hasLogoImage) {
      final String translated = 'pleaseAddLogoImage'.translate(
        context: context,
      );
      errorMessage = translated != 'pleaseAddLogoImage'
          ? translated
          : 'Please add logo image';
      isValid = false;
    } else if (!hasBannerImage) {
      final String translated = 'pleaseAddBannerImage'.translate(
        context: context,
      );
      errorMessage = translated != 'pleaseAddBannerImage'
          ? translated
          : 'Please add banner image';
      isValid = false;
    }

    if (!isValid) {
      UiUtils.showMessage(context, errorMessage, ToastificationType.error);
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          // Language Tabs (only show if more than one language)
          if (widget.languages != null && widget.languages!.length > 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomText(
              'bannerAndProviderImageRecommend'.translate(context: context),
              color: context.colorScheme.blackColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: CustomContainer(
                      width: MediaQuery.of(context).size.width / 0.5,
                      height: 200,
                      color: context.colorScheme.accentColor.withAlpha(30),
                      borderRadius: UiUtils.borderRadiusOf10,
                      border: Border.all(
                        color: context.colorScheme.accentColor,
                        width: 1,
                      ),
                      child: _bennerPicker(
                        context,
                        imageController: widget.pickBannerImage,
                        oldImage:
                            context
                                .read<ProviderDetailsCubit>()
                                .providerDetails
                                .providerInformation
                                ?.banner ??
                            '',
                        hintLabel:
                            "${"addLbl".translate(context: context)} ${"bannerImgLbl".translate(context: context)}",
                        imageType: 'bannerImage',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: context.colorScheme.secondaryColor,
                      minRadius: 35,
                      maxRadius: 35,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.accentColor,
                            width: 1,
                          ),
                        ),
                        child: _logoPicker(
                          context,
                          imageController: widget.pickLogoImage,
                          oldImage:
                              context
                                  .read<ProviderDetailsCubit>()
                                  .providerDetails
                                  .user
                                  ?.image ??
                              '',
                          hintLabel:
                              "${"addLbl".translate(context: context)} ${"logoLbl".translate(context: context)}",
                          imageType: 'logoImage',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Company Name Field (Multi-language)
          if (widget.languages != null && widget.languages!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                bottomPadding: 15,
                labelText:
                    widget
                            .languages![widget.selectedLanguageIndex ?? 0]
                            .languageCode ==
                        widget.defaultLanguage?.languageCode
                    ? '${'compNmLbl'.translate(context: context)} *'
                    : '${'compNmLbl'.translate(context: context)} (${widget.languages![widget.selectedLanguageIndex ?? 0].languageName})',
                hintText:
                    widget
                            .languages![widget.selectedLanguageIndex ?? 0]
                            .languageCode ==
                        widget.defaultLanguage?.languageCode
                    ? null
                    : '${'compNmLbl'.translate(context: context)} (${widget.languages![widget.selectedLanguageIndex ?? 0].languageName})',
                controller:
                    widget.companyNameControllers?[widget
                        .languages![widget.selectedLanguageIndex ?? 0]
                        .languageCode] ??
                    widget.companyNameController,
                currentFocusNode: widget.companyNmFocus,
                prefix: CustomSvgPicture(
                  svgImage: AppAssets.pProfile,
                  color: context.colorScheme.accentColor,
                  boxFit: BoxFit.scaleDown,
                ),
                nextFocusNode: widget.visitingChargeFocus,
                validator:
                    widget.getCompanyNameValidator ??
                    (String? companyName) =>
                        Validator.nullCheck(context, companyName),
              ),
            ),
          ] else ...[
            // Fallback to original field if languages not loaded
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                bottomPadding: 15,
                labelText: 'compNmLbl'.translate(context: context),
                controller: widget.companyNameController,
                currentFocusNode: widget.companyNmFocus,
                prefix: CustomSvgPicture(
                  svgImage: AppAssets.pProfile,
                  color: context.colorScheme.accentColor,
                  boxFit: BoxFit.scaleDown,
                ),
                nextFocusNode: widget.visitingChargeFocus,
                validator: (String? companyName) =>
                    Validator.nullCheck(context, companyName),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomTextFormField(
              bottomPadding: 15,
              labelText: 'visitingCharge'.translate(context: context),
              controller: widget.visitingChargesController,
              currentFocusNode: widget.visitingChargeFocus,
              nextFocusNode: widget.companyNmFocus,
              validator: (String? visitingCharge) =>
                  Validator.nullCheck(context, visitingCharge),
              textInputType: TextInputType.number,
              allowOnlySingleDecimalPoint: true,
              prefix: Padding(
                padding: const EdgeInsetsDirectional.all(15.0),
                // Rebuilds when the country settings load.
                child:
                    BlocBuilder<
                      FetchCountrySettingsCubit,
                      FetchCountrySettingsState
                    >(
                      builder: (context, _) => CustomText(
                        context.providerCurrencySymbol,
                        fontSize: 14.0,
                        color: Theme.of(context).colorScheme.blackColor,
                      ),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomTextFormField(
              bottomPadding: 15,
              labelText: 'advanceBookingDay'.translate(context: context),
              controller: widget.advanceBookingDaysController,
              currentFocusNode: widget.advanceBookingDaysFocus,
              prefix: CustomSvgPicture(
                svgImage: AppAssets.pDate,
                color: context.colorScheme.accentColor,
                boxFit: BoxFit.scaleDown,
              ),
              nextFocusNode: widget.numberOfMemberFocus,
              validator: (String? advancedBooking) {
                final String? value = Validator.nullCheck(
                  context,
                  advancedBooking,
                );
                if (value != null) {
                  return value;
                }
                if (int.parse(advancedBooking ?? '0') < 1) {
                  return 'advanceBookingDaysShouldBeGreaterThan0'.translate(
                    context: context,
                  );
                }
                return null;
              },
              textInputType: TextInputType.number,
            ),
          ),
          BlocBuilder<FetchSystemSettingsCubit, FetchSystemSettingsState>(
            builder: (context, state) {
              final cubit = context.read<FetchSystemSettingsCubit>();
              if (!cubit.isProviderWiseDistance) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomTextFormField(
                  bottomPadding: 15,
                  labelText: 'maxServiceableDistance'.translate(
                    context: context,
                  ),
                  controller: widget.maxServiceableDistanceController,
                  currentFocusNode: widget.maxServiceableDistanceFocus,
                  nextFocusNode: widget.numberOfMemberFocus,
                  textInputType: TextInputType.number,
                  allowOnlySingleDecimalPoint: true,
                  prefix: CustomSvgPicture(
                    svgImage: AppAssets.mapPic,
                    color: context.colorScheme.accentColor,
                    boxFit: BoxFit.scaleDown,
                  ),
                ),
              );
            },
          ),
          // About Company Field (Multi-language)
          if (widget.languages != null && widget.languages!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                bottomPadding: 15,
                labelText:
                    widget
                            .languages![widget.selectedLanguageIndex ?? 0]
                            .languageCode ==
                        widget.defaultLanguage?.languageCode
                    ? '${'aboutCompany'.translate(context: context)} *'
                    : '${'aboutCompany'.translate(context: context)} (${widget.languages![widget.selectedLanguageIndex ?? 0].languageName})',
                hintText:
                    widget
                            .languages![widget.selectedLanguageIndex ?? 0]
                            .languageCode ==
                        widget.defaultLanguage?.languageCode
                    ? null
                    : '${'aboutCompany'.translate(context: context)} (${widget.languages![widget.selectedLanguageIndex ?? 0].languageName})',
                controller:
                    widget.aboutCompanyControllers?[widget
                        .languages![widget.selectedLanguageIndex ?? 0]
                        .languageCode] ??
                    widget.aboutCompanyController,
                prefix: CustomSvgPicture(
                  svgImage: AppAssets.pQuestion,
                  color: context.colorScheme.accentColor,
                  boxFit: BoxFit.scaleDown,
                ),
                currentFocusNode: widget.aboutCompanyFocus,
                expands: true,
                textInputType: TextInputType.multiline,
                validator:
                    widget.getAboutCompanyValidator ??
                    (String? aboutCompany) =>
                        Validator.nullCheck(context, aboutCompany),
              ),
            ),
          ] else ...[
            // Fallback to original field if languages not loaded
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                bottomPadding: 15,
                labelText: 'aboutCompany'.translate(context: context),
                controller: widget.aboutCompanyController,
                prefix: CustomSvgPicture(
                  svgImage: AppAssets.pQuestion,
                  color: context.colorScheme.accentColor,
                  boxFit: BoxFit.scaleDown,
                ),
                currentFocusNode: widget.aboutCompanyFocus,
                expands: true,
                textInputType: TextInputType.multiline,
                validator: (String? aboutCompany) =>
                    Validator.nullCheck(context, aboutCompany),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    bottomPadding: 0,
                    controller: TextEditingController(
                      text: widget.selectCompanyType?["title"] ?? '',
                    ),
                    labelText: 'selectType'.translate(context: context),
                    isReadOnly: true,
                    hintText: 'selectType'.translate(context: context),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    callback: () {
                      widget.selectCompanyTypes();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    bottomPadding: 0,
                    labelText: 'numberOfMember'.translate(context: context),
                    controller: widget.numberOfMemberController,
                    currentFocusNode: widget.numberOfMemberFocus,
                    nextFocusNode: widget.aboutCompanyFocus,
                    validator: (String? numberOfMembers) =>
                        Validator.nullCheck(context, numberOfMembers),
                    isReadOnly: widget.isIndividualType ?? false,
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Expanded(child: Divider(thickness: 0.5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                    'otherImages'.translate(context: context),
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
                const Expanded(child: Divider(thickness: 0.5)),
              ],
            ),
          ),
          const SizedBox(height: 5),

          //other image picker builder
          ValueListenableBuilder(
            valueListenable: widget.previouslyAddedOtherImages,
            builder: (context, previousOtherImages, child) {
              return ValueListenableBuilder(
                valueListenable: widget.selectedOtherImages,
                builder: (BuildContext context, List<String> otherImages, Widget? child) {
                  final bool isThereAnyImage =
                      previousOtherImages.isNotEmpty || otherImages.isNotEmpty;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomText(
                            'otherImagerRecommend'.translate(context: context),
                            color: Theme.of(context).colorScheme.blackColor,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                CustomInkWellContainer(
                                  onTap: () async {
                                    // Dismiss keyboard when image picker is opened
                                    UiUtils.removeFocus();
                                    try {
                                      final FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                            allowMultiple: true,
                                            type: FileType.image,
                                          );
                                      if (result != null) {
                                        for (
                                          int i = 0;
                                          i < result.files.length;
                                          i++
                                        ) {
                                          if (!widget.selectedOtherImages.value
                                              .contains(result.files[i].path)) {
                                            widget
                                                .selectedOtherImages
                                                .value = List.from(
                                              widget.selectedOtherImages.value,
                                            )..insert(0, result.files[i].path!);
                                          }
                                        }
                                      }
                                    } catch (_) {}
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: isThereAnyImage ? 5 : 0,
                                    ),
                                    child: SetDottedBorderWithHint(
                                      height: 100,
                                      width: isThereAnyImage
                                          ? 150
                                          : MediaQuery.sizeOf(context).width -
                                                30,
                                      radius: 7,
                                      str: isThereAnyImage
                                          ? "addImages".translate(
                                              context: context,
                                            )
                                          : "chooseImages".translate(
                                              context: context,
                                            ),
                                      strPrefix: '',
                                      borderColor: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                    ),
                                  ),
                                ),
                                if (otherImages.isNotEmpty)
                                  for (int i = 0; i < otherImages.length; i++)
                                    CustomContainer(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      height: 100 + 20,
                                      width: isThereAnyImage
                                          ? 150
                                          : MediaQuery.sizeOf(context).width -
                                                30,
                                      borderRadius: UiUtils.borderRadiusOf10,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: CustomContainer(
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(
                                                        UiUtils
                                                            .borderRadiusOf10,
                                                      ),
                                                    ),
                                                child: Image.file(
                                                  File(otherImages[i]),
                                                  height: double.maxFinite,
                                                  width: double.maxFinite,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            child: CustomInkWellContainer(
                                              onTap: () {
                                                //assigning new list, because listener will not notify if we remove the values only to the list
                                                widget
                                                    .selectedOtherImages
                                                    .value = List.from(
                                                  widget
                                                      .selectedOtherImages
                                                      .value,
                                                )..removeAt(i);
                                              },
                                              child: CustomContainer(
                                                height: 20,
                                                borderRadius:
                                                    UiUtils.borderRadiusOf50,
                                                width: 20,
                                                color: AppColors.redColor
                                                    .withValues(alpha: 0.5),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.clear_rounded,
                                                    size: 15,
                                                    color: AppColors.redColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                if (previousOtherImages.isNotEmpty)
                                  for (
                                    int i = 0;
                                    i < previousOtherImages.length;
                                    i++
                                  )
                                    CustomContainer(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      height: 100 + 20,
                                      width: isThereAnyImage
                                          ? 150
                                          : MediaQuery.sizeOf(context).width -
                                                30,
                                      borderRadius: UiUtils.borderRadiusOf10,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: CustomContainer(
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(
                                                        UiUtils
                                                            .borderRadiusOf10,
                                                      ),
                                                    ),
                                                child: CustomCachedNetworkImage(
                                                  imageUrl:
                                                      previousOtherImages[i],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            child: CustomInkWellContainer(
                                              onTap: () {
                                                //assigning new list, because listener will not notify if we remove the values only to the list
                                                widget
                                                    .previouslyAddedOtherImages
                                                    .value = List.from(
                                                  widget
                                                      .previouslyAddedOtherImages
                                                      .value,
                                                )..removeAt(i);
                                                widget.onPreviousImageDeleted
                                                    ?.call(
                                                      previousOtherImages[i],
                                                    );
                                              },
                                              child: CustomContainer(
                                                height: 20,
                                                borderRadius:
                                                    UiUtils.borderRadiusOf50,
                                                width: 20,
                                                color: AppColors.redColor
                                                    .withValues(alpha: 0.5),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.clear_rounded,
                                                    size: 15,
                                                    color: AppColors.redColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _bennerPicker(
    BuildContext context, {
    required PickImage imageController,
    required String oldImage,
    required String hintLabel,
    required String imageType,
  }) {
    return imageController.ListenImageChange((BuildContext context, image) {
      if (image == null) {
        if (widget.pickedLocalImages[imageType] != '') {
          return GestureDetector(
            onTap: () {
              widget.showCameraAndGalleryOption(
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
                  File(widget.pickedLocalImages[imageType]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        if (oldImage.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              widget.showCameraAndGalleryOption(
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
            widget.showCameraAndGalleryOption(
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

      widget.pickedLocalImages[imageType] = image?.path;

      return GestureDetector(
        onTap: () {
          widget.showCameraAndGalleryOption(
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

  Widget _logoPicker(
    BuildContext context, {
    required PickImage imageController,
    required String oldImage,
    required String hintLabel,
    required String imageType,
  }) {
    return imageController.ListenImageChange((BuildContext context, image) {
      if (image == null) {
        if (widget.pickedLocalImages[imageType] != '') {
          return GestureDetector(
            onTap: () {
              widget.showCameraAndGalleryOption(
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
                  File(widget.pickedLocalImages[imageType]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        if (oldImage.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              widget.showCameraAndGalleryOption(
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
            widget.showCameraAndGalleryOption(
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

      widget.pickedLocalImages[imageType] = image?.path;

      return GestureDetector(
        onTap: () {
          widget.showCameraAndGalleryOption(
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
}
