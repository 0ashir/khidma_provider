# Provider refresh from the latest supplied Khidma source

Reviewed on 27 October 2026 against `F:/Codebases/khidma_plus/khidma_provider`,
after completing the customer review. This report supersedes the branding,
notification channel, version and validation details in the first migration report.

## Applied changes

- Replaced all five Android launcher densities and every referenced iOS launcher
  image with exact copies from the refreshed source.
  Backed up and removed 18 unassigned old Fixit icon PNGs from the iOS catalog.
- Replaced the old KHIDMA wordmark with the original provider **K+** artwork,
  including its orange accents, in splash, authentication screens and image
  placeholders. The provider artwork is distinct from the customer's blue-accent
  artwork. The shared widget supports PNG and SVG while preserving the PNG's
  original colours. Existing provider/handyman welcome text identifies the selected
  role. Removed the eight retired branding SVGs.
- Adaptive launchers and Android 12+ splash use the provider's original artwork;
  small notifications and themed launchers use the matching white K+ silhouette.
- Both apps now include Android 12+ dark-mode launch resources so night themes
  cannot bypass the branded splash. Native FCM notification accents use `#5465FF`.
- Copied the newly supplied normal notification sounds:
  `android/app/src/main/res/raw/notification_sound.mp3` and
  `ios/Runner/notification_sound.aiff`. The normal notification channel now uses
  **`fixit_notifications`**, matching the latest provider's native and Dart code.
  The existing template booking-alert channel retains the original `callsound.wav`.
  Both custom sounds are retained during Android resource shrinking and registered
  in Runner's resource phase for iOS. Existing Android channel preferences are
  preserved; remote iOS sound selection also depends on the backend payload.
- Debug APNs uses `development`; Release/Profile uses `production`. Removed
  template Xcode version overrides so native versions follow Flutter metadata.
- Prepared **8.2.0+103**, advancing beyond the refreshed provider's **8.1.0+102**
  and the previous new-template build **8.1.0+95**. Private store history still
  determines the final upload build number.

## Rechecked and already current

| Item | Result |
| --- | --- |
| App name | Khidma Provider |
| Android ID | `com.provider.khadamat` |
| iOS ID / team | `com.khidmaplus.provider` / `KD9Z8QMD3Y` |
| Firebase files | Exact matches to refreshed source, project `khidma-plus-52001` |
| Dart Firebase registration | Matches provider native app, distinct from customer registration |
| Release keystore and properties | Exact matches to refreshed source |
| Maps | Actual key from refreshed Dart/iOS source retained; legacy Android placeholder not copied |
| Google sign-in configuration and store destinations | Still match provider identity |
| Brand primary / font | `#5465FF` / Outfit, unchanged in refreshed source; bundled offline font retained |
| Splash background, introduction, native iOS launch assets | Already exact matches |
| Original booking sound | `callsound.wav` already matches |

## Validation

- **16 audit groups passed** against the latest source, including exact asset-path
  capitalization, native IDs, Firebase, original signing files, current icons,
  notification sounds, brand palette, font, store URLs and version ordering.
- **3 Flutter tests passed**: the unconfigured API guard and PNG/SVG rendering in
  both light/dark modes with the bundled font and fallback flag. The PNG logo
  retains its colours even when an icon tint is passed to the shared widget.
- Native XML/plist/entitlement/storyboard/SVG parsing and Android resource
  compilation passed. Updated light/dark fixture previews were visually reviewed.
- Full Flutter analysis: **no issues found**.
- Android debug APK rebuilt successfully. APK inspection confirms current logo,
  icon, splash background, adaptive artwork and both original native sounds are
  packaged, retired wordmark SVGs are absent, and the merged ID/version and
  generated Firebase registration agree.
  Artifact: `build/app/outputs/flutter-apk/app-debug.apk`.
  SHA-256: `FEC2B5EE35A52B4EFEDEF32FF903AB005314888356B370C4C4584CACC95B45FA`.
- The existing release AAB from the first migration predates this refresh; rebuild
  it from the refreshed source before preparing a release.

Pre-refresh files are saved under `../../.migration/provider-before-refresh`;
source hashes and copy details are recorded in
`../../.migration/provider-refreshed-source-inventory.json` and
`../../.migration/provider-refresh-copied-files.json`. The legacy source was read
only. This refresh does not resolve the separate Fixit/eDemand backend contracts,
server-side data migration, signing-fingerprint registration in the Firebase
console, device auth/notification tests, or iOS archive validation described in
`KHIDMA_PROVIDER_MIGRATION.md`.
