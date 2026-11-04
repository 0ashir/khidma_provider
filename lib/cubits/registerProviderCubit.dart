import '../../app/generalImports.dart';

abstract class RegisterProviderState {}

class RegisterProviderInitial extends RegisterProviderState {}

class RegisterProviderInProgress extends RegisterProviderState {}

class RegisterProviderSuccess extends RegisterProviderState {
  RegisterProviderSuccess({
    required this.isError,
    required this.message,
    required this.providerDetails,
  });
  final bool isError;
  final String message;
  final ProviderDetails providerDetails;
}

class RegisterProviderFailure extends RegisterProviderState {
  RegisterProviderFailure({required this.errorMessage});
  final String errorMessage;
}

class RegisterProviderCubit extends Cubit<RegisterProviderState> {
  RegisterProviderCubit() : super(RegisterProviderInitial());
  final AuthRepository _authRepository = AuthRepository();

  Future<void> registerProvider({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      emit(RegisterProviderInProgress());

      // Log registration attempt
      ClarityService.logAction(ClarityActions.registrationAttempt, {
        'phone_number': parameter['phone']?.toString() ?? '',
        'country_code': parameter['country_code']?.toString() ?? '',
      });

      final Map<String, dynamic> responseData = await _authRepository
          .registerProvider(parameters: parameter, isAuthTokenRequired: false);

      if (!responseData['error']) {
        // Log successful registration
        ClarityService.logAction(ClarityActions.registrationCompleted, {
          'username': parameter['username']?.toString() ?? '',
          'company_name': parameter['company_name']?.toString() ?? '',
        });

        ProviderDetails providerDetails =
            responseData['providerDetails'] is ProviderDetails
                ? responseData['providerDetails'] as ProviderDetails
                : ProviderDetails();

        if (responseData['token'] == null ||
            HiveRepository.getUserToken.isEmpty) {
          final String? email = parameter['email']?.toString();
          final String? mobile = parameter['mobile']?.toString();
          final String? countryCode = parameter['country_code']?.toString();
          final String password = parameter['password']?.toString() ?? '';
          final String? loginType = parameter['login_type']?.toString();

          final Map<String, dynamic> loginResponse =
              await _authRepository.loginUser(
            email: email,
            phoneNumber: mobile,
            countryCode: countryCode,
            password: password,
            loginType: loginType,
          );

          if (loginResponse['userDetails'] != null) {
            providerDetails = loginResponse['userDetails'] as ProviderDetails;
          }
        }

        HiveRepository.setUserLoggedIn = true;

        emit(
          RegisterProviderSuccess(
            isError: responseData['error'],
            message: responseData['message'],
            providerDetails: providerDetails,
          ),
        );
        return;
      }

      emit(RegisterProviderFailure(errorMessage: responseData['message']));
    } catch (e, st) {
      emit(RegisterProviderFailure(errorMessage: st.toString()));
    }
  }
}
