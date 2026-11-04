import '../../app/generalImports.dart';

enum HandymanToggleKind { status, availability }

abstract class HandymanToggleState {}

class HandymanToggleInitial extends HandymanToggleState {}

class HandymanToggleInProgress extends HandymanToggleState {
  HandymanToggleInProgress({required this.id, required this.kind});

  final String id;
  final HandymanToggleKind kind;
}

class HandymanToggleSuccess extends HandymanToggleState {
  HandymanToggleSuccess({
    required this.id,
    required this.kind,
    required this.value,
  });

  final String id;
  final HandymanToggleKind kind;

  /// New flag value (0/1).
  final int value;
}

class HandymanToggleFailure extends HandymanToggleState {
  HandymanToggleFailure({
    required this.id,
    required this.kind,
    required this.errorMessage,
    required this.previousValue,
  });

  final String id;
  final HandymanToggleKind kind;
  final String errorMessage;

  /// The value before the toggle was attempted — used to revert optimistic UI.
  final int previousValue;
}

/// Toggles `active` (status) and `is_available` (availability) flags.
class HandymanToggleCubit extends Cubit<HandymanToggleState> {
  HandymanToggleCubit() : super(HandymanToggleInitial());

  final ManageHandymanRepository _repository = ManageHandymanRepository();

  Future<void> toggleStatus(String id, {required bool currentValue}) async {
    final int previous = currentValue ? 1 : 0;
    try {
      emit(HandymanToggleInProgress(id: id, kind: HandymanToggleKind.status));
      final int value = await _repository.toggleStatus(
        id,
        currentValue: previous,
      );
      emit(
        HandymanToggleSuccess(
          id: id,
          kind: HandymanToggleKind.status,
          value: value,
        ),
      );
    } catch (e) {
      emit(
        HandymanToggleFailure(
          id: id,
          kind: HandymanToggleKind.status,
          errorMessage: e.toString(),
          previousValue: previous,
        ),
      );
    }
  }

  Future<void> toggleAvailability(
    String id, {
    required bool currentValue,
  }) async {
    final int previous = currentValue ? 1 : 0;
    try {
      emit(
        HandymanToggleInProgress(id: id, kind: HandymanToggleKind.availability),
      );
      final int value = await _repository.toggleAvailability(
        id,
        currentValue: previous,
      );
      emit(
        HandymanToggleSuccess(
          id: id,
          kind: HandymanToggleKind.availability,
          value: value,
        ),
      );
    } catch (e) {
      emit(
        HandymanToggleFailure(
          id: id,
          kind: HandymanToggleKind.availability,
          errorMessage: e.toString(),
          previousValue: previous,
        ),
      );
    }
  }
}
