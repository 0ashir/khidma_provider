import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanBookingsRepository.dart';

abstract class HandymanBookingDetailState {}

class HandymanBookingDetailInitial extends HandymanBookingDetailState {}

class HandymanBookingDetailInProgress extends HandymanBookingDetailState {}

class HandymanBookingDetailSuccess extends HandymanBookingDetailState {
  final HandymanBookingDetail detail;
  HandymanBookingDetailSuccess(this.detail);
}

class HandymanBookingDetailFailure extends HandymanBookingDetailState {
  final String errorMessage;
  HandymanBookingDetailFailure(this.errorMessage);
}

class HandymanBookingDetailCubit extends Cubit<HandymanBookingDetailState> {
  HandymanBookingDetailCubit() : super(HandymanBookingDetailInitial());

  final HandymanBookingsRepository _repository = HandymanBookingsRepository();

  Future<void> fetchBookingDetail(String orderId) async {
    try {
      emit(HandymanBookingDetailInProgress());
      final detail = await _repository.fetchBookingDetails(orderId: orderId);
      emit(HandymanBookingDetailSuccess(detail));
    } catch (e) {
      emit(HandymanBookingDetailFailure(e.toString()));
    }
  }

  void reset() => emit(HandymanBookingDetailInitial());
}
