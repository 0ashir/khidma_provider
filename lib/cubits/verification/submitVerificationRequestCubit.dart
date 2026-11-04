import 'package:edemand_partner/app/generalImports.dart';

abstract class SubmitVerificationRequestState {}

class SubmitVerificationRequestInitial extends SubmitVerificationRequestState {}

class SubmitVerificationRequestInProgress
    extends SubmitVerificationRequestState {}

class SubmitVerificationRequestSuccess extends SubmitVerificationRequestState {
  SubmitVerificationRequestSuccess(this.message);
  final String message;
}

class SubmitVerificationRequestFail extends SubmitVerificationRequestState {
  SubmitVerificationRequestFail(this.error);
  final String error;
}

class SubmitVerificationRequestCubit
    extends Cubit<SubmitVerificationRequestState> {
  SubmitVerificationRequestCubit() : super(SubmitVerificationRequestInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> submit(Map<String, dynamic> values) async {
    try {
      emit(SubmitVerificationRequestInProgress());
      final String message = await _authRepository.submitVerificationRequest(
        values,
      );
      emit(SubmitVerificationRequestSuccess(message));
    } catch (e) {
      emit(SubmitVerificationRequestFail(e.toString()));
    }
  }
}
