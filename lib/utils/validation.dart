import 'package:edemand_partner/app/generalImports.dart';

class Validator {
  static String? validateNumber(BuildContext context, String number) {
    if (number.isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    } else if (number.length < UiUtils.minimumMobileNumberDigit ||
        number.length > UiUtils.maximumMobileNumberDigit) {
      return 'mobileNumberShouldBeInRange'.translate(context: context);
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? password) {
    final loginSettings = context
        .read<FetchSystemSettingsCubit>()
        .loginSettings;

    if (password == null || password.trim().isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    }

    if (loginSettings != null) {
      if (loginSettings.minumumPasswordLength != null) {
        if (password.length < loginSettings.minumumPasswordLength!) {
          return "${"passwordMustBeAtLeastChars".translate(context: context)} ${loginSettings.minumumPasswordLength!} ${"characterLong".translate(context: context)}";
        }
      }

      if (loginSettings.requireAtLeastOneUppercase == true) {
        if (!password.contains(RegExp('[A-Z]'))) {
          return 'passwordMustHaveUppercase'.translate(context: context);
        }
      }

      if (loginSettings.requireAtLeastOneLowercase == true) {
        if (!password.contains(RegExp('[a-z]'))) {
          return 'passwordMustHaveLowercase'.translate(context: context);
        }
      }

      if (loginSettings.requireAtLeastOneNumber == true) {
        if (!password.contains(RegExp('[0-9]'))) {
          return 'passwordMustHaveNumber'.translate(context: context);
        }
      }

      if (loginSettings.requireAtLeastOneSpecialCharacter == true) {
        if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          return 'passwordMustHaveSpecialChar'.translate(context: context);
        }
      }
    }

    return null;
  }

  static String? nullCheck(
    BuildContext context,
    String? value, {
    int? requiredLength,
    bool? nonZero,
  }) {
    if (value!.isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    } else if (nonZero == true) {
      // '0', '00', '0.0' and '0.00' are all zero.
      if (double.tryParse(value) == 0) {
        return 'enterMoreThenZero'.translate(context: context);
      }
    } else if (requiredLength != null) {
      if (value.length < requiredLength) {
        return '${"textMustBe".translate(context: context)} $requiredLength ${"characterLong".translate(context: context)}';
      } else {
        return null;
      }
    }

    return null;
  }

  static String? validateLatitude(BuildContext context, String? latitude) {
    if (latitude!.isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    } else if (!_isLatitudeValid(latitude)) {
      return 'pleaseEnterValidLatitude'.translate(context: context);
    }
    return null;
  }

  static String? validateLongitude(BuildContext context, String? longitude) {
    if (longitude!.isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    } else if (!_isLongitudeValid(longitude)) {
      return 'pleaseEnterValidLongitude'.translate(context: context);
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? email) {
    if (email!.isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    } else if (!_isValidateEmail(email)) {
      return 'pleaseEnterValidEmail'.translate(context: context);
    }
    return null;
  }

  /// Replace extra coma from String
  ///
  static String filterAddressString(String text) => text.removeExtraComma();

  static bool _isValidateEmail(String email) {
    // Domain labels may contain hyphens (not at either end); nothing may
    // follow the top-level domain.
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      '[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?'
      r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)*'
      r'\.[a-zA-Z]{2,}$',
    ).hasMatch(email.trim());

    return emailValid;
  }

  static bool _isLatitudeValid(String latitude) {
    final bool validLatitude = RegExp(
      r'^-?(90(\.0{1,7})?|[0-8][0-9](\.\d{1,7})?|[0-9](\.\d{1,7})?)$',
    ).hasMatch(latitude);

    return validLatitude;
  }

  static bool _isLongitudeValid(String longitude) {
    final bool validLongitude = RegExp(
      r'^-?(180(\.0{1,7})?|1[0-7][0-9](\.\d{1,7})?|[0-9]{1,2}(\.\d{1,7})?)$',
    ).hasMatch(longitude);

    return validLongitude;
  }
}
