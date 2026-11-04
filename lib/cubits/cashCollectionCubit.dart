import '../../app/generalImports.dart';

abstract class CashCollectionState {}

class FetchCashCollectionInitial extends CashCollectionState {}

class CashCollectionFetchInProgress extends CashCollectionState {}

class CashCollectionFetchSuccess extends CashCollectionState {
  final bool isLoadingMore;
  final bool hasError;
  final int offset;
  final int total;
  final String totalPayableCommission;

  /// Currency of [totalPayableCommission]; null → provider's country currency.
  final String? currencySymbol;
  final int? currencyDecimalPlaces;
  final List<CashCollectionModel> cashCollectionData;

  CashCollectionFetchSuccess({
    required this.isLoadingMore,
    required this.hasError,
    required this.offset,
    required this.total,
    required this.totalPayableCommission,
    required this.cashCollectionData,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  CashCollectionFetchSuccess copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    List<CashCollectionModel>? cashCollectionData,
    String? totalPayableCommission,
  }) {
    return CashCollectionFetchSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      totalPayableCommission:
          totalPayableCommission ?? this.totalPayableCommission,
      currencySymbol: currencySymbol,
      currencyDecimalPlaces: currencyDecimalPlaces,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      cashCollectionData: cashCollectionData ?? this.cashCollectionData,
    );
  }
}

class CashCollectionFetchFailure extends CashCollectionState {
  final String errorMessage;

  CashCollectionFetchFailure(this.errorMessage);
}

class CashCollectionCubit extends Cubit<CashCollectionState> {
  CashCollectionCubit() : super(FetchCashCollectionInitial());

  final CommissionAmountRepository _commissionAmountRepository =
      CommissionAmountRepository();

  Future<void> fetchCashCollection() async {
    try {
      emit(CashCollectionFetchInProgress());

      final Map<String, dynamic> parameter = {
        'provider_cash_recevied': 1,
        ApiParam.order: ApiParam.descending,
        ApiParam.offset: '0',
        ApiParam.limit: UiUtils.limit,
      };
      final DataOutput<CashCollectionModel> result =
          await _commissionAmountRepository.fetchCashCollectionHistory(
            parameter: parameter,
          );

      emit(
        CashCollectionFetchSuccess(
          totalPayableCommission:
              result.extraData?.data['totalPayableCommission'],
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
      emit(CashCollectionFetchFailure(e.toString()));
    }
  }

  Future<void> fetchMoreCashCollection() async {
    try {
      if (state is CashCollectionFetchSuccess) {
        if ((state as CashCollectionFetchSuccess).isLoadingMore) {
          return;
        }
        emit(
          (state as CashCollectionFetchSuccess).copyWith(isLoadingMore: true),
        );

        final Map<String, dynamic> parameter = {
          'provider_cash_recevied': 1,
          ApiParam.offset:
              (state as CashCollectionFetchSuccess).offset + UiUtils.limit,
          ApiParam.limit: UiUtils.limit,
          ApiParam.order: ApiParam.descending,
        };
        final DataOutput<CashCollectionModel> result =
            await _commissionAmountRepository.fetchCashCollectionHistory(
              parameter: parameter,
            );

        (state as CashCollectionFetchSuccess).cashCollectionData.addAll(
          result.modelList,
        );

        emit(
          CashCollectionFetchSuccess(
            isLoadingMore: false,
            hasError: false,
            totalPayableCommission:
                (state as CashCollectionFetchSuccess).totalPayableCommission,
            currencySymbol:
                (state as CashCollectionFetchSuccess).currencySymbol,
            currencyDecimalPlaces:
                (state as CashCollectionFetchSuccess).currencyDecimalPlaces,
            cashCollectionData:
                (state as CashCollectionFetchSuccess).cashCollectionData,
            offset:
                (state as CashCollectionFetchSuccess).offset + UiUtils.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as CashCollectionFetchSuccess).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is CashCollectionFetchSuccess) {
      return (state as CashCollectionFetchSuccess).offset <
          (state as CashCollectionFetchSuccess).total;
    }
    return false;
  }

  void emitSuccessState() {
    if (state is CashCollectionFetchSuccess) {
      final CashCollectionFetchSuccess successState =
          state as CashCollectionFetchSuccess;

      emit(
        CashCollectionFetchSuccess(
          isLoadingMore: successState.isLoadingMore,
          hasError: successState.hasError,
          offset: successState.offset,
          total: successState.total,
          totalPayableCommission: successState.totalPayableCommission,
          currencySymbol: successState.currencySymbol,
          currencyDecimalPlaces: successState.currencyDecimalPlaces,
          cashCollectionData: successState.cashCollectionData,
        ),
      );
    }
  }
}
