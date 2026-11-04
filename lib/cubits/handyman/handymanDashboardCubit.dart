import '../../app/generalImports.dart';

abstract class HandymanDashboardState {}

class HandymanDashboardInitial extends HandymanDashboardState {}

class HandymanDashboardInProgress extends HandymanDashboardState {}

class HandymanDashboardSuccess extends HandymanDashboardState {
  final HandymanDashboardModel data;
  HandymanDashboardSuccess(this.data);
}

class HandymanDashboardFailure extends HandymanDashboardState {
  final String errorMessage;
  HandymanDashboardFailure(this.errorMessage);
}

class HandymanDashboardCubit extends Cubit<HandymanDashboardState> {
  final HandymanDashboardRepository _repository = HandymanDashboardRepository();

  HandymanDashboardCubit() : super(HandymanDashboardInitial());

  Future<void> fetch() async {
    try {
      emit(HandymanDashboardInProgress());
      final data = await _repository.fetchDashboard();
      emit(HandymanDashboardSuccess(data));
    } catch (e) {
      emit(HandymanDashboardFailure(e.toString()));
    }
  }
}
