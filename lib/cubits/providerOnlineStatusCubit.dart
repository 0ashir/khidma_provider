import '../app/generalImports.dart';

/// Provider online/offline switch (server: partner_details.is_online).
/// Offline providers are hidden from customers and cannot get new bookings.
class ProviderOnlineStatusState {
  const ProviderOnlineStatusState({
    this.isOnline,
    this.isLoading = false,
    this.isUpdating = false,
    this.message,
    this.isError = false,
    this.messageId = 0,
  });

  /// Null until the first load finishes.
  final bool? isOnline;
  final bool isLoading;
  final bool isUpdating;

  /// Message to show once (server text); [messageId] changes with each one.
  final String? message;
  final bool isError;
  final int messageId;

  ProviderOnlineStatusState copyWith({
    bool? isOnline,
    bool? isLoading,
    bool? isUpdating,
    String? message,
    bool? isError,
    int? messageId,
  }) {
    return ProviderOnlineStatusState(
      isOnline: isOnline ?? this.isOnline,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      messageId: messageId ?? this.messageId,
    );
  }
}

class ProviderOnlineStatusCubit extends Cubit<ProviderOnlineStatusState> {
  ProviderOnlineStatusCubit() : super(const ProviderOnlineStatusState());

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true));
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.getProviderOnlineStatus,
        parameter: {},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(response['message'].toString());
      }
      final data = response['data'];
      final int value = data is Map
          ? int.tryParse(data['is_online']?.toString() ?? '1') ?? 1
          : 1;
      if (isClosed) return;
      emit(state.copyWith(isOnline: value == 1, isLoading: false));
    } catch (_) {
      if (isClosed) return;
      // Keep the switch usable even if the status could not be loaded
      // (older server): the server default is online.
      emit(state.copyWith(isOnline: state.isOnline ?? true, isLoading: false));
    }
  }

  Future<void> setOnline(bool online) async {
    if (state.isUpdating) return;
    final bool? previous = state.isOnline;
    emit(state.copyWith(isOnline: online, isUpdating: true));
    try {
      final Map<String, dynamic> response = await ApiClient.post(
        url: ApiUrl.setProviderOnlineStatus,
        parameter: {'is_online': online ? 1 : 0},
        useAuthToken: true,
      );
      if (response['error'] == true) {
        throw ApiException(response['message'].toString());
      }
      if (isClosed) return;
      emit(
        state.copyWith(
          isOnline: online,
          isUpdating: false,
          message: response['message']?.toString() ?? '',
          isError: false,
          messageId: state.messageId + 1,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        ProviderOnlineStatusState(
          isOnline: previous,
          message: e.toString(),
          isError: true,
          messageId: state.messageId + 1,
        ),
      );
    }
  }
}
