import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/data/repository/jobRequestRepository.dart';

abstract class ManageCustomJobValueState {}

class ManageCustomJobValueInitial extends ManageCustomJobValueState {}

class ManageCustomJobValueInProgress extends ManageCustomJobValueState {}

class ManageCustomJobValueSuccess extends ManageCustomJobValueState {
  ManageCustomJobValueSuccess();
}

class ManageCustomJobValueFailure extends ManageCustomJobValueState {
  ManageCustomJobValueFailure(this.errorMessage);

  final String errorMessage;
}

class ManageCustomJobValueCubit extends Cubit<ManageCustomJobValueState> {
  ManageCustomJobValueCubit() : super(ManageCustomJobValueInitial());

  final jobRequestRepository _jobRequestRepository = jobRequestRepository();

  Future ManageCustomJobValue({String? customJobValue}) async {
    try {
      emit(ManageCustomJobValueInProgress());

      final Map<String, dynamic> response = await _jobRequestRepository
          .fetchCustomJobValue(customJobValue: customJobValue);
      if (response['error']) {
        emit(ManageCustomJobValueFailure(response['message']));
      } else {
        UiUtils.rootNavigatorKey.currentContext!
            .read<FetchSystemSettingsCubit>()
            .updateAcceptingCustomJobs(customJobValue ?? '0');
        emit(ManageCustomJobValueSuccess());
      }
    } catch (e) {
      emit(ManageCustomJobValueFailure(e.toString()));
    }
  }
}
