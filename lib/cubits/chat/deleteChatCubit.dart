// Delete Chat States
import 'package:edemand_partner/app/generalImports.dart';

abstract class DeleteChatState {}

class DeleteChatInitial extends DeleteChatState {}

class DeleteChatInProgress extends DeleteChatState {}

class DeleteChatFailure extends DeleteChatState {
  final String errorMessage;

  DeleteChatFailure({required this.errorMessage});
}

class DeleteChatSuccess extends DeleteChatState {}

// Delete Chat Cubit
class DeleteChatCubit extends Cubit<DeleteChatState> {
  final ChatRepository chatRepository;

  DeleteChatCubit(this.chatRepository) : super(DeleteChatInitial());

  Future<void> deleteChat(String userId, String bookingId) async {
    emit(DeleteChatInProgress());
    try {
      await chatRepository.deleteChat(userId: userId, bookingId: bookingId);
      emit(DeleteChatSuccess());
    } catch (e) {
      emit(DeleteChatFailure(errorMessage: e.toString()));
    }
  }
}
