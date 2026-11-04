// ignore_for_file: prefer_final_locals

import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/data/model/countryCodeModel.dart';
import 'package:edemand_partner/data/repository/countryCodeRepository.dart';

abstract class CountryCodeState {}

class CountryCodeInitial extends CountryCodeState {}

class CountryCodeLoadingInProgress extends CountryCodeState {}

class CountryCodeFetchSuccess extends CountryCodeState {
  CountryCodeFetchSuccess({
    this.selectedCountry,
    this.countryList,
    this.temporaryCountryList,
  });

  final CountryCodeModel? selectedCountry;
  final List<CountryCodeModel>? countryList;
  final List<CountryCodeModel>? temporaryCountryList;
}

class CountryCodeFetchFail extends CountryCodeState {
  CountryCodeFetchFail(this.error);

  final dynamic error;
}

class CountryCodeCubit extends Cubit<CountryCodeState> {
  CountryCodeCubit() : super(CountryCodeInitial());

  CountryCodeRepository countryCodeRepository = CountryCodeRepository();

  Future<void> loadAllCountryCode(final BuildContext context) async {
    try {
      emit(CountryCodeLoadingInProgress());

      final countriesList = await countryCodeRepository.getCountries(context);

      // Get default country from API response
      CountryCodeModel? defaultCountry = await countryCodeRepository
          .getDefaultCountry(context);

      // If no default country from API, try to get from system settings
      if (defaultCountry == null) {
        defaultCountry = countriesList.isNotEmpty ? countriesList.first : null;
      }

      emit(
        CountryCodeFetchSuccess(
          selectedCountry: defaultCountry,
          countryList: countriesList,
          temporaryCountryList: countriesList,
        ),
      );
    } catch (e) {
      emit(CountryCodeFetchFail(e));
    }
  }

  void selectCountryCode(final CountryCodeModel country) {
    if (state is CountryCodeFetchSuccess) {
      emit(
        CountryCodeFetchSuccess(
          selectedCountry: country,
          countryList: (state as CountryCodeFetchSuccess).countryList,
          temporaryCountryList:
              (state as CountryCodeFetchSuccess).temporaryCountryList,
        ),
      );
    }
  }

  Future<CountryCodeModel> getCountryByCountryCode(
    BuildContext context, {
    required String countryLocale,
  }) async {
    final CountryCodeModel country = await countryCodeRepository
        .getCountryByCountryCode(context, countryLocale);
    return country;
  }

  void filterCountryCodeList(final String content) {
    if (state is CountryCodeFetchSuccess) {
      final List<CountryCodeModel>? mainList =
          (state as CountryCodeFetchSuccess).countryList;
      List<CountryCodeModel>? tempList = [];

      final CountryCodeModel? selectedCountry =
          (state as CountryCodeFetchSuccess).selectedCountry;

      for (int i = 0; i < mainList!.length; i++) {
        final CountryCodeModel country = mainList[i];

        if (country.countryName.toLowerCase().contains(content.toLowerCase()) ||
            country.callingCode.toLowerCase().contains(content.toLowerCase())) {
          if (!tempList.contains(country)) {
            tempList.add(country);
          }
        }
      }

      emit(
        CountryCodeFetchSuccess(
          temporaryCountryList: tempList,
          countryList: mainList,
          selectedCountry: selectedCountry,
        ),
      );
    }
  }

  void clearTemporaryList() {
    if (state is CountryCodeFetchSuccess) {
      final List<CountryCodeModel>? mainList =
          (state as CountryCodeFetchSuccess).countryList;
      final CountryCodeModel? selectedCountry =
          (state as CountryCodeFetchSuccess).selectedCountry;
      emit(
        CountryCodeFetchSuccess(
          temporaryCountryList: [],
          countryList: mainList,
          selectedCountry: selectedCountry,
        ),
      );
    }
  }

  void fillTemporaryList() {
    if (state is CountryCodeFetchSuccess) {
      final List<CountryCodeModel>? mainList =
          (state as CountryCodeFetchSuccess).countryList;
      final CountryCodeModel? selectedCountry =
          (state as CountryCodeFetchSuccess).selectedCountry;
      emit(
        CountryCodeFetchSuccess(
          temporaryCountryList: mainList,
          countryList: mainList,
          selectedCountry: selectedCountry,
        ),
      );
    }
  }

  String getSelectedCountryCode() =>
      (state as CountryCodeFetchSuccess).selectedCountry!.callingCode;

  String getSelectedCountryCodename() =>
      (state as CountryCodeFetchSuccess).selectedCountry!.countryCode;
}
