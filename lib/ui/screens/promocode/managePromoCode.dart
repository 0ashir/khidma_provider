import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../app/generalImports.dart';

class ManagePromocode extends StatefulWidget {
  const ManagePromocode({super.key, this.promocode});

  final PromocodeModel? promocode;

  @override
  ManagePromocodeState createState() => ManagePromocodeState();

  static Route<ManagePromocode> route(RouteSettings routeSettings) {
    final Map? arguments = routeSettings.arguments as Map?;
    return CupertinoPageRoute(
      builder: (_) => ManagePromocode(promocode: arguments?['promocode']),
    );
  }
}

class ManagePromocodeState extends State<ManagePromocode> {
  int currIndex = 1;
  int totalForms = 2;

  //form 1
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  Map? selectedDiscountType;
  String? _discountTypeValue;
  ScrollController scrollController = ScrollController();

  // Multi-language support
  List<AppLanguage> languages = [];
  AppLanguage? defaultLanguage;
  int selectedLanguageIndex = 0;
  StreamSubscription? _languageListSubscription;
  bool _hasInitializedData = false;
  late Map<String, TextEditingController> messageControllers;
  Map<String, String> savedMessageData = {};
  String? selectedStartDate;
  String? selectedEndDate;

  late TextEditingController promocodeController = TextEditingController(
    text: widget.promocode?.promoCode,
  );
  late TextEditingController startDtController = TextEditingController(
    text: widget.promocode?.startDate?.split(" ").first.toString().formatDate(),
  );
  late TextEditingController endDtController = TextEditingController(
    text: widget.promocode?.endDate?.split(" ").first.toString().formatDate(),
  );
  late TextEditingController noOfUserController = TextEditingController(
    text: widget.promocode?.noOfUsers,
  );
  late TextEditingController minOrderAmtController = TextEditingController(
    text: widget.promocode?.minimumOrderAmount,
  );
  late TextEditingController discountController = TextEditingController(
    text: widget.promocode?.discount,
  );
  late TextEditingController discountTypeController = TextEditingController(
    text: widget.promocode?.discountType.toString().translate(context: context),
  );
  late TextEditingController noOfRepeatUsageController = TextEditingController(
    text: widget.promocode?.noOfRepeatUsage,
  );
  FocusNode promocodeFocus = FocusNode();
  FocusNode startDtFocus = FocusNode();
  FocusNode endDtFocus = FocusNode();
  FocusNode noOfUserFocus = FocusNode();
  FocusNode minOrderAmtFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode discountTypeFocus = FocusNode();
  FocusNode maxDiscFocus = FocusNode();
  FocusNode messageFocus = FocusNode();
  FocusNode noOfRepeatUsage = FocusNode();
  PickImage pickImage = PickImage();

  bool isStatus = false;
  bool isRepeatUsage = false;

  late TextEditingController maxDiscController = TextEditingController(
    text: widget.promocode?.maxDiscountAmount,
  );
  late TextEditingController messageController = TextEditingController();

  List<Map> discountTypesFilter = [];

  @override
  void dispose() {
    _languageListSubscription?.cancel();
    promocodeController.dispose();
    startDtController.dispose();
    endDtController.dispose();
    noOfUserController.dispose();
    minOrderAmtController.dispose();
    discountController.dispose();
    discountTypeController.dispose();
    noOfRepeatUsageController.dispose();
    promocodeFocus.dispose();
    endDtFocus.dispose();
    noOfUserFocus.dispose();
    minOrderAmtFocus.dispose();
    discountFocus.dispose();
    discountTypeFocus.dispose();
    maxDiscFocus.dispose();
    messageFocus.dispose();
    noOfRepeatUsage.dispose();
    pickImage.dispose();
    maxDiscController.dispose();
    messageController.dispose();

    for (final controller in messageControllers.values) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint("error===$e");
      }
    }

    super.dispose();
  }

  void _chooseImage() {
    UiUtils.removeFocus();
    pickImage.pick();
  }

  void onAddPromoCode() {
    UiUtils.removeFocus();
    final FormState? form = formKey1.currentState; //default value
    if (form == null) return;

    form.save();

    // Save current language message before validation
    _saveCurrentLanguageMessage();

    if (languages.isNotEmpty && defaultLanguage != null) {
      final defaultLangCode = defaultLanguage!.languageCode;

      final defaultMessage =
          (savedMessageData[defaultLangCode] == null ||
                  savedMessageData[defaultLangCode]!.trim().isEmpty
              ? messageController.text
              : savedMessageData[defaultLangCode]) ??
          '';

      if (defaultMessage.trim().isEmpty) {
        UiUtils.showMessage(
          context,
          'pleaseEnterMessageForDefaultLanguage'.translate(context: context),
          ToastificationType.error,
        );
        return;
      }
    }

    if (selectedDiscountType?['value'] == 'amount') {
      if (maxDiscFocus.hasFocus) {
        maxDiscFocus.unfocus();
      }
    }

    if (form.validate()) {
      if (pickImage.pickedFile != null || widget.promocode?.image != null) {
        _saveCurrentLanguageMessage();

        final Map<String, String> multiLangMessages = {};
        if (languages.isNotEmpty) {
          for (final language in languages) {
            final message = savedMessageData[language.languageCode] ?? '';
            if (message.isNotEmpty) {
              multiLangMessages[language.languageCode] = message;
            }
          }
        }

        String? translatedFieldsJson;
        if (multiLangMessages.isNotEmpty) {
          final translatedFields = {'message': multiLangMessages};
          translatedFieldsJson = jsonEncode(translatedFields);
        }

        final String? discountTypeValue =
            _discountTypeValue ?? selectedDiscountType?['value']?.toString();

        final CreatePromocodeModel createPromocode = CreatePromocodeModel(
          promo_id: widget.promocode?.id,
          promoCode: promocodeController.text,
          startDate: selectedStartDate.toString(),
          endDate: selectedEndDate.toString(),
          minimumOrderAmount: minOrderAmtController.text,
          discountType: discountTypeValue,
          discount: discountController.text,
          maxDiscountAmount: discountTypeValue == 'percentage'
              ? maxDiscController.text
              : null,
          message: messageController.text,
          multiLanguageMessages: multiLangMessages.isNotEmpty
              ? multiLangMessages
              : null,
          translatedFieldsJson: translatedFieldsJson,
          repeat_usage: isRepeatUsage ? '1' : '0',
          status: isStatus ? "1" : '0',
          no_of_users: noOfUserController.text,
          no_of_repeat_usage: noOfRepeatUsageController.text,
          image: pickImage.pickedFile,
        );

        context.read<CreatePromocodeCubit>().createPromocode(createPromocode);
      } else {
        FocusScope.of(context).unfocus();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('imageRequired'.translate(context: context)),
              content: Text('pleaseSelectImage'.translate(context: context)),
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

  @override
  void initState() {
    if (widget.promocode?.status != null) {
      if (widget.promocode?.status == '0') {
        isStatus = false;
      } else {
        isStatus = true;
      }
    }
    if (widget.promocode?.repeatUsage != null) {
      if (widget.promocode?.repeatUsage == '0') {
        isRepeatUsage = false;
      } else {
        isRepeatUsage = true;
      }
    }

    if (widget.promocode?.startDate != null) {
      selectedStartDate = _normalizeDateToApiFormat(
        widget.promocode!.startDate!.split(" ").first,
      );
    }
    if (widget.promocode?.endDate != null) {
      selectedEndDate = _normalizeDateToApiFormat(
        widget.promocode!.endDate!.split(" ").first,
      );
    }

    _initializeLanguageSupport();
    super.initState();
  }

  void _initializeLanguageSupport() {
    context.read<LanguageListCubit>().getLanguageList();

    _languageListSubscription = context.read<LanguageListCubit>().stream.listen(
      (state) {
        if (state is GetLanguageListSuccess && !_hasInitializedData) {
          _setupLanguageControllers(state.languages, state.defaultLanguage);
          _hasInitializedData = true;
        }
      },
    );
  }

  void _setupLanguageControllers(
    List<AppLanguage> languageList,
    AppLanguage? defLanguage,
  ) {
    languages = [];
    defaultLanguage = defLanguage;

    if (defaultLanguage != null) {
      languages.add(defaultLanguage!);
      for (final language in languageList) {
        if (language.languageCode != defaultLanguage!.languageCode) {
          languages.add(language);
        }
      }
    } else {
      languages = languageList;
    }
    messageControllers = {};
    savedMessageData = {};

    for (final language in languages) {
      String initialMessage = '';

      if (widget.promocode != null) {
        if (widget.promocode!.translatedMessages != null &&
            widget.promocode!.translatedMessages!.containsKey(
              language.languageCode,
            )) {
          initialMessage =
              widget.promocode!.translatedMessages![language.languageCode]!;
        } else if (language.languageCode == defaultLanguage?.languageCode) {
          if (widget.promocode!.translatedMessage != null &&
              widget.promocode!.translatedMessage!.isNotEmpty) {
            initialMessage = widget.promocode!.translatedMessage!;
          } else if (widget.promocode!.message != null &&
              widget.promocode!.message!.isNotEmpty) {
            initialMessage = widget.promocode!.message!;
          }
        }
      }

      messageControllers[language.languageCode] = TextEditingController(
        text: initialMessage,
      );
      savedMessageData[language.languageCode] = initialMessage;
    }

    selectedLanguageIndex = 0;

    _updateCurrentMessageController();

    messageController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void _updateCurrentMessageController() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      messageController =
          messageControllers[currentLangCode] ?? TextEditingController();
    }
  }

  void _saveCurrentLanguageMessage() {
    if (languages.isNotEmpty && selectedLanguageIndex < languages.length) {
      final currentLangCode = languages[selectedLanguageIndex].languageCode;
      savedMessageData[currentLangCode] = messageController.text;
    }
  }

  void _switchLanguage(int newIndex) {
    if (newIndex == selectedLanguageIndex || newIndex >= languages.length)
      return;

    if (selectedLanguageIndex == 0 && defaultLanguage != null) {
      final currentMessage = messageController.text.trim();
      if (currentMessage.isEmpty) {
        UiUtils.showMessage(
          context,
          'pleaseEnterMessageForDefaultLanguage'.translate(context: context),
          ToastificationType.error,
        );
        return;
      }
    }

    _saveCurrentLanguageMessage();

    selectedLanguageIndex = newIndex;
    _updateCurrentMessageController();

    setState(() {});
  }

  String? _validateMessage(String? value) {
    if (selectedLanguageIndex == 0 && defaultLanguage != null) {
      return Validator.nullCheck(context, value);
    }
    return null;
  }

  FocusNode? _getNextFocusNodeAfterDiscountType() {
    if (selectedDiscountType?['value'] == 'amount') {
      return isRepeatUsage ? noOfRepeatUsage : null;
    }
    return maxDiscFocus;
  }

  String? _validateDiscount(String? value) {
    final nullCheckError = Validator.nullCheck(context, value, nonZero: true);
    if (nullCheckError != null) {
      return nullCheckError;
    }

    if (value == null || value.isEmpty) {
      return null;
    }

    final discountValue = double.tryParse(value);
    if (discountValue == null) {
      return 'pleaseEnterValidNumber'.translate(context: context);
    }

    final discountType = selectedDiscountType?['value'];

    if (discountType == 'percentage') {
      if (discountValue > 100) {
        return 'discountCannotExceed100Percent'.translate(context: context);
      }
    } else if (discountType == 'amount') {
      final minOrderAmount = double.tryParse(minOrderAmtController.text);
      if (minOrderAmount != null && discountValue > minOrderAmount) {
        return 'discountCannotExceedMinOrderAmount'.translate(context: context);
      }
    }

    return null;
  }

  String? _validateMaxDiscountAmount(String? value) {
    final discountType = selectedDiscountType?['value'];

    if (discountType != 'percentage') {
      return null;
    }

    final nullCheckError = Validator.nullCheck(context, value);
    if (nullCheckError != null) {
      return nullCheckError;
    }

    if (value == null || value.isEmpty) {
      return null;
    }

    final maxDiscountValue = double.tryParse(value);
    if (maxDiscountValue == null) {
      return 'pleaseEnterValidNumber'.translate(context: context);
    }

    if (maxDiscountValue < 0) {
      return 'pleaseEnterValidNumber'.translate(context: context);
    }

    return null;
  }

  String? _validateRepeatUsage(String? value) {
    if (!isRepeatUsage) {
      return null;
    }

    final nullCheckError = Validator.nullCheck(context, value, nonZero: true);
    if (nullCheckError != null) {
      return nullCheckError;
    }

    if (value == null || value.isEmpty) {
      return null;
    }

    final repeatUsageValue = int.tryParse(value);
    if (repeatUsageValue == null) {
      return 'pleaseEnterValidNumber'.translate(context: context);
    }

    if (repeatUsageValue <= 0) {
      return 'repeatUsageMustBeGreaterThanZero'.translate(context: context);
    }

    return null;
  }

  String? _normalizeDateToApiFormat(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      try {
        final dateTime = DateTime.parse(dateString);
        return DateFormat('yyyy-MM-dd').format(dateTime);
      } catch (_) {
        final List<String> possibleFormats = [
          'dd-MM-yyyy',
          'dd/MM/yyyy',
          'MM-dd-yyyy',
          'MM/dd/yyyy',
          'yyyy-MM-dd',
          'yyyy/MM/dd',
        ];

        for (final format in possibleFormats) {
          try {
            final dateTime = DateFormat(format).parse(dateString);
            return DateFormat('yyyy-MM-dd').format(dateTime);
          } catch (_) {
            continue;
          }
        }

        return null;
      }
    } catch (e) {
      debugPrint('Error normalizing date: $dateString - $e');
      return null;
    }
  }

  bool _isLanguageTabEnabled(int targetIndex) {
    if (targetIndex == 0) {
      return true;
    }
    if (selectedLanguageIndex > 0) {
      return true;
    }
    final String defaultMessage = messageController.text.trim();
    return defaultMessage.isNotEmpty;
  }

  @override
  void didChangeDependencies() {
    discountTypesFilter = [
      {
        'value': 'percentage',
        'title': 'percentage'.translate(context: context),
      },
      {'value': 'amount', 'title': 'amount'.translate(context: context)},
    ];

    if (widget.promocode?.discountType != null &&
        selectedDiscountType == null) {
      final matchingTypes = discountTypesFilter
          .where(
            (Map element) => element['value'] == widget.promocode?.discountType,
          )
          .toList();
      if (matchingTypes.isNotEmpty) {
        selectedDiscountType = matchingTypes[0];
        _discountTypeValue = widget.promocode?.discountType;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LanguageListCubit())],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: "promocodeLbl".translate(context: context),

          statusBarColor: context.colorScheme.secondaryColor,
          elevation: 1,
        ),
        body: BlocListener<CreatePromocodeCubit, CreatePromocodeState>(
          listener: (BuildContext context, CreatePromocodeState state) {
            if (state is CreatePromocodeFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
            if (state is CreatePromocodeSuccess) {
              try {
                if (state.id != null) {
                  context.read<FetchPromocodesCubit>().updatePromocode(
                    state.promocode,
                    state.id!,
                  );
                } else {
                  context.read<FetchPromocodesCubit>().addPromocodeToCubit(
                    state.promocode,
                  );
                }
              } catch (_) {}
              Navigator.pop(context);
            }
          },
          child: screenBuilder(currIndex),
        ),
      ),
    );
  }

  Widget screenBuilder(int currentPage) {
    return Stack(
      children: [
        SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.fromLTRB(
            15,
            15,
            15,
            15 + UiUtils.bottomButtonSpacing,
          ),
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: PromoCodeForm(),
        ),
        Align(alignment: Alignment.bottomCenter, child: bottomNavigation()),
      ],
    );
  }

  Widget PromoCodeForm() {
    if (languages.isEmpty) {
      return const ShimmerLoadingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            CustomShimmerContainer(
              height: 50,
              margin: EdgeInsets.only(bottom: 20),
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
                    height: 60,
                    margin: EdgeInsets.only(right: 5),
                  ),
                ),
                Expanded(
                  child: CustomShimmerContainer(
                    height: 60,
                    margin: EdgeInsets.only(left: 5),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Form(
      key: formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            labelText: 'promocodeLbl'.translate(context: context),
            controller: promocodeController,
            currentFocusNode: promocodeFocus,
            validator: (String? value) => Validator.nullCheck(context, value),
            nextFocusNode: messageFocus,
          ),

          if (languages.length > 1) ...[
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: languages.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final AppLanguage language = entry.value;
                    final bool isSelected = selectedLanguageIndex == index;
                    final bool isEnabled = _isLanguageTabEnabled(index);

                    return GestureDetector(
                      onTap: () => _switchLanguage(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
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
                          language.languageName,
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
          ],

          CustomTextFormField(
            expands: true,
            heightVal: 70,
            labelText:
                languages.isNotEmpty && selectedLanguageIndex < languages.length
                ? '${'messageLbl'.translate(context: context)} (${languages[selectedLanguageIndex].languageName})'
                : 'messageLbl'.translate(context: context),
            controller: messageController,
            currentFocusNode: messageFocus,
            nextFocusNode: startDtFocus,
            textInputType: TextInputType.multiline,
            validator: (String? value) => _validateMessage(value),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                'imageLbl'.translate(context: context),
                color: Theme.of(context).colorScheme.blackColor,
              ),
              CustomText(
                " ${'promoCodeImageRecommend'.translate(context: context)}",
                color: Theme.of(context).colorScheme.blackColor,
                fontSize: 12,
              ),
            ],
          ),

          pickImage.ListenImageChange((BuildContext context, image) {
            if (image == null) {
              if (widget.promocode?.image != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: _chooseImage,
                    child: CustomContainer(
                      width: MediaQuery.of(context).size.width / 0.5,
                      height: 200,
                      color: context.colorScheme.accentColor.withAlpha(30),
                      borderRadius: UiUtils.borderRadiusOf10,
                      border: Border.all(
                        color: context.colorScheme.accentColor,
                        width: 1,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(UiUtils.borderRadiusOf10),
                        ),
                        child: CustomCachedNetworkImage(
                          imageUrl: widget.promocode!.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomInkWellContainer(
                  onTap: _chooseImage,
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

            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: _chooseImage,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.sizeOf(context).width,
                      child: Image.file(image),
                    ),
                    SizedBox(
                      height: 210,
                      width: MediaQuery.sizeOf(context).width - 5,
                      child: DashedRect(
                        color: Theme.of(context).colorScheme.blackColor,
                        strokeWidth: 2.0,
                        gap: 4.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  labelText: 'startDateLbl'.translate(context: context),
                  controller: startDtController,
                  currentFocusNode: startDtFocus,
                  nextFocusNode: endDtFocus,
                  validator: (String? value) =>
                      Validator.nullCheck(context, value),
                  callback: () =>
                      onDateTap(isStartDate: true, startDtController),
                  isReadOnly: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextFormField(
                  labelText: 'endDateLbl'.translate(context: context),
                  controller: endDtController,
                  currentFocusNode: endDtFocus,
                  nextFocusNode: minOrderAmtFocus,
                  callback: () {
                    if (startDtController.text.isEmpty) {
                      FocusScope.of(context).unfocus();
                      UiUtils.showMessage(
                        context,
                        'selectStartDateFirst',
                        ToastificationType.warning,
                      );
                      return;
                    }
                    onDateTap(endDtController, isStartDate: false);
                  },
                  validator: (String? value) =>
                      Validator.nullCheck(context, value),
                  isReadOnly: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  labelText: 'minOrderAmtLbl'.translate(context: context),
                  controller: minOrderAmtController,
                  allowOnlySingleDecimalPoint: true,
                  currentFocusNode: minOrderAmtFocus,
                  nextFocusNode: noOfUserFocus,
                  validator: (String? value) =>
                      Validator.nullCheck(context, value, nonZero: true),
                  textInputType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextFormField(
                  labelText: 'noOfUserLbl'.translate(context: context),
                  controller: noOfUserController,
                  currentFocusNode: noOfUserFocus,
                  nextFocusNode: discountFocus,
                  inputFormatters: UiUtils.allowOnlyDigits(),
                  textInputType: TextInputType.number,
                  validator: (String? value) =>
                      Validator.nullCheck(context, value, nonZero: true),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  labelText: 'discountLbl'.translate(context: context),
                  controller: discountController,
                  textInputType: TextInputType.phone,
                  allowOnlySingleDecimalPoint: true,
                  currentFocusNode: discountFocus,
                  nextFocusNode: discountTypeFocus,
                  validator: (String? value) => _validateDiscount(value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextFormField(
                  isReadOnly: true,
                  suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                  labelText: 'discTypeLbl'.translate(context: context),
                  controller: discountTypeController,
                  validator: (String? value) {
                    if (selectedDiscountType == null) {
                      return 'chooseDiscountType'.translate(context: context);
                    }
                    return null;
                  },
                  currentFocusNode: discountTypeFocus,
                  nextFocusNode: _getNextFocusNodeAfterDiscountType(),
                  callback: () async {
                    final List<Map<String, dynamic>> values = [
                      {
                        'id': 'percentage',
                        'title': 'percentage'.translate(context: context),
                        "isSelected":
                            selectedDiscountType?['value'] == "percentage",
                      },
                      {
                        'id': 'amount',
                        'title': 'amount'.translate(context: context),
                        "isSelected":
                            selectedDiscountType?['value'] == "amount",
                      },
                    ];
                    UiUtils.showModelBottomSheets(
                      context: context,
                      child: SelectableListBottomSheet(
                        bottomSheetTitle: "discTypeLbl",
                        itemList: values,
                      ),
                    ).then((value) {
                      if (value != null && value["selectedItemId"] != null) {
                        discountTypeController.text =
                            value['selectedItemName']?.toString() ?? '';

                        final selectedId = value["selectedItemId"]
                            ?.toString()
                            .trim();

                        if (selectedId != null &&
                            (selectedId == 'percentage' ||
                                selectedId == 'amount')) {
                          _discountTypeValue = selectedId;

                          selectedDiscountType = {
                            'value': selectedId,
                            'title':
                                value['selectedItemName']?.toString() ??
                                selectedId,
                          };

                          if (selectedId == 'amount') {
                            maxDiscController.clear();
                          }
                        }

                        setState(() {});
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (selectedDiscountType?['value'] != null &&
                  selectedDiscountType?['value'] == 'percentage')
                Expanded(
                  child: CustomTextFormField(
                    labelText: 'maxDiscAmtLbl'.translate(context: context),
                    controller: maxDiscController,
                    currentFocusNode: maxDiscFocus,
                    nextFocusNode: noOfRepeatUsage,
                    allowOnlySingleDecimalPoint: true,
                    textInputType: TextInputType.number,
                    validator: (String? value) {
                      return _validateMaxDiscountAmount(value);
                    },
                  ),
                ),
              if (isRepeatUsage) ...[
                if (selectedDiscountType?['value'] == 'percentage')
                  const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    labelText: 'noOfRepeatUsage'.translate(context: context),
                    controller: noOfRepeatUsageController,
                    currentFocusNode: noOfRepeatUsage,
                    inputFormatters: UiUtils.allowOnlyDigits(),
                    validator: (String? p0) => _validateRepeatUsage(p0),
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomCheckIconTextButton(
                  onTap: () {
                    isRepeatUsage = !isRepeatUsage;
                    setState(() {});
                  },
                  isSelected: isRepeatUsage,
                  title: 'repeatUsageLbl'.translate(context: context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomCheckIconTextButton(
                  onTap: () {
                    isStatus = !isStatus;
                    setState(() {});
                  },
                  isSelected: isStatus,
                  title: 'statusLbl'.translate(context: context),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Future<void> onDateTap(
    TextEditingController dateInput, {
    required bool isStartDate,
  }) async {
    final DateTime? initialDate = isStartDate
        ? null
        : DateTime.parse('$selectedStartDate 00:00:00.000');

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: initialDate ?? DateTime.now().subtract(Duration.zero), //1
      lastDate: DateTime.now().add(
        const Duration(days: UiUtils.noOfDaysAllowToCreatePromoCode),
      ),
    );

    if (pickedDate != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (isStartDate) {
        selectedStartDate = formattedDate;
      } else {
        selectedEndDate = formattedDate;
      }
      setState(() {
        dateInput.text = formattedDate.formatDate();
      });
    }
  }

  Widget setTitleAndSwitch({
    required Function()? onTap,
    required String titleText,
    required bool isAllowed,
  }) {
    return CustomInkWellContainer(
      showSplashEffect: false,
      onTap: () {
        onTap?.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              titleText,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.blackColor,
            ),
          ),
          CustomSwitch(
            thumbColor: isAllowed ? Colors.green : Colors.red,
            value: isAllowed,
            onChanged: (bool val) {
              onTap?.call();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Padding bottomNavigation() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 5,
        left: 15,
        right: 15,
      ),
      child: CustomRoundedButton(
        widthPercentage: 1,
        textSize: 14,
        height: 55,
        titleColor: AppColors.whiteColors,
        onTap:
            (context.watch<CreatePromocodeCubit>().state
                is CreatePromocodeInProgress)
            ? () {}
            : onAddPromoCode,
        backgroundColor: Theme.of(context).colorScheme.accentColor,
        buttonTitle: widget.promocode?.id != null
            ? 'savePromoCodeTitleLbl'.translate(context: context)
            : 'addPromoCodeTitleLbl'.translate(context: context),
        showBorder: true,
        child:
            (context.watch<CreatePromocodeCubit>().state
                is CreatePromocodeInProgress)
            ? CustomCircularProgressIndicator(color: AppColors.whiteColors)
            : null,
      ),
    );
  }
}
