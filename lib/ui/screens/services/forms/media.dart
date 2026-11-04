import 'package:flutter/material.dart';
import 'package:edemand_partner/app/generalImports.dart';

class Form2 extends StatelessWidget {
  const Form2({
    super.key,
    required this.formKey2,
    required this.priceController,
    required this.discountPriceController,
    required this.memReqTaskController,
    required this.durationTaskController,
    required this.qtyAllowedTaskController,
    required this.priceFocus,
    required this.discountPriceFocus,
    required this.memReqTaskFocus,
    required this.durationTaskFocus,
    required this.qtyAllowedTaskFocus,
    required this.selectedPriceType,
    required this.selectedTaxTitle,
    required this.selectedDurationType,
    required this.onPriceTypeSelect,
    required this.onDurationTypeSelect,
    required this.onTaxSelect,
    required this.imagePicker,
    required this.pickedServiceImage,
    required this.onServiceImagePick,

    required this.service,
    required this.context,
    required this.selectedOtherImages,
    required this.previouslyAddedOtherImages,
    required this.onPreviousImageDeleted,
    required this.selectedFiles,
    required this.previouslyAddedFiles,
    required this.onPreviousFileDeleted,
  });

  final GlobalKey<FormState> formKey2;
  final TextEditingController priceController;
  final TextEditingController discountPriceController;
  final TextEditingController memReqTaskController;
  final TextEditingController durationTaskController;
  final TextEditingController qtyAllowedTaskController;
  final FocusNode priceFocus;
  final FocusNode discountPriceFocus;
  final FocusNode memReqTaskFocus;
  final FocusNode durationTaskFocus;
  final FocusNode qtyAllowedTaskFocus;
  final Map? selectedPriceType;
  final String selectedTaxTitle;
  final Map? selectedDurationType;
  final VoidCallback onPriceTypeSelect;
  final VoidCallback onDurationTypeSelect;
  final VoidCallback onTaxSelect;
  final PickImage imagePicker;
  final String pickedServiceImage;
  final Function(ImageSource) onServiceImagePick;

  final ServiceModel? service;
  final BuildContext context;

  final ValueNotifier<List<String>> selectedOtherImages;
  final ValueNotifier<List<String>> previouslyAddedOtherImages;
  final Function(String imagePath)? onPreviousImageDeleted;

  final ValueNotifier<List<String>> selectedFiles;
  final ValueNotifier<List<String>> previouslyAddedFiles;
  final Function(String imagePath)? onPreviousFileDeleted;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  'serviceImgLbl'.translate(context: context),
                  color: Theme.of(context).colorScheme.blackColor,
                ),
                CustomText(
                  " ${'serviceImageRecommend'.translate(context: context)}",
                  color: Theme.of(context).colorScheme.blackColor,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: imagePicker.ListenImageChange((BuildContext context, image) {
              if (image == null) {
                if (pickedServiceImage != '') {
                  return GestureDetector(
                    onTap: () {
                      showCameraAndGalleryOption(
                        imageController: imagePicker,
                        title: 'serviceImgLbl'.translate(context: context),
                      );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SizedBox(
                            height: 200,
                            width: MediaQuery.sizeOf(context).width,
                            child: Image.file(File(pickedServiceImage)),
                          ),
                        ),
                        SizedBox(
                          height: 210,
                          width: (MediaQuery.sizeOf(context).width - 5) + 5,
                          child: DashedRect(
                            color: Theme.of(context).colorScheme.blackColor,
                            strokeWidth: 2.0,
                            gap: 4.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (service?.imageOfTheService != null) {
                  return GestureDetector(
                    onTap: () {
                      showCameraAndGalleryOption(
                        imageController: imagePicker,
                        title: 'serviceImgLbl'.translate(context: context),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 210,
                          width: MediaQuery.sizeOf(context).width,
                          child: DashedRect(
                            color: Theme.of(context).colorScheme.blackColor,
                            strokeWidth: 2.0,
                            gap: 4.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SizedBox(
                            height: 200,
                            width: (MediaQuery.sizeOf(context).width) - 5.0,
                            child: CustomCachedNetworkImage(
                              imageUrl: service?.imageOfTheService ?? '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CustomInkWellContainer(
                    onTap: () {
                      showCameraAndGalleryOption(
                        imageController: imagePicker,
                        title: 'serviceImgLbl'.translate(context: context),
                      );
                    },
                    child: SetDottedBorderWithHint(
                      height: 100,
                      width: MediaQuery.sizeOf(context).width - 35,
                      radius: 7,
                      str: 'chooseImgLbl'.translate(context: context),
                      strPrefix: '',
                      borderColor: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                );
              }

              onServiceImagePick(ImageSource.gallery);

              return GestureDetector(
                onTap: () {
                  showCameraAndGalleryOption(
                    imageController: imagePicker,
                    title: 'serviceImgLbl'.translate(context: context),
                  );
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                        child: Image.file(File(image.path)),
                      ),
                    ),
                    SizedBox(
                      height: 210,
                      width: (MediaQuery.sizeOf(context).width - 5) + 5,
                      child: DashedRect(
                        color: Theme.of(context).colorScheme.blackColor,
                        strokeWidth: 2.0,
                        gap: 4.0,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  'otherImages'.translate(context: context),
                  color: Theme.of(context).colorScheme.blackColor,
                ),
                CustomText(
                  " ${'otherImagerRecommend'.translate(context: context)}",
                  color: Theme.of(context).colorScheme.blackColor,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: previouslyAddedOtherImages,
            builder: (context, previousOtherImages, child) {
              return ValueListenableBuilder(
                valueListenable: selectedOtherImages,
                builder:
                    (
                      BuildContext context,
                      List<String> otherImages,
                      Widget? child,
                    ) {
                      final bool isThereAnyImage =
                          previousOtherImages.isNotEmpty ||
                          otherImages.isNotEmpty;
                      return SizedBox(
                        height: isThereAnyImage ? 150 : 100,
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
                                        if (!selectedOtherImages.value.contains(
                                          result.files[i].path,
                                        )) {
                                          selectedOtherImages.value = List.from(
                                            selectedOtherImages.value,
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
                                    height: double.maxFinite,
                                    width: isThereAnyImage
                                        ? 100
                                        : MediaQuery.sizeOf(context).width - 35,
                                    radius: 7,
                                    str:
                                        (isThereAnyImage
                                                ? "addImages"
                                                : "chooseImages")
                                            .translate(context: context),
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
                                    width: 100,
                                    height: double.maxFinite,
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .blackColor
                                          .withValues(alpha: 0.5),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.file(
                                            File(otherImages[i]),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          child: CustomInkWellContainer(
                                            onTap: () {
                                              //assigning new list, because listener will not notify if we remove the values only to the list
                                              selectedOtherImages.value =
                                                  List.from(
                                                    selectedOtherImages.value,
                                                  )..removeAt(i);
                                            },
                                            child: CustomContainer(
                                              height: 20,
                                              width: 20,
                                              color: AppColors.whiteColors
                                                  .withValues(alpha: 0.4),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.clear_rounded,
                                                  size: 15,
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
                                    width: 100,
                                    height: double.maxFinite,
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .blackColor
                                          .withValues(alpha: 0.5),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: CustomCachedNetworkImage(
                                            key: ValueKey(
                                              previousOtherImages[i],
                                            ),
                                            imageUrl: previousOtherImages[i],
                                            width: 100,
                                            height: double.maxFinite,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          child: CustomInkWellContainer(
                                            onTap: () {
                                              //assigning new list, because listener will not notify if we remove the values only to the list

                                              previouslyAddedOtherImages.value =
                                                  List.from(
                                                    previouslyAddedOtherImages
                                                        .value,
                                                  )..removeAt(i);
                                              onPreviousImageDeleted?.call(
                                                previousOtherImages[i],
                                              );
                                            },
                                            child: CustomContainer(
                                              height: 20,
                                              width: 20,
                                              color: AppColors.whiteColors
                                                  .withValues(alpha: 0.4),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.clear_rounded,
                                                  size: 15,
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
                      );
                    },
              );
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  'files'.translate(context: context),
                  color: Theme.of(context).colorScheme.blackColor,
                ),
                CustomText(
                  " ${'onlyPdfAndDocAllowed'.translate(context: context)}",
                  color: Theme.of(context).colorScheme.blackColor,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: previouslyAddedFiles,
            builder: (context, previousFiles, child) {
              return ValueListenableBuilder(
                valueListenable: selectedFiles,
                builder: (BuildContext context, List<String> files, Widget? child) {
                  final bool isThereAnyFile =
                      files.isNotEmpty || previousFiles.isNotEmpty;
                  return SizedBox(
                    height: 100,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          CustomInkWellContainer(
                            onTap: () async {
                              try {
                                final FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                      allowMultiple: true,
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf',
                                        'doc',
                                        'docx',
                                        'docm',
                                      ],
                                    );
                                if (result != null) {
                                  for (
                                    int i = 0;
                                    i < result.files.length;
                                    i++
                                  ) {
                                    if (!selectedFiles.value.contains(
                                      result.files[i].path,
                                    )) {
                                      selectedFiles.value = List.from(
                                        selectedFiles.value,
                                      )..insert(0, result.files[i].path!);
                                    }
                                  }
                                }
                              } catch (_) {}
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: isThereAnyFile ? 5 : 0,
                              ),
                              child: SetDottedBorderWithHint(
                                height: double.maxFinite,
                                customIconWidget: Icon(
                                  Icons.file_open_outlined,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.lightGreyColor,
                                  size: 20,
                                ),
                                width: isThereAnyFile
                                    ? 100
                                    : MediaQuery.sizeOf(context).width - 35,
                                radius: 7,
                                str:
                                    "${(isThereAnyFile ? "addFiles" : "pickFiles").translate(context: context)}  ",
                                strPrefix: '',
                                borderColor: Theme.of(
                                  context,
                                ).colorScheme.blackColor,
                              ),
                            ),
                          ),
                          if (files.isNotEmpty)
                            for (int i = 0; i < files.length; i++)
                              CustomContainer(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                width: 150,
                                height: double.maxFinite,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .blackColor
                                      .withValues(alpha: 0.5),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: _fileContainer(filePath: files[i]),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: CustomInkWellContainer(
                                        onTap: () {
                                          selectedFiles.value = List.from(
                                            selectedFiles.value,
                                          )..removeAt(i);
                                        },
                                        child: CustomContainer(
                                          height: 20,
                                          width: 20,
                                          color: AppColors.whiteColors
                                              .withValues(alpha: 0.5),
                                          child: const Center(
                                            child: Icon(
                                              Icons.clear_rounded,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          if (previousFiles.isNotEmpty)
                            for (int i = 0; i < previousFiles.length; i++)
                              CustomContainer(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                width: 150,
                                height: double.maxFinite,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .blackColor
                                      .withValues(alpha: 0.5),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: _fileContainer(
                                        filePath: previousFiles[i],
                                        isNetwork: true,
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: CustomInkWellContainer(
                                        onTap: () {
                                          previouslyAddedFiles.value =
                                              List.from(
                                                previouslyAddedFiles.value,
                                              )..removeAt(i);

                                          onPreviousFileDeleted?.call(
                                            previousFiles[i],
                                          );
                                        },
                                        child: CustomContainer(
                                          height: 20,
                                          width: 20,
                                          color: AppColors.whiteColors
                                              .withValues(alpha: 0.5),
                                          child: const Center(
                                            child: Icon(
                                              Icons.clear_rounded,
                                              size: 15,
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
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: TextEditingController(
                    text: selectedPriceType?["title"] ?? '',
                  ),
                  isReadOnly: true,
                  labelText: 'priceType'.translate(context: context),
                  hintText: 'priceType'.translate(context: context),
                  bottomPadding: 0,
                  callback: onPriceTypeSelect,
                  suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  bottomPadding: 0,
                  controller: TextEditingController(text: selectedTaxTitle),
                  suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                  hintText: 'selectTax'.translate(context: context),
                  labelText: 'selectTax'.translate(context: context),
                  isReadOnly: true,
                  validator: (String? value) {
                    if (selectedTaxTitle == '') {
                      return 'pleaseSelectTax'.translate(context: context);
                    }
                    return null;
                  },
                  callback: onTaxSelect,
                ),
                const SizedBox(height: 10),
                setPriceAndDiscountedPrice(),
                CustomTextFormField(
                  bottomPadding: 10,
                  labelText: 'membersForTaskLbl'.translate(context: context),
                  controller: memReqTaskController,
                  currentFocusNode: memReqTaskFocus,
                  inputFormatters: UiUtils.allowOnlyDigits(),
                  nextFocusNode: durationTaskFocus,
                  //if provider type is individual then they can not edit number of members
                  isReadOnly:
                      context.read<ProviderDetailsCubit>().getProviderType() ==
                      "0",
                  validator: (String? value) {
                    return Validator.nullCheck(context, value);
                  },
                  textInputType: TextInputType.number,
                ),
                CustomTextFormField(
                  bottomPadding: 10,
                  labelText: 'durationForTaskLbl'.translate(context: context),
                  controller: durationTaskController,
                  currentFocusNode: durationTaskFocus,
                  nextFocusNode: qtyAllowedTaskFocus,
                  inputFormatters: UiUtils.allowOnlyDigits(),
                  hintText: '120',
                  validator: (String? value) {
                    return Validator.nullCheck(context, value);
                  },
                  prefix: durationTypePrefixWidget(),
                  textInputType: TextInputType.number,
                ),
                CustomTextFormField(
                  bottomPadding: 10,
                  labelText: 'maxQtyAllowedLbl'.translate(context: context),
                  controller: qtyAllowedTaskController,
                  inputFormatters: UiUtils.allowOnlyDigits(),
                  currentFocusNode: qtyAllowedTaskFocus,
                  validator: (String? value) {
                    return Validator.nullCheck(context, value);
                  },
                  textInputType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileContainer({required String filePath, bool isNetwork = false}) {
    return CustomInkWellContainer(
      onTap: () async {
        if (isNetwork) {
          launchUrl(Uri.parse(filePath), mode: LaunchMode.externalApplication);
        } else {
          OpenFile.open(filePath);
        }
      },
      child: SizedBox(
        width: 150,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.file_present_outlined),
            const SizedBox(height: 3),
            Text(
              filePath.extractFileName(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget setPriceAndDiscountedPrice() {
    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            bottomPadding: 10,
            labelText: 'priceLbl'.translate(context: context),
            inputFormatters: [
              UiUtils.decimalPlacesFormatter(context.providerDecimalPlaces),
            ],
            controller: priceController,
            currentFocusNode: priceFocus,
            prefix: Padding(
              padding: const EdgeInsetsDirectional.all(15.0),
              child: CustomText(
                context.providerCurrencySymbol,
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.blackColor,
              ),
            ),
            nextFocusNode: discountPriceFocus,
            validator: (String? value) {
              return Validator.nullCheck(context, value);
            },
            textInputType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: CustomTextFormField(
            bottomPadding: 10,
            labelText: 'discountPriceLbl'.translate(context: context),
            controller: discountPriceController,
            currentFocusNode: discountPriceFocus,
            inputFormatters: [
              UiUtils.decimalPlacesFormatter(context.providerDecimalPlaces),
            ],
            prefix: Padding(
              padding: const EdgeInsetsDirectional.all(15.0),
              child: CustomText(
                context.providerCurrencySymbol,
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.blackColor,
              ),
            ),
            validator: (String? value) {
              if (value != null && value.isNotEmpty) {
                if (num.parse(value) > num.parse(priceController.text)) {
                  return 'discountIsMoreThanPrice'.translate(context: context);
                } else if (num.parse(value) ==
                    num.parse(priceController.text)) {
                  return 'discountPriceCanNotBeEqualToPrice'.translate(
                    context: context,
                  );
                }
              }
              return Validator.nullCheck(context, value);
            },
            textInputType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget durationTypePrefixWidget() {
    return GestureDetector(
      onTap: onDurationTypeSelect,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                selectedDurationType?["title"] ??
                    'minutesLbl'.translate(context: context),
                fontSize: 15.0,
                color: Theme.of(context).colorScheme.blackColor,
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
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
      ),
    );
  }
}
