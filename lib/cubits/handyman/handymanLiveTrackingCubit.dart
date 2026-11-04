import '../../app/generalImports.dart';
import '../../data/repository/handyman/handymanLiveTrackingRepository.dart';

abstract class HandymanLiveTrackingState {
  const HandymanLiveTrackingState();
}

class HandymanLiveTrackingInitial extends HandymanLiveTrackingState {
  const HandymanLiveTrackingInitial();
}

class HandymanLiveTrackingActive extends HandymanLiveTrackingState {
  final double? latitude;
  final double? longitude;
  bool get hasPosition => latitude != null && longitude != null;
  const HandymanLiveTrackingActive({this.latitude, this.longitude});
}

class HandymanLiveTrackingStopped extends HandymanLiveTrackingState {
  const HandymanLiveTrackingStopped();
}

class HandymanLiveTrackingFailure extends HandymanLiveTrackingState {
  final String errorMessage;
  HandymanLiveTrackingFailure(this.errorMessage);
}

class HandymanLiveTrackingCubit extends Cubit<HandymanLiveTrackingState>
    with WidgetsBindingObserver {
  HandymanLiveTrackingCubit() : super(const HandymanLiveTrackingInitial()) {
    WidgetsBinding.instance.addObserver(this);
  }

  final HandymanLiveTrackingRepository _repository =
      HandymanLiveTrackingRepository();

  StreamSubscription<Position>? _positionSubscription;
  Timer? _firstFixTimer;
  String? _activeBookingId;
  bool _pausedByLifecycle = false;

  Future<void> startTracking({required String bookingId}) async {
    if (state is HandymanLiveTrackingActive) return;

    _activeBookingId = bookingId;
    // Emit active immediately (no position yet) so UI switches to "tracking" mode
    if (!isClosed) emit(const HandymanLiveTrackingActive());
    _beginStream(bookingId);
  }

  void _beginStream(String bookingId) {
    // No foregroundNotificationConfig: tracking stays foreground-only and
    // stops automatically once the app is backgrounded, see didChangeAppLifecycleState.
    final LocationSettings settings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
            intervalDuration: const Duration(seconds: 5),
          )
        : AppleSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
            pauseLocationUpdatesAutomatically: false,
          );

    // Fail visibly instead of waiting forever when no position ever arrives.
    _firstFixTimer?.cancel();
    _firstFixTimer = Timer(const Duration(seconds: 30), () {
      final current = state;
      if (current is HandymanLiveTrackingActive && !current.hasPosition) {
        stopTracking();
        if (!isClosed) emit(HandymanLiveTrackingFailure('noLocationFound'));
      }
    });

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: settings).listen(
          (Position position) async {
            _firstFixTimer?.cancel();
            try {
              await _repository.updateLocation(
                bookingId: bookingId,
                latitude: position.latitude,
                longitude: position.longitude,
              );
              // Update state with latest position for mini map
              if (!isClosed) {
                emit(
                  HandymanLiveTrackingActive(
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ),
                );
              }
            } catch (e) {
              stopTracking();
              if (!isClosed) emit(HandymanLiveTrackingFailure(e.toString()));
            }
          },
          onError: (Object e) {
            stopTracking();
            if (!isClosed) emit(HandymanLiveTrackingFailure(e.toString()));
          },
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.detached) {
      if (state is HandymanLiveTrackingActive && _activeBookingId != null) {
        _pausedByLifecycle = true;
        _firstFixTimer?.cancel();
        _positionSubscription?.cancel();
        _positionSubscription = null;
      }
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (_pausedByLifecycle && _activeBookingId != null) {
        _pausedByLifecycle = false;
        _beginStream(_activeBookingId!);
      }
    }
  }

  void stopTracking() {
    _activeBookingId = null;
    _pausedByLifecycle = false;
    _firstFixTimer?.cancel();
    _positionSubscription?.cancel();
    _positionSubscription = null;
    if (!isClosed) emit(const HandymanLiveTrackingStopped());
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _firstFixTimer?.cancel();
    _positionSubscription?.cancel();
    return super.close();
  }
}
