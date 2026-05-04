import '../../../../config.dart';

class SelectServicemenLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  final int? index, selectIndex;
  final List? list;
  final dynamic data;
  final String? amount;

  const SelectServicemenLayout(
      {super.key,
      this.onTap,
      this.index,
      this.list,
      this.data,
      this.selectIndex,
      this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(language(context, data!),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
          if (amount!.isNotEmpty)
            if (index == 1)
              RichText(
                  text: TextSpan(
                      text: "${language(context, translations!.charges)} : ",
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.green),
                      children: [
                    TextSpan(
                        text: "${getSymbol(context)}${amount ?? "0"}",
                        style: appCss.dmDenseSemiBold14
                            .textColor(appColor(context).appTheme.green)),
                    TextSpan(
                        text:
                            "/${language(context, translations!.perServicemen)}",
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.green))
                  ])).paddingOnly(top: Insets.i4)
        ])),
        CommonRadio(selectedIndex: selectIndex, index: index, onTap: onTap)
      ]),
      if (index != list!.length - 1)
        const DividerCommon().paddingSymmetric(vertical: Insets.i20)
    ]);
  }
}
