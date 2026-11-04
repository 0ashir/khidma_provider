import '../../../app/generalImports.dart';

class HandymanProfileRepository {
  Future<HandymanProfileModel> fetchProfile() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanGetProfile,
        parameter: {},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(
            response['message']?.toString() ?? 'fetchFailed');
      }
      return HandymanProfileModel.fromJson(
          Map<String, dynamic>.from(response['data']));
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Returns a record: profile is non-null on success, isLoggedOut=true when
  /// the phone number changed and all tokens were invalidated.
  Future<({HandymanProfileModel? profile, bool isLoggedOut})> updateProfile({
    required Map<String, String> usernameByLang,
    required String phone,
    required String countryCode,
    String? email,
    String? address,
    String? profileImagePath,
    Map<String, dynamic> customFieldValues = const {},
  }) async {
    try {
      final Map<String, dynamic> params = {
        ApiParam.phone: phone,
        ApiParam.countryCode: countryCode,
      };

      for (final entry in usernameByLang.entries) {
        params['username[${entry.key}]'] = entry.value;
      }
      if (email != null && email.trim().isNotEmpty) {
        params[ApiParam.email] = email.trim();
      }
      if (address != null && address.trim().isNotEmpty) {
        params[ApiParam.address] = address.trim();
      }
      if (profileImagePath != null &&
          profileImagePath.isNotEmpty &&
          File(profileImagePath).existsSync()) {
        params[ApiParam.profileImage] =
            await MultipartFile.fromFile(profileImagePath);
      }
      for (final entry in customFieldValues.entries) {
        final key = 'cf_${entry.key}';
        final val = entry.value;
        if (val is String && val.isNotEmpty && File(val).existsSync()) {
          params[key] = await MultipartFile.fromFile(val);
        } else if (val != null && val.toString().isNotEmpty) {
          params[key] = val;
        }
      }

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanUpdateProfile,
        parameter: params,
        useAuthToken: true,
      );

      if (response['error'] == true) {
        throw ApiException(
            response['message']?.toString() ?? 'updateFailed');
      }

      if (response['is_logged_out'] == true) {
        return (profile: null, isLoggedOut: true);
      }

      return (
        profile: HandymanProfileModel.fromJson(
            Map<String, dynamic>.from(response['data'])),
        isLoggedOut: false,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Explicitly sets availability. Returns the new is_available value (0 or 1).
  Future<int> updateAvailability({required bool available}) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanUpdateAvailability,
        parameter: {ApiParam.isAvailable: available ? 1 : 0},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(
            response['message']?.toString() ?? 'updateFailed');
      }
      return int.tryParse(
              response['data']?['is_available']?.toString() ?? '') ??
          (available ? 1 : 0);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
