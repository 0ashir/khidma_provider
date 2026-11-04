import '../../app/generalImports.dart';

abstract class SendVerificationCodeState {}

class SendVerificationCodeInitialState extends SendVerificationCodeState {}

class SendVerificationCodeInProgressState extends SendVerificationCodeState {}

class SendVerificationCodeSuccessState extends SendVerificationCodeState {
  String authenticationMode;

  SendVerificationCodeSuccessState({required this.authenticationMode});
}

class SendVerificationCodeFailureState extends SendVerificationCodeState {
  SendVerificationCodeFailureState(this.error);

  final dynamic error;
}

class SendVerificationCodeCubit extends Cubit<SendVerificationCodeState> {
  SendVerificationCodeCubit() : super(SendVerificationCodeInitialState());
  final AuthRepository authRepo = AuthRepository();

  Future<void> sendVerificationCodeUsingFirebase({
    required final String phoneNumber,
    required final String phoneNumberWithCountryCode,
    required final String countryCode,
  }) async {
    try {
      emit(SendVerificationCodeInProgressState());

      // Ensure phone number is in E.164 format
      String formattedPhoneNumber = phoneNumberWithCountryCode;
      if (!formattedPhoneNumber.startsWith('+')) {
        formattedPhoneNumber = '+$formattedPhoneNumber';
      }

      await authRepo.verifyPhoneNumber(
        formattedPhoneNumber,
        onError: (error) {
          emit(SendVerificationCodeFailureState(error.code));
        },
        onCodeSent: () {
          emit(
            SendVerificationCodeSuccessState(authenticationMode: "firebase"),
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      emit(SendVerificationCodeFailureState(error.code));
    } catch (error) {
      emit(SendVerificationCodeFailureState(error));
    }
  }

  Future<void> sendVerificationCodeUsingSMSGateway({
    String? phoneNumberWithoutCountryCode,
    String? phoneNumberWithCountryCode,
    String? countryCode,
    String? email,
    String? loginType,
  }) async {
    try {
      emit(SendVerificationCodeInProgressState());

      final Map<String, dynamic> response = await authRepo
          .sendVerificationCodeUsingSMSGateway(
            phoneNumberWithoutCountryCode: phoneNumberWithoutCountryCode,
            countryCode: countryCode,
            email: email,
            loginType: loginType,
          );

      if (response['error']) {
        emit(SendVerificationCodeFailureState(response['message']));
      } else {
        emit(
          SendVerificationCodeSuccessState(authenticationMode: "sms_gateway"),
        );
      }
    } catch (error) {
      emit(SendVerificationCodeFailureState(error));
    }
  }

  void setInitialState() {
    if (state is SendVerificationCodeSuccessState) {
      emit(SendVerificationCodeInitialState());
    }
  }
}
