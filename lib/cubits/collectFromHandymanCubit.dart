import '../../app/generalImports.dart';

abstract class CollectFromHandymanState {}

class CollectFromHandymanInitial extends CollectFromHandymanState {}

class CollectFromHandymanInProgress extends CollectFromHandymanState {}

class CollectFromHandymanSuccess extends CollectFromHandymanState {
  final String message;
  CollectFromHandymanSuccess(this.message);
}

class CollectFromHandymanFailure extends CollectFromHandymanState {
  final String errorMessage;
  CollectFromHandymanFailure(this.errorMessage);
}

class CollectFromHandymanCubit extends Cubit<CollectFromHandymanState> {
  CollectFromHandymanCubit() : super(CollectFromHandymanInitial());

  final CommissionAmountRepository _repository = CommissionAmountRepository();

  Future<void> collect({
    required String handymanId,
    required String amount,
    String? message,
  }) async {
    try {
      emit(CollectFromHandymanInProgress());
      final Map<String, dynamic> result = await _repository.collectFromHandyman(
        handymanId: handymanId,
        amount: amount,
        message: message,
      );
      if (result['error'] == true) {
        emit(CollectFromHandymanFailure(
          result['message']?.toString() ?? 'errorText',
        ));
      } else {
        emit(CollectFromHandymanSuccess(
          result['message']?.toString() ?? '',
        ));
      }
    } catch (e) {
      emit(CollectFromHandymanFailure(e.toString()));
    }
  }

  void reset() => emit(CollectFromHandymanInitial());
}
