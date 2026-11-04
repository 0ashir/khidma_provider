import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/data/model/chat/reportReasonModel.dart';

abstract class GetCancellationReasonsState {}

class GetCancellationReasonsInitial extends GetCancellationReasonsState {}

class GetCancellationReasonsInProgress extends GetCancellationReasonsState {}

class GetCancellationReasonsFailure extends GetCancellationReasonsState {
  final String errorMessage;
  GetCancellationReasonsFailure({required this.errorMessage});
}

class GetCancellationReasonsSuccess extends GetCancellationReasonsState {
  final List<ReportReasonModel> reasons;
  GetCancellationReasonsSuccess({required this.reasons});
}

class GetCancellationReasonsCubit extends Cubit<GetCancellationReasonsState> {
  final BookingsRepository _bookingsRepository = BookingsRepository();

  GetCancellationReasonsCubit() : super(GetCancellationReasonsInitial());

  Future<void> getCancellationReasons() async {
    emit(GetCancellationReasonsInProgress());
    try {
      final reasons = await _bookingsRepository.getCancellationReasons();
      emit(GetCancellationReasonsSuccess(reasons: reasons));
    } catch (e) {
      emit(GetCancellationReasonsFailure(errorMessage: e.toString()));
    }
  }
}
