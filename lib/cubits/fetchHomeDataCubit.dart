import 'package:edemand_partner/data/model/home/homeDataModel.dart';

import '../../app/generalImports.dart';

abstract class FetchHomeDataState {}

class FetchHomeDataInitial extends FetchHomeDataState {}

class FetchHomeDataInProgress extends FetchHomeDataState {}

class FetchHomeDataSuccess extends FetchHomeDataState {
  final HomeDataModel homedata;
  FetchHomeDataSuccess({required this.homedata});
}

class FetchHomeDataFailure extends FetchHomeDataState {
  final String errorMessage;

  FetchHomeDataFailure(this.errorMessage);
}

class FetchHomeDataCubit extends Cubit<FetchHomeDataState> {
  final HomeDataRepository _homeDataRepository = HomeDataRepository();

  FetchHomeDataCubit() : super(FetchHomeDataInitial());

  Future<void> getHomeData() async {
    try {
      emit(FetchHomeDataInProgress());
      final HomeDataModel result = await _homeDataRepository.fetchHomeData();

      emit(FetchHomeDataSuccess(homedata: result));
    } catch (e) {
      emit(FetchHomeDataFailure(e.toString()));
    }
  }
}
