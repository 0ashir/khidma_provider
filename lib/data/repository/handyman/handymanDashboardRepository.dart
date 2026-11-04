import '../../../app/generalImports.dart';

class HandymanDashboardRepository {
  Future<HandymanDashboardModel> fetchDashboard() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.handymanGetDashboard,
        parameter: {},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(response['message']?.toString() ?? 'fetchFailed');
      }
      return HandymanDashboardModel.fromJson(
        Map<String, dynamic>.from(response['data'] as Map),
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
