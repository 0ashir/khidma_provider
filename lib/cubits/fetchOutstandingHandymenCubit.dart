import '../../app/generalImports.dart';

abstract class FetchOutstandingHandymenState {}

class FetchOutstandingHandymenInitial extends FetchOutstandingHandymenState {}

class FetchOutstandingHandymenInProgress extends FetchOutstandingHandymenState {}

class FetchOutstandingHandymenSuccess extends FetchOutstandingHandymenState {
  final bool isLoadingMore;
  final bool hasError;
  final int offset;
  final int total;
  final List<OutstandingHandymanOrderModel> orders;

  FetchOutstandingHandymenSuccess({
    required this.isLoadingMore,
    required this.hasError,
    required this.offset,
    required this.total,
    required this.orders,
  });

  FetchOutstandingHandymenSuccess copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    List<OutstandingHandymanOrderModel>? orders,
  }) {
    return FetchOutstandingHandymenSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      orders: orders ?? this.orders,
    );
  }
}

class FetchOutstandingHandymenFailure extends FetchOutstandingHandymenState {
  final String errorMessage;
  FetchOutstandingHandymenFailure(this.errorMessage);
}

class FetchOutstandingHandymenCubit
    extends Cubit<FetchOutstandingHandymenState> {
  FetchOutstandingHandymenCubit() : super(FetchOutstandingHandymenInitial());

  final CommissionAmountRepository _repository = CommissionAmountRepository();

  Future<void> fetchOutstandingHandymen({String search = ''}) async {
    try {
      emit(FetchOutstandingHandymenInProgress());
      final DataOutput<OutstandingHandymanOrderModel> result =
          await _repository.fetchOutstandingHandymen(search: search);
      emit(
        FetchOutstandingHandymenSuccess(
          isLoadingMore: false,
          hasError: false,
          offset: 0,
          total: result.total,
          orders: result.modelList,
        ),
      );
    } catch (e) {
      emit(FetchOutstandingHandymenFailure(e.toString()));
    }
  }

  Future<void> fetchMore({String search = ''}) async {
    if (state is! FetchOutstandingHandymenSuccess) return;
    final successState = state as FetchOutstandingHandymenSuccess;
    if (successState.isLoadingMore) return;
    try {
      emit(successState.copyWith(isLoadingMore: true));
      final DataOutput<OutstandingHandymanOrderModel> result =
          await _repository.fetchOutstandingHandymen(
        search: search,
        offset: successState.offset + UiUtils.limit,
      );
      successState.orders.addAll(result.modelList);
      emit(
        FetchOutstandingHandymenSuccess(
          isLoadingMore: false,
          hasError: false,
          offset: successState.offset + UiUtils.limit,
          total: result.total,
          orders: successState.orders,
        ),
      );
    } catch (e) {
      emit(successState.copyWith(isLoadingMore: false, hasError: true));
    }
  }

  bool hasMoreData() {
    if (state is FetchOutstandingHandymenSuccess) {
      final s = state as FetchOutstandingHandymenSuccess;
      return s.offset < s.total;
    }
    return false;
  }
}
