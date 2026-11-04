import '../../app/generalImports.dart';

abstract class VerifyBookingOTPState {}

class VerifyBookingOTPInitial extends VerifyBookingOTPState {}

class VerifyBookingOTPInProgress extends VerifyBookingOTPState {}

class VerifyBookingOTPSuccess extends VerifyBookingOTPState {
  final String message;

  VerifyBookingOTPSuccess(this.message);
}

class VerifyBookingOTPFailure extends VerifyBookingOTPState {
  final String errorMessage;

  VerifyBookingOTPFailure(this.errorMessage);
}

class VerifyBookingOTPCubit extends Cubit<VerifyBookingOTPState> {
  final BookingsRepository _bookingsRepository = BookingsRepository();

  VerifyBookingOTPCubit() : super(VerifyBookingOTPInitial());

  Future<void> verifyBookingOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      emit(VerifyBookingOTPInProgress());

      final Map<String, dynamic> response = await _bookingsRepository
          .verifyBookingOTP(userId: userId, otp: otp);

      if (response['error'] == true) {
        emit(
          VerifyBookingOTPFailure(
            response['message']?.toString() ?? 'invalidOTP',
          ),
        );
      } else {
        emit(
          VerifyBookingOTPSuccess(
            response['message']?.toString() ?? 'verified',
          ),
        );
      }
    } catch (e) {
      emit(VerifyBookingOTPFailure(e.toString()));
    }
  }

  void reset() {
    emit(VerifyBookingOTPInitial());
  }
}
