import 'package:flutter/cupertino.dart';

import '../config.dart';

class ServicemenChargesSheet extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final GestureTapCallback? onTap;

  const ServicemenChargesSheet(
      {super.key, this.formKey, this.focusNode, this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.44,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, translations!.servicemenCharge),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText)),
                const Icon(CupertinoIcons.multiply)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i20),
              const VSpace(Sizes.s5),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language(context, translations!.charges),
                              style: appCss.dmDenseMedium14.textColor(
                                  appColor(context).appTheme.darkText)),
                          const VSpace(Sizes.s8),
                          Stack(
                              alignment: rtl(context)
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              children: [
                                TextFieldCommon(
                                    validator: (val) => validation
                                        .commonValidation(context, val),
                                    keyboardType: TextInputType.number,
                                    hintText: translations!.enterAmount!,
                                    focusNode: focusNode,
                                    controller: controller,
                                    prefixIcon: eSvgAssets.dollar),
                                Text("/${language(context, translations!.perServicemen)}",
                                        style: appCss.dmDenseRegular14
                                            .textColor(appColor(context)
                                                .appTheme
                                                .lightText))
                                    .paddingSymmetric(horizontal: Insets.i15)
                              ]),
                          const VSpace(Sizes.s12),
                          Text(
                              language(context,
                                  translations!.enterThePayableCharges),
                              style: appCss.dmDenseRegular12
                                  .textColor(appColor(context).appTheme.red))
                        ]).paddingAll(Insets.i15).boxShapeExtension(
                        color: appColor(context).appTheme.fieldCardBg)),
                const VSpace(Sizes.s20),
                BottomSheetButtonCommon(
                    textTwo: translations!.done,
                    applyTap: onTap,
                    textOne: translations!.cancel,
                    clearTap: () => route.pop(context))
              ]).paddingSymmetric(horizontal: Insets.i20)
            ])).bottomSheetExtension(context));
  }
}
