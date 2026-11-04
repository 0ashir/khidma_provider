import '../../app/generalImports.dart';

abstract class FetchSettlementHistoryState {}

class FetchSettlementHistoryInitial extends FetchSettlementHistoryState {}

class FetchSettlementHistoryInProgress extends FetchSettlementHistoryState {}

class FetchSettlementHistorySuccess extends FetchSettlementHistoryState {
  final bool isLoadingMore;
  final bool hasError;
  final int offset;
  final int total;
  final String amountReceivable;

  /// Currency of [amountReceivable] (provider's country).
  final String? currencySymbol;
  final int? currencyDecimalPlaces;
  final List<SettlementModel> settlementDetails;

  FetchSettlementHistorySuccess({
    required this.isLoadingMore,
    required this.hasError,
    required this.offset,
    required this.total,
    required this.settlementDetails,
    required this.amountReceivable,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  FetchSettlementHistorySuccess copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    String? amountReceivable,
    List<SettlementModel>? settlementDetails,
  }) {
    return FetchSettlementHistorySuccess(
      amountReceivable: amountReceivable ?? this.amountReceivable,
      currencySymbol: currencySymbol,
      currencyDecimalPlaces: currencyDecimalPlaces,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      settlementDetails: settlementDetails ?? this.settlementDetails,
    );
  }
}

class FetchSettlementHistoryFailure extends FetchSettlementHistoryState {
  final String errorMessage;

  FetchSettlementHistoryFailure(this.errorMessage);
}

class FetchSettlementHistoryCubit extends Cubit<FetchSettlementHistoryState> {
  FetchSettlementHistoryCubit() : super(FetchSettlementHistoryInitial());
  final CommissionAmountRepository _commissionAmountRepository =
      CommissionAmountRepository();

  Future<void> fetchSettlementHistory() async {
    try {
      emit(FetchSettlementHistoryInProgress());

      final Map<String, dynamic> parameter = {
        ApiParam.offset: '0',
        ApiParam.limit: UiUtils.limit,
        ApiParam.order: ApiParam.descending,
      };
      final DataOutput<SettlementModel> result =
          await _commissionAmountRepository.fetchSettlementHistory(
            parameter: parameter,
          );

      emit(
        FetchSettlementHistorySuccess(
          hasError: false,
          isLoadingMore: false,
          offset: result.modelList.length,
          total: result.total,
          settlementDetails: result.modelList,
          amountReceivable: (result.extraData?.data['balance'] ?? '0')
              .toString(),
          currencySymbol: result.extraData?.data['currencySymbol'],
          currencyDecimalPlaces:
              result.extraData?.data['currencyDecimalPlaces'],
        ),
      );
    } catch (e) {
      emit(FetchSettlementHistoryFailure(e.toString()));
    }
  }

  Future<void> fetchMoreSettlementHistory() async {
    try {
      if (state is FetchSettlementHistorySuccess) {
        if ((state as FetchSettlementHistorySuccess).isLoadingMore) {
          return;
        }
        emit(
          (state as FetchSettlementHistorySuccess).copyWith(
            isLoadingMore: true,
          ),
        );

        final Map<String, dynamic> parameter = {
          ApiParam.offset: (state as FetchSettlementHistorySuccess).offset,
          ApiParam.limit: UiUtils.limit,
          ApiParam.order: ApiParam.descending,
        };
        final DataOutput<SettlementModel> result =
            await _commissionAmountRepository.fetchSettlementHistory(
              parameter: parameter,
            );

        (state as FetchSettlementHistorySuccess).settlementDetails.addAll(
          result.modelList,
        );

        emit(
          FetchSettlementHistorySuccess(
            isLoadingMore: false,
            hasError: false,
            settlementDetails:
                (state as FetchSettlementHistorySuccess).settlementDetails,
            offset: (state as FetchSettlementHistorySuccess)
                .settlementDetails
                .length,

            total: result.total,
            amountReceivable: (result.extraData?.data['balance'] ?? '0')
                .toString(),
            currencySymbol: result.extraData?.data['currencySymbol'],
            currencyDecimalPlaces:
                result.extraData?.data['currencyDecimalPlaces'],
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchSettlementHistorySuccess).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is FetchSettlementHistorySuccess) {
      return (state as FetchSettlementHistorySuccess).offset <
          (state as FetchSettlementHistorySuccess).total;
    }
    return false;
  }
}
