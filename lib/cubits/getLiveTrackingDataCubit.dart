import '../app/generalImports.dart';
import '../data/model/liveTracking/liveTrackingDataModel.dart';
import '../data/repository/liveTrackingDataRepository.dart';

abstract class GetLiveTrackingDataState {}

class GetLiveTrackingDataInitial extends GetLiveTrackingDataState {}

class GetLiveTrackingDataLoading extends GetLiveTrackingDataState {}

class GetLiveTrackingDataSuccess extends GetLiveTrackingDataState {
  final LiveTrackingDataModel data;
  GetLiveTrackingDataSuccess(this.data);
}

class GetLiveTrackingDataFailure extends GetLiveTrackingDataState {
  final String errorMessage;
  GetLiveTrackingDataFailure(this.errorMessage);
}

class GetLiveTrackingDataCubit extends Cubit<GetLiveTrackingDataState> {
  GetLiveTrackingDataCubit() : super(GetLiveTrackingDataInitial());

  final GetLiveTrackingDataRepository _repository =
      GetLiveTrackingDataRepository();

  Timer? _timer;
  LiveTrackingDataModel? _lastKnownData;
  VoidCallback? onTransientError;

  void startPolling({required String orderId}) {
    _timer?.cancel();
    _fetch(orderId);
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetch(orderId),
    );
  }

  Future<void> _fetch(String orderId) async {
    if (_lastKnownData == null && state is! GetLiveTrackingDataLoading) {
      if (!isClosed) emit(GetLiveTrackingDataLoading());
    }
    try {
      final data = await _repository.getLiveTrackingData(orderId: orderId);
      _lastKnownData = data;
      if (!isClosed) emit(GetLiveTrackingDataSuccess(data));
    } catch (e) {
      if (_lastKnownData == null && !isClosed) {
        emit(GetLiveTrackingDataFailure(e.toString()));
      } else {
        // Keep last known position; notify caller so it can show a snackbar.
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
