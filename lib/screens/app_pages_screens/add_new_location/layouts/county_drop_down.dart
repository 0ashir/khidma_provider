import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../config.dart';

class CountryDropDown extends StatelessWidget {
  final bool isAddLocation, isUpdate;

  const CountryDropDown(
      {super.key, this.isAddLocation = false, this.isUpdate = false});

  @override
  Widget build(BuildContext context) {
    return Consumer4<LanguageProvider, NewLocationProvider,
            SignUpCompanyProvider, CompanyDetailProvider>(
        builder: (context2, lang, value, signup, company, child) {
      return Consumer<LocationProvider>(
          builder: (context2, locationCtrl, child) {
        CountryStateModel? selectedCountry = isUpdate
            ? company.country
            : !isAddLocation
                ? value.country
                : signup.country;

        return Stack(alignment: Alignment.centerLeft, children: [
          DropdownButton2<CountryStateModel>(
              underline: Container(),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: Sizes.s400,
                  decoration:
                      BoxDecoration(color: appColor(context).appTheme.whiteBg)),
              isExpanded: true,
              isDense: true,
              iconStyleData: IconStyleData(
                  icon: SvgPicture.asset(eSvgAssets.dropDown,
                      colorFilter: ColorFilter.mode(
                          isUpdate
                              ? company.country == null
                                  ? appColor(context).appTheme.lightText
                                  : appColor(context).appTheme.darkText
                              : !isAddLocation
                                  ? value.country == null
                                      ? appColor(context).appTheme.lightText
                                      : appColor(context).appTheme.darkText
                                  : signup.country == null
                                      ? appColor(context).appTheme.lightText
                                      : appColor(context).appTheme.darkText,
                          BlendMode.srcIn))),
              //searchable IconStyle
              hint: Text(language(context, translations!.selectCountry),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.lightText)),
              //Searchable DropDown Title Text
              items: [
                if (isUpdate)
                  ...company.countryList.map((e) => DropdownMenuItem(
                      value: e,
                      //Searchable DropDown SubTitle Text
                      child: Text(
                        e.name!,
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.darkText),
                      ))),
                if (!isAddLocation)
                  ...value.countryList.map((e) => DropdownMenuItem(
                      value: e,
                      //Search able DropDown SubTitle Text
                      child: Text(
                        e.name!,
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.darkText),
                      ))),
                if (isAddLocation)
                  ...signup.countryList.map((e) => DropdownMenuItem(
                      value: e,
                      //Searchable DropDown SubTitle Text
                      child: Text(
                        e.name!,
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.darkText),
                      )))
              ],
              value: selectedCountry,
              onChanged: (val) {
                CountryStateModel? country = val;
                if (isUpdate) {
                  company.country = country;
                  company.countryCtrl.text = country?.name ?? '';
                  company.onChangeCountryCompany(context, country!.id, country);
                } else {
                  if (!isAddLocation) {
                    value.country = country;
                    value.countryCtrl.text = country?.name ?? '';
                    value.onChangeCountryCompany(
                        context, country!.id!, country);
                  } else {
                    signup.country = country;
                    signup.countryCtrl.text = country?.name ?? '';
                    signup.onChangeCountryCompany(
                        context, country!.id, country);
                  }
                }
              },
              buttonStyleData: ButtonStyleData(
                  elevation: 0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      color: appColor(context).appTheme.whiteBg,
                      border:
                          Border.all(color: appColor(context).appTheme.trans)),
                  padding: EdgeInsets.only(
                      left: rtl(context) ? Insets.i20 : Sizes.s30,
                      right: rtl(context) ? Sizes.s30 : Sizes.s20),
                  height: Sizes.s52),
              //search ButtonStyle Data
              menuItemStyleData: const MenuItemStyleData(height: Sizes.s40),
              dropdownSearchData: DropdownSearchData(
                  searchController: isUpdate
                      ? company.countryCtrl
                      : !isAddLocation
                          ? value.countryCtrl
                          : signup.countryCtrl,
                  searchInnerWidgetHeight: Sizes.s60,
                  searchInnerWidget: Container(
                      height: Sizes.s60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.s10, vertical: Sizes.s10),
                      child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: isUpdate
                              ? company.countryCtrl
                              : !isAddLocation
                                  ? value.countryCtrl
                                  : signup.countryCtrl,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              hintText:
                                  language(context, translations!.searchHere),
                              hintStyle: const TextStyle(fontSize: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))))),
                  //searchable layout container
                  searchMatchFn: (item, searchValue) {
                    return item.value!.name
                        .toString()
                        .toLowerCase()
                        .contains(searchValue);
                  }),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  isUpdate
                      ? company.countryCtrl.clear()
                      : !isAddLocation
                          ? value.countryCtrl.clear()
                          : signup.countryCtrl.clear();
                }
              }),
          Align(
            alignment: lang.getLocal() == "ar"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: SvgPicture.asset(eSvgAssets.country,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                        isUpdate
                            ? company.country == null
                                ? appColor(context).appTheme.lightText
                                : appColor(context).appTheme.darkText
                            : !isAddLocation
                                ? value.country == null
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.darkText
                                : signup.country == null
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.darkText,
                        BlendMode.srcIn))
                .paddingSymmetric(horizontal: Insets.i15),
          )
        ]);
      });
    });
  }
}
