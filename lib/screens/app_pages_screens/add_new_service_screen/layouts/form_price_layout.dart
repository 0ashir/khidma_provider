import '../../../../config.dart';

class FormPriceLayout extends StatelessWidget {
  const FormPriceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AddNewServiceProvider>(
        builder: (context1, lang, value, child) {
      return Column(children: [
        ContainerWithTextLayout(title: language(context, translations!.price))
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        Container(
                decoration: ShapeDecoration(
                    color: appColor(context).appTheme.whiteBg,
                    shape: RoundedRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: AppRadius.r8, cornerSmoothing: 0))),
                child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: appArray.priceList
                            .asMap()
                            .entries
                            .map((e) => PriceLayout(
                                title: e.value["title"],
                                index: e.key,
                                selectIndex: value.selectIndex,
                                onTap: () => value.onChangePrice(e.key)))
                            .toList())
                    .paddingAll(Insets.i15))
            .paddingSymmetric(horizontal: Insets.i20),
        if (value.selectIndex == 0)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContainerWithTextLayout(
                    title: "${language(context, translations!.amount)} *")
                .paddingOnly(top: Insets.i24, bottom: Insets.i12),
            TextFieldCommon(
                    validator: (name) => validation.dynamicTextValidation(
                        context, name, "Please enter amount"),
                    keyboardType: TextInputType.number,
                    focusNode: value.amountFocus,
                    controller: value.amount,
                    hintText: translations!.enterAmt!,
                    prefixIcon: eSvgAssets.dollar)
                .padding(horizontal: Insets.i20)
          ]),
        if (value.selectIndex == 1)
          Column(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ContainerWithTextLayout(
                      title: "${language(context, translations!.amount)} *")
                  .paddingOnly(bottom: Insets.i12),
              TextFieldCommon(
                      keyboardType: TextInputType.number,
                      focusNode: value.amountFocus,
                      controller: value.amount,
                      hintText: translations!.enterAmt!,
                      prefixIcon: eSvgAssets.dollar)
                  .paddingSymmetric(horizontal: Sizes.s20)
            ]),
            const VSpace(Sizes.s20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ContainerWithTextLayout(
                      title: language(context, translations!.discount))
                  .paddingOnly(bottom: Insets.i12),
              TextFieldCommon(
                      keyboardType: TextInputType.number,
                      focusNode: value.discountFocus,
                      controller: value.discount,
                      hintText: translations!.addDic!,
                      prefixIcon: eSvgAssets.discount)
                  .paddingSymmetric(horizontal: Sizes.s20)
            ])
          ]).padding(top: Insets.i24),
        if (taxList.isNotEmpty)
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerWithTextLayout(
                        title: language(context, translations!.tax))
                    .paddingOnly(top: Insets.i24, bottom: Insets.i12),
                Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        // REMOVE the fixed height
                        width: double.infinity,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align text to top
                            children: [
                              SvgPicture.asset(eSvgAssets.receiptDiscount),
                              const HSpace(Insets.i10),
                              Expanded(
                                  child: Column(
                                      spacing: 10,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: taxList.map((tax) {
                                        return Text(tax.name!,
                                            style: appCss.dmDenseMedium14
                                                .textColor(appColor(context)
                                                    .appTheme
                                                    .lightText));
                                      }).toList()))
                            ]))
                    .boxShapeExtension(
                        color: appColor(context).appTheme.whiteBg)
                    .marginSymmetric(horizontal: Insets.i20)
              ]),

        // TaxDropDownLayout(
        //         doc: value.taxIndex,
        //         icon: eSvgAssets.receiptDiscount,
        //         hintText: translations!.selectTax,
        //         isIcon: true,
        //         tax: taxList,
        //         onChanged: (val) => value.onChangeTax(val))
        //     .paddingSymmetric(horizontal: Insets.i20),
        const VSpace(Sizes.s20),
        if (value.serviceOption != "scheduled")
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                flex: 8,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          language(context, translations!.enableAdvancePayment),
                          style: appCss.dmDenseSemiBold14
                              .textColor(appColor(context).appTheme.darkText)),
                    ])),
            const HSpace(Sizes.s25),
            Expanded(
                flex: 2,
                child: FlutterSwitchCommon(
                    value: value.isAdvancePayment,
                    onToggle: (val) => value.onTapAdvancePayment(val))),
          ])
              .paddingAll(Insets.i15)
              .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
              .paddingSymmetric(horizontal: Insets.i20),
        if (value.isAdvancePayment)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContainerWithTextLayout(
                    title:
                        "${language(context, translations!.advancePaymentPercentage)} *")
                .paddingOnly(top: Insets.i24, bottom: Insets.i12),
            TextFieldCommon(
                    validator: (name) =>
                        validation.advancePaymentValidation(context, name),
                    keyboardType: TextInputType.number,
                    focusNode: value.advancePaymentPercentageFocus,
                    controller: value.advancePaymentPercentage,
                    hintText: language(
                        context, translations!.enterAdvancePaymentPercentage),
                    prefixIcon: eSvgAssets.discount)
                .padding(horizontal: Insets.i20)
          ]),
        const VSpace(Sizes.s25),

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 8,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language(context, translations!.status),
                        style: appCss.dmDenseSemiBold14
                            .textColor(appColor(context).appTheme.darkText)),
                    Text(language(context, translations!.thisServiceCanBe),
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).appTheme.lightText))
                  ])),
          const HSpace(Sizes.s25),
          Expanded(
              flex: 2,
              child: FlutterSwitchCommon(
                  value: value.isSwitch,
                  onToggle: (val) => value.onTapSwitch(val))),
        ])
            .paddingAll(Insets.i15)
            .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
            .paddingSymmetric(horizontal: Insets.i20),
        const VSpace(Sizes.s25),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 8,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language(context, "Is Featured"),
                        style: appCss.dmDenseSemiBold14
                            .textColor(appColor(context).appTheme.darkText)),
                    Text(language(context, appFonts.enableToFeature),
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).appTheme.lightText))
                  ])),
          const HSpace(Sizes.s25),
          Expanded(
              flex: 2,
              child: FlutterSwitchCommon(
                  value: value.isFeatured,
                  onToggle: (val) => value.onChangeFeature(val)))
        ])
            .paddingAll(Insets.i15)
            .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
            .paddingSymmetric(horizontal: Insets.i20),
        // ContainerWithTextLayout(title: language(context, "Is Featured"))
        //     .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        // Row(children: [
        //   FlutterSwitchCommon(
        //       value: value.isFeatured,
        //       onToggle: (val) => value.onChangeFeature(val)),
        // ]).marginSymmetric(horizontal: Insets.i20),
      ]);
    });
  }
}
