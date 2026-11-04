import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanReviewsRepository.dart';

abstract class FetchHandymanReviewsState {}

class FetchHandymanReviewsInitial extends FetchHandymanReviewsState {}

class FetchHandymanReviewsInProgress extends FetchHandymanReviewsState {}

class FetchHandymanReviewsSuccess extends FetchHandymanReviewsState {
  final List<HandymanReviewModel> reviews;
  final int total;
  final int offset;
  final bool isLoadingMore;
  final bool hasLoadMoreError;

  FetchHandymanReviewsSuccess({
    required this.reviews,
    required this.total,
    required this.offset,
    required this.isLoadingMore,
    required this.hasLoadMoreError,
  });

  FetchHandymanReviewsSuccess copyWith({
    List<HandymanReviewModel>? reviews,
    int? total,
    int? offset,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) =>
      FetchHandymanReviewsSuccess(
        reviews: reviews ?? this.reviews,
        total: total ?? this.total,
        offset: offset ?? this.offset,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
      );
}

class FetchHandymanReviewsFailure extends FetchHandymanReviewsState {
  final String errorMessage;
  FetchHandymanReviewsFailure(this.errorMessage);
}

class FetchHandymanReviewsCubit extends Cubit<FetchHandymanReviewsState> {
  FetchHandymanReviewsCubit() : super(FetchHandymanReviewsInitial());

  final _repo = HandymanReviewsRepository();

  Future<void> fetchReviews() async {
    try {
      emit(FetchHandymanReviewsInProgress());
      final result = await _repo.fetchReviews(offset: 0);
      emit(
        FetchHandymanReviewsSuccess(
          reviews: result.reviews,
          total: result.total,
          offset: 0,
          isLoadingMore: false,
          hasLoadMoreError: false,
        ),
      );
    } catch (e) {
      emit(FetchHandymanReviewsFailure(e.toString()));
    }
  }

  Future<void> fetchMoreReviews() async {
    if (state is! FetchHandymanReviewsSuccess) return;
    final current = state as FetchHandymanReviewsSuccess;
    if (current.isLoadingMore) return;

    try {
      emit(current.copyWith(isLoadingMore: true));
      final nextOffset = current.offset + UiUtils.limit;
      final result = await _repo.fetchReviews(offset: nextOffset);
      current.reviews.addAll(result.reviews);
      emit(
        current.copyWith(
          reviews: current.reviews,
          total: result.total,
          offset: nextOffset,
          isLoadingMore: false,
          hasLoadMoreError: false,
        ),
      );
    } catch (_) {
      emit(
        (state as FetchHandymanReviewsSuccess).copyWith(
          isLoadingMore: false,
          hasLoadMoreError: true,
        ),
      );
    }
  }

  bool hasMoreReviews() {
    if (state is FetchHandymanReviewsSuccess) {
      final s = state as FetchHandymanReviewsSuccess;
      return s.offset + UiUtils.limit < s.total;
    }
    return false;
  }
}
