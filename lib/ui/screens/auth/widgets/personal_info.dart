import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class PersonalInfo extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController mobileNumberController;
  final FocusNode userNmFocus;
  final FocusNode emailFocus;
  final FocusNode mobNoFocus;
  final GlobalKey<FormState> formKey;
  final GlobalKey<CustomFieldsFormState> customFieldsKey;
  final String? atStore;
  final String? atDoorstepAllowed;
  final String? isPreBookingChatAllowed;
  final String? isPostBookingChatAllowed;
  final Function(String?) onAtStoreChanged;
  final Function(String?) onAtDoorstepChanged;
  final Function(String?) onPreBookingChatChanged;
  final Function(String?) onPostBookingChatChanged;
  final Function showCameraAndGalleryOption;

  // Multi-language support for username
  final List<AppLanguage>? languages;
  final AppLanguage? defaultLanguage;
  final int? selectedLanguageIndex;
  final Function(int)? onLanguageChanged;
  final Map<String, TextEditingController>? userNameControllers;
  final String? Function(String?)? getUserNameValidator;

  final Map<String, dynamic>? customFieldsLocalValues;

  // Login type to determine field editability
  final LoginType? loginType;

  /// View-only country / region the provider registered with. A field is
  /// shown only when its controller has text.
  final TextEditingController? countryController;
  final TextEditingController? regionController;

  /// Editable tax registration number (GST, SIN, VAT...). Hidden when null.
  final TextEditingController? taxRegistrationNumberController;

  const PersonalInfo({
    Key? key,
    required this.userNameController,
    required this.emailController,
    required this.mobileNumberController,
    required this.userNmFocus,
    required this.emailFocus,
    required this.mobNoFocus,
    required this.formKey,
    required this.customFieldsKey,
    required this.atStore,
    required this.atDoorstepAllowed,
    required this.isPreBookingChatAllowed,
    required this.isPostBookingChatAllowed,
    required this.onAtStoreChanged,
    required this.onAtDoorstepChanged,
    required this.onPreBookingChatChanged,
    required this.onPostBookingChatChanged,
    required this.showCameraAndGalleryOption,
    // Multi-language support for username
    this.languages,
    this.defaultLanguage,
    this.selectedLanguageIndex,
    this.onLanguageChanged,
    this.userNameControllers,
    this.getUserNameValidator,
    this.customFieldsLocalValues,
    this.loginType,
    this.countryController,
    this.regionController,
    this.taxRegistrationNumberController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Don't show shimmer here - parent form handles loading state
    // This widget is displayed inside proivderRegistrationForm which has its own shimmer

    // ID Proof requirements are now dynamic using CustomFieldsForm

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Language Tabs for Username (only show if more than one language)
          if (languages != null && languages!.length > 1) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: languages!.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final AppLanguage language = entry.value;
                      final bool isSelected = selectedLanguageIndex == index;

                      return GestureDetector(
                        onTap: () => onLanguageChanged?.call(index),
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
            ),
          ],
          // Username Field (Multi-language)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                if (languages != null && languages!.isNotEmpty) ...[
                  CustomTextFormField(
                    labelText:
                        languages![selectedLanguageIndex ?? 0].languageCode ==
                            defaultLanguage?.languageCode
                        ? '${'userNmLbl'.translate(context: context)} *'
                        : '${'userNmLbl'.translate(context: context)} (${languages![selectedLanguageIndex ?? 0].languageName})',
                    hintText:
                        languages![selectedLanguageIndex ?? 0].languageCode ==
                            defaultLanguage?.languageCode
                        ? null
                        : '${'userNmLbl'.translate(context: context)} (${languages![selectedLanguageIndex ?? 0].languageName})',
                    controller:
                        userNameControllers?[languages![selectedLanguageIndex ??
                                0]
                            .languageCode] ??
                        userNameController,
                    currentFocusNode: userNmFocus,
                    prefix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.person,
                            color: userNmFocus.hasFocus
                                ? context.colorScheme.accentColor
                                : context.colorScheme.blackColor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 1,
                          height: 15,
                          color: context.colorScheme.lightGreyColor,
                        ),
                      ],
                    ),
                    nextFocusNode: emailFocus,
                    validator:
                        getUserNameValidator ??
                        (String? userName) =>
                            Validator.nullCheck(context, userName),
                  ),
                ] else ...[
                  // Fallback to original field if languages not loaded
                  CustomTextFormField(
                    labelText: 'userNmLbl'.translate(context: context),
                    controller: userNameController,
                    currentFocusNode: userNmFocus,
                    prefix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.person,
                            color: userNmFocus.hasFocus
                                ? context.colorScheme.accentColor
                                : context.colorScheme.blackColor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 1,
                          height: 15,
                          color: context.colorScheme.lightGreyColor,
                        ),
                      ],
                    ),
                    nextFocusNode: emailFocus,
                    validator: (String? userName) =>
                        Validator.nullCheck(context, userName),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomTextFormField(
              labelText: 'emailLbl'.translate(context: context),
              controller: emailController,
              currentFocusNode: emailFocus,
              prefix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.mail,
                      color: emailFocus.hasFocus
                          ? context.colorScheme.accentColor
                          : context.colorScheme.blackColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 1,
                    height: 15,
                    color: context.colorScheme.lightGreyColor,
                  ),
                ],
              ),
              nextFocusNode: mobNoFocus,
              textInputType: TextInputType.emailAddress,
              isReadOnly: loginType?.isEmail ?? false,
              validator: (String? email) => Validator.nullCheck(context, email),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomTextFormField(
              labelText: 'mobNoLbl'.translate(context: context),
              controller: mobileNumberController,
              currentFocusNode: mobNoFocus,
              prefix: _buildCountryCodePrefix(context),
              textInputType: TextInputType.phone,
              inputFormatters: UiUtils.allowOnlyDigits(),
              isReadOnly: loginType?.isPhone ?? true,
              validator: (String? mobileNumber) =>
                  Validator.nullCheck(context, mobileNumber),
            ),
          ),
          if (countryController?.text.isNotEmpty ?? false) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                labelText: 'countryLbl'.translate(context: context),
                controller: countryController,
                isReadOnly: true,
              ),
            ),
          ],
          if (regionController?.text.isNotEmpty ?? false) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                labelText: 'regionLbl'.translate(context: context),
                controller: regionController,
                isReadOnly: true,
              ),
            ),
          ],
          if (taxRegistrationNumberController != null) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextFormField(
                labelText: 'taxRegistrationNumberLbl'.translate(
                  context: context,
                ),
                controller: taxRegistrationNumberController,
                maxLength: UiUtils.taxRegistrationNumberMaxLength,
                inputFormatters: UiUtils.taxRegistrationNumberFormatters(),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: BlocBuilder<GetCustomFieldsCubit, GetCustomFieldsState>(
              builder: (context, state) {
                if (state is GetCustomFieldsInProgress) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CustomCircularProgressIndicator()),
                  );
                } else if (state is GetCustomFieldsSuccess) {
                  final fields = state.fields
                      .where((f) => f.fieldGroup == 'documents')
                      .toList();
                  if (fields.isEmpty) return const SizedBox.shrink();

                  return CustomFieldsForm(
                    key: customFieldsKey,
                    fields: fields,
                    initialValues: {
                      ...state.savedValues,
                      if (customFieldsLocalValues != null)
                        ...customFieldsLocalValues!,
                    },
                  );
                } else if (state is GetCustomFieldsFail) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ErrorContainer(
                      errorMessage: state.error,
                      showErrorImage: false,
                      errorMessageFontSize: 12,
                      onTapRetry: () {
                        context
                            .read<GetCustomFieldsCubit>()
                            .fetchCustomFields();
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Expanded(child: Divider(thickness: 0.5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                    'bookingSetting'.translate(context: context),
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
                const Expanded(child: Divider(thickness: 0.5)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: CustomCheckIconTextButton(
                    title: 'atStore',
                    isSelected: atStore == "1",
                    onTap: () {
                      onAtStoreChanged(atStore == "1" ? "0" : "1");
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: CustomCheckIconTextButton(
                    title: 'atDoorstep',
                    isSelected: atDoorstepAllowed == "1",
                    onTap: () {
                      onAtDoorstepChanged(atDoorstepAllowed == "1" ? "0" : "1");
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if ((context.read<FetchSystemSettingsCubit>().state
                      as FetchSystemSettingsSuccess)
                  .chatSettings
                  .isPostBookingChatAllowed ||
              (context.read<FetchSystemSettingsCubit>().state
                      as FetchSystemSettingsSuccess)
                  .chatSettings
                  .isPreBookingChatAllowed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Expanded(child: Divider(thickness: 0.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomText(
                      'chatSetting'.translate(context: context),
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 0.5)),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                if ((context.read<FetchSystemSettingsCubit>().state
                        as FetchSystemSettingsSuccess)
                    .chatSettings
                    .isPreBookingChatAllowed)
                  Expanded(
                    child: CustomCheckIconTextButton(
                      title: "preBooking",
                      isSelected: isPreBookingChatAllowed == "1",
                      onTap: () {
                        onPreBookingChatChanged(
                          isPreBookingChatAllowed == "1" ? "0" : "1",
                        );
                      },
                    ),
                  ),
                if ((context.read<FetchSystemSettingsCubit>().state
                            as FetchSystemSettingsSuccess)
                        .chatSettings
                        .isPostBookingChatAllowed &&
                    (context.read<FetchSystemSettingsCubit>().state
                            as FetchSystemSettingsSuccess)
                        .chatSettings
                        .isPreBookingChatAllowed)
                  const SizedBox(width: 5),
                if ((context.read<FetchSystemSettingsCubit>().state
                        as FetchSystemSettingsSuccess)
                    .chatSettings
                    .isPostBookingChatAllowed)
                  Expanded(
                    child: CustomCheckIconTextButton(
                      title: "postBooking",
                      isSelected: isPostBookingChatAllowed == "1",
                      onTap: () {
                        onPostBookingChatChanged(
                          isPostBookingChatAllowed == "1" ? "0" : "1",
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The country the provider registered with is fixed, and so is its calling
  /// code, even when the phone number is editable (email login).
  bool get _isCountryFixed => countryController?.text.isNotEmpty ?? false;

  Widget _buildCountryCodePrefix(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12.0, bottom: 2, top: 2),
      child: BlocBuilder<CountryCodeCubit, CountryCodeState>(
        builder: (BuildContext context, CountryCodeState state) {
          String code = '--';

          if (state is CountryCodeFetchSuccess) {
            code = state.selectedCountry!.callingCode;
          }

          return SizedBox(
            height: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    // Only allow changing country code when email login (phone is editable)
                    if ((loginType?.isPhone ?? true) || _isCountryFixed) {
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
                              width: 24,
                              height: 16,
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
                      const SizedBox(width: 8),
                      if (!allowOnlySingleCountry &&
                          !_isCountryFixed &&
                          !(state is CountryCodeFetchSuccess &&
                              state.temporaryCountryList != null &&
                              state.temporaryCountryList!.length == 1) &&
                          !(loginType?.isPhone ??
                              true)) // Only show dropdown when email login
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
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 4),
              ],
            ),
          );
        },
      ),
    );
  }
}
