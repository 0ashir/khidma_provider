import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanCashCollectionRepository.dart';

abstract class HandymanCashCollectionState {}

class HandymanCashCollectionInitial extends HandymanCashCollectionState {}

class HandymanCashCollectionInProgress extends HandymanCashCollectionState {}

class HandymanCashCollectionSuccess extends HandymanCashCollectionState {
  final List<HandymanCashCollectionModel> rows;
  final int total;
  final int offset;
  final HandymanCashCollectionSummary summary;
  final bool isLoadingMore;
  final bool hasError;

  HandymanCashCollectionSuccess({
    required this.rows,
    required this.total,
    required this.offset,
    required this.summary,
    required this.isLoadingMore,
    required this.hasError,
  });

  HandymanCashCollectionSuccess copyWith({
    List<HandymanCashCollectionModel>? rows,
    int? total,
    int? offset,
    HandymanCashCollectionSummary? summary,
    bool? isLoadingMore,
    bool? hasError,
  }) => HandymanCashCollectionSuccess(
    rows: rows ?? this.rows,
    total: total ?? this.total,
    offset: offset ?? this.offset,
    summary: summary ?? this.summary,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasError: hasError ?? this.hasError,
  );
}

class HandymanCashCollectionFailure extends HandymanCashCollectionState {
  final String errorMessage;
  HandymanCashCollectionFailure(this.errorMessage);
}

class HandymanCashCollectionCubit extends Cubit<HandymanCashCollectionState> {
  HandymanCashCollectionCubit() : super(HandymanCashCollectionInitial());

  final _repo = HandymanCashCollectionRepository();

  String? _currentSearch;
  String? _currentType;
  DateTime? _currentDateFrom;
  DateTime? _currentDateTo;

  String? get currentSearch => _currentSearch;
  String? get currentType => _currentType;
  DateTime? get currentDateFrom => _currentDateFrom;
  DateTime? get currentDateTo => _currentDateTo;

  Future<void> fetch({
    String? search,
    String? type,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    _currentSearch = search;
    _currentType = type;
    _currentDateFrom = dateFrom;
    _currentDateTo = dateTo;
    try {
      emit(HandymanCashCollectionInProgress());
      final result = await _repo.fetchList(params: _buildParams(offset: 0));
      emit(
        HandymanCashCollectionSuccess(
          rows: result.rows,
          total: result.total,
          offset: 0,
          summary: result.summary,
          isLoadingMore: false,
          hasError: false,
        ),
      );
    } catch (e) {
      emit(HandymanCashCollectionFailure(e.toString()));
    }
  }

  Future<void> refresh() => fetch(
    search: _currentSearch,
    type: _currentType,
    dateFrom: _currentDateFrom,
    dateTo: _currentDateTo,
  );

  Future<void> fetchMore() async {
    if (state is! HandymanCashCollectionSuccess) return;
    final current = state as HandymanCashCollectionSuccess;
    if (current.isLoadingMore) return;

    try {
      emit(current.copyWith(isLoadingMore: true));
      final nextOffset = current.rows.length;
      final result = await _repo.fetchList(
        params: _buildParams(offset: nextOffset),
      );
      current.rows.addAll(result.rows);
      emit(
        current.copyWith(
          rows: current.rows,
          total: result.total,
          offset: nextOffset,
          isLoadingMore: false,
          hasError: false,
        ),
      );
    } catch (_) {
      emit(
        (state as HandymanCashCollectionSuccess).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is HandymanCashCollectionSuccess) {
      final s = state as HandymanCashCollectionSuccess;
      return s.rows.length < s.total;
    }
    return false;
  }

  Map<String, dynamic> _buildParams({required int offset}) {
    final params = <String, dynamic>{
      ApiParam.limit: UiUtils.limit,
      ApiParam.offset: offset,
      ApiParam.sort: 'created_at',
      ApiParam.order: ApiParam.descending,
    };
    if (_currentSearch != null && _currentSearch!.isNotEmpty) {
      params[ApiParam.search] = _currentSearch;
    }
    if (_currentType != null && _currentType!.isNotEmpty) {
      params[ApiParam.type] = _currentType;
    }
    if (_currentDateFrom != null) {
      params[ApiParam.dateFrom] = _formatDate(_currentDateFrom!);
    }
    if (_currentDateTo != null) {
      params[ApiParam.dateTo] = _formatDate(_currentDateTo!);
    }
    return params;
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
