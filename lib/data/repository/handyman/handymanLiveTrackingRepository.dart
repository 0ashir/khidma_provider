import '../../../app/generalImports.dart';

class HandymanLiveTrackingRepository {
  Future<void> updateLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: HiveRepository.isHandymanSession
            ? ApiUrl.updateHandymanLocation
            : ApiUrl.updateLocation,
        parameter: {
          ApiParam.orderId: bookingId,
          ApiParam.latitude: latitude.toStringAsFixed(8),
          ApiParam.longitude: longitude.toStringAsFixed(8),
        },
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(
          response['message']?.toString() ?? 'updateLocationFailed',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
