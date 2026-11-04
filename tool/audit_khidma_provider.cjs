// node tool/audit_khidma_provider.cjs [path-to-legacy-provider]
// Compare identity and assets to the live provider's source without printing
// signing passwords, API tokens, or private-key contents.
const fs=require('node:fs');
const path=require('node:path');
const crypto=require('node:crypto');
const assert=require('node:assert/strict');
const root=path.resolve(__dirname,'..');
const old=process.argv[2] || 'F:/Codebases/khidma_plus/khidma_provider';
const read=file=>fs.readFileSync(path.join(root,file),'utf8');
const digest=file=>crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
const equal=(source,target=source)=>assert.equal(digest(path.join(root,target)),digest(path.join(old,source)),target);
const plist=(text,key)=>text.match(new RegExp(`<key>${key}</key>\\s*<string>([^<]+)</string>`))?.[1];
let groups=0;
function check(label,fn){fn();groups++;console.log('PASS '+label);}
const gradle=read('android/app/build.gradle');
const manifest=read('android/app/src/main/AndroidManifest.xml');
const pbx=read('ios/Runner.xcodeproj/project.pbxproj');
const ios=read('ios/Runner/Info.plist');
const firebase=JSON.parse(read('android/app/google-services.json'));
const client=firebase.client.find(c=>c.client_info.android_client_info.package_name==='com.provider.khadamat');
const options=read('lib/firebase_options.dart');

function paddedAsset(file) {
  const manifest = JSON.parse(read('tool/icon-padding-manifest.json'));
  assert.equal(digest(path.join(root, file)), manifest.files[file], file);
  assert.equal(digest(path.join(root, manifest.source)), manifest.sourceSha256);
}
check('Provider Android identity and Kotlin entrypoint',()=>{
 assert.match(gradle,/namespace "com\.provider\.khadamat"/);
 assert.match(gradle,/applicationId "com\.provider\.khadamat"/);
 assert.match(read('android/app/src/main/kotlin/com/provider/khadamat/MainActivity.kt'),/package com\.provider\.khadamat/);
 assert.match(manifest,/android:label="Khidma Provider"/);
 for(const scheme of ['tel','mailto','sms','https','http'])assert.ok(manifest.includes(`android:scheme="${scheme}"`),scheme);
 assert.match(gradle,/minSdkVersion 24/);
 assert.match(gradle,/targetSdkVersion 36/);
});
check('Provider iOS identity, display names and Apple team',()=>{
 assert.equal((pbx.match(/PRODUCT_BUNDLE_IDENTIFIER = com\.khidmaplus\.provider;/g)||[]).length,3);
 assert.equal((pbx.match(/DEVELOPMENT_TEAM = KD9Z8QMD3Y;/g)||[]).length,3);
 assert.equal((pbx.match(/INFOPLIST_KEY_CFBundleDisplayName = "Khidma Provider";/g)||[]).length,3);
 assert.equal(plist(ios,'CFBundleDisplayName'),'Khidma Provider');
 assert.match(read('ios/Runner/Runner.entitlements'), /\$\(KHIDMA_APS_ENVIRONMENT\)/);
 assert.equal((pbx.match(/KHIDMA_APS_ENVIRONMENT = development;/g)||[]).length,1);
 assert.equal((pbx.match(/KHIDMA_APS_ENVIRONMENT = production;/g)||[]).length,2);
 assert.doesNotMatch(pbx,/FLUTTER_BUILD_NAME = 5\.1\.0/);
});
check('Firebase registration matches the provider, not the customer',()=>{
 assert.ok(client);
 assert.equal(firebase.project_info.project_id,'khidma-plus-52001');
 assert.ok(options.includes(`appId: '${client.client_info.mobilesdk_app_id}'`));
 assert.ok(options.includes(`apiKey: '${client.api_key[0].current_key}'`));
 equal('android/app/google-services.json');
 equal('ios/Runner/GoogleService-Info.plist');
 const config=read('ios/Runner/GoogleService-Info.plist');
 assert.equal(plist(config,'BUNDLE_ID'),'com.khidmaplus.provider');
 assert.ok(options.includes(`appId: '${plist(config,'GOOGLE_APP_ID')}'`));
 assert.ok(ios.includes(plist(config,'REVERSED_CLIENT_ID')));
 assert.equal(plist(ios,'GIDClientID'),plist(config,'CLIENT_ID'));
});
check('Original provider keystore and properties preserved',()=>{
 equal('android/key.properties');
 equal('android/app/khidma-provider-keystore.jks');
 assert.match(read('android/key.properties'),/storeFile=khidma-provider-keystore\.jks/);
 assert.match(gradle,/signingConfig signingConfigs\.release/);
 assert.doesNotMatch(gradle,/signingConfig signingConfigs\.debug/);
 assert.match(read('.gitignore'),/\/android\/key\.properties/);
 assert.match(read('.gitignore'),/\*\.jks/);
 assert.ok(fs.existsSync(path.join(root,'upload_certificate.pem')));
});
check('Padded Android launcher icons at all densities',()=>{
 for(const density of ['mdpi','hdpi','xhdpi','xxhdpi','xxxhdpi'])paddedAsset(`android/app/src/main/res/mipmap-${density}/ic_launcher.png`);
 // The 2026-10-28 artwork replaced the live app's icon; pin it via the manifest.
 const iconSource=JSON.parse(read('tool/icon-padding-manifest.json')).sourceSha256;
 assert.equal(digest(path.join(root,'assets/images/svg/branding/app_icon.png')),iconSource,'assets/images/svg/branding/app_icon.png');
 assert.equal(digest(path.join(root,'android/app/src/main/res/drawable-nodpi/khidma_launcher_artwork.png')),iconSource,'khidma_launcher_artwork.png');
 assert.match(read('android/app/src/main/res/drawable/khidma_launcher_foreground.xml'), /@drawable\/khidma_launcher_artwork/);
 assert.match(read('android/app/src/main/res/values-night-v31/styles.xml'), /windowSplashScreenAnimatedIcon/);
 assert.match(manifest,/default_notification_color/);
});
check('Padded iOS launcher icons and preserved native launch artwork',()=>{
 for(const folder of ['AppIcon.appiconset','LaunchImage.imageset']){
  const base=`ios/Runner/Assets.xcassets/${folder}`;
  equal(`${base}/Contents.json`);
  for(const image of JSON.parse(read(`${base}/Contents.json`)).images)if(image.filename){if(folder==='AppIcon.appiconset')paddedAsset(`${base}/${image.filename}`);else equal(`${base}/${image.filename}`);}
  const assigned=new Set(JSON.parse(read(`${base}/Contents.json`)).images.map(image=>image.filename));
  assert.ok(fs.readdirSync(path.join(root,base)).filter(name=>name.endsWith('.png')).every(name=>assigned.has(name)),`Unassigned legacy image remains in ${folder}`);
 }
 equal('ios/Runner/Base.lproj/LaunchScreen.storyboard');
});
check('Provider splash and introduction images reused',()=>{
 equal('assets/images/splashBg.png','assets/images/svg/branding/splash_background.png');
 equal('assets/images/introImage.png','assets/images/svg/login_type_image.png');
 assert.match(read('lib/ui/screens/auth/loginTypeSelectionScreen.dart'),/fit: BoxFit\.contain/);
});
check('Declared and literal asset paths exist with exact capitalization',()=>{
 const constants=new Map();
 const exactPaths=new Set();
 function inventory(dir){for(const item of fs.readdirSync(path.join(root,dir),{withFileTypes:true})){const relative=path.posix.join(dir,item.name);exactPaths.add(relative);if(item.isDirectory())inventory(relative)}}
 inventory('assets');
 for(const match of read('lib/app/appAssets.dart').matchAll(/^\s*static const String\s+(\w+)\s*=\s*"([^"]*)";/gm)){
  const value=match[2].replace(/\$(\w+)/g,(_,name)=>{assert.ok(constants.has(name),name);return constants.get(name)});
  constants.set(match[1],value);
  assert.ok(fs.existsSync(path.join(root,value)),`Missing ${value}`);
  assert.ok(exactPaths.has(value),`Asset capitalization mismatch: ${value}`);
 }
 assert.equal(constants.size,128);
 function checkLiterals(dir){for(const item of fs.readdirSync(path.join(root,dir),{withFileTypes:true})){const relative=path.join(dir,item.name);if(item.isDirectory()){checkLiterals(relative);continue;}if(!relative.endsWith('.dart'))continue;const code=read(relative).split(/\r?\n/).filter(line=>!line.trim().startsWith('//')).join('\n');for(const match of code.matchAll(/['"](assets\/[^'"\n]+)['"]/g)){const value=match[1];if(value.includes('$'))continue;assert.ok(exactPaths.has(value),`Literal asset path is missing or incorrectly capitalized in ${relative}: ${value}`);}}}
 checkLiterals('lib');
});
check('Latest original K+ logo is used across roles and placeholders',()=>{
 equal('assets/images/appLogo.png','assets/images/svg/branding/app_logo.png');
 assert.doesNotMatch(read('lib/app/appAssets.dart'), /_brandingAssetsPath\/[^"\n]*\.svg/);
 assert.match(read('lib/ui/widgets/customSvgPicture.dart'), /Image\.asset/);
 for(const screen of ['loginScreen','sendOTPScreen','createNewPassword','verifyOTPScreen'])assert.match(read(`lib/ui/screens/auth/${screen}.dart`),/boxFit: BoxFit\.contain/);
});
check('Live brand palette and bundled offline Outfit font configured',()=>{
 assert.match(read('lib/utils/colors.dart'),/lightAccentColor = const Color\(0xff5465FF\)/);
 assert.match(read('lib/utils/colors.dart'),/darkAccentColor = const Color\(0xff5465FF\)/);
 assert.match(read('lib/app/appTheme.dart'),/fontFamily: 'Outfit'/);
 const font=fs.readFileSync(path.join(root,'assets/fonts/Outfit-Variable.ttf'));
 assert.equal(font.readUInt32BE(0),0x00010000);
 assert.match(read('assets/fonts/OFL-Outfit.txt'),/SIL OPEN FONT LICENSE/);
 assert.match(read('pubspec.yaml'),/family: Outfit/);
});
check('Notification icon, early initialization and legacy channel configured',()=>{
 assert.match(manifest,/@drawable\/ic_stat_khidma/);
 assert.match(manifest,/fixit_notifications/);
 assert.match(manifest,/FLUTTER_NOTIFICATION_CLICK/);
 assert.match(manifest,/android.permission.POST_NOTIFICATIONS/);
 assert.match(read('lib/utils/Notification/awsomeNotification.dart'),/resource:\/\/drawable\/ic_stat_khidma/);
 assert.match(read('lib/utils/Notification/awsomeNotification.dart'),/fixit_notifications/);
 assert.match(read('lib/app/app.dart'),/FirebaseMessaging.onBackgroundMessage\(onBackgroundMessageHandler\)/);
 assert.match(read('lib/utils/Notification/notificationService.dart'),/Firebase.initializeApp/);
});
check('Original notification sound copied for Android and iOS',()=>{
 equal('android/app/src/main/res/raw/callsound.wav');
 equal('android/app/src/main/res/raw/callsound.wav','ios/Runner/callsound.wav');
 assert.match(read('lib/utils/Notification/awsomeNotification.dart'),/resource:\/\/raw\/callsound/);
 assert.match(read('lib/utils/Notification/awsomeNotification.dart'),/callsound\.wav/);
 assert.match(pbx,/callsound\.wav in Resources/);
 assert.match(read('android/app/src/main/res/raw/keep.xml'),/@raw\/callsound/);
 equal('android/app/src/main/res/raw/notification_sound.mp3');
 equal('ios/Runner/notification_sound.aiff');
 assert.match(read('lib/utils/Notification/awsomeNotification.dart'),/resource:\/\/raw\/notification_sound/);
 assert.match(read('lib/utils/Notification/awsomeNotification.dart'),/notification_sound\.aiff/);
 assert.match(pbx,/notification_sound\.aiff in Resources/);
 assert.match(read('android/app/src/main/res/raw/keep.xml'),/@raw\/notification_sound/);
});
check('Provider store destinations are distinct from the customer',()=>{
 const constants=read('lib/utils/constant.dart');
 assert.match(constants,/details\?id=com\.provider\.khadamat/);
 assert.match(constants,/id6755718687/);
 assert.match(constants,/details\?id=com\.services\.khadamat/);
 assert.match(constants,/id6755617892/);
});
check('Unsafe TLS and vendor integration placeholders removed',()=>{
 for(const source of [manifest,ios,pbx,read('lib/utils/constant.dart')])assert.doesNotMatch(source,/wrteam\.edemand|ADD_YOUR_|PLACE_YOUR_|811828125363/);
 assert.doesNotMatch(read('lib/app/app.dart'),/badCertificateCallback|MyHttpOverrides/);
 assert.match(read('lib/utils/constant.dart'),/showCompanyLogoOnSplash = false/);
 assert.match(read('lib/utils/api/apiClient.dart'),/backend.scheme != 'https'/);
});
check('Version advances over the supplied live source and template',()=>{
 const version=text=>text.match(/^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)/m).slice(1).map(Number);
 const next=version(read('pubspec.yaml'));const previous=version(fs.readFileSync(path.join(old,'pubspec.yaml'),'utf8'));
 assert.ok(next[0]>previous[0]||next[0]===previous[0]&&next[1]>previous[1]);
 assert.ok(next[3]>Math.max(previous[3],58));
});
check('AGP 9 webview compatibility fix is project-local and licensed',()=>{
 assert.match(read('pubspec.yaml'),/path: third_party\/flutter_inappwebview_android/);
 const plugin='third_party/flutter_inappwebview_android/';
 const config=read(plugin+'android/build.gradle');
 assert.doesNotMatch(config,/getDefaultProguardFile\('proguard-android\.txt'\)/);
 assert.equal((config.match(/getDefaultProguardFile\('proguard-android-optimize\.txt'\)/g)||[]).length,2);
 assert.ok(read(plugin+'LICENSE').length>100);
 assert.match(read(plugin+'KHIDMA_PATCH.md'),/1\.1\.3/);
 assert.match(read('android/gradle.properties'),/^kotlin\.incremental=false$/m);
});
console.log(`\n${groups} provider audit groups passed. Device/backend and store-console validation remain separate.`);
const uploadSha1='df8229785c412d8ff644758e57c93e6a6cca878e';
if(!client.oauth_client.some(c=>c.client_type===1&&c.android_info.certificate_hash.toLowerCase()===uploadSha1))console.log('NOTE Provider upload SHA-1 is absent from the supplied OAuth entries. Check the actual APK/Play signing certificate for device authentication.');
