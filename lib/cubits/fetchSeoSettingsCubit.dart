import '../app/generalImports.dart';

abstract class FetchSeoSettingsState {}

class FetchSeoSettingsInitial extends FetchSeoSettingsState {}

class FetchSeoSettingsInProgress extends FetchSeoSettingsState {}

class FetchSeoSettingsSuccess extends FetchSeoSettingsState {
  final SeoSettingsData data;
  FetchSeoSettingsSuccess(this.data);
}

class FetchSeoSettingsFailure extends FetchSeoSettingsState {
  final String errorMessage;
  FetchSeoSettingsFailure(this.errorMessage);
}

class FetchSeoSettingsCubit extends Cubit<FetchSeoSettingsState> {
  FetchSeoSettingsCubit() : super(FetchSeoSettingsInitial());

  final SeoSettingsRepository _repository = SeoSettingsRepository();

  Future<void> fetchSeoSettings() async {
    try {
      emit(FetchSeoSettingsInProgress());
      final data = await _repository.getSeoSettings();
      emit(FetchSeoSettingsSuccess(data));
    } catch (e) {
      emit(FetchSeoSettingsFailure(e.toString()));
    }
  }
}
