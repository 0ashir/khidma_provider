import 'package:flutter/material.dart';
import '../../app/generalImports.dart';

class AppThemeCubit extends Cubit<ThemeState> {
  AppThemeCubit() : super(ThemeState(HiveRepository.getCurrentTheme()));

  void changeTheme(AppTheme appTheme) {
    HiveRepository.setCurrentTheme(appTheme);
    emit(ThemeState(appTheme));

    // Force status bar update after theme change
    _updateStatusBarStyle();
  }

  void toggleTheme() {
    if (state.appTheme == AppTheme.dark) {
      HiveRepository.setCurrentTheme(AppTheme.light);
      emit(ThemeState(AppTheme.light));
    } else {
      HiveRepository.setCurrentTheme(AppTheme.dark);
      emit(ThemeState(AppTheme.dark));
    }

    // Force status bar update after theme change
    _updateStatusBarStyle();
  }

  void _updateStatusBarStyle() {
    final isDark = state.appTheme == AppTheme.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
  }

  bool isDarkMode() {
    return state.appTheme == AppTheme.dark;
  }
}

class ThemeState {
  ThemeState(this.appTheme);
  final AppTheme appTheme;
}
