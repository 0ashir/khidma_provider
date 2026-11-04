import 'package:edemand_partner/app/generalImports.dart';

abstract class FetchCountriesState {}

class FetchCountriesInitial extends FetchCountriesState {}

class FetchCountriesInProgress extends FetchCountriesState {}

class FetchCountriesSuccess extends FetchCountriesState {
  FetchCountriesSuccess({required this.countries});
  final List<CountryModel> countries;
}

class FetchCountriesFailure extends FetchCountriesState {
  FetchCountriesFailure({required this.errorMessage});
  final String errorMessage;
}

class FetchCountriesCubit extends Cubit<FetchCountriesState> {
  FetchCountriesCubit() : super(FetchCountriesInitial());
  final LocationDataRepository _repository = LocationDataRepository();

  Future<void> fetchCountries() async {
    try {
      emit(FetchCountriesInProgress());
      final List<CountryModel> countries = await _repository.getCountries();
      emit(FetchCountriesSuccess(countries: countries));
    } catch (e) {
      emit(FetchCountriesFailure(errorMessage: e.toString()));
    }
  }
}
