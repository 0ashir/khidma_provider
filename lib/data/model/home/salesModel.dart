class SalesModel {
  final String? year;
  final String? month;
  final String? totalAmount;
  final String? week;

  SalesModel({this.year, this.month, this.totalAmount, this.week});

  SalesModel.fromJson(Map<String, dynamic> json)
    : year = json['year']?.toString() ?? '',
      month = json['month']?.toString() ?? '',
      totalAmount = json['total_amount']?.toString() ?? '',
      week = json['week']?.toString() ?? '';

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'total_amount': totalAmount,
    'week': week,
  };
}
