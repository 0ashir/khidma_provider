import 'package:edemand_partner/data/model/countryCodeModel.dart';
import 'package:edemand_partner/data/repository/mainActivityRepository.dart';
import 'package:edemand_partner/ui/widgets/countryFlag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

CountryCodeModel country({String code = 'SA', String flag = ''}) =>
    CountryCodeModel(
      id: '1',
      countryName: 'Saudi Arabia',
      callingCode: '+966',
      countryCode: code,
      flagImage: flag,
      isDefault: '1',
    );

void main() {
  group('CountryFlag', () {
    test('emoji from a two-letter ISO code', () {
      expect(CountryFlag.emojiFor('SA'), '🇸🇦');
      expect(CountryFlag.emojiFor(' in '), '🇮🇳');
      expect(CountryFlag.emojiFor('SAU'), isNull);
      expect(CountryFlag.emojiFor(''), isNull);
    });

    // The API sends flag_image '' when no flag file was uploaded; that used
    // to reach Image.asset('') and show "Unable to load asset".
    for (final flag in ['', 'in.png', 'uploads/flags/in.png']) {
      testWidgets('no asset lookup for flag_image "$flag"', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CountryFlag(country: country(flag: flag)),
          ),
        );
        expect(find.byType(Image), findsNothing);
        expect(find.text('🇸🇦'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('unknown code falls back to an icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountryFlag(country: country(code: '')),
        ),
      );
      expect(find.byIcon(Icons.flag), findsOneWidget);
    });

    testWidgets('URL flags load from the network', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountryFlag(
            country: country(flag: 'https://admin.khidmaplus.com/sa.png'),
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('settings grid order', () {
    const defaults = [
      (name: 'notifications', icon: 'assets/images/svg/notification.svg'),
      (name: 'aboutUs', icon: 'assets/images/svg/dr_about_us.svg'),
      (name: 'logoutLbl', icon: 'assets/images/svg/dr_logout.svg'),
    ];

    test('keeps the saved order but always uses current icon paths', () async {
      SharedPreferences.setMockInitialValues({
        MainActivityRepository.key: [
          'aboutUs*assets/images/svg/renamed_or_removed.svg',
          'notifications*assets/images/svg/notification.svg',
          'removedItem*assets/images/svg/x.svg',
        ],
      });

      final items = await MainActivityRepository.loadPositions(defaults);

      expect(items.map((e) => e.name), [
        'logoutLbl', // new since the order was saved
        'aboutUs',
        'notifications',
      ]);
      expect(items.map((e) => e.icon), [
        defaults[2].icon,
        defaults[1].icon,
        defaults[0].icon,
      ]);
    });
  });
}
