import 'package:edemand_partner/app/generalImports.dart';

class CustomPageRepository {
  Future<List<CustomPageModel>> getCustomPages() async {
    try {
      final response = await ApiClient.post(
        url: ApiUrl.getCustomPages,
        parameter: {},
        useAuthToken: HiveRepository.isUserLoggedIn,
      );

      final List data = response['data'] ?? [];
      return data
          .map((final e) => CustomPageModel.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> getPageSetting(
    String pageKey, {
    UserType? requestedUserType,
  }) async {
    try {
      bool isHandyman = HiveRepository.isHandymanSession;
      if (requestedUserType != null) {
        isHandyman = isHandyman || requestedUserType.isHandyman;
      }

      final bool isLegalPage =
          pageKey == 'terms_conditions' || pageKey == 'privacy_policy';
      final String resolvedPageKey = isHandyman && isLegalPage
          ? 'handyman_$pageKey'
          : pageKey;

      final Map<String, dynamic> parameters = {'page': resolvedPageKey};
      if (isHandyman) {
        parameters[ApiParam.userType] = ApiParam.handyman;
      }

      final response = await ApiClient.post(
        url: ApiUrl.getPageSetting,
        parameter: parameters,
        useAuthToken: HiveRepository.isUserLoggedIn,
      );

      final data = response['data'];

      if (data is Map) {
        if (data.containsKey('content')) {
          return data['content'].toString();
        } else if (data.containsKey(resolvedPageKey)) {
          return data[resolvedPageKey].toString();
        }
      }
      return "";
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
