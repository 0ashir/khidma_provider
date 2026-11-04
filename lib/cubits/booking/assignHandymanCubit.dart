import '../../app/generalImports.dart';

abstract class AssignHandymanState {}

class AssignHandymanInitial extends AssignHandymanState {}

class AssignHandymanInProgress extends AssignHandymanState {}

class AssignHandymanSuccess extends AssignHandymanState {
  final List<AssignedHandymanModel> newHandymen;
  AssignHandymanSuccess({required this.newHandymen});
}

class AssignHandymanFailure extends AssignHandymanState {
  final String errorMessage;
  AssignHandymanFailure(this.errorMessage);
}

class AssignHandymanCubit extends Cubit<AssignHandymanState> {
  AssignHandymanCubit() : super(AssignHandymanInitial());

  final BookingsRepository _repository = BookingsRepository();

  Future<void> assign({
    required String orderId,
    required List<String> handymanIds,
  }) async {
    try {
      emit(AssignHandymanInProgress());
      final List<AssignedHandymanModel> newHandymen =
          await _repository.assignHandyman(
        orderId: orderId,
        handymanIds: handymanIds,
      );
      emit(AssignHandymanSuccess(newHandymen: newHandymen));
    } catch (e) {
      emit(AssignHandymanFailure(e.toString()));
    }
  }
}
