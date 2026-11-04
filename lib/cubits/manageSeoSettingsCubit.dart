import '../app/generalImports.dart';

abstract class ManageSeoSettingsState {}

class ManageSeoSettingsInitial extends ManageSeoSettingsState {}

class ManageSeoSettingsInProgress extends ManageSeoSettingsState {}

class ManageSeoSettingsSuccess extends ManageSeoSettingsState {
  final String message;
  ManageSeoSettingsSuccess(this.message);
}

class ManageSeoSettingsFailure extends ManageSeoSettingsState {
  final String errorMessage;
  ManageSeoSettingsFailure(this.errorMessage);
}

class ManageSeoSettingsCubit extends Cubit<ManageSeoSettingsState> {
  ManageSeoSettingsCubit() : super(ManageSeoSettingsInitial());

  final SeoSettingsRepository _repository = SeoSettingsRepository();

  Future<void> manageSeoSettings({
    required Map<String, dynamic> parameters,
  }) async {
    try {
      emit(ManageSeoSettingsInProgress());
      await _repository.manageSeoSettings(parameters: parameters);
      emit(ManageSeoSettingsSuccess('Data updated successfully'));
    } catch (e) {
      emit(ManageSeoSettingsFailure(e.toString()));
    }
  }
}
