import '../../app/generalImports.dart';

abstract class HandymanSignInState {}

class HandymanSignInInitial extends HandymanSignInState {}

class HandymanSignInInProgress extends HandymanSignInState {}

class HandymanSignInSuccess extends HandymanSignInState {
  HandymanSignInSuccess({
    required this.handyman,
    required this.error,
    required this.message,
  });

  final HandymanLoginModel handyman;
  final bool error;
  final String message;
}

class HandymanSignInFailure extends HandymanSignInState {
  HandymanSignInFailure(this.errorMessage);

  final String errorMessage;
}

/// Handles handyman login (user_type=handyman). Kept separate from
/// [SignInCubit] so the provider login flow stays untouched.
class HandymanSignInCubit extends Cubit<HandymanSignInState> {
  HandymanSignInCubit() : super(HandymanSignInInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> signIn({
    required String phoneNumber,
    required String password,
    String? countryCode,
    String? fcmId,
  }) async {
    try {
      emit(HandymanSignInInProgress());

      final Map<String, dynamic> response = await _authRepository.loginHandyman(
        phoneNumber: phoneNumber,
        password: password,
        countryCode: countryCode,
        fcmId: fcmId,
      );

      if (response['handymanDetails'] != null) {
        emit(
          HandymanSignInSuccess(
            handyman: response['handymanDetails'] as HandymanLoginModel,
            error: response['error'] ?? false,
            message: response['message'] ?? '',
          ),
        );
      } else {
        emit(HandymanSignInFailure(response['message'] ?? ''));
      }
    } catch (e) {
      emit(HandymanSignInFailure(e.toString()));
    }
  }

  void setInitial() {
    emit(HandymanSignInInitial());
  }
}
