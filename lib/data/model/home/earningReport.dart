class EarningReport {
  final String? adminCommission;
  final String? myIncome;
  final String? remainingIncome;
  final String? futureEarningFromBookings;

  /// Currency of every amount above; empty / null falls back to the system one.
  final String? currencySymbol;
  final int? currencyDecimalPlaces;

  EarningReport({
    this.adminCommission,
    this.myIncome,
    this.remainingIncome,
    this.futureEarningFromBookings,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  EarningReport.fromJson(Map<String, dynamic> json)
    : adminCommission = json['admin_commission']?.toString() ?? '',
      myIncome = json['my_income']?.toString() ?? '',
      remainingIncome = json['remaining_income']?.toString() ?? '',
      futureEarningFromBookings =
          json['future_earning_from_bookings']?.toString() ?? '0',
      currencySymbol = json['currency_symbol']?.toString() ?? '',
      currencyDecimalPlaces = int.tryParse(
        json['currency_decimal_places']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
    'admin_commission': adminCommission,
    'my_income': myIncome,
    'remaining_income': remainingIncome,
    'future_earning_from_bookings': futureEarningFromBookings,
    'currency_symbol': currencySymbol,
    'currency_decimal_places': currencyDecimalPlaces,
  };
}
