import 'package:flutter_test/flutter_test.dart';
import 'package:edemand_partner/app/generalImports.dart';

void main() {
  test(
    'store links keep customer and provider identities on both platforms',
    () {
      expect(
        Uri.parse(customerStoreUrl(isIOS: false)).queryParameters['id'],
        'com.services.khadamat',
      );
      expect(
        Uri.parse(providerStoreUrl(isIOS: false)).queryParameters['id'],
        'com.provider.khadamat',
      );
      expect(
        Uri.parse(customerStoreUrl(isIOS: true)).path,
        '/app/id6755617892',
      );
      expect(
        Uri.parse(providerStoreUrl(isIOS: true)).path,
        '/app/id6755718687',
      );
    },
  );

  test('stale backend URLs cannot replace the app store identities', () {
    final settings = AppSetting.fromJson({
      'customer_playstore_url': 'https://example.com/wrong-customer',
      'customer_appstore_url': '',
      'provider_playstore_url': '',
      'provider_appstore_url': 'https://example.com/wrong-provider',
    });
    expect(settings.customerAppPlayStoreURL, customerPlayStoreUrl);
    expect(settings.customerAppAppStoreURL, customerAppStoreUrl);
    expect(settings.providerAppPlayStoreURL, providerPlayStoreUrl);
    expect(settings.providerAppAppStoreURL, providerAppStoreUrl);
  });

  test('store actions have URLs before settings finish loading', () {
    final cubit = FetchSystemSettingsCubit();
    addTearDown(cubit.close);
    expect(cubit.getAppStoreURL, providerAppStoreUrl);
    expect(cubit.getPlayStoreURL, providerPlayStoreUrl);
    expect(cubit.getProviderAppURL, isNotEmpty);
  });
}
