import 'dart:convert';
import 'dart:io';

import 'package:edemand_partner/app/appLocalization.dart';
import 'package:edemand_partner/data/model/taxBreakdownModel.dart';
import 'package:edemand_partner/data/repository/hiveRepository.dart';
import 'package:edemand_partner/utils/checkURLType.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edemand_partner/cubits/getCustomFieldsCubit.dart';
import 'package:edemand_partner/data/model/customFieldModel.dart';
import 'package:edemand_partner/ui/screens/auth/widgets/bank_info.dart';
import 'package:edemand_partner/ui/widgets/customFields/customFieldsForm.dart';
import 'package:hive_flutter/hive_flutter.dart';

final Map<String, dynamic> en =
    jsonDecode(File('assets/languages/en.json').readAsStringSync())
        as Map<String, dynamic>;

late AppLocalization loadedLocalization;

class _BankFieldsCubit extends Cubit<GetCustomFieldsState>
    implements GetCustomFieldsCubit {
  _BankFieldsCubit(super.initialState);

  @override
  Future<void> fetchCustomFields({String? fieldGroup}) async {}
}

/// Serves the [AppLocalization] loaded in setUpAll; asset IO does not
/// complete under the widget tester's fake async.
class _LoadedLocalizationDelegate
    extends LocalizationsDelegate<AppLocalization> {
  const _LoadedLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalization> load(Locale locale) =>
      SynchronousFuture(loadedLocalization);

  @override
  bool shouldReload(_LoadedLocalizationDelegate old) => false;
}

/// Pumps a bare app with the app's English strings and hands back a context
/// that can translate.
Future<BuildContext> localizedContext(WidgetTester tester) async {
  BuildContext? captured;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        _LoadedLocalizationDelegate(),
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return captured!;
}

void main() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.createTempSync('khidma_hive').path);
    await HiveRepository.init();
    loadedLocalization = AppLocalization(const Locale('en'));
    await loadedLocalization.loadJson();
  });

  group('bank registration step', () {
    Future<GlobalKey<FormState>> pumpBankStep(
      WidgetTester tester,
      GetCustomFieldsState state,
    ) async {
      final cubit = _BankFieldsCubit(state);
      addTearDown(cubit.close);
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [_LoadedLocalizationDelegate()],
          home: BlocProvider<GetCustomFieldsCubit>.value(
            value: cubit,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Form6BankInfo(
                  formKey: formKey,
                  customFieldsKey: GlobalKey<CustomFieldsFormState>(),
                ),
              ),
            ),
          ),
        ),
      );
      return formKey;
    }

    testWidgets('empty bank configuration explains recovery and allows Next', (
      tester,
    ) async {
      final key = await pumpBankStep(
        tester,
        GetCustomFieldsSuccess(fields: [], savedValues: {}),
      );
      expect(find.textContaining('Please contact support'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(key.currentState!.validate(), isTrue);
    });

    testWidgets('initial, loading and failed requests cannot pass validation', (
      tester,
    ) async {
      for (final state in <GetCustomFieldsState>[
        GetCustomFieldsInitial(),
        GetCustomFieldsInProgress(),
        GetCustomFieldsFail('Could not load bank details'),
      ]) {
        final key = await pumpBankStep(tester, state);
        expect(key.currentState!.validate(), isFalse);
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('configured bank fields display and validate required input', (
      tester,
    ) async {
      final key = await pumpBankStep(
        tester,
        GetCustomFieldsSuccess(
          fields: [
            CustomFieldModel.fromJson({
              'id': 42,
              'label': 'Account holder name',
              'field_type': 'text',
              'field_group': 'bank_details',
              'required': 1,
              'visible': 1,
            }),
          ],
          savedValues: {},
        ),
      );
      expect(find.textContaining('Account holder name'), findsWidgets);
      expect(key.currentState!.validate(), isFalse);
      await tester.enterText(find.byType(TextFormField), 'Test Provider');
      expect(key.currentState!.validate(), isTrue);
    });
  });

  group('translations', () {
    test('every literal key passed to translate() exists in en.json', () {
      final keyUse = RegExp(r'''["']([A-Za-z0-9_]+)["']\s*\.\s*translate\(''');
      final missing = <String>{};
      for (final file in Directory('lib').listSync(recursive: true)) {
        if (file is! File || !file.path.endsWith('.dart')) continue;
        for (final m in keyUse.allMatches(file.readAsStringSync())) {
          if (!en.containsKey(m.group(1))) missing.add(m.group(1)!);
        }
      }
      expect(
        missing,
        isEmpty,
        reason: 'Missing keys render as raw camelCase text in the UI',
      );
    });
  });

  group('assets', () {
    test('image arguments are asset paths, not bare names', () {
      // e.g. 'imageName': 'registration' showed "Unable to load asset".
      final imageArg = RegExp(
        r'''['"]?(?:imageName|svgImage|imgName)['"]?\s*:\s*['"]([^'"$]*)['"]''',
      );
      final bare = <String>[];
      for (final file in Directory('lib').listSync(recursive: true)) {
        if (file is! File || !file.path.endsWith('.dart')) continue;
        for (final m in imageArg.allMatches(file.readAsStringSync())) {
          final value = m.group(1)!;
          if (value.isEmpty || value.contains('/')) continue;
          bare.add('${file.path}: $value');
        }
      }
      expect(bare, isEmpty);
    });
  });

  group('Validator', () {
    /// Inputs for which [validate] does not return [expected].
    List<String> wrong(
      Iterable<String> inputs,
      String? Function(String) validate,
      Object? expected,
    ) => [
      for (final input in inputs)
        if (validate(input) != expected) '"$input" -> ${validate(input)}',
    ];

    testWidgets('validateEmail accepts real addresses', (tester) async {
      final context = await localizedContext(tester);
      expect(
        wrong(
          [
            'provider@example.com',
            'first.last@mail.example.co.uk',
            'owner+jobs@gmail.com',
            'support@khidma-plus.com',
          ],
          (e) => Validator.validateEmail(context, e),
          null,
        ),
        isEmpty,
      );
    });

    testWidgets('validateEmail rejects malformed addresses', (tester) async {
      final context = await localizedContext(tester);
      expect(
        wrong(
          [
            'plainaddress',
            'user@',
            'user@domain',
            'user name@example.com',
            'user@example.com extra words',
          ],
          (e) => Validator.validateEmail(context, e),
          en['pleaseEnterValidEmail'],
        ),
        isEmpty,
      );
      expect(Validator.validateEmail(context, ''), en['fieldMustNotBeEmpty']);
    });

    testWidgets('validateNumber enforces the configured digit range', (
      tester,
    ) async {
      final context = await localizedContext(tester);
      expect(Validator.validateNumber(context, ''), en['fieldMustNotBeEmpty']);
      expect(
        Validator.validateNumber(context, '12'),
        en['mobileNumberShouldBeInRange'],
      );
      expect(Validator.validateNumber(context, '501234567'), isNull);
    });

    testWidgets('nullCheck(nonZero) rejects every spelling of zero', (
      tester,
    ) async {
      final context = await localizedContext(tester);
      expect(
        wrong(
          ['0', '0.0', '00', '0.00'],
          (v) => Validator.nullCheck(context, v, nonZero: true),
          en['enterMoreThenZero'],
        ),
        isEmpty,
        reason: 'a zero discount/amount must be rejected',
      );
      expect(Validator.nullCheck(context, '10', nonZero: true), isNull);
    });

    testWidgets('latitude and longitude ranges', (tester) async {
      final context = await localizedContext(tester);
      String? lat(String v) => Validator.validateLatitude(context, v);
      String? lng(String v) => Validator.validateLongitude(context, v);
      expect(wrong(['24.713552', '-33.86', '90', '0'], lat, null), isEmpty);
      expect(
        wrong(['90.5', '-91', 'abc'], lat, en['pleaseEnterValidLatitude']),
        isEmpty,
      );
      expect(
        wrong(['46.675296', '-122.4194', '180', '-180'], lng, null),
        isEmpty,
      );
      expect(
        wrong(['180.1', '-181', 'abc'], lng, en['pleaseEnterValidLongitude']),
        isEmpty,
      );
    });
  });

  group('String helpers', () {
    test('removeExtraComma drops empty parts but keeps short ones', () {
      expect('Olaya,,Riyadh,'.removeExtraComma(), 'Olaya,Riyadh');
      expect(',Riyadh'.removeExtraComma(), 'Riyadh');
      // Single-character segments (building "A", block "7") are real data.
      expect('Block,A,Riyadh'.removeExtraComma(), 'Block,A,Riyadh');
      expect('Street 5,7,Jeddah'.removeExtraComma(), 'Street 5,7,Jeddah');
    });

    test('trimLatLong keeps at most 6 decimals and never throws', () {
      expect('24.71355212345'.trimLatLong(), '24.713552');
      expect('24.7135'.trimLatLong(), '24.7135');
      // 10 characters but only 5 decimals: must not throw a RangeError.
      expect(() => '-122.12345'.trimLatLong(), returnsNormally);
      expect('-122.12345'.trimLatLong(), '-122.12345');
    });

    test('formatAccountNumber masks all but the last 4 digits', () {
      expect('1234567890'.formatAccountNumber(), '******7890');
      expect('12345'.formatAccountNumber(), '12345');
      expect(''.formatAccountNumber(), '-');
      expect('<p>no number</p>'.formatAccountNumber(), '-');
      expect(
        '<span>A/c No:</span> SA1234567890 | IBAN'.formatAccountNumber(),
        '********7890',
      );
    });

    test('extractFileName / isImage / capitalize', () {
      expect('https://x.com/a/b/invoice.pdf'.extractFileName(), 'invoice.pdf');
      expect('photo.JPG'.isImage(), isTrue);
      expect('doc.pdf'.isImage(), isFalse);
      expect('hELLO'.capitalize(), 'Hello');
      expect(''.capitalize(), '');
    });

    test('formatDate parses API dates into the configured format', () {
      expect('2026-10-30'.formatDate(), isNot('2026-10-30T00:00:00'));
      expect('not a date'.formatDate(), 'not a date');
    });
  });

  group('UrlTypeHelper', () {
    test('detects images and videos regardless of case and query', () {
      expect(
        UrlTypeHelper.getType('https://cdn.x.com/a/photo.JPG?v=2'),
        UrlType.image,
      );
      expect(UrlTypeHelper.getType('https://cdn.x.com/v.mp4'), UrlType.video);
      expect(UrlTypeHelper.getType('https://cdn.x.com/file'), UrlType.unknown);
      expect(UrlTypeHelper.getType('::::'), UrlType.unknown);
    });
  });

  group('TaxBreakdown', () {
    test('parses groups in order, tolerating strings, commas and nulls', () {
      final breakdown = TaxBreakdown.fromJson({
        'services': {
          'title': 'Services',
          'base_amount': '1,000.50',
          'total_tax': 150,
          'total_with_tax': '1150.5',
          'tax_type': 'excluded',
          'tax_components': [
            {'name': 'VAT', 'percentage': '15', 'tax_amount': '150'},
            {'name': 'Legacy', 'percentage': null, 'amount': 2},
            'garbage',
          ],
        },
        'visiting_charges': {'title': 'Visit', 'base_amount': null},
        'not_a_group': 'ignored',
      });

      expect(breakdown.groups.keys, ['services', 'visiting_charges']);
      final services = breakdown.groups['services']!;
      expect(services.baseAmount, 1000.5);
      expect(services.totalTax, 150);
      expect(services.totalWithTax, 1150.5);
      expect(services.components.map((c) => c.name), ['VAT', 'Legacy']);
      expect(services.components[0].amount, 150);
      expect(services.components[1].amount, 2);
      expect(services.components[1].percentage, 0);
      expect(breakdown.groups['visiting_charges']!.baseAmount, 0);
      expect(breakdown.groups['visiting_charges']!.components, isEmpty);
    });
  });
}
