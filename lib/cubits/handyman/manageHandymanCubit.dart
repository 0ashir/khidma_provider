import '../../app/generalImports.dart';

abstract class ManageHandymanState {}

class ManageHandymanInitial extends ManageHandymanState {}

class ManageHandymanInProgress extends ManageHandymanState {}

class ManageHandymanSuccess extends ManageHandymanState {
  ManageHandymanSuccess({required this.message, required this.isEditing});

  final String message;
  final bool isEditing;
}

class ManageHandymanFailure extends ManageHandymanState {
  ManageHandymanFailure(this.errorMessage);

  final String errorMessage;
}

/// Handles create + update of a handyman (provider-side).
class ManageHandymanCubit extends Cubit<ManageHandymanState> {
  ManageHandymanCubit() : super(ManageHandymanInitial());

  final ManageHandymanRepository _repository = ManageHandymanRepository();

  Future<void> manageHandyman(CreateHandymanModel model) async {
    try {
      emit(ManageHandymanInProgress());
      final String message = model.isEditing
          ? await _repository.updateHandyman(model)
          : await _repository.storeHandyman(model);
      emit(ManageHandymanSuccess(message: message, isEditing: model.isEditing));
    } catch (e) {
      emit(ManageHandymanFailure(e.toString()));
    }
  }
}
