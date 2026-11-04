import 'package:edemand_partner/ui/screens/withdrawal/withDrawalStatusEnum.dart';

import '../../app/generalImports.dart';

abstract class FetchWithdrawalRequestState {}

class FetchWithdrawalRequestInitial extends FetchWithdrawalRequestState {}

class FetchWithdrawalRequestInProgress extends FetchWithdrawalRequestState {}

class FetchWithdrawalRequestSuccess extends FetchWithdrawalRequestState {
  final bool isLoadingMore;
  final bool hasError;
  final int offset;
  final int total;
  final String availableBalance;
  final List<WithdrawalModel> withdrawals;

  FetchWithdrawalRequestSuccess({
    required this.isLoadingMore,
    required this.hasError,
    required this.offset,
    required this.availableBalance,
    required this.total,
    required this.withdrawals,
  });

  FetchWithdrawalRequestSuccess copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    String? availableBalance,
    List<WithdrawalModel>? withdrawals,
  }) {
    return FetchWithdrawalRequestSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      availableBalance: availableBalance ?? this.availableBalance,
      withdrawals: withdrawals ?? this.withdrawals,
    );
  }
}

class FetchWithdrawalRequestFailure extends FetchWithdrawalRequestState {
  final String errorMessage;

  FetchWithdrawalRequestFailure(this.errorMessage);
}

class FetchWithdrawalRequestCubit extends Cubit<FetchWithdrawalRequestState> {
  FetchWithdrawalRequestCubit() : super(FetchWithdrawalRequestInitial());
  final CommissionAmountRepository _commissionAmountRepository =
      CommissionAmountRepository();

  Future<void> fetchWithdrawals({required String status}) async {
    try {
      final WithDrawalStatusEnum currentStatus =
          WithDrawalStatusEnum.fromString(status);
      emit(FetchWithdrawalRequestInProgress());
      final Map<String, dynamic> parameter = {
        ApiParam.offset: '0',
        ApiParam.limit: UiUtils.limit,
        ApiParam.order: ApiParam.descending,
        if (status != 'all') ApiParam.statusFilter: currentStatus.value,
      };

      final DataOutput<WithdrawalModel> result =
          await _commissionAmountRepository.fetchWithdrawalRequests(
            parameter: parameter,
          );
      emit(
        FetchWithdrawalRequestSuccess(
          hasError: false,
          isLoadingMore: false,
          offset: result.modelList.length,
          total: result.total,
          withdrawals: result.modelList,
          availableBalance: result.extraData?.data ?? "0",
        ),
      );
    } catch (e) {
      emit(FetchWithdrawalRequestFailure(e.toString()));
    }
  }

  Future<void> fetchMoreWithdrawals({required String status}) async {
    try {
      if (state is FetchWithdrawalRequestSuccess) {
        if ((state as FetchWithdrawalRequestSuccess).isLoadingMore) {
          return;
        }
        emit(
          (state as FetchWithdrawalRequestSuccess).copyWith(
            isLoadingMore: true,
          ),
        );

        final Map<String, dynamic> parameter = {
          ApiParam.offset: (state as FetchWithdrawalRequestSuccess).offset,
          ApiParam.limit: UiUtils.limit,
          ApiParam.order: ApiParam.descending,
          if (status != 'all') ApiParam.statusFilter: status,
        };

        final DataOutput<WithdrawalModel> result =
            await _commissionAmountRepository.fetchWithdrawalRequests(
              parameter: parameter,
            );

        final FetchWithdrawalRequestSuccess withdrawalState =
            state as FetchWithdrawalRequestSuccess;
        withdrawalState.withdrawals.addAll(result.modelList);
        emit(
          FetchWithdrawalRequestSuccess(
            isLoadingMore: false,
            hasError: false,
            withdrawals: withdrawalState.withdrawals,
            offset:
                (state as FetchWithdrawalRequestSuccess).offset + UiUtils.limit,
            total: result.total,
            availableBalance: result.extraData?.data ?? "0",
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchWithdrawalRequestSuccess).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is FetchWithdrawalRequestSuccess) {
      return (state as FetchWithdrawalRequestSuccess).offset <
          (state as FetchWithdrawalRequestSuccess).total;
    }
    return false;
  }
}
