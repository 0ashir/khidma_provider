import '../../../app/generalImports.dart';

class HandymanLiveMapRepository {
  Future<List<HandymanLiveMapItem>> getLiveMapData() async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.liveMapData,
        parameter: {},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(response['message']?.toString() ?? 'fetchFailed');
      }
      final List data = response['data'] ?? [];
      return data
          .map((e) => HandymanLiveMapItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
