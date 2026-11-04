import '../../app/generalImports.dart';

class SettingsRepository {
  Future getSystemSettings({required bool isAnonymous}) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getSettings,
        parameter: {},
        useAuthToken: isAnonymous ? false : true,
      );
      return response['data'];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future updateFCM({
    required final String fcmId,
    required final String platform,
  }) async {
    await ApiClient.post(
      url: ApiUrl.updateFcm,
      parameter: {ApiParam.fcmId: fcmId, ApiParam.platform: platform},
      useAuthToken: true,
    );
  }

  Future<String> createRazorpayOrderId({
    required final String subscriptionID,
  }) async {
    try {
      final Map<String, dynamic> parameters = {
        ApiParam.subscriptionID: subscriptionID,
      };
      final result = await ApiClient.post(
        parameter: parameters,
        url: ApiUrl.createRazorpayOrder,
        useAuthToken: true,
      );

      return result['data']['id'];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Creates a Cashfree order via the backend and returns
  /// { 'order_id': String, 'payment_session_id': String }
  Future<Map<String, String>> createCashfreeOrder({
    required final String subscriptionID,
    required final String transactionId,
  }) async {
    try {
      final Map<String, dynamic> parameters = {
        ApiParam.subscriptionID: subscriptionID,
        ApiParam.transactionID: transactionId,
      };
      final result = await ApiClient.post(
        parameter: parameters,
        url: ApiUrl.createCashfreeOrder,
        useAuthToken: true,
      );

      if (result['error'] == true) {
        throw ApiException(
          result['message'] ?? 'Failed to create Cashfree order',
        );
      }

      return {
        'order_id': result['data']['order_id']?.toString() ?? '',
        'payment_session_id':
            result['data']['payment_session_id']?.toString() ?? '',
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Fetches the Cashfree order status from our backend, if the transaction is not present, we consider it failed.
  Future<bool> getCashfreeOrderStatus({required final String orderId}) async {
    try {
      final result = await ApiClient.post(
        url: ApiUrl.getCashfreeOrderStatus,
        useAuthToken: true,
        parameter: {ApiParam.orderId: orderId},
      );

      return (result['data']['transaction'] != null &&
              result['data']['transaction']['status']
                      .toString()
                      .toLowerCase() ==
                  'success') ||
          (result['data']['order']['order_status'] == 'PAID');
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> sendQueryToAdmin({
    required final Map<String, dynamic> parameter,
  }) async {
    try {
      final response = await ApiClient.post(
        url: ApiUrl.sendQuery,
        parameter: parameter,
        useAuthToken: true,
      );

      return {"message": response["message"], "error": response['error']};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<LanguageListModel> getLanguageList() async {
    try {
      final response = await ApiClient.get(
        url: ApiUrl.getLanguageList,
        useAuthToken: false,
        queryParameters: {'platform': 'provider_app'},
      );

      return LanguageListModel.fromJson(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  ///This method is used to fetch language JSON data
  Future<Map<String, dynamic>> getLanguageJsonData(String languageCode) async {
    try {
      // Get FCM token
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken().timeout(
          const Duration(seconds: 5),
          onTimeout: () => null,
        );
      } catch (_) {
        // If FCM token fails to get, continue without it
      }

      final Map<String, dynamic> parameters = {
        ApiParam.languageCode: languageCode,
        ApiParam.platform: 'provider_app',
      };

      // Add FCM token if available
      if (fcmToken != null && fcmToken.isNotEmpty) {
        parameters[ApiParam.fcmId] = fcmToken;
      }

      final response = await ApiClient.post(
        url: ApiUrl.getLanguageJsonData,
        parameter: parameters,
        useAuthToken: false,
      );

      return response['data'] ?? {};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
