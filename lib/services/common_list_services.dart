import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/model/current_zone_model.dart';

List<KnownLanguageModel> knownLanguageList = [];
List<SubscriptionModel> subscriptionList = [];
List<DocumentModel> documentList = [];
List<CountryStateModel> countryStateList = [];
List<StateModel> stateList = [];
List<PaymentMethods> paymentMethods = [];
List<ZoneModel> zoneList = [];
List subscriptionIds = [];

List<CurrencyModel> currencyList = [];
List<DefaultLanguage> defaultLanguages = [];
List<ServicemanModel> servicemanList = [];
List<BlogModel> blogList = [], firstTwoBlogList = [];
List<CategoryModel> categoryList = [];
List<CategoryModel> allCategoryList = [];
List<TaxModel> taxList = [];
List<BookingStatusModel> bookingStatusList = [];
List<Datum> currentZoneModel = [];

AppSettingModel? appSettingModel;

final symbolPosition =
    appSettingModel?.general?.defaultCurrency?.symbolPosition == "left";
