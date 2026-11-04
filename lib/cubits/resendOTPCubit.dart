import '../../app/generalImports.dart';

abstract class ResendOtpState {}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpInProcess extends ResendOtpState {}

class ResendOtpSuccess extends ResendOtpState {}

class ResendOtpFail extends ResendOtpState {
  ResendOtpFail(this.error);

  final dynamic error;
}

class ResendOtpCubit extends Cubit<ResendOtpState> {
  ResendOtpCubit() : super(ResendOtpInitial());
  final AuthRepository authRepo = AuthRepository();

  Future<void> resendOtpUsingFirebase({
    required String phoneNumber,
    required String phoneNumberWithoutCountryCode,
    required String countryCode,
    final VoidCallback? onOtpSent,
  }) async {
    try {
      emit(ResendOtpInProcess());

      await authRepo.verifyPhoneNumber(
        phoneNumber,
        onError: (err) {
          emit(ResendOtpFail(err));
        },
        onCodeSent: () {
          onOtpSent?.call();
          emit(ResendOtpSuccess());
        },
      );
    } on FirebaseAuthException catch (error) {
      final String errorMessage = _getFirebaseErrorMessage(error);
      emit(ResendOtpFail(errorMessage));
    } catch (error) {
      emit(ResendOtpFail('Failed to resend OTP. Please try again.'));
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-phone-number':
        return 'invalidPhoneNumber'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'too-many-requests':
        return 'tooManyRequests'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'quota-exceeded':
        return 'smsQuotaExceeded'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'network-request-failed':
        return 'networkError'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'invalid-verification-code':
        return 'invalidVerificationCode'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'session-expired':
        return 'sessionExpired'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'missing-phone-number':
        return 'phoneNumberRequired'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'invalid-verification-id':
        return 'invalidVerificationId'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'credential-already-in-use':
        return 'phoneNumberAlreadyInUse'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'user-disabled':
        return 'accountDisabled'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      case 'operation-not-allowed':
        return 'operationNotAllowed'.translate(
          context: UiUtils.rootNavigatorKey.currentContext!,
        );
      default:
        return error.message?.isNotEmpty == true
            ? error.message!
            : 'verificationFailed'.translate(
                context: UiUtils.rootNavigatorKey.currentContext!,
              );
    }
  }

  Future<void> resendOtpUsingSMSGateway({
    String? phoneNumber,
    String? phoneNumberWithoutCountryCode,
    String? countryCode,
    String? email,
    String? loginType,
    final VoidCallback? onOtpSent,
  }) async {
    try {
      emit(ResendOtpInProcess());

      final Map<String, dynamic> response = await authRepo
          .sendVerificationCodeUsingSMSGateway(
            phoneNumberWithoutCountryCode: phoneNumberWithoutCountryCode,
            countryCode: countryCode,
            email: email,
            loginType: loginType,
          );
      if (response["error"]) {
        emit(ResendOtpFail(response["message"]));
      } else {
        onOtpSent?.call();
        emit(ResendOtpSuccess());
      }
    } catch (error) {
      emit(ResendOtpFail(error.toString()));
    }
  }

  void setDefaultOtpState() {
    emit(ResendOtpInitial());
  }
}
