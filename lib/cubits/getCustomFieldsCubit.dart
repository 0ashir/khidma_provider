import 'package:edemand_partner/app/generalImports.dart';

abstract class GetCustomFieldsState {}

class GetCustomFieldsInitial extends GetCustomFieldsState {}

class GetCustomFieldsInProgress extends GetCustomFieldsState {}

class GetCustomFieldsSuccess extends GetCustomFieldsState {
  GetCustomFieldsSuccess({required this.fields, required this.savedValues});
  final List<CustomFieldModel> fields;

  /// Pre-filled values keyed by field_key
  final Map<String, dynamic> savedValues;
}

class GetCustomFieldsFail extends GetCustomFieldsState {
  GetCustomFieldsFail(this.error);
  final String error;
}

class GetCustomFieldsCubit extends Cubit<GetCustomFieldsState> {
  GetCustomFieldsCubit() : super(GetCustomFieldsInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> fetchCustomFields({String? fieldGroup}) async {
    try {
      emit(GetCustomFieldsInProgress());
      final CustomFieldsResponse result = await _authRepository
          .fetchCustomFields(fieldGroup: fieldGroup);
      emit(
        GetCustomFieldsSuccess(
          fields: result.fields,
          savedValues: result.savedValues,
        ),
      );
    } catch (e) {
      emit(GetCustomFieldsFail(e.toString()));
    }
  }
}
