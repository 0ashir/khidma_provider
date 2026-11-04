import '../../app/generalImports.dart';

class AuthRepository {
  static String? verificationId;

  // Issued by verify_otp; proves the OTP to forgot-password.
  static String? _resetProof;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    Function(dynamic err)? onError,
    VoidCallback? onCodeSent,
  }) async {
    // Firebase needs E.164; the backend returns calling codes without "+".
    final String digits = phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    await _auth.verifyPhoneNumber(
      phoneNumber: '+$digits',
      verificationCompleted: (PhoneAuthCredential complete) {},
      verificationFailed: (FirebaseAuthException err) {
        onError?.call(err);
      },
      codeSent: (String verification, int? forceResendingToken) {
        verificationId = verification;
        // this is force resending token
        HiveRepository.setResendToken = forceResendingToken;
        if (onCodeSent != null) {
          onCodeSent();
        }
      },
      forceResendingToken: HiveRepository.getResendToken,
      codeAutoRetrievalTimeout: (String timeout) {},
    );
  }

  Future<Map<String, dynamic>> sendVerificationCodeUsingSMSGateway({
    String? phoneNumberWithoutCountryCode,
    String? countryCode,
    String? email,
    String? loginType,
  }) async {
    final Map<String, dynamic> parameter = {};

    if (email != null && email.isNotEmpty) {
      parameter[ApiParam.email] = email;
    } else if (phoneNumberWithoutCountryCode != null &&
        phoneNumberWithoutCountryCode.isNotEmpty) {
      parameter[ApiParam.mobile] = '$countryCode$phoneNumberWithoutCountryCode';
    }

    if (loginType != null && loginType.isNotEmpty) {
      parameter[ApiParam.loginType] = loginType;
    }

    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.resendOTP,
      parameter: parameter,
      useAuthToken: false,
    );

    return response;
  }

  Future<UserCredential?> verifyOTPUsingFirebase({required String code}) async {
    if (verificationId != null) {
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
            verificationId: verificationId!,
            smsCode: code,
          );

      final UserCredential userCredential = await _auth.signInWithCredential(
        phoneAuthCredential,
      );
      return userCredential;
    }
    return null;
  }

  Future<Map<String, dynamic>> verifyOTPUsingSMSGateway({
    String? phoneNumberWithOutCountryCode,
    String? countryCode,
    String? email,
    required final String otp,
    String? loginType,
  }) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        ApiParam.otp: otp,
      };

      if (email != null && email.isNotEmpty) {
        parameter[ApiParam.email] = email;
      } else if (phoneNumberWithOutCountryCode != null &&
          phoneNumberWithOutCountryCode.isNotEmpty) {
        parameter[ApiParam.mobile] = phoneNumberWithOutCountryCode;
        if (countryCode != null && countryCode.isNotEmpty) {
          parameter[ApiParam.countryCode] = countryCode;
        }
      }

      if (loginType != null && loginType.isNotEmpty) {
        parameter[ApiParam.loginType] = loginType;
      }

      final response = await ApiClient.post(
        parameter: parameter,
        url: ApiUrl.verifyOTP,
        useAuthToken: false,
      );
      _resetProof = response['error'] == false
          ? response['reset_proof']?.toString()
          : null;
      return {"error": response['error'], "message": response['message']};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> verifyUserMobileNumberFromAPI({
    String? mobileNumber,
    String? countryCode,
    String? email,
    String? loginType,
  }) async {
    try {
      final Map<String, dynamic> parameter = {};

      if (email != null && email.isNotEmpty) {
        parameter[ApiParam.email] = email;
      } else if (mobileNumber != null && mobileNumber.isNotEmpty) {
        parameter[ApiParam.mobile] = mobileNumber;
        if (countryCode != null && countryCode.isNotEmpty) {
          parameter[ApiParam.countryCode] = countryCode;
        }
      }

      if (loginType != null && loginType.isNotEmpty) {
        parameter[ApiParam.loginType] = loginType;
      }

      final Map<String, dynamic> response = await ApiClient.post(
        parameter: parameter,
        url: ApiUrl.verifyUser,
        useAuthToken: false,
      );

      return {
        'error': response['error'],
        'message': response['message'] ?? '',
        'messageCode': response['message_code'] ?? '',
        'authenticationMode': response['authentication_mode'] ?? '',
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> loginUser({
    String? phoneNumber,
    String? email,
    required String password,
    String? countryCode,
    String? fcmId,
    String? loginType,
    UserType? requestedUserType,
  }) async {
    // Get current language code from Hive
    final currentLanguage = HiveRepository.getCurrentLanguage();
    final languageCode = currentLanguage?.languageCode ?? '';

    final Map<String, dynamic> parameters = {ApiParam.password: password};

    if (requestedUserType != null && requestedUserType.isHandyman) {
      parameters[ApiParam.userType] = ApiParam.handyman;
    }

    // Add either email or phone number
    if (email != null && email.isNotEmpty) {
      parameters[ApiParam.email] = email;
    } else if (phoneNumber != null && phoneNumber.isNotEmpty) {
      parameters[ApiParam.mobile] = phoneNumber;
      if (countryCode != null && countryCode.isNotEmpty) {
        parameters[ApiParam.countryCode] = countryCode;
      }
    }

    // Add language code if available
    if (languageCode.isNotEmpty) {
      parameters[ApiParam.languageCode] = languageCode;
    }

    if (loginType != null && loginType.isNotEmpty) {
      parameters[ApiParam.loginType] = loginType;
    }

    if (fcmId != null) {
      parameters[ApiParam.fcmId] = fcmId;
      parameters[ApiParam.platform] = Platform.isAndroid ? "android" : "ios";
    }
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.loginApi,
      parameter: parameters,
      useAuthToken: false,
    );

    // The backend auto-detects the user's group from their credentials and
    // returns `user_type` so a single login call serves both providers and
    // handymen. Anything that is not `handyman` is treated as a provider.
    final data = response['data'];
    final UserType userType = UserType.fromValue(
      (response[ApiParam.userType] ??
              (data is Map ? data[ApiParam.userType] : null))
          ?.toString(),
    );

    if (response['token'] != null) {
      HiveRepository.setUserToken = response['token'];
      if (userType.isHandyman) {
        HiveRepository.setHandymanData(Map<String, dynamic>.from(data ?? {}));
        HiveRepository.setLoggedInUserType = UserType.handyman;
        // Edit-profile screen locks the field the handyman signed in with.
        HiveRepository.setHandymanLoginType =
            (email != null && email.isNotEmpty)
            ? LoginType.email
            : LoginType.phone;
      } else {
        HiveRepository.setUserData(data);
        HiveRepository.setLoggedInUserType = UserType.provider;
      }
    }

    if (data == null) {
      return {
        'userType': userType,
        'userDetails': null,
        'handymanDetails': null,
        'error': true,
        'message': response['message'] ?? '',
      };
    }

    if (userType.isHandyman) {
      return {
        'userType': userType,
        'handymanDetails': HandymanLoginModel.fromJson(
          Map<String, dynamic>.from(data),
        ),
        'error': response['error'] ?? false,
        'message': response['message'] ?? '',
      };
    }

    return {
      'userType': userType,
      'userDetails': ProviderDetails.fromJson(data ?? {}),
      'error': response['error'] ?? false,
      'message': response['message'] ?? '',
    };
  }

  /// Logs in a handyman (group_id 4) against the shared login endpoint by
  /// sending `user_type=handyman`. Phone-only; returns the flat handyman
  /// profile payload. Provider [loginUser] is intentionally untouched.
  Future<Map<String, dynamic>> loginHandyman({
    required String phoneNumber,
    required String password,
    String? countryCode,
    String? fcmId,
  }) async {
    final currentLanguage = HiveRepository.getCurrentLanguage();
    final languageCode = currentLanguage?.languageCode ?? '';

    final Map<String, dynamic> parameters = {
      ApiParam.userType: ApiParam.handyman,
      ApiParam.password: password,
      ApiParam.mobile: phoneNumber,
    };

    if (countryCode != null && countryCode.isNotEmpty) {
      parameters[ApiParam.countryCode] = countryCode;
    }
    if (languageCode.isNotEmpty) {
      parameters[ApiParam.languageCode] = languageCode;
    }
    if (fcmId != null) {
      parameters[ApiParam.fcmId] = fcmId;
      parameters[ApiParam.platform] = Platform.isAndroid ? "android" : "ios";
    }

    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.loginApi,
      parameter: parameters,
      useAuthToken: false,
    );

    if (response['token'] != null) {
      HiveRepository.setUserToken = response['token'];
      HiveRepository.setHandymanData(
        Map<String, dynamic>.from(response['data'] ?? {}),
      );
      HiveRepository.setLoggedInUserType = UserType.handyman;
      HiveRepository.setHandymanLoginType = LoginType.phone;
    }

    if (response['data'] == null) {
      return {
        'handymanDetails': null,
        'error': true,
        'message': response['message'] ?? '',
      };
    }

    return {
      'handymanDetails': HandymanLoginModel.fromJson(
        Map<String, dynamic>.from(response['data']),
      ),
      'error': response['error'] ?? false,
      'message': response['message'] ?? '',
    };
  }

  Future logout(BuildContext context) async {
    Future.delayed(Duration.zero, () {
      HiveRepository.setUserLoggedIn = false;
      HiveRepository.clearBoxValues(boxName: HiveRepository.userDetailBoxKey);
      context.read<AuthenticationCubit>().setUnAuthenticated();
      // The next login may be another country; never reuse these settings.
      context.read<FetchCountrySettingsCubit>().clear();
      NotificationService.disposeListeners();
      AppQuickActions.clearShortcutItems();
    });

    Navigator.of(context).popUntil((Route route) => route.isFirst);
    Navigator.pushReplacementNamed(context, Routes.loginScreenRoute);
  }

  Future deleteUserAccount() async {
    await ApiClient.post(
      url: ApiUrl.deleteUserAccount,
      parameter: {},
      useAuthToken: true,
    );
  }

  Future<Map<String, dynamic>> registerProvider({
    required Map<String, dynamic> parameters,
    required bool isAuthTokenRequired,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.registerProvider,
        parameter: parameters,
        useAuthToken: isAuthTokenRequired,
      );
      if (response['error']) {
        throw ApiException(response["message"].toString());
      }

      final Map<String, dynamic> responseData = response['data'] != null
          ? Map.from(response['data'])
          : <String, dynamic>{};

      if (response['token'] != null) {
        HiveRepository.setUserToken = response['token'];
        HiveRepository.setUserLoggedIn = true;
        HiveRepository.setUserData(responseData);
        HiveRepository.setLoggedInUserType = UserType.provider;
      }

      return {
        'providerDetails': responseData.isNotEmpty
            ? ProviderDetails.fromJson(responseData)
            : ProviderDetails(),
        'message': response['message'],
        'error': response['error'],
        'token': response['token'],
      };
    } catch (e) {
      return {
        'message': e.toString(),
        'error': true,
        'providerDetails': ProviderDetails(),
      };
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final Map<String, dynamic> parameters = {
        ApiParam.oldPassword: oldPassword,
        ApiParam.newPassword: newPassword,
      };
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.changePassword,
        parameter: parameters,
        useAuthToken: true,
      );
      return {'message': response['message'], 'error': response['error']};
    } catch (e) {
      return {'message': e.toString(), 'error': true};
    }
  }

  Future<Map<String, dynamic>> createNewPassword({
    String? countryCode,
    required String newPassword,
    String? mobileNumber,
    String? email,
    String? loginType,
  }) async {
    try {
      final Map<String, dynamic> parameters = {
        ApiParam.newPasswords: newPassword,
      };

      if (email != null && email.isNotEmpty) {
        parameters[ApiParam.email] = email;
      } else if (mobileNumber != null && mobileNumber.isNotEmpty) {
        parameters[ApiParam.mobileNumber] = mobileNumber;
        if (countryCode != null && countryCode.isNotEmpty) {
          parameters[ApiParam.countryCode] = countryCode;
        }
      }

      if (loginType != null && loginType.isNotEmpty) {
        parameters[ApiParam.loginType] = loginType;
      }

      // Proof of the verified OTP: server OTP (email / SMS gateway) or Firebase phone sign-in.
      if (_resetProof != null) {
        parameters['reset_proof'] = _resetProof;
      } else if (email == null || email.isEmpty) {
        final String? idToken = await _auth.currentUser?.getIdToken();
        if (idToken != null) {
          parameters['firebase_id_token'] = idToken;
        }
      }

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.createNewPassword,
        parameter: parameters,
        useAuthToken: false,
      );
      if (response['error'] == false) {
        _resetProof = null;
      }

      return {'message': response['message'], 'error': response['error']};
    } catch (e) {
      return {'message': e.toString(), 'error': true};
    }
  }

  Future<Map<String, dynamic>> getProviderDetails() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getUserInfo,
        parameter: {},
        useAuthToken: true,
      );
      return response;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<CustomFieldsResponse> fetchCustomFields({String? fieldGroup}) async {
    try {
      final Map<String, dynamic> parameter = {};
      if (fieldGroup != null && fieldGroup.isNotEmpty) {
        parameter['field_group'] = fieldGroup;
      }

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getCustomFields,
        useAuthToken: true,
        parameter: parameter,
      );

      final data = response['data'] as Map<String, dynamic>? ?? {};

      final Map<String, dynamic> savedValues = {};

      final List<CustomFieldModel> fields =
          (data['custom_fields'] as List<dynamic>? ?? []).map((entry) {
            final map = entry as Map<String, dynamic>;

            if (map.containsKey('value') && map['value'] != null) {
              final id = map['id']?.toString();
              if (id != null) savedValues[id] = map['value'];
            }
            return CustomFieldModel.fromJson(map);
          }).toList();

      // Client-side fallback in case the endpoint ignores the group filter.
      final List<CustomFieldModel> filtered = fieldGroup == null
          ? fields
          : fields.where((f) => f.fieldGroup == fieldGroup).toList();
      if (fieldGroup != null && filtered.isNotEmpty) {
        fields
          ..clear()
          ..addAll(filtered);
      }

      fields.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      final savedList = data['provider_custom_fields'] as List<dynamic>? ?? [];
      for (final item in savedList) {
        if (item is Map<String, dynamic>) {
          final dynamic value = item['value'];
          if (value == null) continue;

          final String? id =
              item['custom_field_id']?.toString() ??
              item['field_id']?.toString();

          if (id != null) {
            savedValues[id] = value;
          }
        }
      }

      return CustomFieldsResponse(fields: fields, savedValues: savedValues);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<VerificationStatusModel> getVerificationStatus() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getVerificationStatus,
        parameter: {},
        useAuthToken: true,
      );

      final data = response['data'] as Map<String, dynamic>? ?? {};
      return VerificationStatusModel.fromJson(data);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// [values] is keyed by custom_field_id, plus an optional `is_resubmit`
  /// entry sent as-is (not prefixed). File-type values must be local file
  /// paths; they are converted to [MultipartFile]s before submission.
  Future<String> submitVerificationRequest(Map<String, dynamic> values) async {
    try {
      final Map<String, dynamic> parameters = {};
      for (final entry in values.entries) {
        if (entry.key == 'is_resubmit') {
          parameters[entry.key] = entry.value;
          continue;
        }
        final dynamic value = entry.value;
        if (value is String && value.isNotEmpty && File(value).existsSync()) {
          parameters['cf_${entry.key}'] = await MultipartFile.fromFile(value);
        } else {
          parameters['cf_${entry.key}'] = value;
        }
      }

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.submitVerificationRequest,
        parameter: parameters,
        useAuthToken: true,
      );

      if (response['error'] == true) {
        throw ApiException(response['message'].toString());
      }
      return response['message']?.toString() ?? '';
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<bool> logoutUser({required String? fcmId}) async {
    try {
      final Map<String, dynamic> parameters = <String, dynamic>{
        ApiParam.fcmId: fcmId,
      };
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.logout,
        parameter: parameters,
        useAuthToken: true,
      );
      return response['error'];
    } catch (_) {
      // 401 or any network error — token already invalid, allow local logout
      return false;
    }
  }
}
