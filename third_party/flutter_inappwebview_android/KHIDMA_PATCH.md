# Android Gradle Plugin 9 compatibility

Upstream: flutter_inappwebview_android 1.1.3, published at https://pub.dev/packages/flutter_inappwebview_android/versions/1.1.3 .
Upstream archive SHA-256: `62557c15a5c2db5d195cb3892aab74fcaec266d7b86d59a6f0027abd672cddba`.

Only android/build.gradle is modified: both build types use proguard-android-optimize.txt instead of proguard-android.txt, which AGP 9 rejects. Dart APIs, native implementation, and plugin registration are unchanged. Upstream LICENSE is retained. This project-local dependency override avoids editing the shared Pub cache or adopting prerelease APIs.

Remove the override when a compatible stable upstream release replaces it, then repeat analysis, tests, and a signed release build.
