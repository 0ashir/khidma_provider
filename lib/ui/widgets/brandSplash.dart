import 'package:flutter/material.dart';

import '../../app/appAssets.dart';

/// Brand splash: full-screen splash artwork.
///
/// Shared by the startup bootstrap (shown while Firebase/Hive initialise) and
/// [SplashScreen], so the hand-off between them is pixel-identical. Kept free of
/// theme, localisation and bloc dependencies so it can render before any of
/// them exist.
class BrandSplash extends StatelessWidget {
  const BrandSplash({super.key});

  /// Dominant background of the artwork. Must match `@color/khidma_splash_bg`
  /// (Android) and the LaunchScreen storyboard background (iOS) so the
  /// native → Flutter switch, and the frame before the image decodes, are
  /// seamless.
  static const Color backgroundColor = Color(0xFFF5F8FD);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: backgroundColor,
      child: SizedBox.expand(
        // 9:16 artwork; cover crops only the outer side margins on taller
        // phones, which keeps the logo and illustration fully visible.
        child: Image(
          image: AssetImage(AppAssets.splashScreenArt),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
