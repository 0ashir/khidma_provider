import 'dart:io';
import 'dart:ui' as ui;

import 'package:edemand_partner/app/appAssets.dart';
import 'package:edemand_partner/app/appTheme.dart';
import 'package:edemand_partner/ui/widgets/customSvgPicture.dart';
import 'package:edemand_partner/ui/widgets/customCachedNetworkImage.dart';
import 'package:edemand_partner/utils/api/apiClient.dart';
import 'package:edemand_partner/utils/api/apiException.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'unconfigured requests cannot reach the legacy production API',
    () async {
      final unavailable = isA<ApiException>().having(
        (error) => error.errorMessage,
        'message',
        'serviceUnavailable',
      );
      // Configuration must be checked before opening storage or issuing HTTP.
      await expectLater(
        ApiClient.get(url: '${baseUrl}get_settings', useAuthToken: false),
        throwsA(unavailable),
      );
      await expectLater(
        ApiClient.post(
          url: '${baseUrl}get_settings',
          parameter: {},
          useAuthToken: false,
        ),
        throwsA(unavailable),
      );
      await expectLater(
        ApiClient.downloadAPI(
          url: '${baseUrl}invoice-download',
          parameter: {},
          useAuthToken: false,
        ),
        throwsA(unavailable),
      );
    },
    skip: domain.isNotEmpty,
  );

  for (final mode in AppTheme.values) {
    testWidgets('latest K+ assets render with bundled Outfit in ${mode.name}', (
      tester,
    ) async {
      final font = FontLoader('Outfit')
        ..addFont(rootBundle.load('assets/fonts/Outfit-Variable.ttf'));
      await font.load();

      await tester.pumpWidget(
        MaterialApp(
          theme: appThemeData[mode],
          home: RepaintBoundary(
            key: const ValueKey('brand-preview'),
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(appName),
                    const CustomSvgPicture(
                      svgImage: AppAssets.providerLoginLogo,
                      width: 240,
                      height: 100,
                      boxFit: BoxFit.contain,
                      color: Colors.red,
                    ),
                    const CustomSvgPicture(
                      svgImage: AppAssets.handymanLoginLogo,
                      width: 240,
                      height: 100,
                      boxFit: BoxFit.contain,
                    ),
                    Image.asset(
                      AppAssets.loginTypeImage,
                      width: 240,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const CustomCachedNetworkImage(
                      imageUrl: 'assets/images/flags/aus.png',
                      width: 48,
                      height: 32,
                    ),
                    const CustomSvgPicture(
                      svgImage: AppAssets.chat,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        await precacheImage(
          const AssetImage(AppAssets.loginTypeImage),
          tester.element(find.text(appName)),
        );
        await precacheImage(
          const AssetImage(AppAssets.providerLoginLogo),
          tester.element(find.text(appName)),
        );
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(appName), findsOneWidget);
      expect(find.byType(CustomSvgPicture), findsNWidgets(3));
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.widget<Image>(find.byType(Image).first).color, isNull);
      expect(
        Theme.of(tester.element(find.text(appName))).colorScheme.primary,
        const Color(0xFF5465FF),
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text(appName))).style.color,
        mode == AppTheme.dark
            ? const Color(0xFFF1F1F1)
            : const Color(0xFF00162E),
      );
      if (const bool.fromEnvironment('KHIDMA_CAPTURE_PREVIEW')) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('brand-preview')),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 1.5);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File(
            '../../.migration/provider-brand-${mode.name}.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    });
  }
}
