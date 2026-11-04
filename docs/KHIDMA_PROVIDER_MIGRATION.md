# Khidma Provider migration

The latest source refresh is documented in [KHIDMA_LATEST_SOURCE_RECHECK.md](KHIDMA_LATEST_SOURCE_RECHECK.md).
It supersedes the original branding, notification channel, version and validation results below.

The new provider project is `eDemand Provider/eDemand-Provider`. Branding and
native identity are migrated from `F:/Codebases/khidma_plus/khidma_provider`.
The old source and the customer project were not modified. The purchased provider
template is backed up at `../../.migration/provider-template-original`, excluding
generated caches and builds.

**Production rollout still requires a compatible backend and device testing.**

## Provider identity

| Setting | Value |
| --- | --- |
| Visible name | Khidma Provider |
| Android ID / namespace | `com.provider.khadamat` |
| iOS bundle ID | `com.khidmaplus.provider` |
| Apple team | `KD9Z8QMD3Y` |
| Firebase project | `khidma-plus-52001` |
| Firebase Android app | `1:526848120057:android:e2b0eb76acb9bd701ebe28` |
| Firebase iOS app | `1:526848120057:ios:6283f602c1c024ac1ebe28` |
| Main brand colour | `#5465FF`, in light and dark themes |
| Font | Outfit, bundled locally with its SIL OFL licence |
| Prepared version | `8.1.0+95` (old source: `8.0.5+94`; template: `5.2.0+58`) |
| Android listing | `https://play.google.com/store/apps/details?id=com.provider.khadamat` |
| iPhone listing | `https://apps.apple.com/app/id6755718687` |

The provider's iPhone listing was verified with Apple's bundle-ID lookup for
`com.khidmaplus.provider`; it is [Khidma Provider](https://apps.apple.com/us/app/khidma-provider/id6755718687).
The public iPhone listing reports version `8.0.9`, newer than the supplied old
source's `8.0.5`. The prepared `8.1.0` advances beyond both. The private uploaded
build-number history still requires store-console verification.
Customer cross-links retain the distinct customer Android ID and iPhone listing
`6755617892`. The template's internal Dart package name, `edemand_partner`, stays
unchanged because imports depend on it; it does not control store identity.

## Branding and assets

- All five Android launcher densities and all referenced iOS app-icon files match
  the original provider files byte for byte. Launcher regeneration references the
  original provider `app_icon.png`.
- The original provider splash background, native iOS launch storyboard and
  launch-image set are copied. The Flutter splash shows Khidma Provider over the
  original artwork. Android 12+ launch styling and adaptive launcher use Khidma
  colours and the original wordmark converted to vector paths.
- The original `introImage.png` replaces the template's login-selection photo.
  The image is contained without cropping; the lower gradient uses Khidma shades.
- All eight branding SVGs are replaced. Provider and handyman login logos retain
  their distinct role labels with native vector paths. Authentication-screen logo
  boxes now fit the full wordmark. The template's missing `loginlogo.svg` was added.
  The template's `emptyStateFeatureOff.svg` reference was corrected to the actual
  `emptystateFeatureOff.svg` capitalization so it works on Android. Every one of
  the 128 declared asset paths now resolves with exact case.
- The fallback English flag's missing `english-au.svg` reference now uses the
  bundled Australian flag. The shared image widget loads local SVG/raster assets
  from the asset bundle rather than attempting HTTP requests for asset paths.
- New template icons, SVG illustrations and animation brand accents use Khidma
  blue and matching shades. Flags, payment-provider logos, skin tones, neutrals,
  and meaningful green/red/orange status colours are preserved.
- Both default Material controls and custom widgets inherit Khidma's brand.
  Light/dark backgrounds and text colours come from the old provider palette.
  Outfit is bundled rather than fetched at runtime. Source and licence:
  [Google Fonts Outfit](https://github.com/google/fonts/tree/main/ofl/outfit).
- A monochrome K+ notification vector replaces the template's notification icon.
  Native FCM and local/chat notifications use it. The old ordinary-notification
  channel ID, `high_importance_channel`, is retained. The new template's separate
  custom-sound and chat channels remain available.
- The legacy `FLUTTER_NOTIFICATION_CLICK` intent filter is retained. Android app
  visibility queries and iOS URL-scheme queries cover the actual phone, email,
  SMS and browser launch checks; Android's legacy Custom Tabs service query is
  preserved too.
- The provider's original `callsound.wav` is copied for Android and included in
  the iOS app's Copy Bundle Resources phase. New custom-sound booking notifications
  reference this sound on both platforms. The legacy WAV is about 25.5 seconds.
  Android resource-shrinking rules explicitly retain the dynamically loaded WAV.

## Signing, Firebase and Maps

The provider's own `android/key.properties` and
`android/app/khidma-provider-keystore.jks` are copied unchanged. The key was opened
successfully; its alias is `khidma-provider-keystore`. Release builds use it and
fail if the signing files are missing instead of falling back to debug signing.
The exported public certificate is `upload_certificate.pem`. Signing passwords
were not printed. Signing files are explicitly ignored by Git.

Upload certificate SHA-256:

```text
DF:C0:33:2F:86:0D:59:8E:BC:CC:41:A8:C9:CC:77:8A:D4:73:75:48:D7:8A:B9:B1:B4:BA:3F:48:B7:CD:4F:32
```

Upload certificate SHA-1:

```text
DF:82:29:78:5C:41:2D:8F:F6:44:75:8E:57:C9:3E:6A:6C:CA:87:8E
```

The original Android and iOS Firebase files are unchanged. Dart options match the
provider registrations, including `com.khidmaplus.provider`, and startup explicitly
initializes that Firebase project. The background notification entrypoint is
registered early and initializes Firebase and notification channels in its isolate.
The provider's iOS client ID and reversed URL scheme are restored.

**Fingerprint distinction:** the upload SHA-1 above is not present among the two
Android OAuth certificate entries supplied in the original provider configuration.
Play App Signing may use a separate certificate. Verify/register the certificate
that actually signs each tested APK (debug, locally signed release, or Play) for
Firebase phone authentication and any relevant Google services. This task did not
change cloud-console fingerprints. Do not replace the provider key with the
customer key or a newly generated key.

The old provider Android manifest had a Maps placeholder, while the provider's
Dart configuration and iOS delegate contained a real key. That existing key is now
used in both new native platforms. Its restrictions, enabled APIs and quota require
device/cloud-console verification.

The iOS development team, bundle ID, Xcode display-name overrides and push
entitlements match the provider. Native iOS project syntax and the sound resource
reference were checked with an Xcode-project parser; archive signing and TestFlight
still require macOS/Xcode, provisioning and APNs credentials.

The template's global TLS-certificate bypass is removed, cleartext traffic is
disabled, and release builds no longer log request credentials through the cURL
interceptor. Optional template ads remain off by default
(`KHIDMA_ENABLE_ADS=false`); no AdMob identity existed in the supplied provider
source. Sample native AdMob IDs remain for the inactive SDK. Replace both native
application IDs and panel ad-unit IDs before deliberately enabling ads. Clarity
remains inactive because no existing project ID was supplied.

## Native dependency compatibility repair

The template combines Android Gradle Plugin 9 with the stable
`flutter_inappwebview_android` 1.1.3 implementation pulled in by its HTML editor.
That package calls `getDefaultProguardFile('proguard-android.txt')`, which AGP 9
rejects during project evaluation. The latest stable package was still 1.1.3 when
checked against the publisher's pub.dev package metadata.

A project-local override at `third_party/flutter_inappwebview_android` contains
the published runtime sources and licence. Only its two Gradle default-file calls
were changed to `proguard-android-optimize.txt`. All other 199 Android/Dart runtime
files were compared byte for byte to the published package cache and are unchanged.
The shared Pub cache was not modified. Provenance and the upstream archive hash
are in that directory's `KHIDMA_PATCH.md`. Vendor files are excluded from app lint
analysis but remain compiled as dependencies. Recheck the service HTML editor and
any webview workflows on a real Android device before rollout, and remove this
override once a suitable stable upstream release replaces it.

The first native compilation also exposed Kotlin's incremental-cache failure when
plugin sources are on `C:` and this project is on `F:` (`this and base files have
different roots`). Project-local `kotlin.incremental=false` avoids those invalid
relative-path caches. This changes compilation caching rather than runtime app
behaviour; incremental compilation can be reconsidered when the toolchain fixes
the issue or all sources share one drive.

Resolved AndroidX Lifecycle Compose 2.11.0 artifacts require compile SDK 37 and
AGP 9.1+. The provider therefore uses AGP 9.1.1 with compile SDK 37; minimum SDK
24 and target SDK 36 are unchanged. Gradle 9.5.1 is retained, and its downloaded
archive was verified against the official SHA-256. This matches the
[AGP 9.1 compatibility requirements](https://developer.android.com/build/releases/agp-9-1-0-release-notes).

## Backend work still required

The old provider uses Fixit's `https://admin.khidmaplus.com/api`. The new provider
expects eDemand's `/partner/api/v1/` contracts. Copying branding and Firebase does
not adapt those APIs or move business data.

| Area | Existing provider | New provider |
| --- | --- | --- |
| Profile/settings | `/self`, `/settings`, `/updateProfile` | `/get_user_info`, `/get_settings` |
| Bookings | `/booking`, `/booking/assign`, `/bookingStatus` | `/get_orders`, `/update_order_status`, handyman endpoints |
| Services/coverage | `/service`, `/providerServices`, `/provider-zone/update` | `/get_services`, `/manage_service`, country/region setup |
| Finance | `/wallet/provider`, `/provider/withdraw-request`, `/commissionHistory` | cash-collection, settlement and withdrawal APIs |
| Subscriptions | `/subscription/plans`, `/subscription/create` | `/get_subscription`, subscription-history and transaction APIs |
| Chat | Legacy Firestore/notification contracts | eDemand API chat history, messages and payloads |

The compatible eDemand backend and verified data migration were subsequently
deployed on 28 October 2026. The default `KHIDMA_BACKEND_ORIGIN` is now
`https://admin.khidmaplus.com`, serving provider and handyman requests under
`/partner/api/v1/`. An explicit build-time define can select another environment.
Empty or non-HTTPS origins still fail with a service-unavailable message.

Migration/testing must account for provider and staff IDs, provider/handyman role
mapping, passwords and Firebase UIDs, verification documents and approval status,
bank details, service/category/package IDs, country/zone coverage, working hours,
bookings and assignments, invoices, extra charges, proofs of service, custom
requests/bids, wallets and ledgers, commissions, cash collection, settlements,
withdrawals, subscriptions, tax/currency rules, reviews, chat history and files,
FCM tokens, notification payloads and account deletion/deactivation.

The old app uses SharedPreferences for its session; the new app uses Hive. Old
bearer tokens are not imported into a different backend. Existing storage is not
cleared. Session/preference migration and reauthentication need to follow the
chosen backend strategy. Maps, notification icons and Firebase configuration do
not by themselves preserve this business data.

Keep the customer, provider and backend versions compatible during rollout. Test
provider and handyman onboarding/login, staff assignments, subscription purchase,
withdrawals, new-booking notifications and background/terminated taps, customer
chat, live tracking while switching to navigation, and customer/provider booking
status synchronization. The template retains its foreground-only tracking policy;
it does not acquire new background-location or foreground-service permissions.
The original provider had no native universal-link declarations; none were invented.
Server-supplied legal/support content, payment credentials/webhooks, SMS, remote
languages and admin update settings still need configuration in the chosen backend.

## Validation

- `node tool/audit_khidma_provider.cjs`: 16 groups passed, including native/Firebase
  identity, signing-file hashes, original launcher and artwork hashes, all asset
  paths, offline font, roles, notification sound and store links.
- Android resources compiled with SDK 36's `aapt2`.
- All 145 XML/SVG documents parsed; all 431 Dart source files parsed with the
  formatter without writing to unrelated files.
- Dependencies resolved successfully; `pubspec.lock` records the selected versions.
- Three Flutter tests passed: API requests fail before network/storage access when
  unconfigured, and the generated role graphics/images/font render in light and
  dark themes with Khidma's Material primary colour.
- Native Xcode project parsed, and the legacy sound's group/file/resource links
  resolve correctly.
- `flutter analyze --no-pub` completed with no issues; the final theme/preview
  changes also passed targeted Dart analysis.
- `flutter build bundle --release --no-pub` succeeded, including the bundled
  Outfit font, licence and branded assets.
- Light/dark asset previews were rendered and visually inspected. The preview
  exposed and helped fix the template's inherited dark-text-on-dark-background
  issue. Optional preview generation is available with
  `flutter test --dart-define=KHIDMA_CAPTURE_PREVIEW=true`.
- `flutter build appbundle --release --no-pub` succeeded. The validation bundle
  is `build/app/outputs/bundle/release/app-release.aab` (113,852,337 bytes).
- The AAB's JAR signature verified, and its signing certificate matches the original
  provider upload key. Ten packaged branding/font/licence/fallback assets match
  final source bytes. The original notification WAV is present after resource
  shrinking. The generated release manifest and Firebase resources confirm
  `com.provider.khadamat`, `8.1.0+95`, min SDK 24, target SDK 36 and the provider's
  Firebase Android registration.

Tested with Flutter 3.44.4 / Dart 3.12.2, JDK 21, Gradle 9.5.1 and AGP 9.1.1.
The native build has nonblocking third-party deprecation, SDK XML and future Kotlin
migration warnings. The validation AAB deliberately has no business API origin;
configure a compatible backend and rebuild before distributing it to customers.

AAB SHA-256:

```text
0A31CD75FE236200C36895F82DF7AF4E01F5D70B7B42BB2D52F5385A311A7DBF
```

No app was deployed or published. Actual store highest uploaded build numbers must
be checked before choosing final release numbering. Source version ordering alone
cannot prove store-console acceptance.

After the backend is ready, build from this project with its compatible origin:

```powershell
node tool/audit_khidma_provider.cjs
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release --dart-define=KHIDMA_BACKEND_ORIGIN=https://admin.khidmaplus.com
```

As of 28 October 2026, the default backend is the live eDemand server at
`https://admin.khidmaplus.com`; provider and handyman requests use
`/partner/api/v1/`. A build without the define now uses this production default;
the define remains available for other environments. Earlier validation builds
remain unconfigured and must be replaced with a newly built app. iOS archive validation must
be repeated on macOS with the same backend define and existing signing identity.
