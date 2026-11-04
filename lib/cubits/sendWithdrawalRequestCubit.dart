import '../../app/generalImports.dart';

abstract class SendWithdrawalRequestState {}

class SendWithdrawalRequestInitial extends SendWithdrawalRequestState {}

class SendWithdrawalRequestInProgress extends SendWithdrawalRequestState {}

class SendWithdrawalRequestSuccess extends SendWithdrawalRequestState {
  final String balance;
  final String message;
  SendWithdrawalRequestSuccess({required this.balance, required this.message});
}

class SendWithdrawalRequestFailure extends SendWithdrawalRequestState {
  final String errorMessage;

  SendWithdrawalRequestFailure(this.errorMessage);
}

class SendWithdrawalRequestCubit extends Cubit<SendWithdrawalRequestState> {
  SendWithdrawalRequestCubit() : super(SendWithdrawalRequestInitial());

  final CommissionAmountRepository _commissionAmountRepository =
      CommissionAmountRepository();

  Future<void> sendWithdrawalRequest({required String amount}) async {
    try {
      emit(SendWithdrawalRequestInProgress());
      final result = await _commissionAmountRepository.sendWithdrawalRequest(
        amount: amount,
      );

      // Log withdrawal request
      ClarityService.logAction(ClarityActions.withdrawalRequestSent, {
        'amount': amount,
        'remaining_balance': result['balance'],
      });

      emit(
        SendWithdrawalRequestSuccess(
          balance: result['balance'] ?? '0',
          message: result['message'] ?? '',
        ),
      );
    } catch (e) {
      emit(SendWithdrawalRequestFailure(e.toString()));
    }
  }
}
