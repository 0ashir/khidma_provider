import 'dart:developer';

import '../config.dart';

class Validation {
  RegExp digitRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{6,15}$)');
  RegExp passRegex = RegExp(
      "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-]).{8,}\$");
  RegExp zipRegex = RegExp("^\d{5}(?:[-\s]\d{4})?\$");

  // Zip Code Validation
  zipCodeValidation(context, zipCode) {
    if (zipCode.isEmpty) {
      return language(context, translations!.enterZip);
    }
    return null;
  }

  validateMobile(value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return null;
  }

// City validation
  cityValidation(context, name) {
    if (name.isEmpty) {
      return language(context, translations!.pleaseCity);
    }
    return null;
  }

  // address validation
  addressValidation(context, name) {
    if (name.isEmpty) {
      return language(context, translations!.pleaseAddress);
    }
    return null;
  }

  // Email Validation
  emailValidation(context, email) {
    if (email.isEmpty) {
      return language(context, translations!.pleaseEnterEmail);
    } else if (!digitRegex.hasMatch(email)) {
      return language(context, translations!.pleaseEnterValid);
    }
    return null;
  }

  // Password Validation
  passValidation(context, password) {
    if (password.isEmpty) {
      return language(context, translations!.pleaseEnterPassword);
    }

    return null;
  }

//confirm Password Validation

  confirmPassValidation(context, password, pass) {
    if (password.isEmpty) {
      return language(context, translations!.pleaseEnterPassword);
    }

    if (password != pass) {
      return language(context, translations!.notMatch);
    }
    return null;
  }

  // name validation
  nameValidation(context, name) {
    if (name.isEmpty) {
      return language(context, translations!.pleaseEnterName);
    }
    return null;
  }

//service name validation
  serviceNameValidation(context, name) {
    if (name.isEmpty) {
      return language(context, "Please Enter Per Serviceman Commission ");
    }
    return null;
  }

  // phone validation
  phoneValidation(context, phone) {
    if (phone.isEmpty) {
      return language(context, translations!.pleaseEnterNumber);
    }
    if (!regex.hasMatch(phone)) {
      return language(context, translations!.pleaseEnterValidNumber);
    }

    return null;
  }

  // Otp Validation
  otpValidation(context, value) {
    if (value!.isEmpty) {
      return language(context, translations!.enterOtp);
    }
    if (!regex.hasMatch(value)) {
      return language(context, translations!.enterValidOtp);
    }
    return null;
  }

  // Common field validation
  commonValidation(context, value) {
    if (value!.isEmpty) {
      return language(context, translations!.pleaseEnterValue);
    }
  }

  // dynamic field validation
  dynamicTextValidation(context, value, text) {
    log("VCC :$value");
    if (value!.isEmpty) {
      return language(context, text);
    }
  }

  // country state  field validation
  countryStateValidation(context, value, text) {
    if (value == null) {
      return language(context, text);
    }
  }

  // advance payment validation
  advancePaymentValidation(context, value) {
    if (value!.isEmpty) {
      return language(context, translations!.enterAdvancePaymentPercentage);
    }
    if (double.parse(value) > 100) {
      return language(context, "Percentage cannot be more than 100");
    }
    return null;
  }

//focus node change
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
