import '../../app/generalImports.dart';

abstract class UpdateBookingStatusState {}

class UpdateBookingStatusInitial extends UpdateBookingStatusState {}

class UpdateBookingStatusInProgress extends UpdateBookingStatusState {}

class UpdateBookingStatusSuccess extends UpdateBookingStatusState {
  final int orderId;
  final String status;
  final String translatedStatus;
  final String error;
  final String message;
  final List<dynamic> imagesList;
  final List<dynamic>? additionalCharges;

  UpdateBookingStatusSuccess({
    required this.orderId,
    required this.status,
    required this.translatedStatus,
    required this.error,
    required this.message,
    required this.imagesList,
    required this.additionalCharges,
  });
}

class UpdateBookingStatusFailure extends UpdateBookingStatusState {
  final String errorMessage;

  UpdateBookingStatusFailure(this.errorMessage);
}

class UpdateBookingStatusCubit extends Cubit<UpdateBookingStatusState> {
  final BookingsRepository _bookingsRepository = BookingsRepository();

  UpdateBookingStatusCubit() : super(UpdateBookingStatusInitial());

  Future<void> updateBookingStatus({
    required int orderId,
    required int customerId,
    required String status,
    required String translatedStatus,
    required String otp,
    List<Map<String, dynamic>>? proofData,
    List<Map<String, dynamic>>? additionalCharges,
    String? time,
    String? date,
    String? cancelReasonId,
    String? additionalInfo,
  }) async {
    try {
      emit(UpdateBookingStatusInProgress());

      final Map<String, dynamic> response = await _bookingsRepository
          .updateBookingStatus(
            customerId: customerId,
            orderId: orderId,
            status: status,
            otp: otp,
            date: date,
            time: time,
            proofData: proofData,
            additionalCharges: additionalCharges,
            cancelReasonId: cancelReasonId,
            additionalInfo: additionalInfo,
          );
      // Don't translate this because we need to send this title in api;
      final List<Map<String, String>> getStatusForApi = [
        {'value': '1', 'title': 'awaiting'},
        {'value': '2', 'title': 'confirmed'},
        {'value': '3', 'title': 'started'},
        {'value': '4', 'title': 'rescheduled'},
        {'value': '5', 'title': 'booking_ended'},
        {'value': '6', 'title': 'completed'},
        {'value': '7', 'title': 'cancelled'},
      ];
      // Get status title from getStatusForApi if status is numeric
      String statusTitle = status.toLowerCase().trim();
      final statusMap = getStatusForApi.firstWhere(
        (item) => item['value'] == status,
        orElse: () => <String, String>{},
      );
      if (statusMap.isNotEmpty && statusMap['title'] != null) {
        statusTitle = statusMap['title']!;
      }

      // Log booking status update based on status
      final String clarityAction;
      switch (statusTitle) {
        // Confirmed status (value: '2', title: 'confirmed')
        case '2':
        case 'confirmed':
        case 'accept':
        case 'accepted':
          clarityAction = ClarityActions.bookingAccepted;
          break;

        // Cancelled status (value: '7', title: 'cancelled')
        case '7':
        case 'cancelled':
        case 'cancel':
          clarityAction = ClarityActions.bookingCancelled;
          break;

        // Completed status (value: '6', title: 'completed')
        case '6':
        case 'completed':
        case 'complete':
          clarityAction = ClarityActions.bookingCompleted;
          break;

        // Rejected status
        case 'reject':
        case 'rejected':
          clarityAction = ClarityActions.bookingRejected;
          break;

        // Other statuses from getStatusForApi
        case '1':
        case 'awaiting':
        case '3':
        case 'started':
        case '4':
        case 'rescheduled':
        case '5':
        case 'booking_ended':
          clarityAction = ClarityActions.bookingStatusUpdated;
          break;

        default:
          clarityAction = ClarityActions.bookingStatusUpdated;
      }

      ClarityService.logAction(clarityAction, {
        'booking_id': orderId.toString(),
        'status': status,
        'customer_id': customerId.toString(),
      });

      emit(
        UpdateBookingStatusSuccess(
          message: response['message'],
          error: response['error'].toString(),
          orderId: orderId,
          status: status,
          translatedStatus: translatedStatus,
          imagesList: response['data'] ?? [],
          additionalCharges: additionalCharges,
        ),
      );
    } catch (e) {
      emit(UpdateBookingStatusFailure(e.toString()));
    }
  }
}
