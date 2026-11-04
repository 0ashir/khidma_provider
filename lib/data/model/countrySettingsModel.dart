bool _toBool(final dynamic value) =>
    value == true || value?.toString() == '1' || value?.toString() == 'true';

/// Null when the key is absent, so callers can tell "off" from "not sent".
bool? _toOptionalBool(final dynamic value) =>
    value == null ? null : _toBool(value);

/// `get_country_settings`: currency, date/time format and payment options of
/// the logged-in provider's country.
class CountrySettings {
  const CountrySettings({
    required this.currency,
    required this.currencySymbol,
    required this.currencyDecimalPlaces,
    required this.dateFormat,
    required this.timeFormat,
    required this.codEnabled,
    required this.onlinePaymentEnabled,
    required this.paymentGateways,
  });

  factory CountrySettings.fromJson(final Map<String, dynamic> json) {
    return CountrySettings(
      currency: json['currency']?.toString() ?? '',
      currencySymbol: json['currency_symbol']?.toString() ?? '',
      currencyDecimalPlaces: int.tryParse(
        json['currency_decimal_places']?.toString() ?? '',
      ),
      dateFormat: json['date_format']?.toString() ?? '',
      timeFormat: json['time_format']?.toString() ?? '',
      codEnabled: _toOptionalBool(json['cod_setting'] ?? json['cod_enabled']),
      onlinePaymentEnabled: _toOptionalBool(
        json['provider_online_payment_setting'] ??
            json['online_payment_enabled'],
      ),
      paymentGateways: json['payment_gateways'] is List
          ? (json['payment_gateways'] as List)
                .whereType<Map>()
                .map(
                  (e) => CountryPaymentGateway.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : const [],
    );
  }

  /// Currency code, e.g. `INR`.
  final String currency;

  /// Display symbol, e.g. `₹`. Holds the currency code when the country has no
  /// symbol.
  final String currencySymbol;

  /// Decimals to show for amounts; null when the API does not send it.
  final int? currencyDecimalPlaces;

  /// One of `DD-MM-YYYY`, `MM-DD-YYYY`, `YYYY-MM-DD`, `DD/MM/YYYY`,
  /// `MM/DD/YYYY`, `DD Mon YYYY`; empty when the API does not send it.
  final String dateFormat;

  /// `h:i A` (12-hour) or `H:i` (24-hour); empty when the API does not send it.
  final String timeFormat;

  /// [dateFormat] as an `intl` pattern, e.g. `DD Mon YYYY` -> `dd MMM yyyy`.
  String get intlDateFormat => dateFormat
      .replaceAll('DD', 'dd')
      .replaceAll('YYYY', 'yyyy')
      .replaceAll('Mon', 'MMM');

  /// Uppercase `H` is the 24-hour clock (`H:i`); `h:i A` is 12-hour.
  bool get use24HourFormat => timeFormat.startsWith('H');

  /// `cod_setting`: 1 shows cash on delivery (pay on service), 0 hides it.
  /// Null when the API does not send it.
  final bool? codEnabled;

  /// `provider_online_payment_setting`: 0 means the provider cannot pay online
  /// (and [paymentGateways] is empty), 1 means they can. Null when not sent.
  final bool? onlinePaymentEnabled;

  /// Enabled gateways only; empty when [onlinePaymentEnabled] is false.
  final List<CountryPaymentGateway> paymentGateways;
}

class CountryPaymentGateway {
  const CountryPaymentGateway({
    required this.gateway,
    required this.label,
    required this.mode,
    required this.currency,
    required this.clientKey,
  });

  factory CountryPaymentGateway.fromJson(final Map<String, dynamic> json) {
    // The client key field is named differently per gateway.
    final String clientKey =
        [
              json['key'],
              json['publishable_key'],
              json['client_key'],
              json['public_key'],
            ]
            .map((e) => e?.toString() ?? '')
            .firstWhere((e) => e.isNotEmpty, orElse: () => '');

    return CountryPaymentGateway(
      gateway: json['gateway']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      mode: json['mode']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      clientKey: clientKey,
    );
  }

  final String gateway;
  final String label;
  final String mode;
  final String currency;
  final String clientKey;
}
