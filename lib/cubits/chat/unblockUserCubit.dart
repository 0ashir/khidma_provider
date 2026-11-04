// States
import 'package:edemand_partner/app/generalImports.dart';

abstract class UnblockUserState {}

class UnblockUserInitial extends UnblockUserState {}

class UnblockUserInProgress extends UnblockUserState {}

class UnblockUserSuccess extends UnblockUserState {
  final String message;
  final String userId;
  UnblockUserSuccess({required this.message, required this.userId});
}

class UnblockUserFailure extends UnblockUserState {
  final String errorMessage;
  UnblockUserFailure({required this.errorMessage});
}

// Cubit
class UnblockUserCubit extends Cubit<UnblockUserState> {
  final ChatRepository _chatRepository;

  UnblockUserCubit(this._chatRepository) : super(UnblockUserInitial());

  Future<void> unblockUser(String userId) async {
    emit(UnblockUserInProgress());
    try {
      final response = await _chatRepository.unblockUser(userId: userId);
      emit(
        UnblockUserSuccess(
          message: response['message'],
          userId: response['userId'],
        ),
      );
    } catch (e) {
      emit(UnblockUserFailure(errorMessage: e.toString()));
    }
  }
}
