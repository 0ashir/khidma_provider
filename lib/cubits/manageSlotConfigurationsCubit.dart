import '../app/generalImports.dart';

abstract class ManageSlotConfigurationsState {}

class ManageSlotConfigurationsInitial extends ManageSlotConfigurationsState {}

class ManageSlotConfigurationsInProgress
    extends ManageSlotConfigurationsState {}

class ManageSlotConfigurationsSuccess extends ManageSlotConfigurationsState {
  final String message;
  ManageSlotConfigurationsSuccess(this.message);
}

class ManageSlotConfigurationsFailure extends ManageSlotConfigurationsState {
  final String errorMessage;
  ManageSlotConfigurationsFailure(this.errorMessage);
}

class ManageSlotConfigurationsBookingConflict
    extends ManageSlotConfigurationsState {
  final String message;
  final List<Map<String, dynamic>> bookings;
  ManageSlotConfigurationsBookingConflict({
    required this.message,
    required this.bookings,
  });
}

class ManageSlotConfigurationsCubit
    extends Cubit<ManageSlotConfigurationsState> {
  ManageSlotConfigurationsCubit() : super(ManageSlotConfigurationsInitial());

  final SlotManagementRepository _repository = SlotManagementRepository();

  Future<void> manageShifts(List<Map<String, dynamic>> shifts) async {
    try {
      emit(ManageSlotConfigurationsInProgress());
      final params = <String, dynamic>{'type': 'shifts'};
      for (int i = 0; i < shifts.length; i++) {
        final s = shifts[i];
        params['shifts[$i][day]'] = s['day'];
        params['shifts[$i][shift_number]'] = s['shift_number'];
        params['shifts[$i][opening_time]'] = s['opening_time'];
        params['shifts[$i][closing_time]'] = s['closing_time'];
        params['shifts[$i][is_open]'] = s['is_open'];
      }
      final response = await _repository.manageSlotConfigurations(
        parameters: params,
      );
      emit(
        ManageSlotConfigurationsSuccess(
          response['message']?.toString() ?? 'success',
        ),
      );
    } catch (e) {
      emit(ManageSlotConfigurationsFailure(e.toString()));
    }
  }

  Future<void> manageSlotSettings(Map<String, dynamic> settings) async {
    try {
      emit(ManageSlotConfigurationsInProgress());
      final params = <String, dynamic>{
        'type': 'slot_configurations',
        ...settings,
      };
      final response = await _repository.manageSlotConfigurations(
        parameters: params,
      );
      emit(
        ManageSlotConfigurationsSuccess(
          response['message']?.toString() ?? 'success',
        ),
      );
    } catch (e) {
      emit(ManageSlotConfigurationsFailure(e.toString()));
    }
  }

  Future<void> manageLeaves(List<Map<String, dynamic>> leaves) async {
    try {
      emit(ManageSlotConfigurationsInProgress());
      final params = <String, dynamic>{'type': 'leaves'};
      for (int i = 0; i < leaves.length; i++) {
        final l = leaves[i];
        params['leaves[$i][leave_date]'] = l['leave_date'];
        params['leaves[$i][shift_number]'] = l['shift_number'];
      }
      final response = await _repository.manageSlotConfigurations(
        parameters: params,
      );
      if (response['booking_conflict'] == true) {
        final rawList = response['bookings'];
        final bookings = (rawList is List)
            ? rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList()
            : <Map<String, dynamic>>[];
        emit(
          ManageSlotConfigurationsBookingConflict(
            message: response['message']?.toString() ?? '',
            bookings: bookings,
          ),
        );
      } else {
        emit(
          ManageSlotConfigurationsSuccess(
            response['message']?.toString() ?? 'success',
          ),
        );
      }
    } catch (e) {
      emit(ManageSlotConfigurationsFailure(e.toString()));
    }
  }

  Future<void> deleteLeave(String leaveDate) async {
    try {
      emit(ManageSlotConfigurationsInProgress());
      final response = await _repository.deleteLeave(leaveDate: leaveDate);
      emit(
        ManageSlotConfigurationsSuccess(
          response['message']?.toString() ?? 'success',
        ),
      );
    } catch (e) {
      emit(ManageSlotConfigurationsFailure(e.toString()));
    }
  }
}
