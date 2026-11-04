import '../../app/generalImports.dart';

abstract class HandymanLiveMapState {}

class HandymanLiveMapInitial extends HandymanLiveMapState {}

class HandymanLiveMapLoading extends HandymanLiveMapState {}

class HandymanLiveMapSuccess extends HandymanLiveMapState {
  final List<HandymanLiveMapItem> handymen;
  HandymanLiveMapSuccess(this.handymen);
}

class HandymanLiveMapFailure extends HandymanLiveMapState {
  final String errorMessage;
  HandymanLiveMapFailure(this.errorMessage);
}

class HandymanLiveMapCubit extends Cubit<HandymanLiveMapState> {
  HandymanLiveMapCubit() : super(HandymanLiveMapInitial());

  final HandymanLiveMapRepository _repository = HandymanLiveMapRepository();

  Timer? _timer;
  List<HandymanLiveMapItem>? _lastKnownData;
  VoidCallback? onTransientError;

  void startPolling() {
    _timer?.cancel();
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetch());
  }

  Future<void> _fetch() async {
    if (_lastKnownData == null && state is! HandymanLiveMapLoading) {
      if (!isClosed) emit(HandymanLiveMapLoading());
    }
    try {
      final data = await _repository.getLiveMapData();
      _lastKnownData = data;
      if (!isClosed) emit(HandymanLiveMapSuccess(data));
    } catch (e) {
      if (_lastKnownData == null && !isClosed) {
        emit(HandymanLiveMapFailure(e.toString()));
      } else {
        onTransientError?.call();
      }
    }
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
