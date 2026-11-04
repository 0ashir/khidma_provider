import '../../app/generalImports.dart';

class VerifyPhoneNumberFromAPICubit
    extends Cubit<VerifyPhoneNumberFromAPIState> {
  VerifyPhoneNumberFromAPICubit({required this.authenticationRepository})
    : super(VerifyPhoneNumberFromAPIInitial());
  AuthRepository authenticationRepository;

  Future<void> verifyPhoneNumberFromAPI({
    String? mobileNumber,
    String? countryCode,
    String? email,
    String? loginType,
  }) async {
    emit(VerifyPhoneNumberFromAPIInProgress());

    try {
      final Map<String, dynamic> value = await authenticationRepository
          .verifyUserMobileNumberFromAPI(
            mobileNumber: mobileNumber,
            countryCode: countryCode,
            email: email,
            loginType: loginType,
          );
      emit(
        VerifyPhoneNumberFromAPISuccess(
          error: value['error'],
          message: value['message'],
          messageCode: value['messageCode'],
          authenticationMode: value['authenticationMode'],
        ),
      );
    } catch (e) {
      emit(VerifyPhoneNumberFromAPIFailure(errorMessage: e.toString()));
    }
  }
}

abstract class VerifyPhoneNumberFromAPIState {}

class VerifyPhoneNumberFromAPIInitial extends VerifyPhoneNumberFromAPIState {}

class VerifyPhoneNumberFromAPIInProgress extends VerifyPhoneNumberFromAPIState {
  VerifyPhoneNumberFromAPIInProgress();
}

class VerifyPhoneNumberFromAPISuccess extends VerifyPhoneNumberFromAPIState {
  VerifyPhoneNumberFromAPISuccess({
    required this.error,
    required this.message,
    required this.messageCode,
    required this.authenticationMode,
  });

  //if error is true then mobile number is already registered

  final bool error;
  final String messageCode;
  final String message;
  final String authenticationMode;
}

class VerifyPhoneNumberFromAPIFailure extends VerifyPhoneNumberFromAPIState {
  VerifyPhoneNumberFromAPIFailure({required this.errorMessage});

  final String errorMessage;
}
