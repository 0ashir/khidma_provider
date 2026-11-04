import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/app/registerBlocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show LicenseRegistry, LicenseEntryWithLineBreaks;
import 'package:flutter_localizations/flutter_localizations.dart';

/// Starts Flutter immediately so the native splash is dismissed on the first
/// frame; all startup work runs behind [BrandSplash] in [_AppBootstrap].
void initApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _AppBootstrap());
}

Future<void> _initServices() async {
  //locked in portrait mode only
  final orientation = SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);

  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Outfit',
    ], await rootBundle.loadString('assets/fonts/OFL-Outfit.txt'));
  });

  await Hive.initFlutter();
  await HiveRepository.init();
  await AppLocalization.preloadBundled();
  await orientation;
}

/// Shows [BrandSplash] while [_initServices] runs, then mounts the real app
/// (blocs read Hive on creation, so they are only created afterwards).
class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap();

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initServices().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Directionality(
        textDirection: TextDirection.ltr,
        child: BrandSplash(),
      );
    }
    return MultiBlocProvider(providers: registerBlocks(), child: const App());
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ClarityService.logAction(ClarityActions.appLaunch);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ClarityService.logAction(ClarityActions.appResume);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        ClarityService.logAction(ClarityActions.appBackground);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme currentTheme = context.watch<AppThemeCubit>().state.appTheme;

    return BlocBuilder<LanguageDataCubit, LanguageDataState>(
      builder: (context, languageState) {
        return BlocBuilder<AppThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MicrosoftClarityInitializer(
                projectId: microsoftClarityProjectId,
                child: MaterialApp(
                  title: appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: UiUtils.rootNavigatorKey,
                  onGenerateRoute: Routes.onGenerateRouted,
                  initialRoute: Routes.splash,
                  theme: appThemeData[currentTheme],
                  navigatorObservers: [clarityRouteObserver],
                  builder: (context, child) {
                    TextDirection direction = TextDirection.ltr;

                    if (languageState is GetLanguageDataSuccess) {
                      direction = languageState.currentLanguage.isRtl == "1"
                          ? TextDirection.rtl
                          : TextDirection.ltr;
                    }
                    return Directionality(
                      textDirection: direction,
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: UiUtils.getSystemUiOverlayStyle(
                          context: context,
                          appTheme: themeState.appTheme,
                        ),
                        child: ColoredBox(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: SafeArea(
                            top: false,
                            bottom: Platform.isAndroid,
                            child: child!,
                          ),
                        ),
                      ),
                    );
                  },
                  localizationsDelegates: const [
                    AppLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: loadLocalLanguageIfFail(languageState),
                ),
              ),
            );
          },
        );
      },
    );
  }

  dynamic loadLocalLanguageIfFail(LanguageDataState state) {
    if (state is GetLanguageDataSuccess) {
      return Locale(state.currentLanguage.languageCode);
    } else if (state is GetLanguageDataError) {
      return const Locale("en");
    }
  }
}
