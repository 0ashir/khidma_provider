import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

/// Create / edit a handyman (provider-side).
class ManageHandymanScreen extends StatefulWidget {
  const ManageHandymanScreen({super.key, this.handyman});

  final HandymanModel? handyman;

  @override
  State<ManageHandymanScreen> createState() => _ManageHandymanScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final Map? arguments = routeSettings.arguments as Map?;
    return CupertinoPageRoute(
      builder: (_) => ManageHandymanScreen(handyman: arguments?['handyman']),
    );
  }
}

class _ManageHandymanScreenState extends State<ManageHandymanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<CustomFieldsFormState> _customFieldsKey =
      GlobalKey<CustomFieldsFormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  final PickImage _pickImage = PickImage();

  bool _isActive = true;

  // Multi-language username support.
  List<AppLanguage> _languages = [];
  AppLanguage? _defaultLanguage;
  int _selectedLanguageIndex = 0;
  final Map<String, TextEditingController> _usernameControllers = {};
  bool _languagesReady = false;

  bool get _isEditing => widget.handyman != null;

  /// Handymen always use the provider's country; the form has no picker.
  String get _countryCode {
    final String code =
        context
            .read<ProviderDetailsCubit>()
            .providerDetails
            .user
            ?.countryCode ??
        '';
    return (code.isNotEmpty && code != 'null')
        ? code
        : context.read<CountryCodeCubit>().getSelectedCountryCode();
  }

  String _formatSalary(String salary) {
    final double? value = double.tryParse(salary.replaceAll(',', ''));
    return value == null
        ? salary
        : value.toStringAsFixed(context.providerDecimalPlaces);
  }

  @override
  void initState() {
    super.initState();
    final handyman = widget.handyman;
    if (handyman != null) {
      _phoneController.text = handyman.phone;
      _emailController.text = handyman.email;
      _addressController.text = handyman.address;
      _salaryController.text = _formatSalary(handyman.salary);
      _isActive = handyman.isActive;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCustomFieldsCubit>().fetchCustomFields(
        fieldGroup: 'handyman_details',
      );
      final languageState = context.read<LanguageListCubit>().state;
      if (languageState is GetLanguageListSuccess && !_languagesReady) {
        _setupLanguages(languageState.languages, languageState.defaultLanguage);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    _pickImage.dispose();
    for (final c in _usernameControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _setupLanguages(List<AppLanguage> list, AppLanguage? defaultLang) {
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
      String initial = '';
      final handyman = widget.handyman;
      if (handyman != null) {
        initial = handyman.usernameForLanguage(lang.languageCode);
      }
      _usernameControllers[lang.languageCode] = TextEditingController(
        text: initial,
      );
    }
    _languagesReady = true;
    if (mounted) setState(() {});
  }

  Map<String, String> _collectUsernames() {
    final Map<String, String> result = {};
    for (final lang in _languages) {
      final text = _usernameControllers[lang.languageCode]?.text.trim() ?? '';
      if (text.isNotEmpty) result[lang.languageCode] = text;
    }
    return result;
  }

  void _onSubmit() {
    UiUtils.removeFocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

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

    // Profile image required on create.
    final String? imagePath = _pickImage.pickedFile?.path;
    if (!_isEditing && (imagePath == null || imagePath.isEmpty)) {
      UiUtils.showMessage(
        context,
        'pleaseSelectImage'.translate(context: context),
        ToastificationType.error,
      );
      return;
    }

    final model = CreateHandymanModel(
      handymanId: _isEditing ? widget.handyman!.id : null,
      usernameByLang: usernames,
      phone: _phoneController.text.trim(),
      countryCode: _countryCode,
      password: _isEditing ? null : _passwordController.text,
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      salary: _salaryController.text.trim(),
      status: _isActive ? 1 : 0,
      profileImagePath: imagePath,
      customFieldValues: _customFieldsKey.currentState?.getKeyValueMap() ?? {},
    );

    context.read<ManageHandymanCubit>().manageHandyman(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: (_isEditing ? 'editHandymanLbl' : 'addHandymanLbl').translate(
          context: context,
        ),
        statusBarColor: context.colorScheme.secondaryColor,
        elevation: 1,
      ),
      body: BlocListener<ManageHandymanCubit, ManageHandymanState>(
        listener: (context, state) {
          if (state is ManageHandymanSuccess) {
            UiUtils.showMessage(
              context,
              state.message,
              ToastificationType.success,
            );
            Navigator.pop(context, true);
          }
          if (state is ManageHandymanFailure) {
            UiUtils.showMessage(
              context,
              state.errorMessage,
              ToastificationType.error,
            );
          }
        },
        child: BlocListener<LanguageListCubit, LanguageListState>(
          listener: (context, state) {
            if (state is GetLanguageListSuccess && !_languagesReady) {
              _setupLanguages(state.languages, state.defaultLanguage);
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
          _buildUsernameField(),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _phoneController,
            textInputType: TextInputType.phone,
            inputFormatters: UiUtils.allowOnlyDigits(),
            isDense: false,
            fillColor: Colors.transparent,
            hintText: 'enterMobileNumber'.translate(context: context),
            hintTextColor: context.colorScheme.lightGreyColor,
            // Prefix box is forced to 48dp tall and Padding pins its child to
            // the top, so centre the text. Same size and scaling as the input.
            prefix: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
              child: Center(
                widthFactor: 1,
                child: Text(
                  _countryCode,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colorScheme.blackColor,
                  ),
                ),
              ),
            ),
            validator: (value) =>
                Validator.validateNumber(context, value ?? ''),
          ),
          const SizedBox(height: 12),
          if (!_isEditing) ...[
            CustomTextFormField(
              controller: _passwordController,
              isPassword: true,
              labelText: 'passwordLbl'.translate(context: context),
              validator: (value) => Validator.validatePassword(context, value),
            ),
            const SizedBox(height: 12),
          ],
          CustomTextFormField(
            controller: _emailController,
            labelText: 'emailOptionalLbl'.translate(context: context),
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              return Validator.validateEmail(context, value);
            },
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _addressController,
            labelText: 'addressOptionalLbl'.translate(context: context),
            expands: true,
            heightVal: 70,
            textInputType: TextInputType.multiline,
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _salaryController,
            labelText: 'salaryLbl'.translate(context: context),
            inputFormatters: [
              UiUtils.decimalPlacesFormatter(context.providerDecimalPlaces),
            ],
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            prefix: Padding(
              padding: const EdgeInsetsDirectional.all(15.0),
              child: CustomText(
                context.providerCurrencySymbol,
                fontSize: 14.0,
                color: context.colorScheme.blackColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusSwitch(),
          const SizedBox(height: 12),
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
            if (_isEditing && widget.handyman!.image.isNotEmpty) {
              return GestureDetector(
                onTap: _pickImage.pick,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
                  child: CustomCachedNetworkImage(
                    imageUrl: widget.handyman!.image,
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

  Widget _buildStatusSwitch() {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            'statusLbl'.translate(context: context),
            color: context.colorScheme.blackColor,
          ),
        ),
        CustomSwitch(
          value: _isActive,
          thumbColor: _isActive ? Colors.green : Colors.red,
          onChanged: (val) => setState(() => _isActive = val),
        ),
      ],
    );
  }

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
            for (final cf in (widget.handyman?.customFields ?? []))
              if (cf.value != null && !cf.isFile) cf.id.toString(): cf.value,
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
    final bool inProgress =
        context.watch<ManageHandymanCubit>().state is ManageHandymanInProgress;
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
        buttonTitle: (_isEditing ? 'saveBtnLbl' : 'addHandymanLbl').translate(
          context: context,
        ),
        showBorder: true,
        child: inProgress
            ? CustomCircularProgressIndicator(color: AppColors.whiteColors)
            : null,
      ),
    );
  }
}
