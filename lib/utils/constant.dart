export 'appStoreLinks.dart';

const String appName = 'Khidma Provider';

// Live eDemand backend; a build-time define can select another environment.
const String domain = String.fromEnvironment(
  'KHIDMA_BACKEND_ORIGIN',
  defaultValue: 'https://admin.khidmaplus.com',
);

const bool enableAds = bool.fromEnvironment('KHIDMA_ENABLE_ADS');

const String baseUrl = "$domain/partner/api/v1/";

const String microsoftClarityProjectId = '';

const bool showCompanyLogoOnSplash = false;

//if you do not want user to select another country rather than default country,
//then make below variable true
const bool allowOnlySingleCountry = false;

const String defaultDateFormat = "dd/MM/yyyy";
const bool defaultUse24HourFormat = false;

// Defaults until `get_country_settings` loads; FetchCountrySettingsCubit then
// overwrites them with the provider's country format.
Map<String, dynamic> dateAndTimeSetting = {
  "dateFormat": defaultDateFormat,
  "use24HourFormat": defaultUse24HourFormat,
};
