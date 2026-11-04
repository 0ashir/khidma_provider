import '../../app/generalImports.dart';

class CountrySettingsRepository {
  /// Country comes from the auth token; no parameters.
  Future<CountrySettings> getCountrySettings() async {
    final Map<String, dynamic> response = await ApiClient.post(
      url: ApiUrl.getCountrySettings,
      parameter: {},
      useAuthToken: true,
    );

    if (response['error'] == true) {
      throw ApiException(response['message'].toString());
    }

    return CountrySettings.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }
}
