import '../../app/generalImports.dart';

abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpInProcess extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {}

class VerifyOtpFail extends VerifyOtpState {
  VerifyOtpFail(this.error);

  final dynamic error;
}

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpInitial());
  final AuthRepository authRepo = AuthRepository();

  Future<void> verifyOtpUsingFirebase({required String otp}) async {
    try {
      emit(VerifyOtpInProcess());

      await authRepo.verifyOTPUsingFirebase(code: otp);

      emit(VerifyOtpSuccess());
    } on FirebaseAuthException catch (error) {
      emit(VerifyOtpFail(error.code));
    }
  }

  Future<void> verifyOtpUsingSMSGateway({
    required String otp,
    String? countryCode,
    String? phoneNumberWithOutCountryCode,
    String? email,
    String? loginType,
  }) async {
    try {
      emit(VerifyOtpInProcess());
      final Map<String, dynamic> response = await authRepo
          .verifyOTPUsingSMSGateway(
            otp: otp,
            countryCode: countryCode,
            phoneNumberWithOutCountryCode: phoneNumberWithOutCountryCode,
            email: email,
            loginType: loginType,
          );
      if (response["error"]) {
        emit(VerifyOtpFail(response["message"]));
      } else {
        emit(VerifyOtpSuccess());
      }
    } on FirebaseAuthException catch (error) {
      emit(VerifyOtpFail(error.code));
    } catch (e) {
      emit(VerifyOtpFail(e));
    }
  }

  void setInitialState() {
    if (state is VerifyOtpFail) {
      emit(VerifyOtpInitial());
    }
    if (state is VerifyOtpSuccess) {
      emit(VerifyOtpInitial());
    }
  }
}
