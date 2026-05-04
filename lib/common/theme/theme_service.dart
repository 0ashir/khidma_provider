import '../../config.dart';
import 'app_theme.dart';

class ThemeService extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  final BuildContext? context;

  ThemeService(this.sharedPreferences, this.context);

  bool get isDarkMode => sharedPreferences.getBool(session.isDarkMode) ??
      MediaQuery.of(context!).platformBrightness == Brightness.dark
      ? true
      : false;

  int get themeIndex => sharedPreferences.getInt(session.themeIndex) ?? 2;

  ThemeMode get theme => themeIndex == 2
      ? MediaQuery.of(context!).platformBrightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light
      : isDarkMode
      ? ThemeMode.dark
      : ThemeMode.light;

  void switchTheme(isTheme, index) {
    sharedPreferences.setBool(session.isDarkMode, isTheme);
    sharedPreferences.setInt(
        session.themeIndex,
        index == 2
            ? 2
            : isDarkMode
            ? 0
            : 1);
    notifyListeners();
  }

  /// Switch theme and save to local storage
  AppTheme get appTheme => isDarkMode
      ? AppTheme.fromType(ThemeType.dark)
      : AppTheme.fromType(ThemeType.light);
}
