import '../../app/generalImports.dart';

abstract class DeleteHandymanState {}

class DeleteHandymanInitial extends DeleteHandymanState {}

class DeleteHandymanInProgress extends DeleteHandymanState {}

class DeleteHandymanSuccess extends DeleteHandymanState {
  DeleteHandymanSuccess({required this.id, required this.message});

  final String id;
  final String message;
}

class DeleteHandymanFailure extends DeleteHandymanState {
  DeleteHandymanFailure(this.errorMessage);

  final String errorMessage;
}

class DeleteHandymanCubit extends Cubit<DeleteHandymanState> {
  DeleteHandymanCubit() : super(DeleteHandymanInitial());

  final ManageHandymanRepository _repository = ManageHandymanRepository();

  Future<void> deleteHandyman(String id) async {
    try {
      emit(DeleteHandymanInProgress());
      final String message = await _repository.deleteHandyman(id);
      emit(DeleteHandymanSuccess(id: id, message: message));
    } catch (e) {
      emit(DeleteHandymanFailure(e.toString()));
    }
  }
}
