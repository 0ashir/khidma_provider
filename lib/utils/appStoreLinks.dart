const String providerPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.provider.khadamat';
const String providerAppStoreUrl = 'https://apps.apple.com/app/id6755718687';
const String customerPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.services.khadamat';
const String customerAppStoreUrl = 'https://apps.apple.com/app/id6755617892';

String customerStoreUrl({required bool isIOS}) =>
    isIOS ? customerAppStoreUrl : customerPlayStoreUrl;

String providerStoreUrl({required bool isIOS}) =>
    isIOS ? providerAppStoreUrl : providerPlayStoreUrl;
