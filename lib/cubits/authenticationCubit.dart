import '../../app/generalImports.dart';

enum AuthenticationState { initial, authenticated, unAuthenticated, firstTime }

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState.initial) {
    _checkIfAuthenticated();
  }

  void _checkIfAuthenticated() {
    final bool userAuthenticated = HiveRepository.isUserLoggedIn;

    if (userAuthenticated) {
      emit(AuthenticationState.authenticated);
    } else {
      if (HiveRepository.isUserFirstTimeInApp) {
        emit(AuthenticationState.firstTime);
      } else {
        emit(AuthenticationState.unAuthenticated);
      }
    }
  }

  void setUnAuthenticated() {
    emit(AuthenticationState.unAuthenticated);
  }
}
