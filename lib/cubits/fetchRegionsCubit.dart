import 'package:edemand_partner/app/generalImports.dart';

abstract class FetchRegionsState {}

class FetchRegionsInitial extends FetchRegionsState {}

class FetchRegionsInProgress extends FetchRegionsState {}

class FetchRegionsSuccess extends FetchRegionsState {
  FetchRegionsSuccess({required this.regions});
  final List<RegionModel> regions;
}

class FetchRegionsFailure extends FetchRegionsState {
  FetchRegionsFailure({required this.errorMessage});
  final String errorMessage;
}

class FetchRegionsCubit extends Cubit<FetchRegionsState> {
  FetchRegionsCubit() : super(FetchRegionsInitial());
  final LocationDataRepository _repository = LocationDataRepository();

  Future<void> fetchRegions({required String countryId}) async {
    try {
      emit(FetchRegionsInProgress());
      final List<RegionModel> regions = await _repository.getRegions(
        countryId: countryId,
      );
      emit(FetchRegionsSuccess(regions: regions));
    } catch (e) {
      emit(FetchRegionsFailure(errorMessage: e.toString()));
    }
  }

  void reset() => emit(FetchRegionsInitial());
}
