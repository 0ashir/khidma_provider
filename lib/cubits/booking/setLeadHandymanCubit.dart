import '../../app/generalImports.dart';

abstract class SetLeadHandymanState {}

class SetLeadHandymanInitial extends SetLeadHandymanState {}

class SetLeadHandymanInProgress extends SetLeadHandymanState {}

class SetLeadHandymanSuccess extends SetLeadHandymanState {
  final String handymanId;
  SetLeadHandymanSuccess({required this.handymanId});
}

class SetLeadHandymanFailure extends SetLeadHandymanState {
  final String errorMessage;
  SetLeadHandymanFailure(this.errorMessage);
}

class SetLeadHandymanCubit extends Cubit<SetLeadHandymanState> {
  SetLeadHandymanCubit() : super(SetLeadHandymanInitial());

  final BookingsRepository _repository = BookingsRepository();

  Future<void> setLead({
    required String orderId,
    required String handymanId,
  }) async {
    try {
      emit(SetLeadHandymanInProgress());
      await _repository.setLeadHandyman(
        orderId: orderId,
        handymanId: handymanId,
      );
      emit(SetLeadHandymanSuccess(handymanId: handymanId));
    } catch (e) {
      emit(SetLeadHandymanFailure(e.toString()));
    }
  }
}
