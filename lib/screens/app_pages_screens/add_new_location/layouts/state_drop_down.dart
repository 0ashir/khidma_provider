import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../config.dart';

class StateDropDown extends StatelessWidget {
  final bool isAddLocation, isUpdate;

  const StateDropDown({
    super.key,
    this.isAddLocation = false,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer4<LanguageProvider, NewLocationProvider,
        SignUpCompanyProvider, CompanyDetailProvider>(
      builder: (context2, lang, value, signup, company, child) {
        return Consumer<LocationProvider>(
            builder: (context2, locationCtrl, child) {
          // 1. Determine correct state list
          CountryStateModel? selectedCountry = isUpdate
              ? company.country
              : !isAddLocation
                  ? value.country
                  : signup.country;

          List<StateModel> statesList = selectedCountry?.state ?? [];

          StateModel? selectedState = isUpdate
              ? company.state
              : !isAddLocation
                  ? value.state
                  : signup.state;

          return Stack(alignment: Alignment.centerLeft, children: [
            DropdownButton2<StateModel>(
              underline: Container(),
              dropdownStyleData: DropdownStyleData(
                maxHeight: Sizes.s400,
                decoration:
                    BoxDecoration(color: appColor(context).appTheme.whiteBg),
              ),
              isExpanded: true,
              isDense: true,
              iconStyleData: IconStyleData(
                icon: SvgPicture.asset(eSvgAssets.dropDown,
                    colorFilter: ColorFilter.mode(
                        (isUpdate
                                    ? company.state
                                    : !isAddLocation
                                        ? value.state
                                        : signup.state) ==
                                null
                            ? appColor(context).appTheme.lightText
                            : appColor(context).appTheme.darkText,
                        BlendMode.srcIn)),
              ),
              hint: Text(
                language(context, translations!.selectState),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.lightText),
              ),
              items: statesList.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name ?? '',
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                );
              }).toList(),
              value: selectedState,
              onChanged: (val) {
                StateModel? state = val;
                if (isUpdate) {
                  company.state = state;
                  company.stateCtrl.text = state?.name ?? '';
                  company.onChangeStateCompany(state!.id, state);
                } else {
                  if (!isAddLocation) {
                    value.state = state;
                    value.stateCtrl.text = state?.name ?? '';
                    value.onChangeStateCompany(state!.id, state);
                  } else {
                    signup.state = state;
                    signup.stateCtrl.text = state?.name ?? '';
                    signup.onChangeStateCompany(state!.id, state);
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
              menuItemStyleData: const MenuItemStyleData(height: Sizes.s40),
              dropdownSearchData: DropdownSearchData(
                  searchController: isUpdate
                      ? company.stateCtrl
                      : !isAddLocation
                          ? value.stateCtrl
                          : signup.stateCtrl,
                  searchInnerWidgetHeight: Sizes.s60,
                  searchInnerWidget: Container(
                      height: Sizes.s60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.s10, vertical: Sizes.s10),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: isUpdate
                            ? company.stateCtrl
                            : !isAddLocation
                                ? value.stateCtrl
                                : signup.stateCtrl,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          hintText: language(context, translations!.searchHere),
                          hintStyle: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      )),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.name
                        .toString()
                        .toLowerCase()
                        .contains(searchValue);
                  }),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  if (isUpdate) {
                    company.stateCtrl.clear();
                  } else if (!isAddLocation) {
                    value.stateCtrl.clear();
                  } else {
                    signup.stateCtrl.clear();
                  }
                }
              },
            ),
            Align(
              alignment: lang.getLocal() == "ar"
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: SvgPicture.asset(eSvgAssets.country,
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                          (isUpdate
                                      ? company.state
                                      : !isAddLocation
                                          ? value.state
                                          : signup.state) ==
                                  null
                              ? appColor(context).appTheme.lightText
                              : appColor(context).appTheme.darkText,
                          BlendMode.srcIn))
                  .paddingSymmetric(horizontal: Insets.i15),
            )
          ]);
        });
      },
    );
  }
}
