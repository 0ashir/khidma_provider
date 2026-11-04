import '../app/generalImports.dart';

abstract class FetchCountrySettingsState {}

class FetchCountrySettingsInitial extends FetchCountrySettingsState {}

class FetchCountrySettingsInProgress extends FetchCountrySettingsState {}

class FetchCountrySettingsSuccess extends FetchCountrySettingsState {
  FetchCountrySettingsSuccess(this.settings);

  final CountrySettings settings;
}

class FetchCountrySettingsFailure extends FetchCountrySettingsState {
  FetchCountrySettingsFailure(this.errorMessage);

  final String errorMessage;
}

/// Currency etc. of the logged-in provider's country. Getters return null until
/// the settings load, so callers fall back to the system currency.
class FetchCountrySettingsCubit extends Cubit<FetchCountrySettingsState> {
  FetchCountrySettingsCubit() : super(FetchCountrySettingsInitial());

  final CountrySettingsRepository _repository = CountrySettingsRepository();

  Future<void> fetch() async {
    try {
      // Keep showing the loaded settings while they refresh.
      if (settings == null) emit(FetchCountrySettingsInProgress());
      final CountrySettings loaded = await _repository.getCountrySettings();
      _applyDateAndTimeFormat(loaded);
      emit(FetchCountrySettingsSuccess(loaded));
    } catch (e) {
      // A failed refresh keeps the loaded settings.
      if (settings == null) emit(FetchCountrySettingsFailure(e.toString()));
    }
  }

  /// formatDate / formatTime / formatDateAndTime read [dateAndTimeSetting].
  /// A format the API does not send keeps the app default.
  void _applyDateAndTimeFormat(final CountrySettings loaded) {
    if (loaded.dateFormat.isNotEmpty) {
      dateAndTimeSetting['dateFormat'] = loaded.intlDateFormat;
    }
    if (loaded.timeFormat.isNotEmpty) {
      dateAndTimeSetting['use24HourFormat'] = loaded.use24HourFormat;
    }
  }

  /// Fetches the settings unless they are loaded or loading, e.g. when a
  /// screen needs them and the app start did not load them.
  Future<void> ensureLoaded() async {
    if (state is FetchCountrySettingsSuccess ||
        state is FetchCountrySettingsInProgress) {
      return;
    }
    await fetch();
  }

  /// Back to system currency and the default date/time format, e.g. on logout.
  void clear() {
    dateAndTimeSetting['dateFormat'] = defaultDateFormat;
    dateAndTimeSetting['use24HourFormat'] = defaultUse24HourFormat;
    emit(FetchCountrySettingsInitial());
  }

  CountrySettings? get settings => state is FetchCountrySettingsSuccess
      ? (state as FetchCountrySettingsSuccess).settings
      : null;

  String? get currencyCode =>
      (settings?.currency.isNotEmpty ?? false) ? settings!.currency : null;

  String? get currencySymbol => (settings?.currencySymbol.isNotEmpty ?? false)
      ? settings!.currencySymbol
      : null;

  int? get currencyDecimalPlaces => settings?.currencyDecimalPlaces;

  /// The country's gateway entry for [paymentType] (`stripe`, `razorpay`...);
  /// null when the country does not offer it or settings are not loaded.
  CountryPaymentGateway? gatewayOf(final String paymentType) {
    for (final CountryPaymentGateway gateway
        in settings?.paymentGateways ?? const <CountryPaymentGateway>[]) {
      if (gateway.gateway.toLowerCase() == paymentType.toLowerCase()) {
        return gateway;
      }
    }
    return null;
  }

  /// Whether the country allows cash on delivery (pay on service); null until
  /// the settings load or when the API does not say.
  bool? get isCodEnabled => settings?.codEnabled;

  /// Whether the provider can pay online in this country
  /// (`provider_online_payment_setting` and at least one gateway); null until
  /// the settings load.
  bool? get hasOnlinePayment {
    final CountrySettings? current = settings;
    if (current == null) return null;
    return (current.onlinePaymentEnabled ?? true) &&
        current.paymentGateways.isNotEmpty;
  }

  /// The payment methods of [allMethods] that the provider's country offers
  /// (`payment_gateways`), in the API's order; null until the settings load.
  /// The country decides, whatever the system settings enable.
  List<Map<String, dynamic>>? paymentMethodsFrom(
    final List<Map<String, dynamic>> allMethods,
  ) {
    final CountrySettings? current = settings;
    if (current == null) return null;
    final List<Map<String, dynamic>> methods = [];
    if (current.onlinePaymentEnabled == false) return methods;
    for (final CountryPaymentGateway gateway in current.paymentGateways) {
      for (final Map<String, dynamic> method in allMethods) {
        if (method['paymentType'].toString().toLowerCase() ==
            gateway.gateway.toLowerCase()) {
          methods.add(method);
          break;
        }
      }
    }
    return methods;
  }
}
