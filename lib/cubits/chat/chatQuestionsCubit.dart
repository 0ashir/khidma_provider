import 'package:edemand_partner/app/generalImports.dart';

abstract class ChatQuestionsState {}

class ChatQuestionsInitial extends ChatQuestionsState {}

class ChatQuestionsFetchInProgress extends ChatQuestionsState {}

class ChatQuestionsFetchSuccess extends ChatQuestionsState {
  final List<ChatQuestionModel> chatQuestions;

  ChatQuestionsFetchSuccess(this.chatQuestions);
}

class ChatQuestionsFetchFailure extends ChatQuestionsState {
  final String errorMessage;

  ChatQuestionsFetchFailure(this.errorMessage);
}

class ChatQuestionsCubit extends Cubit<ChatQuestionsState> {
  final ChatRepository chatRepository;

  ChatQuestionsCubit(this.chatRepository) : super(ChatQuestionsInitial());

  Future<void> fetchChatQuestions({required String type}) async {
    emit(ChatQuestionsFetchInProgress());
    try {
      final List<ChatQuestionModel> chatQuestions = await chatRepository
          .fetchChatQuestions(type: type);
      emit(ChatQuestionsFetchSuccess(chatQuestions));
    } catch (e) {
      emit(ChatQuestionsFetchFailure(e.toString()));
    }
  }
}
