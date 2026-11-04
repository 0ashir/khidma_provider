String _currencySymbolOf(Map<String, dynamic> json, [String fallback = '']) {
  final symbol = (json['currency_symbol'] ?? json['currency'])?.toString();
  return (symbol == null || symbol.isEmpty) ? fallback : symbol;
}

int? _decimalPlacesOf(Map<String, dynamic> json, [int? fallback]) =>
    int.tryParse(json['currency_decimal_places']?.toString() ?? '') ?? fallback;

class HandymanDashboardBookingCounts {
  final int todayBookings;
  final int tomorrowBookings;
  final int upcomingBookings;

  const HandymanDashboardBookingCounts({
    required this.todayBookings,
    required this.tomorrowBookings,
    required this.upcomingBookings,
  });

  factory HandymanDashboardBookingCounts.fromJson(Map<String, dynamic> json) =>
      HandymanDashboardBookingCounts(
        todayBookings:
            int.tryParse(json['today_bookings']?.toString() ?? '0') ?? 0,
        tomorrowBookings:
            int.tryParse(json['tomorrow_bookings']?.toString() ?? '0') ?? 0,
        upcomingBookings:
            int.tryParse(json['upcoming_bookings']?.toString() ?? '0') ?? 0,
      );
}

class HandymanDashboardCashCollection {
  final String currency;
  final int? currencyDecimalPlaces;
  final double overallTotal;
  final double outstandingTotal;

  const HandymanDashboardCashCollection({
    required this.currency,
    this.currencyDecimalPlaces,
    required this.overallTotal,
    required this.outstandingTotal,
  });

  factory HandymanDashboardCashCollection.fromJson(
    Map<String, dynamic> json, {
    String fallbackCurrency = '',
    int? fallbackDecimalPlaces,
  }) => HandymanDashboardCashCollection(
    currency: _currencySymbolOf(json, fallbackCurrency),
    currencyDecimalPlaces: _decimalPlacesOf(json, fallbackDecimalPlaces),
    overallTotal:
        double.tryParse(json['overall_total']?.toString() ?? '0') ?? 0,
    outstandingTotal:
        double.tryParse(json['outstanding_total']?.toString() ?? '0') ?? 0,
  );
}

class HandymanRecentBooking {
  final String orderId;
  final String dateOfService;
  final String startingTime;
  final String endingTime;
  final String finalTotal;
  final String address;
  final String customerName;
  final String currency;
  final int? currencyDecimalPlaces;

  const HandymanRecentBooking({
    required this.orderId,
    required this.dateOfService,
    required this.startingTime,
    required this.endingTime,
    required this.finalTotal,
    required this.address,
    required this.customerName,
    this.currency = '',
    this.currencyDecimalPlaces,
  });

  factory HandymanRecentBooking.fromJson(
    Map<String, dynamic> json, {
    String fallbackCurrency = '',
    int? fallbackDecimalPlaces,
  }) => HandymanRecentBooking(
    orderId: json['order_id']?.toString() ?? '',
    dateOfService: json['date_of_service']?.toString() ?? '',
    startingTime: json['starting_time']?.toString() ?? '',
    endingTime: json['ending_time']?.toString() ?? '',
    finalTotal: json['final_total']?.toString() ?? '',
    address: json['address']?.toString() ?? '',
    customerName: json['customer_name']?.toString() ?? '',
    currency: _currencySymbolOf(json, fallbackCurrency),
    currencyDecimalPlaces: _decimalPlacesOf(json, fallbackDecimalPlaces),
  );
}

class HandymanDashboardModel {
  final String? salary;
  final String currency;
  final int? currencyDecimalPlaces;
  final int totalBookings;
  final int leadBookings;
  final HandymanDashboardBookingCounts bookings;
  final HandymanDashboardCashCollection cashCollection;
  final List<HandymanRecentBooking> recentCompletedBookings;

  const HandymanDashboardModel({
    required this.salary,
    required this.currency,
    this.currencyDecimalPlaces,
    required this.totalBookings,
    required this.leadBookings,
    required this.bookings,
    required this.cashCollection,
    required this.recentCompletedBookings,
  });

  factory HandymanDashboardModel.fromJson(Map<String, dynamic> json) {
    final currency = _currencySymbolOf(json);
    final decimalPlaces = _decimalPlacesOf(json);

    return HandymanDashboardModel(
      salary: json['salary']?.toString(),
      currency: currency,
      currencyDecimalPlaces: decimalPlaces,
      totalBookings:
          int.tryParse(json['total_bookings']?.toString() ?? '0') ?? 0,
      leadBookings: int.tryParse(json['lead_bookings']?.toString() ?? '0') ?? 0,
      bookings: HandymanDashboardBookingCounts.fromJson(
        json['bookings'] is Map<String, dynamic>
            ? json['bookings'] as Map<String, dynamic>
            : {},
      ),
      cashCollection: HandymanDashboardCashCollection.fromJson(
        json['cash_collection'] is Map<String, dynamic>
            ? json['cash_collection'] as Map<String, dynamic>
            : {},
        fallbackCurrency: currency,
        fallbackDecimalPlaces: decimalPlaces,
      ),
      recentCompletedBookings: (json['recent_completed_bookings'] is List)
          ? (json['recent_completed_bookings'] as List)
                .map(
                  (e) => HandymanRecentBooking.fromJson(
                    Map<String, dynamic>.from(e as Map),
                    fallbackCurrency: currency,
                    fallbackDecimalPlaces: decimalPlaces,
                  ),
                )
                .toList()
          : [],
    );
  }
}
