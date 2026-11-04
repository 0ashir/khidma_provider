import '../../app/generalImports.dart';

abstract class AdminCollectCashCollectionHistoryState {}

class AdminCollectCashCollectionHistoryStateFetchInitial
    extends AdminCollectCashCollectionHistoryState {}

class AdminCollectCashCollectionHistoryFetchInProgress
    extends AdminCollectCashCollectionHistoryState {}

class AdminCollectCashCollectionHistoryFetchSuccess
    extends AdminCollectCashCollectionHistoryState {
  final bool isLoadingMore;
  final String totalPayableCommission;

  /// Currency of [totalPayableCommission]; null → provider's country currency.
  final String? currencySymbol;
  final int? currencyDecimalPlaces;
  final bool hasError;
  final int offset;
  final int total;
  final List<CashCollectionModel> cashCollectionData;

  AdminCollectCashCollectionHistoryFetchSuccess({
    required this.isLoadingMore,
    required this.hasError,
    required this.offset,
    required this.totalPayableCommission,
    required this.total,
    required this.cashCollectionData,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  AdminCollectCashCollectionHistoryFetchSuccess copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    String? totalPayableCommission,
    List<CashCollectionModel>? cashCollectionData,
  }) {
    return AdminCollectCashCollectionHistoryFetchSuccess(
      totalPayableCommission:
          totalPayableCommission ?? this.totalPayableCommission,
      currencySymbol: currencySymbol,
      currencyDecimalPlaces: currencyDecimalPlaces,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      cashCollectionData: cashCollectionData ?? this.cashCollectionData,
    );
  }
}

class AdminCollectCashCollectionHistoryStateFailure
    extends AdminCollectCashCollectionHistoryState {
  final String errorMessage;

  AdminCollectCashCollectionHistoryStateFailure(this.errorMessage);
}

class AdminCollectCashCollectionHistoryCubit
    extends Cubit<AdminCollectCashCollectionHistoryState> {
  AdminCollectCashCollectionHistoryCubit()
    : super(AdminCollectCashCollectionHistoryStateFetchInitial());

  final CommissionAmountRepository _commissionAmountRepository =
      CommissionAmountRepository();

  Future<void> fetchAdminCollectedCashCollection() async {
    try {
      emit(AdminCollectCashCollectionHistoryFetchInProgress());

      final Map<String, dynamic> parameter = {
        'admin_cash_recevied': 1,
        ApiParam.offset: '0',
        ApiParam.limit: UiUtils.limit,
        ApiParam.order: ApiParam.descending,
      };
      final DataOutput<CashCollectionModel> result =
          await _commissionAmountRepository.fetchCashCollectionHistory(
            parameter: parameter,
          );

      emit(
        AdminCollectCashCollectionHistoryFetchSuccess(
          totalPayableCommission:
              result.extraData?.data['totalPayableCommission'] ?? '0.0',
          currencySymbol: result.extraData?.data['currencySymbol'],
          currencyDecimalPlaces:
              result.extraData?.data['currencyDecimalPlaces'],
          hasError: false,
          isLoadingMore: false,
          offset: 0,
          total: result.total,
          cashCollectionData: result.modelList,
        ),
      );
    } catch (e) {
      emit(AdminCollectCashCollectionHistoryStateFailure(e.toString()));
    }
  }

  Future<void> fetchAdminCollectedMoreCashCollection() async {
    try {
      if (state is AdminCollectCashCollectionHistoryFetchSuccess) {
        if ((state as AdminCollectCashCollectionHistoryFetchSuccess)
            .isLoadingMore) {
          return;
        }
        emit(
          (state as AdminCollectCashCollectionHistoryFetchSuccess).copyWith(
            isLoadingMore: true,
          ),
        );
        final Map<String, dynamic> parameter = {
          'admin_cash_recevied': 1,
          ApiParam.offset:
              (state as AdminCollectCashCollectionHistoryFetchSuccess).offset +
              UiUtils.limit,
          ApiParam.limit: UiUtils.limit,
          ApiParam.order: ApiParam.descending,
        };
        final DataOutput<CashCollectionModel> result =
            await _commissionAmountRepository.fetchCashCollectionHistory(
              parameter: parameter,
            );

        (state as AdminCollectCashCollectionHistoryFetchSuccess)
            .cashCollectionData
            .addAll(result.modelList);

        final AdminCollectCashCollectionHistoryFetchSuccess successState =
            state as AdminCollectCashCollectionHistoryFetchSuccess;
        emit(
          AdminCollectCashCollectionHistoryFetchSuccess(
            totalPayableCommission: successState.totalPayableCommission,
            currencySymbol: successState.currencySymbol,
            currencyDecimalPlaces: successState.currencyDecimalPlaces,
            isLoadingMore: false,
            hasError: false,
            cashCollectionData: successState.cashCollectionData,
            offset: successState.offset + UiUtils.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as AdminCollectCashCollectionHistoryFetchSuccess).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is AdminCollectCashCollectionHistoryFetchSuccess) {
      return (state as AdminCollectCashCollectionHistoryFetchSuccess).offset <
          (state as AdminCollectCashCollectionHistoryFetchSuccess).total;
    }
    return false;
  }

  void emitSuccessState() {
    if (state is AdminCollectCashCollectionHistoryFetchSuccess) {
      final AdminCollectCashCollectionHistoryFetchSuccess successState =
          state as AdminCollectCashCollectionHistoryFetchSuccess;

      emit(
        AdminCollectCashCollectionHistoryFetchSuccess(
          totalPayableCommission: successState.totalPayableCommission,
          currencySymbol: successState.currencySymbol,
          currencyDecimalPlaces: successState.currencyDecimalPlaces,
          isLoadingMore: successState.isLoadingMore,
          hasError: successState.hasError,
          offset: successState.offset,
          total: successState.total,
          cashCollectionData: successState.cashCollectionData,
        ),
      );
    }
  }
}
