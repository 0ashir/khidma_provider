// ignore_for_file: file_names

import '../../app/generalImports.dart';

class GooglePlaceRepository {
  Future<PlacesModel> searchLocationsFromPlaceAPI(String text) async {
    try {
      final Map<String, dynamic> queryParameters = {ApiUrl.input: text};

      final Map<String, dynamic> placesData = await ApiClient.get(
        url: ApiUrl.placeAPI,
        useAuthToken: false,
        queryParameters: queryParameters,
      );

      return PlacesModel.fromJson(placesData['data']);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future getPlaceDetailsFromPlaceId(String placeId) async {
    try {
      final Map<String, dynamic> queryParameters = {ApiUrl.placeid: placeId};
      final Map<String, dynamic> response = await ApiClient.get(
        url: ApiUrl.placeApiDetails,
        queryParameters: queryParameters,
        useAuthToken: false,
      );
      return response['data']['result']['geometry']['location'];
    } catch (e) {
      rethrow;
    }
  }
}
