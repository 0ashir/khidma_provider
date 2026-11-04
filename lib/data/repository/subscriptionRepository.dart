import 'package:edemand_partner/app/generalImports.dart';

class SubscriptionsRepository {
  Future<Map<String, dynamic>> fetchSubscriptionsList() async {
    try {
      final Map<String, dynamic> parameter = {ApiParam.limit: UiUtils.limit};

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getSubscriptionsList,
        parameter: parameter,
        useAuthToken: true,
      );
      if (response['error']) {
        return {
          "data": [],
          "error": true,
          "message": e.toString(),
          "total": "0",
        };
      }
      return {
        "data": (response['data'] as List)
            .map((e) => SubscriptionInformation.fromJson(Map.from(e)))
            .toList(),
        "error": response['error'] ?? false,
        "total": (response['total'] ?? 0).toString(),
        "message": response['message'] ?? '',
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchPreviousSubscriptionsList({
    required final String offset,
  }) async {
    try {
      final Map<String, dynamic> parameter = {
        ApiParam.offset: offset,
        ApiParam.limit: UiUtils.limit,
      };

      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getPreviousSubscriptionsHistory,
        parameter: parameter,
        useAuthToken: true,
      );
      if (response['error']) {
        return {
          "data": [],
          "error": true,
          "message": e.toString(),
          "total": "0",
        };
      }

      return {
        "data": (response['data'] as List)
            .map((e) => SubscriptionInformation.fromJson(Map.from(e)))
            .toList(),
        "error": response['error'] ?? false,
        "total": (response['total'] ?? 0).toString(),
        "message": response['message'] ?? '',
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> addSubscriptionTransaction({
    required final Map<String, dynamic> parameter,
  }) async {
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.addSubscriptionTransaction,
        parameter: parameter,
        useAuthToken: true,
      );
      if (response['error']) {
        return {"data": [], "error": true, "message": response['message']};
      }
      return {
        "paypalPaymentURL": response["data"]["paypal_link"],
        "paystackPaymentURL": response["data"]["paystack_link"],
        "flutterwavePaymentURL":
            response["data"]["flutterwave_link"] ??
            response["data"]["flutterwave"],
        'xendit_url': response['data']['xendit_link'] ?? '',
        "transactionData": response['data']['transaction'],
        "subscriptionData": response['data']['subscription_information'],
        "error": response['error'] ?? false,
        "message": response['message'] ?? '',
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
