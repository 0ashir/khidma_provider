import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/data/repository/jobRequestRepository.dart';

abstract class ApplyForCustomJobCubitState {}

class ApplyForCustomJobInitial extends ApplyForCustomJobCubitState {}

class ApplyForCustomJobInProgress extends ApplyForCustomJobCubitState {}

class ApplyForCustomJobSuccess extends ApplyForCustomJobCubitState {
  final String error;
  final String message;

  ApplyForCustomJobSuccess({required this.error, required this.message});
}

class ApplyForCustomJobFailure extends ApplyForCustomJobCubitState {
  final String errorMessage;

  ApplyForCustomJobFailure(this.errorMessage);
}

class ApplyForCustomJobCubit extends Cubit<ApplyForCustomJobCubitState> {
  final jobRequestRepository _jobRequestRepository = jobRequestRepository();

  ApplyForCustomJobCubit() : super(ApplyForCustomJobInitial());

  Future<void> applyForCustomJob(
    String? id,
    String? counterPrice,
    String? coverNote,
    String? duration,
    String? taxId,
  ) async {
    try {
      emit(ApplyForCustomJobInProgress());

      final response = await _jobRequestRepository.applyForCustomJob(
        counterPrice: counterPrice,
        coverNote: coverNote,
        duration: duration,
        id: id,
        taxId: taxId,
      );
      final message = response['message'] is Map<String, dynamic>
          ? response['message'].values.join(", ")
          : response['message'].toString();

      // Log custom job application
      ClarityService.logAction(ClarityActions.customJobApplied, {
        'job_request_id': id ?? '',
        'counter_price': counterPrice ?? '',
        'duration': duration ?? '',
      });

      emit(
        ApplyForCustomJobSuccess(
          error: response['error'].toString(),
          message: message,
        ),
      );
    } catch (e) {
      emit(ApplyForCustomJobFailure(e.toString()));
    }
  }
}
