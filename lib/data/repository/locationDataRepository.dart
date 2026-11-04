import 'package:edemand_partner/app/generalImports.dart';

class LocationDataRepository {
  Future<List<CountryModel>> getCountries() async {
    try {
      final Map<String, dynamic> response = await ApiClient.get(
        url: ApiUrl.getCountries,
        useAuthToken: false,
      );

      if (response['error'] == true) {
        throw ApiException(response['message'].toString());
      }

      final List data = response['data'] as List? ?? [];
      return data
          .map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<RegionModel>> getRegions({required String countryId}) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getRegions,
        parameter: {ApiParam.countryId: countryId},
        useAuthToken: false,
      );

      if (response['error'] == true) {
        throw ApiException(response['message'].toString());
      }

      final List data = response['data'] as List? ?? [];
      return data
          .map((e) => RegionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
