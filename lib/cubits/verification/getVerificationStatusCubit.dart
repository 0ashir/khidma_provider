import 'package:edemand_partner/app/generalImports.dart';

abstract class GetVerificationStatusState {}

class GetVerificationStatusInitial extends GetVerificationStatusState {}

class GetVerificationStatusInProgress extends GetVerificationStatusState {}

class GetVerificationStatusSuccess extends GetVerificationStatusState {
  GetVerificationStatusSuccess(this.status);
  final VerificationStatusModel status;
}

class GetVerificationStatusFail extends GetVerificationStatusState {
  GetVerificationStatusFail(this.error);
  final String error;
}

class GetVerificationStatusCubit extends Cubit<GetVerificationStatusState> {
  GetVerificationStatusCubit() : super(GetVerificationStatusInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> fetch() async {
    try {
      emit(GetVerificationStatusInProgress());
      final VerificationStatusModel result = await _authRepository
          .getVerificationStatus();
      emit(GetVerificationStatusSuccess(result));
    } catch (e) {
      emit(GetVerificationStatusFail(e.toString()));
    }
  }
}
