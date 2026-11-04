import '../../app/generalImports.dart';

abstract class FetchBookingPaymentManagementDataState {}

class FetchBookingPaymentManagementDataInitialState
    extends FetchBookingPaymentManagementDataState {}

class FetchBookingPaymentManagementDataInProgressState
    extends FetchBookingPaymentManagementDataState {}

class FetchBookingPaymentManagementDataSuccessState
    extends FetchBookingPaymentManagementDataState {
  final bool isLoadingMore;
  final bool hasError;
  final int total;
  final List<BookingPaymentDataModel> bookingPaymentData;

  FetchBookingPaymentManagementDataSuccessState({
    required this.isLoadingMore,
    required this.hasError,
    required this.total,
    required this.bookingPaymentData,
  });

  FetchBookingPaymentManagementDataSuccessState copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    List<BookingPaymentDataModel>? bookingPaymentData,
  }) {
    return FetchBookingPaymentManagementDataSuccessState(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      total: total ?? this.total,
      bookingPaymentData: bookingPaymentData ?? this.bookingPaymentData,
    );
  }
}

class FetchBookingPaymentManagementDataFailureState
    extends FetchBookingPaymentManagementDataState {
  final String errorMessage;

  FetchBookingPaymentManagementDataFailureState(this.errorMessage);
}

class FetchBookingPaymentManagementDataCubit
    extends Cubit<FetchBookingPaymentManagementDataState> {
  FetchBookingPaymentManagementDataCubit()
    : super(FetchBookingPaymentManagementDataInitialState());
  final CommissionAmountRepository _commissionAmountRepository =
      CommissionAmountRepository();

  Future<void> fetchBookingPaymentManagementData() async {
    try {
      emit(FetchBookingPaymentManagementDataInProgressState());

      final Map<String, dynamic> parameter = {
        ApiParam.offset: '0',
        ApiParam.limit: UiUtils.limit,
        ApiParam.order: ApiParam.descending,
      };
      final DataOutput<BookingPaymentDataModel> result =
          await _commissionAmountRepository.fetchBookingPaymentManagementData(
            parameter: parameter,
          );

      emit(
        FetchBookingPaymentManagementDataSuccessState(
          hasError: false,
          isLoadingMore: false,
          total: result.total,
          bookingPaymentData: result.modelList,
        ),
      );
    } catch (e) {
      emit(FetchBookingPaymentManagementDataFailureState(e.toString()));
    }
  }

  Future<void> fetchMoreBookingPaymentManagementData() async {
    try {
      if (state is FetchBookingPaymentManagementDataSuccessState) {
        if ((state as FetchBookingPaymentManagementDataSuccessState)
            .isLoadingMore) {
          return;
        }
        emit(
          (state as FetchBookingPaymentManagementDataSuccessState).copyWith(
            isLoadingMore: true,
          ),
        );

        final Map<String, dynamic> parameter = {
          ApiParam.offset:
              (state as FetchBookingPaymentManagementDataSuccessState)
                  .bookingPaymentData
                  .length,
          ApiParam.limit: UiUtils.limit,
          ApiParam.order: ApiParam.descending,
        };
        final DataOutput<BookingPaymentDataModel> result =
            await _commissionAmountRepository.fetchBookingPaymentManagementData(
              parameter: parameter,
            );

        (state as FetchBookingPaymentManagementDataSuccessState)
            .bookingPaymentData
            .addAll(result.modelList);

        emit(
          FetchBookingPaymentManagementDataSuccessState(
            isLoadingMore: false,
            hasError: false,
            bookingPaymentData:
                (state as FetchBookingPaymentManagementDataSuccessState)
                    .bookingPaymentData,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchBookingPaymentManagementDataSuccessState).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is FetchBookingPaymentManagementDataSuccessState) {
      return (state as FetchBookingPaymentManagementDataSuccessState)
              .bookingPaymentData
              .length <
          (state as FetchBookingPaymentManagementDataSuccessState).total;
    }
    return false;
  }
}
