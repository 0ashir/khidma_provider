import '../../app/generalImports.dart';

abstract class AddSubscriptionTransactionState {}

class AddSubscriptionTransactionInitial
    extends AddSubscriptionTransactionState {}

class AddSubscriptionTransactionInProgress
    extends AddSubscriptionTransactionState {
  final String subscriptionId;

  AddSubscriptionTransactionInProgress({required this.subscriptionId});
}

class AddSubscriptionTransactionSuccess
    extends AddSubscriptionTransactionState {
  final String transactionId;
  final String paymentMethodType;
  final String paypalPaymentURL;
  final String paystackPaymentURL;
  final String flutterwavePaymentURL;
  final String subscriptionAmount;
  final String subscriptionId;
  final String razorpayOrderId;
  final String subscriptionStatus;
  final SubscriptionInformation subscriptionInformation;
  final String xenditURL;
  // Cashfree
  final String cashfreeOrderId;
  final String cashfreePaymentSessionId;

  AddSubscriptionTransactionSuccess({
    required this.subscriptionStatus,
    required this.paypalPaymentURL,
    required this.subscriptionInformation,
    required this.razorpayOrderId,
    required this.transactionId,
    required this.paymentMethodType,
    required this.subscriptionAmount,
    required this.subscriptionId,
    required this.paystackPaymentURL,
    required this.flutterwavePaymentURL,
    required this.xenditURL,
    required this.cashfreeOrderId,
    required this.cashfreePaymentSessionId,
  });
}

class AddSubscriptionTransactionFailure
    extends AddSubscriptionTransactionState {
  final String errorMessage;

  AddSubscriptionTransactionFailure(this.errorMessage);
}

class AddSubscriptionTransactionCubit
    extends Cubit<AddSubscriptionTransactionState> {
  AddSubscriptionTransactionCubit()
    : super(AddSubscriptionTransactionInitial());

  final SubscriptionsRepository _subscriptionsRepository =
      SubscriptionsRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  Future<void> addSubscriptionTransaction({
    required final String subscriptionId,
    final String? transactionId,
    required final String message,
    required final String status,
    required final String paymentMethodType,
    required bool needToCreateRazorpayOrderID,
  }) async {
    try {
      emit(
        AddSubscriptionTransactionInProgress(subscriptionId: subscriptionId),
      );

      String razorpayOrderId = '';
      String cashfreeOrderId = '';
      String cashfreePaymentSessionId = '';

      final Map<String, dynamic> transactionData =
          await _subscriptionsRepository.addSubscriptionTransaction(
            parameter: {
              ApiParam.subscriptionID: subscriptionId,
              ApiParam.status: status,
              ApiParam.transactionID: transactionId,
              ApiParam.message: message,
              ApiParam.type: paymentMethodType,
              ApiParam.fromApp: "1",
            },
          );

      if (transactionData["error"]) {
        throw ApiException(transactionData['message']);
      }

      if (paymentMethodType == "razorpay" && needToCreateRazorpayOrderID) {
        razorpayOrderId = await _settingsRepository.createRazorpayOrderId(
          subscriptionID: subscriptionId,
        );
      }

      if (paymentMethodType == "cashfree" && needToCreateRazorpayOrderID) {
        final cashfreeData = await _settingsRepository.createCashfreeOrder(
          subscriptionID: subscriptionId,
          transactionId:
              transactionData['transactionData']['id']?.toString() ?? '',
        );
        cashfreeOrderId = cashfreeData['order_id'] ?? '';
        cashfreePaymentSessionId = cashfreeData['payment_session_id'] ?? '';
      }

      emit(
        AddSubscriptionTransactionSuccess(
          paypalPaymentURL: transactionData["paypalPaymentURL"] ?? '',
          paystackPaymentURL: transactionData["paystackPaymentURL"] ?? '',
          flutterwavePaymentURL: transactionData["flutterwavePaymentURL"] ?? '',
          subscriptionStatus: status.toString(),
          subscriptionInformation: SubscriptionInformation.fromJson(
            Map.from(transactionData["subscriptionData"] ?? {}),
          ),
          subscriptionId: subscriptionId.toString(),
          razorpayOrderId: razorpayOrderId.toString(),
          subscriptionAmount: transactionData['transactionData']['amount']
              .toString(),
          paymentMethodType: paymentMethodType.toString(),
          transactionId: transactionData['transactionData']['id'] ?? "0",
          xenditURL: transactionData['xendit_url'] ?? '',
          cashfreeOrderId: cashfreeOrderId,
          cashfreePaymentSessionId: cashfreePaymentSessionId,
        ),
      );
    } catch (e) {
      emit(AddSubscriptionTransactionFailure(e.toString()));
    }
  }

  Map<String, dynamic> getTransactionDetails() {
    if (state is AddSubscriptionTransactionSuccess) {
      return {
        "subscriptionAmount":
            (state as AddSubscriptionTransactionSuccess).subscriptionAmount,
        "transactionId":
            (state as AddSubscriptionTransactionSuccess).transactionId,
        "subscriptionId":
            (state as AddSubscriptionTransactionSuccess).subscriptionId,
        "paymentMethodType":
            (state as AddSubscriptionTransactionSuccess).paymentMethodType,
      };
    }
    return {
      "subscriptionAmount": "0",
      "transactionId": "0",
      "subscriptionId": "0",
      "paymentMethodType": '',
    };
  }
}
