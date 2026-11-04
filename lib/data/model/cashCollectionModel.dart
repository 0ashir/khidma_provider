class CashCollectionModel {
  const CashCollectionModel({
    this.id,
    this.message,
    this.commissionAmount,
    this.status,
    this.translatedStatus,
    this.date,
    this.orderID,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  factory CashCollectionModel.fromJson(Map<String, dynamic> json) {
    return CashCollectionModel(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      commissionAmount: json['commison']?.toString() ?? '',
      status: json['status']?.toString() == 'admin_cash_recevied'
          ? 'paid'
          : 'received',
      translatedStatus: (json['translated_status']?.toString() ?? '').isNotEmpty
          ? json['translated_status'].toString()
          : (json['status']?.toString() == 'admin_cash_recevied'
                ? 'paid'
                : 'received'),
      orderID: json['order_id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      currencySymbol: json['currency_symbol']?.toString(),
      currencyDecimalPlaces: int.tryParse(
        json['currency_decimal_places']?.toString() ?? '',
      ),
    );
  }

  final String? id;
  final String? message;
  final String? commissionAmount;
  final String? status;
  final String? translatedStatus;
  final String? date;
  final String? orderID;

  /// Currency saved on the row's booking; null → provider's country currency.
  final String? currencySymbol;
  final int? currencyDecimalPlaces;
}
