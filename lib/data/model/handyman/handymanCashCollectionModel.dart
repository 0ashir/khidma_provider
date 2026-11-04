String _currencySymbolOf(Map<String, dynamic> json) =>
    json['currency_symbol']?.toString() ?? '';

int? _decimalPlacesOf(Map<String, dynamic> json) =>
    int.tryParse(json['currency_decimal_places']?.toString() ?? '');

class HandymanCashCollectionSummary {
  final String currency;
  final int? currencyDecimalPlaces;
  final double overallTotal;
  final double outstandingTotal;

  const HandymanCashCollectionSummary({
    required this.currency,
    this.currencyDecimalPlaces,
    required this.overallTotal,
    required this.outstandingTotal,
  });

  factory HandymanCashCollectionSummary.fromJson(Map<String, dynamic> json) =>
      HandymanCashCollectionSummary(
        currency: _currencySymbolOf(json),
        currencyDecimalPlaces: _decimalPlacesOf(json),
        overallTotal:
            double.tryParse(json['overall_total']?.toString() ?? '0') ?? 0,
        outstandingTotal:
            double.tryParse(json['outstanding_total']?.toString() ?? '0') ?? 0,
      );
}

class HandymanCashCollectionModel {
  final String id;
  final String? orderId;
  final String type;
  final double amount;
  final String? message;
  final String createdAt;
  final String? finalTotal;
  final String? dateOfService;
  final String? customerName;
  final String currency;
  final int? currencyDecimalPlaces;

  const HandymanCashCollectionModel({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.message,
    required this.createdAt,
    required this.finalTotal,
    required this.dateOfService,
    required this.customerName,
    required this.currency,
    this.currencyDecimalPlaces,
  });

  bool get isCollection => type == 'collection';

  factory HandymanCashCollectionModel.fromJson(Map<String, dynamic> json) =>
      HandymanCashCollectionModel(
        id: json['id']?.toString() ?? '',
        orderId: json['order_id']?.toString(),
        type: json['type']?.toString() ?? '',
        amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
        message: json['message']?.toString(),
        createdAt: json['created_at']?.toString() ?? '',
        finalTotal: json['final_total']?.toString(),
        dateOfService: json['date_of_service']?.toString(),
        customerName: json['customer_name']?.toString(),
        currency: _currencySymbolOf(json),
        currencyDecimalPlaces: _decimalPlacesOf(json),
      );
}
