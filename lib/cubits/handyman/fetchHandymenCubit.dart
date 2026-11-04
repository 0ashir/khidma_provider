import '../../app/generalImports.dart';

abstract class FetchHandymenState {}

class FetchHandymenInitial extends FetchHandymenState {}

class FetchHandymenInProgress extends FetchHandymenState {}

class FetchHandymenSuccess extends FetchHandymenState {
  final List<HandymanModel> handymen;
  final bool isLoadingMore;
  final bool loadingMoreError;
  final int offset;
  final int total;

  FetchHandymenSuccess({
    required this.handymen,
    required this.isLoadingMore,
    required this.loadingMoreError,
    required this.offset,
    required this.total,
  });

  FetchHandymenSuccess copyWith({
    List<HandymanModel>? handymen,
    bool? isLoadingMore,
    bool? loadingMoreError,
    int? offset,
    int? total,
  }) {
    return FetchHandymenSuccess(
      handymen: handymen ?? this.handymen,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchHandymenFailure extends FetchHandymenState {
  final String errorMessage;

  FetchHandymenFailure(this.errorMessage);
}

class FetchHandymenCubit extends Cubit<FetchHandymenState> {
  FetchHandymenCubit() : super(FetchHandymenInitial());

  final ManageHandymanRepository _repository = ManageHandymanRepository();

  String _search = '';

  Future<void> fetchHandymen({String search = ''}) async {
    try {
      _search = search;
      emit(FetchHandymenInProgress());
      final DataOutput<HandymanModel> result = await _repository.getHandymen(
        offset: 0,
        search: _search,
      );
      emit(
        FetchHandymenSuccess(
          handymen: result.modelList,
          isLoadingMore: false,
          loadingMoreError: false,
          offset: 0,
          total: result.total,
        ),
      );
    } catch (e) {
      emit(FetchHandymenFailure(e.toString()));
    }
  }

  Future<void> fetchMore() async {
    if (state is! FetchHandymenSuccess) return;
    final current = state as FetchHandymenSuccess;
    if (current.isLoadingMore) return;

    try {
      emit(current.copyWith(isLoadingMore: true));
      final DataOutput<HandymanModel> result = await _repository.getHandymen(
        offset: current.offset + UiUtils.limit,
        search: _search,
      );
      final List<HandymanModel> updated = List.of(current.handymen)
        ..addAll(result.modelList);
      emit(
        FetchHandymenSuccess(
          handymen: updated,
          isLoadingMore: false,
          loadingMoreError: false,
          offset: current.offset + UiUtils.limit,
          total: result.total,
        ),
      );
    } catch (_) {
      emit(
        (state as FetchHandymenSuccess).copyWith(
          isLoadingMore: false,
          loadingMoreError: true,
        ),
      );
    }
  }

  bool hasMore() {
    if (state is FetchHandymenSuccess) {
      final s = state as FetchHandymenSuccess;
      return s.handymen.length < s.total;
    }
    return false;
  }

  void addHandyman(HandymanModel model) {
    if (state is FetchHandymenSuccess) {
      final s = state as FetchHandymenSuccess;
      final List<HandymanModel> updated = List.of(s.handymen)..insert(0, model);
      emit(s.copyWith(handymen: updated, total: s.total + 1));
    }
  }

  void updateHandymanInList(HandymanModel model) {
    if (state is FetchHandymenSuccess) {
      final s = state as FetchHandymenSuccess;
      final List<HandymanModel> updated = List.of(s.handymen);
      final index = updated.indexWhere((e) => e.id == model.id);
      if (index != -1) {
        updated[index] = model;
        emit(s.copyWith(handymen: updated));
      }
    }
  }

  void removeHandyman(String id) {
    if (state is FetchHandymenSuccess) {
      final s = state as FetchHandymenSuccess;
      final List<HandymanModel> updated = List.of(s.handymen)
        ..removeWhere((e) => e.id == id);
      emit(s.copyWith(handymen: updated, total: s.total > 0 ? s.total - 1 : 0));
    }
  }

  void setActive(String id, int active) {
    if (state is FetchHandymenSuccess) {
      final s = state as FetchHandymenSuccess;
      final List<HandymanModel> updated = s.handymen
          .map((e) => e.id == id ? e.copyWith(active: active) : e)
          .toList();
      emit(s.copyWith(handymen: updated));
    }
  }

  void setAvailability(String id, int isAvailable) {
    if (state is FetchHandymenSuccess) {
      final s = state as FetchHandymenSuccess;
      final List<HandymanModel> updated = s.handymen
          .map((e) => e.id == id ? e.copyWith(isAvailable: isAvailable) : e)
          .toList();
      emit(s.copyWith(handymen: updated));
    }
  }
}
