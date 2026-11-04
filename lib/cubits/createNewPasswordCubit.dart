import '../../app/generalImports.dart';

abstract class CreateNewPasswordState {}

class CreateNewPasswordInitial extends CreateNewPasswordState {}

class CreateNewPasswordInProgress extends CreateNewPasswordState {}

class CreateNewPasswordSuccess extends CreateNewPasswordState {}

class CreateNewPasswordFailure extends CreateNewPasswordState {
  CreateNewPasswordFailure(this.errorMessage);

  final String errorMessage;
}

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future createNewPassword({
    String? countryCode,
    String? mobileNumber,
    String? email,
    required String newPassword,
    String? loginType,
  }) async {
    try {
      emit(CreateNewPasswordInProgress());

      final Map<String, dynamic> response = await _authRepository
          .createNewPassword(
            countryCode: countryCode,
            newPassword: newPassword,
            mobileNumber: mobileNumber,
            email: email,
            loginType: loginType,
          );
      if (response['error']) {
        emit(CreateNewPasswordFailure(response['message']));
      } else {
        emit(CreateNewPasswordSuccess());
      }
    } catch (e) {
      emit(CreateNewPasswordFailure(e.toString()));
    }
  }
}
