import 'dart:io' show Platform;

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MicrosoftClarityInitializer extends StatelessWidget {
  const MicrosoftClarityInitializer({
    super.key,
    required this.projectId,
    required this.child,
  });

  final String projectId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final trimmedId = projectId.trim();
    if (trimmedId.isEmpty || kIsWeb || !_isMobilePlatform) {
      return child;
    }

    return ClarityWidget(
      clarityConfig: ClarityConfig(projectId: trimmedId),
      app: child,
    );
  }

  bool get _isMobilePlatform {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }
}
