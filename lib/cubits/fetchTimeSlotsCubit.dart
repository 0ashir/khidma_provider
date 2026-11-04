import '../../app/generalImports.dart';

abstract class TimeSlotState {}

class TimeSlotInitial extends TimeSlotState {}

class TimeSlotFetchInProgress extends TimeSlotState {}

class TimeSlotFetchSuccess extends TimeSlotState {
  TimeSlotFetchSuccess({
    required this.isError,
    required this.message,
    required this.slotsData,
  });
  final List<TimeSlotModel> slotsData;
  final bool isError;
  final String message;
}

class TimeSlotFetchFailure extends TimeSlotState {
  TimeSlotFetchFailure({required this.errorMessage});
  final String errorMessage;
}

class TimeSlotCubit extends Cubit<TimeSlotState> {
  TimeSlotCubit() : super(TimeSlotInitial());
  final BookingsRepository _bookingsRepository = BookingsRepository();

  Future<void> getTimeslotDetails({
    required DateTime selectedDate,
    String? customJobRequestId,
  }) async {
    try {
      emit(TimeSlotFetchInProgress());

      final DataOutput<TimeSlotModel> value = await _bookingsRepository
          .getAllTimeSlots(
            selectedDate.toString().split(' ')[0],
            customJobRequestId!,
          );

      final bool isError = value.extraData!.data['error'] == true;
      final String message = value.extraData!.data['message'] ?? '';

      if (isError) {
        emit(TimeSlotFetchFailure(errorMessage: message));
      } else {
        emit(
          TimeSlotFetchSuccess(
            message: message,
            isError: false,
            slotsData: value.modelList,
          ),
        );
      }
    } catch (e) {
      emit(TimeSlotFetchFailure(errorMessage: e.toString()));
    }
  }
}
