import 'package:fixit_provider/screens/app_pages_screens/add_new_location/layouts/county_drop_down.dart';
import 'package:fixit_provider/screens/app_pages_screens/add_new_location/layouts/state_drop_down.dart';

import '../../../../config.dart';

class LocationTextFieldLayout extends StatelessWidget {
  const LocationTextFieldLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewLocationProvider>(builder: (context2, value, child) {
      return Consumer<LocationProvider>(
          builder: (context2, locationCtrl, child) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          textCommon.dmSensMediumDark14(context, text: translations!.street),
          const VSpace(Sizes.s8),
          TextFieldCommon(
              focusNode: value.streetFocus,
              validator: (add) => validation.addressValidation(context, add),
              controller: value.streetCtrl,
              hintText: translations!.street!,
              prefixIcon: eSvgAssets.address),
          /*  const VSpace(Sizes.s15), */
          /*  textCommon.dmSensMediumDark14(context,
              text: translations!.areaLocality),
          const VSpace(Sizes.s8),
          TextFieldCommon(
              focusNode: value.addressFocus,
              validator: (add) => validation.dynamicTextValidation(
                  context, add, translations!.pleaseEnterArea),
              controller: value.addressCtrl,
              hintText: translations!.areaLocality!,
              prefixIcon: eSvgAssets.address),
 */
          // RowTextBoxLayoutWithoutContainer(
          //     focusNode1: value.latitudeFocus,
          //     focusNode2: value.longitudeFocus,
          //     icon1: eSvgAssets.locationOut,
          //     icon2: eSvgAssets.locationOut,
          //     text1: translations!.latitude,
          //     text2: translations!.longitude,
          //     textEditingController1: value.latitudeCtrl,
          //     textEditingController2: value.longitudeCtrl,
          //     validator1: (val) => validation.dynamicTextValidation(
          //         context, val, translations!.pleaseEnterLatitude),
          //     validator2: (val) => validation.dynamicTextValidation(
          //         context, val, translations!.pleaseEnterLongitude)),

          const VSpace(Sizes.s15),
          textCommon.dmSensMediumDark14(context, text: translations!.country),
          const VSpace(Sizes.s8),

          /* StateCountryDropdown(
              items: countryStateList,
              selectedItem: value.country,
              validator: (val) => validation.countryStateValidation(context, val, translations!.pleaseSelectCountry),
            hint: translations!.country,
              onChanged: (val) => value.onChangeCountryCompany(val))*/
          CountryDropDown(),
          const VSpace(Sizes.s15),
          textCommon.dmSensMediumDark14(context, text: translations!.state),

          const VSpace(Sizes.s8),
          StateDropDown(),
          // StateCountryDropdown(
          //     icon: eSvgAssets.state,
          //     items: stateList,
          //     validator: (val) => validation.countryStateValidation(context, val, translations!.pleaseSelectState),
          //     selectedItem: value.state,
          //     onChanged: (val) => value.onChangeStateCompany(val,value.state!),hint: translations!.state),
          const VSpace(Sizes.s15),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  textCommon.dmSensMediumDark14(context,
                      text: translations!.city),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                      focusNode: value.cityFocus,
                      validator: (city) =>
                          validation.cityValidation(context, city),
                      controller: value.cityCtrl,
                      hintText: translations!.city!,
                      prefixIcon: eSvgAssets.locationOut)
                ])),
            const HSpace(Sizes.s18),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  textCommon.dmSensMediumDark14(context,
                      text: translations!.zipCode),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                      keyboardType: TextInputType.number,
                      focusNode: value.zipFocus,
                      validator: (zip) =>
                          validation.cityValidation(context, zip),
                      controller: value.zipCtrl,
                      hintText: translations!.zipCode!,
                      prefixIcon: eSvgAssets.zipcode)
                ]))
          ]),
        ]);
      });
    });
  }
}
