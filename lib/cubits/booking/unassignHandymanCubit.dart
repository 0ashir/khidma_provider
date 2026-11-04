import '../../app/generalImports.dart';

abstract class UnassignHandymanState {}

class UnassignHandymanInitial extends UnassignHandymanState {}

class UnassignHandymanInProgress extends UnassignHandymanState {
  final String handymanId;
  UnassignHandymanInProgress({required this.handymanId});
}

class UnassignHandymanSuccess extends UnassignHandymanState {
  final String handymanId;
  UnassignHandymanSuccess({required this.handymanId});
}

class UnassignHandymanFailure extends UnassignHandymanState {
  final String errorMessage;
  UnassignHandymanFailure(this.errorMessage);
}

class UnassignHandymanCubit extends Cubit<UnassignHandymanState> {
  UnassignHandymanCubit() : super(UnassignHandymanInitial());

  final BookingsRepository _repository = BookingsRepository();

  Future<void> unassign({
    required String orderId,
    required String handymanId,
  }) async {
    try {
      emit(UnassignHandymanInProgress(handymanId: handymanId));
      await _repository.unassignHandyman(
        orderId: orderId,
        handymanId: handymanId,
      );
      emit(UnassignHandymanSuccess(handymanId: handymanId));
    } catch (e) {
      emit(UnassignHandymanFailure(e.toString()));
    }
  }
}
