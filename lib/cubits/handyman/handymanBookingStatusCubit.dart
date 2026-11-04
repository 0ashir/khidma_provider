import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanBookingsRepository.dart';

abstract class HandymanBookingStatusState {}

class HandymanBookingStatusInitial extends HandymanBookingStatusState {}

class HandymanBookingStatusInProgress extends HandymanBookingStatusState {}

class HandymanBookingStatusSuccess extends HandymanBookingStatusState {
  final HandymanStatusUpdateResult result;
  HandymanBookingStatusSuccess(this.result);
}

class HandymanBookingStatusFailure extends HandymanBookingStatusState {
  final String errorMessage;
  HandymanBookingStatusFailure(this.errorMessage);
}

class HandymanBookingStatusCubit extends Cubit<HandymanBookingStatusState> {
  HandymanBookingStatusCubit() : super(HandymanBookingStatusInitial());

  final HandymanBookingsRepository _repository = HandymanBookingsRepository();

  Future<void> updateStatus({
    required String bookingId,
    required String status,
    String? rejectedReason,
    String? otp,
    List<Map<String, dynamic>>? additionalCharges,
    List<Map<String, dynamic>>? workProof,
  }) async {
    if (state is HandymanBookingStatusInProgress) return;
    try {
      emit(HandymanBookingStatusInProgress());
      final result = await _repository.updateBookingStatus(
        orderId: bookingId,
        status: status,
        rejectedReason: rejectedReason,
        otp: otp,
        additionalCharges: additionalCharges,
        workProof: workProof,
      );
      if (result.error) {
        emit(HandymanBookingStatusFailure(result.message));
      } else {
        emit(HandymanBookingStatusSuccess(result));
      }
    } catch (e) {
      emit(HandymanBookingStatusFailure(e.toString()));
    }
  }

  void reset() => emit(HandymanBookingStatusInitial());
}
