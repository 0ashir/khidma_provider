import 'package:edemand_partner/app/generalImports.dart';

abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutFailure extends LogoutState {}

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository authRepository = AuthRepository();

  LogoutCubit() : super(LogoutInitial());

  Future<void> logout(BuildContext context) async {
    emit(LogoutLoading());

    String fcmId = '';
    try {
      fcmId = await FirebaseMessaging.instance.getToken() ?? '';
    } catch (_) {}
    await authRepository.logoutUser(fcmId: fcmId);
    // Log logout
    ClarityService.logAction(ClarityActions.logout);

    await AuthRepository().logout(context);
    emit(LogoutSuccess());
  }
}
