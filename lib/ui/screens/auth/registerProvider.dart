import 'package:edemand_partner/data/model/countryCodeModel.dart';
import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class ProviderRegistration extends StatefulWidget {
  const ProviderRegistration({
    super.key,
    required this.mobileNumber,
    required this.countryCode,
    required this.phoneNumberWithOutCountryCode,
    this.email,
    required this.loginType,
  });

  final String mobileNumber;
  final String phoneNumberWithOutCountryCode;
  final String countryCode;
  final String? email;
  final LoginType loginType;

  @override
  ProviderRegistrationState createState() => ProviderRegistrationState();

  static Route<ProviderRegistration> route(RouteSettings routeSettings) {
    final Map<String, dynamic> parameter =
        routeSettings.arguments as Map<String, dynamic>;

    // Get loginType from parameters, default to phone if not provided
    final LoginType loginType = parameter['loginType'] is LoginType
        ? parameter['loginType'] as LoginType
        : LoginType.phone;

    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<RegisterProviderCubit>(
            create: (BuildContext context) => RegisterProviderCubit(),
          ),
          BlocProvider<FetchCountriesCubit>(
            create: (BuildContext context) => FetchCountriesCubit(),
          ),
          BlocProvider<FetchRegionsCubit>(
            create: (BuildContext context) => FetchRegionsCubit(),
          ),
        ],
        child: ProviderRegistration(
          mobileNumber: parameter['registeredMobileNumber'].toString(),
          countryCode: parameter['countryCode'].toString(),
          phoneNumberWithOutCountryCode:
              parameter['phoneNumberWithOutCountryCode'].toString(),
          email: parameter['email'],
          loginType: loginType,
        ),
      ),
    );
  }
}

class ProviderRegistrationState extends State<ProviderRegistration> {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  ///form1
  TextEditingController userNmController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController companyNmController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController taxRegistrationNumberController =
      TextEditingController();

  CountryModel? selectedCountry;
  RegionModel? selectedRegion;

  FocusNode userNmFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobNoFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode companyNameFocus = FocusNode();

  // No multi-language support needed for company name
  List<Map<String, String>> languages = [];

  @override
  void dispose() {
    userNmController.dispose();
    emailController.dispose();
    mobNoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyNmController.dispose();
    countryController.dispose();
    regionController.dispose();
    taxRegistrationNumberController.dispose();

    // No language-specific controllers to dispose

    userNmFocus.dispose();
    emailFocus.dispose();
    mobNoFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    companyNameFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // Set email or phone based on login type
    if (widget.loginType.isEmail) {
      emailController.text = widget.email ?? '';
      // Phone number is empty - user needs to enter it
    } else {
      mobNoController.text = widget.phoneNumberWithOutCountryCode;
    }
    // Always set the country code from widget to ensure cubit is initialized correctly
    _setCountryCodeFromWidget();
    _initializeLanguages();
    context.read<FetchCountriesCubit>().fetchCountries();
    super.initState();
  }

  void _setCountryCodeFromWidget() {
    Future.delayed(Duration.zero, () {
      final cubitState = context.read<CountryCodeCubit>().state;
      if (cubitState is CountryCodeFetchSuccess) {
        // The phone step may have picked Canada or the US (both +1); keep it.
        if (cubitState.selectedCountry?.callingCode == widget.countryCode) {
          return;
        }
        // Find country by calling code
        final country = cubitState.countryList?.firstWhere(
          (c) => c.callingCode == widget.countryCode,
          orElse: () => cubitState.selectedCountry!,
        );
        if (country != null) {
          context.read<CountryCodeCubit>().selectCountryCode(country);
        }
      }
    });
  }

  void _initializeLanguages() {
    final cubit = context.read<LanguageListCubit>();
    final currentLang = HiveRepository.getCurrentLanguage();

    if (currentLang == null) return;

    // Trigger fetching language list from cubit
    cubit.getLanguageList();

    // Listen to cubit state once and initialize languages when success
    cubit.stream.listen((state) {
      if (state is GetLanguageListSuccess) {
        languages = [
          {'code': currentLang.languageCode, 'name': currentLang.languageName},
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

        setState(() {}); // Refresh UI if needed
      }
    });
  }

  Widget _buildCountryCodePrefix() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12.0, bottom: 2),
      child: BlocBuilder<CountryCodeCubit, CountryCodeState>(
        builder: (BuildContext context, CountryCodeState state) {
          String code = '--';

          if (state is CountryCodeFetchSuccess) {
            code = state.selectedCountry!.callingCode;
          }

          return SizedBox(
            height: 27,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInkWellContainer(
                  onTap: () {
                    // Only allow changing country code when email login (phone is editable)
                    if (widget.loginType.isPhone) {
                      return; // Read-only, can't change
                    }

                    if (allowOnlySingleCountry ||
                        (state is CountryCodeFetchSuccess &&
                            state.temporaryCountryList != null &&
                            state.temporaryCountryList!.length == 1)) {
                      return;
                    }
                    Navigator.pushNamed(
                      context,
                      Routes.countryCodePickerRoute,
                    ).then((Object? value) {
                      Future.delayed(const Duration(milliseconds: 250)).then((
                        value,
                      ) {
                        context.read<CountryCodeCubit>().fillTemporaryList();
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          if (state is CountryCodeFetchSuccess) {
                            return SizedBox(
                              width: 35,
                              height: 27,
                              child: CountryFlag(
                                country: state.selectedCountry!,
                              ),
                            );
                          }
                          if (state is CountryCodeFetchFail) {
                            return ErrorContainer(
                              errorMessage: state.error.toString().translate(
                                context: context,
                              ),
                            );
                          }
                          return const CustomCircularProgressIndicator();
                        },
                      ),
                      const SizedBox(width: 10),
                      if (!allowOnlySingleCountry &&
                          !(state is CountryCodeFetchSuccess &&
                              state.temporaryCountryList != null &&
                              state.temporaryCountryList!.length == 1) &&
                          widget
                              .loginType
                              .isEmail) // Only show dropdown when email login
                        CustomSvgPicture(
                          svgImage: AppAssets.spDown,
                          height: 5,
                          width: 5,
                          color: Theme.of(context).colorScheme.accentColor,
                        ),
                    ],
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  indent: 6,
                  endIndent: 6,
                  color: Theme.of(context).colorScheme.lightGreyColor,
                ),
                Text(
                  code,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 5),
              ],
            ),
          );
        },
      ),
    );
  }

  /// The country picked with the phone's calling code; null until codes load.
  CountryCodeModel? get _phoneCountry {
    final CountryCodeState state = context.read<CountryCodeCubit>().state;
    return state is CountryCodeFetchSuccess ? state.selectedCountry : null;
  }

  /// Only the phone's own country, found by id: countries share calling codes
  /// (+1: United States and Canada), so the code alone cannot tell them apart.
  /// Phone login only: its number was verified in that country. An email login
  /// can pick any country. All countries while the phone country is unknown or
  /// not in [all].
  List<CountryModel> _countriesForPhone(final List<CountryModel> all) {
    final CountryCodeModel? phoneCountry = _phoneCountry;
    if (widget.loginType.isEmail || phoneCountry == null) return all;

    final List<CountryModel> matched = all
        .where((CountryModel c) => c.id == phoneCountry.id)
        .toList();
    return matched.isEmpty ? all : matched;
  }

  void _applyCountry(final CountryModel? country) {
    selectedCountry = country;
    countryController.text = country?.name ?? '';

    // Regions depend on country - clear old selection and reload
    selectedRegion = null;
    regionController.clear();
    if (country != null) {
      context.read<FetchRegionsCubit>().fetchRegions(countryId: country.id);
    }
    setState(() {});
  }

  /// Keeps the country in line with the phone's country: it is preselected, and
  /// a different country is dropped.
  void _syncCountryWithPhone(final List<CountryModel> all) {
    if (widget.loginType.isEmail) return;

    final List<CountryModel> allowed = _countriesForPhone(all);
    if (selectedCountry != null &&
        allowed.any((CountryModel c) => c.id == selectedCountry!.id)) {
      return;
    }

    CountryModel? pick;
    for (final CountryModel c in allowed) {
      if (c.id == _phoneCountry?.id) pick = c;
    }
    if (pick == null && allowed.length == 1) pick = allowed.first;

    if (pick == null && selectedCountry == null) return;
    _applyCountry(pick);
  }

  Future<void> _selectCountry() async {
    final FetchCountriesState state = context.read<FetchCountriesCubit>().state;

    if (state is FetchCountriesInProgress) return;
    if (state is! FetchCountriesSuccess) {
      // Initial / failed - retry loading list
      context.read<FetchCountriesCubit>().fetchCountries();
      return;
    }

    final dynamic result = await UiUtils.showModelBottomSheets(
      context: context,
      child: SelectableListBottomSheet(
        bottomSheetTitle: 'selectCountry',
        itemList: _countriesForPhone(state.countries)
            .map(
              (CountryModel country) => {
                'title': country.name,
                'id': country.id,
                'isSelected': country.id == selectedCountry?.id,
              },
            )
            .toList(),
      ),
    );

    if (result == null || !mounted) return;

    final String? countryId = result['selectedItemId']?.toString();
    if (countryId == null || countryId == selectedCountry?.id) return;

    _applyCountry(
      state.countries.firstWhere(
        (CountryModel country) => country.id == countryId,
      ),
    );
  }

  Future<void> _selectRegion() async {
    if (selectedCountry == null) {
      UiUtils.showMessage(
        context,
        'selectCountryFirst'.translate(context: context),
        ToastificationType.warning,
      );
      return;
    }

    final FetchRegionsState state = context.read<FetchRegionsCubit>().state;

    if (state is FetchRegionsInProgress) return;
    if (state is! FetchRegionsSuccess) {
      // Failed - retry loading list
      context.read<FetchRegionsCubit>().fetchRegions(
        countryId: selectedCountry!.id,
      );
      return;
    }

    final dynamic result = await UiUtils.showModelBottomSheets(
      context: context,
      child: SelectableListBottomSheet(
        bottomSheetTitle: 'selectRegion',
        itemList: state.regions
            .map(
              (RegionModel region) => {
                'title': region.name,
                'id': region.id,
                'isSelected': region.id == selectedRegion?.id,
              },
            )
            .toList(),
      ),
    );

    if (result == null || !mounted) return;

    final String? regionId = result['selectedItemId']?.toString();
    if (regionId == null) return;

    selectedRegion = state.regions.firstWhere(
      (RegionModel region) => region.id == regionId,
    );
    regionController.text = selectedRegion!.name;
    setState(() {});
  }

  Widget _loadingSuffix() {
    return const Padding(
      padding: EdgeInsets.all(14),
      child: SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildCountryField() {
    return BlocBuilder<FetchCountriesCubit, FetchCountriesState>(
      builder: (BuildContext context, FetchCountriesState state) {
        final bool isLoading = state is FetchCountriesInProgress;
        return CustomTextFormField(
          labelText: 'countryLbl'.translate(context: context),
          controller: countryController,
          isReadOnly: true,
          isDropdown: !isLoading,
          suffixIcon: isLoading ? _loadingSuffix() : null,
          callback: _selectCountry,
          validator: (String? country) => Validator.nullCheck(context, country),
        );
      },
    );
  }

  Widget _buildRegionField() {
    return BlocBuilder<FetchRegionsCubit, FetchRegionsState>(
      builder: (BuildContext context, FetchRegionsState state) {
        final bool isLoading = state is FetchRegionsInProgress;
        return CustomTextFormField(
          labelText: 'regionLbl'.translate(context: context),
          controller: regionController,
          isReadOnly: true,
          isDropdown: !isLoading,
          suffixIcon: isLoading ? _loadingSuffix() : null,
          callback: _selectRegion,
          validator: (String? region) => Validator.nullCheck(context, region),
        );
      },
    );
  }

  // Method to get company name data for API

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FetchCountriesCubit, FetchCountriesState>(
          listener: (BuildContext context, FetchCountriesState state) {
            if (state is FetchCountriesSuccess) {
              _syncCountryWithPhone(state.countries);
            }
          },
        ),
      ],
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    // Show loading indicator if languages are not yet loaded
    if (languages.isEmpty) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'regFormTitle'.translate(context: context),
          elevation: 1,
          statusBarColor: context.colorScheme.secondaryColor,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'regFormTitle'.translate(context: context),
        elevation: 1,
        statusBarColor: context.colorScheme.secondaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            clipBehavior: Clip.none,
            child: Form(
              key: formKey1,
              child: Column(
                children: [
                  // Company Name Field (Single language)
                  CustomTextFormField(
                    labelText: 'compNmLbl'.translate(context: context),
                    controller: companyNmController,
                    currentFocusNode: companyNameFocus,
                    validator: (String? companyName) =>
                        Validator.nullCheck(context, companyName),
                  ),
                  CustomTextFormField(
                    labelText: 'userNmLbl'.translate(context: context),
                    controller: userNmController,
                    currentFocusNode: userNmFocus,
                    nextFocusNode: emailFocus,
                    validator: (String? username) =>
                        Validator.nullCheck(context, username),
                  ),
                  CustomTextFormField(
                    labelText: 'emailLbl'.translate(context: context),
                    controller: emailController,
                    currentFocusNode: emailFocus,
                    nextFocusNode: mobNoFocus,
                    textInputType: TextInputType.emailAddress,
                    isReadOnly: widget.loginType.isEmail,
                    validator: (String? email) =>
                        Validator.validateEmail(context, email),
                  ),
                  // Mobile number field with country code picker
                  CustomTextFormField(
                    labelText: 'mobNoLbl'.translate(context: context),
                    controller: mobNoController,
                    currentFocusNode: mobNoFocus,
                    nextFocusNode: passwordFocus,
                    textInputType: TextInputType.phone,
                    inputFormatters: UiUtils.allowOnlyDigits(),
                    isReadOnly: widget.loginType.isPhone,
                    validator: (String? mobile) {
                      if (mobile == null || mobile.isEmpty) {
                        return 'fieldMustNotBeEmpty'.translate(
                          context: context,
                        );
                      }
                      return Validator.validateNumber(context, mobile);
                    },
                    prefix: _buildCountryCodePrefix(),
                  ),
                  _buildCountryField(),
                  _buildRegionField(),
                  CustomTextFormField(
                    labelText: 'taxRegistrationNumberLbl'.translate(
                      context: context,
                    ),
                    controller: taxRegistrationNumberController,
                    maxLength: UiUtils.taxRegistrationNumberMaxLength,
                    inputFormatters: UiUtils.taxRegistrationNumberFormatters(),
                  ),
                  CustomPasswordFieldWithValidators(
                    controller: passwordController,
                    labelText: 'passwordLbl'.translate(context: context),
                    currentFocusNode: passwordFocus,
                    nextFocusNode: confirmPasswordFocus,
                    validator: (String? password) {
                      return Validator.validatePassword(context, password);
                    },
                    bottomPadding: 15,
                  ),
                  CustomTextFormField(
                    labelText: 'confirmPasswordLbl'.translate(context: context),
                    controller: confirmPasswordController,
                    currentFocusNode: confirmPasswordFocus,
                    nextFocusNode: companyNameFocus,
                    isPassword: true,
                    validator: (String? confirmPassword) =>
                        Validator.nullCheck(context, confirmPassword),
                  ),
                  const SizedBox(height: 55),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
              child: BlocConsumer<RegisterProviderCubit, RegisterProviderState>(
                listener: (BuildContext context, RegisterProviderState state) {
                  if (state is RegisterProviderSuccess) {
                    HiveRepository.setUserLoggedIn = true;
                    context.read<FetchCountrySettingsCubit>().fetch();
                    context.read<ProviderDetailsCubit>().setUserInfo(
                      state.providerDetails,
                    );
                    UiUtils.navigateAfterAuth(context, clearStack: true);
                  } else if (state is RegisterProviderFailure) {
                    UiUtils.showMessage(
                      context,
                      state.errorMessage,
                      ToastificationType.error,
                    );
                  }
                },
                builder: (BuildContext context, RegisterProviderState state) {
                  Widget? child;
                  if (state is RegisterProviderInProgress) {
                    child = CustomCircularProgressIndicator(
                      color: AppColors.whiteColors,
                    );
                  } else if (state is RegisterProviderSuccess ||
                      state is RegisterProviderFailure) {
                    child = null;
                  }
                  return CustomRoundedButton(
                    showBorder: false,
                    buttonTitle: 'submitBtnLbl'.translate(context: context),
                    widthPercentage: 1,
                    backgroundColor: Theme.of(context).colorScheme.accentColor,
                    titleColor: AppColors.whiteColors,
                    child: child,
                    onTap: () {
                      if (state is RegisterProviderInProgress) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      formKey1.currentState?.save();

                      if (formKey1.currentState!.validate()) {
                        if (passwordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          UiUtils.showMessage(
                            context,
                            'confirmPasswordDoesNotMatch',
                            ToastificationType.error,
                          );
                          return;
                        }

                        final Map<String, dynamic> parameter = {
                          'username': userNmController.text.trim(),
                          'company_name': companyNmController.text.trim(),
                          'password': passwordController.text.trim(),
                          'password_confirm': passwordController.text.trim(),
                          'login_type': widget.loginType.value,
                          'email': emailController.text.trim(),
                          'mobile': mobNoController.text.trim(),
                          ApiParam.countryId: selectedCountry!.id,
                          ApiParam.regionId: selectedRegion!.id,
                        };

                        parameter[ApiParam.taxRegistrationNumber] =
                            taxRegistrationNumberController.text.trim();

                        // Add country code - get from cubit
                        final countryCode = context
                            .read<CountryCodeCubit>()
                            .getSelectedCountryCode();
                        parameter['country_code'] = countryCode;

                        context.read<RegisterProviderCubit>().registerProvider(
                          parameter: parameter,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
