import 'package:edemand_partner/app/generalImports.dart';

abstract class LanguageListState {}

class LanguageListInitial extends LanguageListState {}

class GetLanguageListInProgress extends LanguageListState {}

class GetLanguageListSuccess extends LanguageListState {
  final List<AppLanguage> languages;
  final AppLanguage? defaultLanguage;

  GetLanguageListSuccess({
    required this.languages,
    required this.defaultLanguage,
  });
}

class GetLanguageListError extends LanguageListState {
  final dynamic error;

  GetLanguageListError(this.error);
}

class LanguageListCubit extends Cubit<LanguageListState> {
  LanguageListCubit() : super(LanguageListInitial());

  /// Creates a fallback English language using local en.json file
  AppLanguage _createFallbackEnglishLanguage() {
    return const AppLanguage(
      id: 'en_fallback',
      languageCode: 'en',
      languageName: 'English',
      imageURL: 'assets/images/flags/aus.png',
      isRtl: '0',
      isDefault: true,
    );
  }

  Future<void> getLanguageList() async {
    try {
      emit(GetLanguageListInProgress());
      final languageData = await SettingsRepository().getLanguageList();

      final languages = languageData.languageList ?? [];
      final defaultLanguage = languageData.defaultLanguage;

      // Check if language list is empty or null
      if (languages.isEmpty) {
        // Use fallback English language from local assets
        final fallbackEnglish = _createFallbackEnglishLanguage();
        emit(
          GetLanguageListSuccess(
            defaultLanguage: fallbackEnglish,
            languages: [fallbackEnglish],
          ),
        );
      } else {
        emit(
          GetLanguageListSuccess(
            defaultLanguage: defaultLanguage,
            languages: languages,
          ),
        );
      }
    } catch (e) {
      // On error, fallback to English language using local en.json
      final fallbackEnglish = _createFallbackEnglishLanguage();
      emit(
        GetLanguageListSuccess(
          defaultLanguage: fallbackEnglish,
          languages: [fallbackEnglish],
        ),
      );
    }
  }
}
