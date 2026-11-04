import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class HandymanEditProfileScreen extends StatefulWidget {
  const HandymanEditProfileScreen({super.key, required this.profile});

  final HandymanProfileModel profile;

  @override
  State<HandymanEditProfileScreen> createState() =>
      _HandymanEditProfileScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final profile = routeSettings.arguments as HandymanProfileModel;
    return CupertinoPageRoute(
      builder: (_) => HandymanEditProfileScreen(profile: profile),
    );
  }
}

class _HandymanEditProfileScreenState extends State<HandymanEditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<CustomFieldsFormState> _customFieldsKey =
      GlobalKey<CustomFieldsFormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final PickImage _pickImage = PickImage();

  bool _isAvailable = true;
  bool _submitInProgress = false;

  // The credential the handyman signed in with can't be changed here.
  final LoginType? _loginType = HiveRepository.getHandymanLoginType;
  bool get _isPhoneLocked => _loginType?.isPhone ?? false;
  bool get _isEmailLocked => _loginType?.isEmail ?? false;

  List<AppLanguage> _languages = [];
  AppLanguage? _defaultLanguage;
  int _selectedLanguageIndex = 0;
  final Map<String, TextEditingController> _usernameControllers = {};
  bool _languagesReady = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _phoneController.text = p.phone;
    _emailController.text = p.email;
    _addressController.text = p.address;
    _isAvailable = p.available;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCustomFieldsCubit>().fetchCustomFields(
        fieldGroup: 'handyman_details',
      );
      _initCountryCode(p.countryCode);
      final langState = context.read<LanguageListCubit>().state;
      if (langState is GetLanguageListSuccess && !_languagesReady) {
        _setupLanguages(langState.languages, langState.defaultLanguage, p);
      }
    });
  }

  void _initCountryCode(String countryCode) {
    final state = context.read<CountryCodeCubit>().state;
    if (state is CountryCodeFetchSuccess) {
      final match = state.countryList?.firstWhere(
        (c) => c.callingCode == countryCode,
        orElse: () => state.selectedCountry!,
      );
      if (match != null) {
        context.read<CountryCodeCubit>().selectCountryCode(match);
      }
    }
  }

  void _setupLanguages(
    List<AppLanguage> list,
    AppLanguage? defaultLang,
    HandymanProfileModel p,
  ) {
    _languages = [];
    _defaultLanguage = defaultLang;
    if (defaultLang != null) {
      _languages.add(defaultLang);
      for (final l in list) {
        if (l.languageCode != defaultLang.languageCode) _languages.add(l);
      }
    } else {
      _languages = list;
    }

    for (final lang in _languages) {
      final initial =
          p.translations[lang.languageCode] ??
          (lang == _languages.first ? p.username : '');
      _usernameControllers[lang.languageCode] = TextEditingController(
        text: initial,
      );
    }

    _languagesReady = true;
    if (mounted) setState(() {});
  }

  Map<String, String> _collectUsernames() {
    final result = <String, String>{};
    for (final lang in _languages) {
      final text = _usernameControllers[lang.languageCode]?.text.trim() ?? '';
      if (text.isNotEmpty) result[lang.languageCode] = text;
    }
    return result;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pickImage.dispose();
    for (final c in _usernameControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    UiUtils.removeFocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final countryState = context.read<CountryCodeCubit>().state;
    if (countryState is! CountryCodeFetchSuccess) {
      UiUtils.showMessage(
        context,
        'pleaseWait'.translate(context: context),
        ToastificationType.info,
      );
      return;
    }

    final usernames = _collectUsernames();
    final defaultLangCode =
        _defaultLanguage?.languageCode ??
        (_languages.isNotEmpty ? _languages.first.languageCode : 'en');

    if ((usernames[defaultLangCode] ?? '').isEmpty) {
      UiUtils.showMessage(
        context,
        'pleaseEnterUsernameForDefaultLanguage'.translate(context: context),
        ToastificationType.error,
      );
      return;
    }

    final countryCode = context
        .read<CountryCodeCubit>()
        .getSelectedCountryCode();
    final customValues = _customFieldsKey.currentState?.getKeyValueMap() ?? {};

    _submitInProgress = true;
    context.read<HandymanProfileCubit>().updateProfile(
      usernameByLang: usernames,
      phone: _phoneController.text.trim(),
      countryCode: countryCode,
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      profileImagePath: _pickImage.pickedFile?.path,
      customFieldValues: customValues,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'completeRegistration'.translate(context: context),
        statusBarColor: context.colorScheme.secondaryColor,
        elevation: 1,
      ),
      body: BlocListener<HandymanProfileCubit, HandymanProfileState>(
        listenWhen: (_, current) =>
            (current is HandymanProfileSuccess && _submitInProgress) ||
            current is HandymanProfileLoggedOut ||
            current is HandymanProfileFailure,
        listener: (context, state) {
          if (state is HandymanProfileSuccess) {
            _submitInProgress = false;
            UiUtils.showMessage(
              context,
              'profileUpdatedSuccessfully'.translate(context: context),
              ToastificationType.success,
            );
            Navigator.pop(context, true);
          } else if (state is HandymanProfileFailure) {
            final wasSubmit = _submitInProgress;
            _submitInProgress = false;
            UiUtils.showMessage(
              context,
              state.errorMessage.translate(context: context),
              ToastificationType.error,
            );
            // Revert availability switch if failure was from an availability-only update
            if (!wasSubmit) {
              setState(() => _isAvailable = !_isAvailable);
            }
          } else if (state is HandymanProfileLoggedOut) {
            _submitInProgress = false;
            AuthRepository().logout(context);
          }
        },
        child: BlocListener<LanguageListCubit, LanguageListState>(
          listener: (context, state) {
            if (state is GetLanguageListSuccess && !_languagesReady) {
              _setupLanguages(
                state.languages,
                state.defaultLanguage,
                widget.profile,
              );
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  15,
                  15,
                  15 + UiUtils.bottomButtonSpacing,
                ),
                child: _buildForm(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    if (!_languagesReady) {
      return const ShimmerLoadingContainer(
        child: Column(
          children: [
            CustomShimmerContainer(
              height: 120,
              margin: EdgeInsets.only(bottom: 15),
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
              height: 60,
              margin: EdgeInsets.only(bottom: 15),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePicker(),
          const SizedBox(height: 16),
          if (_languages.length > 1) _buildLanguageTabs(),
          const SizedBox(height: 12),
          _buildUsernameField(),
          // const SizedBox(height: 12),
          EmailOrPhoneField(
            controller: _phoneController,
            bottomPadding: 0,
            isPhoneAuthEnabled: true,
            isEmailAuthEnabled: false,
            isReadOnly: _isPhoneLocked,
            hintText: 'enterMobileNumber'.translate(context: context),
            validator: (value) =>
                Validator.validateNumber(context, value ?? ''),
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _emailController,
            labelText: 'emailOptionalLbl'.translate(context: context),
            textInputType: TextInputType.emailAddress,
            isReadOnly: _isEmailLocked,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              return Validator.validateEmail(context, value);
            },
          ),
          // const SizedBox(height: 12),
          CustomTextFormField(
            controller: _addressController,
            labelText: 'addressOptionalLbl'.translate(context: context),
            expands: true,
            heightVal: 70,
            textInputType: TextInputType.multiline,
          ),
          // const SizedBox(height: 12),
          // _buildAvailabilitySwitch(),
          // const SizedBox(height: 12),
          _buildCustomFields(),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'profileImageLbl'.translate(context: context),
          color: context.colorScheme.blackColor,
        ),
        const SizedBox(height: 6),
        _pickImage.ListenImageChange((context, image) {
          if (image == null) {
            if (widget.profile.image.isNotEmpty) {
              return GestureDetector(
                onTap: _pickImage.pick,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
                  child: CustomCachedNetworkImage(
                    imageUrl: widget.profile.image,
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            return CustomInkWellContainer(
              onTap: _pickImage.pick,
              child: SetDottedBorderWithHint(
                height: 120,
                width: MediaQuery.sizeOf(context).width - 35,
                radius: 7,
                str: 'chooseImgLbl'.translate(context: context),
                strPrefix: '',
                borderColor: context.colorScheme.blackColor,
              ),
            );
          }
          return GestureDetector(
            onTap: _pickImage.pick,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
              child: Image.file(
                image,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLanguageTabs() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _languages.asMap().entries.map((entry) {
            final index = entry.key;
            final language = entry.value;
            final isSelected = _selectedLanguageIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedLanguageIndex = index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.accentColor
                      : context.colorScheme.secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  language.languageName,
                  color: isSelected
                      ? AppColors.whiteColors
                      : context.colorScheme.blackColor,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    if (_languages.isEmpty) return const SizedBox.shrink();
    final lang = _languages[_selectedLanguageIndex];
    final isDefault =
        lang.languageCode == _defaultLanguage?.languageCode ||
        _selectedLanguageIndex == 0;
    final label = _languages.length > 1
        ? '${'nameLbl'.translate(context: context)} (${lang.languageName})'
        : 'nameLbl'.translate(context: context);
    return CustomTextFormField(
      key: ValueKey('username_${lang.languageCode}'),
      controller: _usernameControllers[lang.languageCode],
      labelText: label,
      validator: (value) =>
          isDefault ? Validator.nullCheck(context, value) : null,
    );
  }

  // Widget _buildAvailabilitySwitch() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: CustomText(
  //           'availabilityLbl'.translate(context: context),
  //           color: context.colorScheme.blackColor,
  //         ),
  //       ),
  //       CustomSwitch(
  //         value: _isAvailable,
  //         thumbColor: _isAvailable ? Colors.green : Colors.red,
  //         onChanged: (val) {
  //           setState(() => _isAvailable = val);
  //           context.read<HandymanProfileCubit>().updateAvailability(
  //             available: val,
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCustomFields() {
    return BlocBuilder<GetCustomFieldsCubit, GetCustomFieldsState>(
      builder: (context, state) {
        if (state is GetCustomFieldsInProgress) {
          return const ShimmerLoadingContainer(
            child: CustomShimmerContainer(height: 60),
          );
        }
        if (state is GetCustomFieldsSuccess && state.fields.isNotEmpty) {
          final Map<String, dynamic> initialValues = {
            for (final cf in widget.profile.customFields)
              if (cf.value.isNotEmpty && !cf.isFile) cf.id.toString(): cf.value,
          };
          return CustomFieldsForm(
            key: _customFieldsKey,
            fields: state.fields,
            initialValues: initialValues,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<HandymanProfileCubit, HandymanProfileState>(
      builder: (context, state) {
        final inProgress =
            state is HandymanProfileInProgress ||
            state is HandymanProfileUpdating;
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
            onTap: inProgress ? () {} : _onSubmit,
            backgroundColor: context.colorScheme.accentColor,
            buttonTitle: 'saveBtnLbl'.translate(context: context),
            showBorder: true,
            child: inProgress
                ? CustomCircularProgressIndicator(color: AppColors.whiteColors)
                : null,
          ),
        );
      },
    );
  }
}
