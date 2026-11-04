import '../app/generalImports.dart';

abstract class FetchSlotConfigurationsState {}

class FetchSlotConfigurationsInitial extends FetchSlotConfigurationsState {}

class FetchSlotConfigurationsInProgress extends FetchSlotConfigurationsState {}

class FetchSlotConfigurationsSuccess extends FetchSlotConfigurationsState {
  final SlotConfigurationData data;
  FetchSlotConfigurationsSuccess(this.data);
}

class FetchSlotConfigurationsFailure extends FetchSlotConfigurationsState {
  final String errorMessage;
  FetchSlotConfigurationsFailure(this.errorMessage);
}

class FetchSlotConfigurationsCubit extends Cubit<FetchSlotConfigurationsState> {
  FetchSlotConfigurationsCubit() : super(FetchSlotConfigurationsInitial());

  final SlotManagementRepository _repository = SlotManagementRepository();

  Future<void> fetchSlotConfigurations() async {
    try {
      emit(FetchSlotConfigurationsInProgress());
      final data = await _repository.getSlotConfigurations();
      emit(FetchSlotConfigurationsSuccess(data));
    } catch (e) {
      emit(FetchSlotConfigurationsFailure(e.toString()));
    }
  }
}
