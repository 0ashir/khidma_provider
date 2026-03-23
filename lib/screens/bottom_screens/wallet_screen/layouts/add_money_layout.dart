// ignore_for_file: unused_field

import 'package:fixit_provider/widgets/wallet_drop_down.dart';

import '../../../../config.dart';

class AddMoneyLayout extends StatefulWidget {
  final BuildContext originalContext;

  const AddMoneyLayout({super.key, required this.originalContext});

  @override
  State<AddMoneyLayout> createState() => _AddMoneyLayoutState();
}

class _AddMoneyLayoutState extends State<AddMoneyLayout> {
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(builder: (context1, value, child) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                  shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.only(
                          topLeft: SmoothRadius(
                              cornerRadius: AppRadius.r20, cornerSmoothing: 1),
                          topRight: SmoothRadius(
                              cornerRadius: AppRadius.r20,
                              cornerSmoothing: 0.4))),
                  color: appColor(context).appTheme.whiteBg),
              child: SingleChildScrollView(
                  child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, translations!.addMoney),
                          style: appCss.dmDenseMedium18
                              .textColor(appColor(context).appTheme.darkText)),
                      SvgPicture.asset(eSvgAssets.cross)
                          .inkWell(onTap: () => route.pop(context))
                    ]).paddingAll(Insets.i20),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(language(context, translations!.addForm),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                  const VSpace(Sizes.s8),
                  PaymentDropDownLayout(
                      icon: eSvgAssets.wallet,
                      val: value.wallet,
                      isIcon: true,
                      list: value.paymentList,
                      onChanged: (val) => value.onTapGateway(val)),
                  const VSpace(Sizes.s20),
                  Text(language(context, translations!.amount),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                      keyboardType: TextInputType.number,
                      focusNode: value.amountFocus,
                      controller: value.amountCtrl,
                      hintText: translations!.enterAmount!,
                      prefixIcon: eSvgAssets.dollar)
                ])
                    .paddingSymmetric(
                        vertical: Insets.i20, horizontal: Insets.i15)
                    .boxShapeExtension(
                        color: appColor(context).appTheme.fieldCardBg)
                    .paddingSymmetric(horizontal: Insets.i20),
                const VSpace(Sizes.s30),
                Row(children: [
                  Expanded(
                      child: ButtonCommon(
                          onTap: () => value.cancelTap(context),
                          title: translations!.cancel,
                          color: appColor(context).appTheme.whiteBg,
                          borderColor: appColor(context).appTheme.primary,
                          style: appCss.dmDenseSemiBold16
                              .textColor(appColor(context).appTheme.primary))),
                  const HSpace(Sizes.s15),
                  Expanded(
                      child: ButtonCommon(
                          title: translations!.addMoney,
                          onTap: () {
                            value.addToWallet(context);
                          }))
                ]).paddingSymmetric(horizontal: Insets.i20)
              ]))));
    });
  }
}
