import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanBookingsRepository.dart';

abstract class HandymanBookingsState {}

class HandymanBookingsInitial extends HandymanBookingsState {}

class HandymanBookingsInProgress extends HandymanBookingsState {}

class HandymanBookingsSuccess extends HandymanBookingsState {
  final List<HandymanBookingListItem> bookings;
  final int total;
  final int offset;
  final bool isLoadingMore;
  final bool loadingMoreError;

  HandymanBookingsSuccess({
    required this.bookings,
    required this.total,
    required this.offset,
    this.isLoadingMore = false,
    this.loadingMoreError = false,
  });

  HandymanBookingsSuccess copyWith({
    List<HandymanBookingListItem>? bookings,
    int? total,
    int? offset,
    bool? isLoadingMore,
    bool? loadingMoreError,
  }) => HandymanBookingsSuccess(
    bookings: bookings ?? this.bookings,
    total: total ?? this.total,
    offset: offset ?? this.offset,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadingMoreError: loadingMoreError ?? this.loadingMoreError,
  );

  bool get hasMore => offset < total;
}

class HandymanBookingsFailure extends HandymanBookingsState {
  final String errorMessage;
  HandymanBookingsFailure(this.errorMessage);
}

class HandymanBookingsCubit extends Cubit<HandymanBookingsState> {
  HandymanBookingsCubit() : super(HandymanBookingsInitial());

  static const int _limit = 10;
  final HandymanBookingsRepository _repository = HandymanBookingsRepository();

  String? _currentStatus;
  String? _currentSearch;

  Future<void> fetchBookings({String? status, String? search}) async {
    _currentStatus = status;
    _currentSearch = search;
    try {
      emit(HandymanBookingsInProgress());
      final result = await _repository.fetchBookings(
        offset: 0,
        limit: _limit,
        status: status,
        search: search,
      );
      emit(
        HandymanBookingsSuccess(
          bookings: result.modelList,
          total: result.total,
          offset: 0,
        ),
      );
    } catch (e) {
      emit(HandymanBookingsFailure(e.toString()));
    }
  }

  Future<void> fetchMoreBookings() async {
    if (state is! HandymanBookingsSuccess) return;
    final current = state as HandymanBookingsSuccess;
    if (current.isLoadingMore || !current.hasMore) return;

    try {
      emit(current.copyWith(isLoadingMore: true, loadingMoreError: false));
      final newOffset = current.offset + _limit;
      final result = await _repository.fetchBookings(
        offset: newOffset,
        limit: _limit,
        status: _currentStatus,
        search: _currentSearch,
      );
      final merged = [...current.bookings, ...result.modelList];
      emit(
        current.copyWith(
          bookings: merged,
          total: result.total,
          offset: newOffset,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      final current2 = state is HandymanBookingsSuccess
          ? state as HandymanBookingsSuccess
          : null;
      if (current2 != null) {
        emit(current2.copyWith(isLoadingMore: false, loadingMoreError: true));
      }
    }
  }

  Future<void> refresh() =>
      fetchBookings(status: _currentStatus, search: _currentSearch);

  void updateBookingLocally({
    required String bookingId,
    required String newStatus,
    String? orderStatus,
    String? transalatedOrderStatus,
  }) {
    if (state is! HandymanBookingsSuccess) return;
    final current = state as HandymanBookingsSuccess;
    final updated = current.bookings.map((b) {
      return b.id == bookingId
          ? b.copyWith(
              handymanStatus: newStatus,
              orderStatus: orderStatus,
              transalatedOrderStatus: transalatedOrderStatus,
            )
          : b;
    }).toList();
    emit(current.copyWith(bookings: updated));
  }
}
