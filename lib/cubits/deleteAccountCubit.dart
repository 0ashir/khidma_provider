import 'package:edemand_partner/app/generalImports.dart';

abstract class DeleteProviderAccountState {}

class DeleteProviderAccountInitial extends DeleteProviderAccountState {}

class DeleteProviderAccountInProgress extends DeleteProviderAccountState {}

class DeleteProviderAccountSuccess extends DeleteProviderAccountState {}

class DeleteProviderAccountFailure extends DeleteProviderAccountState {
  DeleteProviderAccountFailure(this.errorMessage);

  final String errorMessage;
}

class DeleteProviderAccountCubit extends Cubit<DeleteProviderAccountState> {
  DeleteProviderAccountCubit() : super(DeleteProviderAccountInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future deleteProviderAccount() async {
    try {
      emit(DeleteProviderAccountInProgress());
      await _authRepository.deleteUserAccount();

      // Log account deletion
      ClarityService.logAction(ClarityActions.deleteAccount);

      await HiveRepository.clearBoxValues(
        boxName: HiveRepository.userDetailBoxKey,
      );
      emit(DeleteProviderAccountSuccess());
    } catch (e) {
      emit(DeleteProviderAccountFailure(e.toString()));
    }
  }
}
