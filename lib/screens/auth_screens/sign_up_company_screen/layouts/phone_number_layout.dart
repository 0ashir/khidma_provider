//phone textBox
import '../../../../config.dart';
import '../../../../widgets/country_picker_custom/layouts/country_list_layout.dart';

class RegisterWidgetClass {
  /*  Widget phoneTextBox(context, controller, focus,
          {Function(CountryCodeCustom?)? onChanged,
          ValueChanged<String>? onFieldSubmitted,
          double? hPadding,
          dialCode}) =>
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CountryListLayout(onChanged: onChanged),
          const HSpace(Sizes.s4),
          Expanded(
              child: TextFieldCommon(
                  isNumber: true,
                  keyboardType: TextInputType.number,
                  validator: (phone) =>
                      Validation().phoneValidation(context, phone),
                  controller: controller,
                  onFieldSubmitted: onFieldSubmitted,
                  focusNode: focus,
                  hintText: language(context, translations!.enterPhoneNumber)))
        ]).paddingSymmetric(horizontal: hPadding ?? Insets.i20),
      ); */

  Widget phoneTextBox(context, controller, focus,
          {Function(CountryCodeCustom?)? onChanged,
          bool isValidator = true,
          ValueChanged<String>? onFieldSubmitted,
          double? hPadding,
          dialCode}) =>
      Consumer<ProfileDetailProvider>(
          builder: (context1, value, child) {
        return IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CountryListLayout(
              onChanged: onChanged,
              dialCode: dialCode,
            ),
            const HSpace(Sizes.s4),
            Expanded(
                child: TextFieldCommon(
                    keyboardType: TextInputType.number,
                    validator: isValidator == true
                        ? (phone) =>
                            Validation().phoneValidation(context, phone)
                        : null,
                    controller: controller,
                    onFieldSubmitted: onFieldSubmitted,
                    focusNode: focus,
                    isNumber: true,
                    hintText:
                        language(context, translations!.enterPhoneNumber)))
          ]).paddingSymmetric(horizontal: hPadding ?? Insets.i20),
        );
      });
}
