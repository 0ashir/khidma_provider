import '../../../../config.dart';

class PaymentMethodLayout extends StatelessWidget {
  final PaymentMethods? data;

  //final dynamic? data;
  final int? index, selectIndex;
  final GestureTapCallback? onTap;

  const PaymentMethodLayout(
      {super.key, this.data, this.onTap, this.index, this.selectIndex});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<PaymentProvider>(context, listen: true);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        if (data!.slug != "cash")
          CommonImageLayout(
              height: Sizes.s45,
              boxFit: BoxFit.contain,
              width: Sizes.s70,
              image: data!.image,
              assetImage: eImageAssets.noImageFound1),
        const HSpace(Sizes.s12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(capitalizeFirstLetter(language(context, data!.name!)),
              style: appCss.dmDenseSemiBold15.textColor(selectIndex == index
                  ? appColor(context).appTheme.primary
                  : appColor(context).appTheme.darkText))
        ])
      ]),
      CommonRadio(index: index, selectedIndex: selectIndex, onTap: onTap)
    ])
        .paddingSymmetric(vertical: Insets.i12, horizontal: Insets.i15)
        .boxBorderExtension(context,
            bColor: selectIndex == index
                ? appColor(context).appTheme.stroke
                : appColor(context).appTheme.fieldCardBg,
            isShadow: selectIndex == index ? false : true)
        .paddingSymmetric(vertical: Insets.i10, horizontal: Sizes.s20)
        .inkWell(onTap: onTap);
  }
}
