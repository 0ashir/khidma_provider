import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/data/model/countryCodeModel.dart';

class CountryCodeRepository {
  Future<List<CountryCodeModel>> getCountries(BuildContext context) async {
    try {
      final response = await ApiClient.get(
        url: ApiUrl.getCountryCodes,
        useAuthToken: false,
      );

      if (response['error'] == false) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return data
            .map<CountryCodeModel>((json) => CountryCodeModel.fromJson(json))
            .toList();
      } else {
        throw ApiException(
          response['message'] ?? 'Failed to fetch country codes',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
      // Fallback to JSON file if API fails
      // final String rawData =
      //     await rootBundle.loadString('assets/countryCodes/countryCodes.json');
      // final parsed =
      //     json.decode(rawData.toString()).cast<Map<String, dynamic>>();
      // return parsed
      //     .map<CountryCodeModel>((json) => CountryCodeModel.fromJson(json))
      //     .toList();
    }
  }

  Future<CountryCodeModel> getCountryByCountryCode(
    BuildContext context,
    String countryCode,
  ) async {
    final list = await getCountries(context);
    return list.firstWhere((element) => element.countryCode == countryCode);
  }

  Future<CountryCodeModel?> getDefaultCountry(BuildContext context) async {
    final list = await getCountries(context);
    try {
      return list.firstWhere((element) => element.isDefaultCountry);
    } catch (e) {
      // If no default country found, return the first one
      return list.isNotEmpty ? list.first : null;
    }
  }
}
