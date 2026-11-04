import '../../app/generalImports.dart';

class SeoSettingsRepository {
  Future<SeoSettingsData> getSeoSettings() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getSeoSettings,
        parameter: {},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(
          response['message']?.toString() ?? 'Something went wrong',
        );
      }
      return SeoSettingsData.fromJson(
        response['data'] as Map<String, dynamic>? ?? {},
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> manageSeoSettings({
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.manageSeoSettings,
        parameter: parameters,
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(
          response['message']?.toString() ?? 'Something went wrong',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
