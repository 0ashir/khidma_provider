import '../../../../config.dart';

class UpdateBillSummaryBottom extends StatelessWidget {
  const UpdateBillSummaryBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context1, setState) {
      final value = Provider.of<AddExtraChargesProvider>(context);
      return SizedBox(
              height: MediaQuery.of(context).size.height / 2.15,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    BottomSheetTopLayout(
                        title: translations!.updateBillSummary),
                    const VSpace(Sizes.s25),
                    Container(
                        height: Sizes.s210,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(eImageAssets.pendingBillBg),
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                    appColor(context).appTheme.fieldCardBg,
                                    BlendMode.srcIn))),
                        child: Column(children: [
                          BillRowCommon(
                              title: translations!.addServiceName,
                              price: value.chargeTitleCtrl.text),
                          BillRowCommon(
                                  title: translations!.amount,
                                  price: symbolPosition
                                      ? "${getSymbol(context)}${value.perServiceAmountCtrl.text}"
                                      : "${value.perServiceAmountCtrl.text}${getSymbol(context)}")
                              .paddingSymmetric(vertical: Insets.i20),
                          BillRowCommon(
                              title: translations!.noOfService,
                              price: "${value.val}"),
                          Divider(
                                  color: appColor(context).appTheme.stroke,
                                  thickness: 1,
                                  height: 1,
                                  indent: 6,
                                  endIndent: 6)
                              .paddingOnly(top: Insets.i33),
                          BillRowCommon(
                                  title: translations!.totalAmount,
                                  price: symbolPosition
                                      ? "${getSymbol(context)}${(int.tryParse(value.perServiceAmountCtrl.text) ?? 0) * (int.tryParse(value.val.toString()) ?? 0)}"
                                      : "${(int.tryParse(value.perServiceAmountCtrl.text) ?? 0) * (int.tryParse(value.val.toString()) ?? 0)}${getSymbol(context)}",
                                  styleTitle: appCss.dmDenseMedium14.textColor(
                                      appColor(context).appTheme.darkText),
                                  style: appCss.dmDenseBold16.textColor(
                                      appColor(context).appTheme.primary))
                              .paddingOnly(top: 15, bottom: Insets.i10)
                        ]).padding(top: Insets.i20)),
                    ButtonCommon(
                            isLoading: value.isExtraChargeLoader ? true : false,
                            title: translations!.updateBill,
                            onTap: () => value.onUpdateBill(context))
                        .paddingSymmetric(vertical: Insets.i20)
                  ]).paddingSymmetric(
                      vertical: Insets.i20, horizontal: Insets.i20)))
          .bottomSheetExtension(context);
    });
  }
}
