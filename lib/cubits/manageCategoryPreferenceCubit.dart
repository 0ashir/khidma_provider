import 'package:edemand_partner/app/generalImports.dart';

abstract class ManageCategoryPreferenceState {}

class ManageCategoryPreferenceInitial extends ManageCategoryPreferenceState {}

class ManageCategoryPreferenceInProgress
    extends ManageCategoryPreferenceState {}

class ManageCategoryPreferenceSuccess extends ManageCategoryPreferenceState {
  ManageCategoryPreferenceSuccess();
}

class ManageCategoryPreferenceFailure extends ManageCategoryPreferenceState {
  ManageCategoryPreferenceFailure(this.errorMessage);

  final String errorMessage;
}

class ManageCategoryPreferenceCubit
    extends Cubit<ManageCategoryPreferenceState> {
  ManageCategoryPreferenceCubit() : super(ManageCategoryPreferenceInitial());

  final CategoriesRepository _manageCategoryRepository = CategoriesRepository();

  Future ManageCategoryPreference({List<String>? categoryId}) async {
    try {
      emit(ManageCategoryPreferenceInProgress());

      final Map<String, dynamic> response = await _manageCategoryRepository
          .manageCategoryPreference(categoryId: categoryId);
      if (response['error']) {
        emit(ManageCategoryPreferenceFailure(response['message']));
      } else {
        emit(ManageCategoryPreferenceSuccess());
      }
    } catch (e) {
      emit(ManageCategoryPreferenceFailure(e.toString()));
    }
  }
}
