import '../../app/generalImports.dart';

class SlotManagementRepository {
  Future<SlotConfigurationData> getSlotConfigurations() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getSlotConfigurations,
        parameter: {},
        useAuthToken: true,
      );
      return SlotConfigurationData.fromJson(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> manageSlotConfigurations({
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.manageSlotConfigurations,
        parameter: parameters,
        useAuthToken: true,
      );
      if (response['error'] == true) {
        // Booking conflict: return full response so cubit can emit conflict state
        if (response['booking_conflict'] == true) return response;
        throw ApiException(
          response['message']?.toString() ?? 'Something went wrong',
        );
      }
      return response;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> deleteLeave({required String leaveDate}) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.deleteLeave,
        parameter: {'leave_date': leaveDate},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(
          response['message']?.toString() ?? 'Something went wrong',
        );
      }
      return response;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
