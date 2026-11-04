import '../../app/generalImports.dart';

abstract class SendQueryToAdminState {}

class SendQueryToAdminInitialState extends SendQueryToAdminState {}

class SendQueryToAdminInProgressState extends SendQueryToAdminState {}

class SendQueryToAdminSuccessState extends SendQueryToAdminState {
  final String error;
  final String message;

  SendQueryToAdminSuccessState({required this.error, required this.message});
}

class SendQueryToAdminFailureState extends SendQueryToAdminState {
  final String errorMessage;

  SendQueryToAdminFailureState(this.errorMessage);
}

class SendQueryToAdminCubit extends Cubit<SendQueryToAdminState> {
  final SettingsRepository settingsRepository = SettingsRepository();

  SendQueryToAdminCubit() : super(SendQueryToAdminInitialState());

  Future<void> sendQueryToAdmin({
    required final String name,
    required final String email,
    required final String subject,
    required final String message,
  }) async {
    try {
      emit(SendQueryToAdminInProgressState());
      final response = await settingsRepository.sendQueryToAdmin(
        parameter: {
          "name": name,
          "message": message,
          "subject": subject,
          "email": email,
        },
      );

      ClarityService.logAction(ClarityActions.contactUsSubmitted, {
        'subject': subject,
        'email': email,
      });

      emit(
        SendQueryToAdminSuccessState(
          message: response['message'],
          error: response['error'].toString(),
        ),
      );
    } catch (e) {
      emit(SendQueryToAdminFailureState(e.toString()));
    }
  }
}
