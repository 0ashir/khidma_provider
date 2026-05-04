import 'package:fixit_provider/providers/app_pages_provider/service_add_ons_provider.dart';

import '../../../../config.dart';

class AddOnsDescriptionForm extends StatelessWidget {
  const AddOnsDescriptionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServiceAddOnsProvider>(
        builder: (context, lang, value, child) {
      return Column(children: [
        ContainerWithTextLayout(
                title: "${translations!.title} (${lang.selectedLocaleService})")
            .paddingOnly(bottom: Insets.i8),
        TextFieldCommon(
                keyboardType: TextInputType.text,
                // focusNode: value.discountFocus,
                controller: value.title,
                hintText: language(context, translations!.enterTitle),
                prefixIcon: eSvgAssets.title)
            .padding(horizontal: Insets.i20, bottom: Insets.i15),
        ContainerWithTextLayout(title: translations!.price)
            .paddingOnly(bottom: Insets.i8),
        TextFieldCommon(
                keyboardType: TextInputType.number,
                // focusNode: value.amountFocus,
                controller: value.price,
                validator: (value) => validation.dynamicTextValidation(
                    context, value, translations!.enterAmount),
                hintText: language(context, translations!.enterAmt),
                prefixIcon: eSvgAssets.dollar)
            .padding(horizontal: Insets.i20, bottom: Insets.i15),
        if (value.isEdit == true)
          StatusLayoutCommon(
              title: translations!.status,
              value: value.isSwitch,
              onToggle: (val) => value.onTapSwitch(val))
      ]);
    });
  }
}
