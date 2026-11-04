import '../../app/generalImports.dart';
import '../model/liveTracking/liveTrackingDataModel.dart';

class GetLiveTrackingDataRepository {
  Future<LiveTrackingDataModel> getLiveTrackingData({
    required String orderId,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getLiveTrackingData,
        parameter: {ApiParam.orderId: orderId},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(response['message']?.toString() ?? 'fetchFailed');
      }
      return LiveTrackingDataModel.fromJson(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
