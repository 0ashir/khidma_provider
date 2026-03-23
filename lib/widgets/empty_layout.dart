import '../config.dart';

class EmptyLayout extends StatelessWidget {
  final String? title,subtitle,buttonText,inkText;
  final Widget? widget;
  final GestureTapCallback? bTap,inkOnTap;
  final bool isInk,isButton,isBooking;
  const EmptyLayout({super.key,this.subtitle,this.bTap,this.title,this.buttonText,this.widget,this.inkText,this.inkOnTap,this.isInk = false,this.isButton = false, this.isBooking =false});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: isBooking ?MainAxisAlignment.start : MainAxisAlignment.spaceBetween, children: [
      const SizedBox(),
      Column(children: [
       widget!,
        const VSpace(Sizes.s25),
        Text(language(context, title!),textAlign: TextAlign.center,
            style: appCss.dmDenseBold18
                .textColor(appColor(context).appTheme.darkText)),
        const VSpace(Sizes.s8),
        Text(language(context, subtitle!),
            textAlign: TextAlign.center,
            style: appCss.dmDenseRegular12
                .textColor(appColor(context).appTheme.lightText))
      ]),
      Column(
        children: [
          if(isButton == true)
          ButtonCommon(
              title: language(context, buttonText!),
              onTap: bTap)
              .paddingOnly(bottom: isInk == true ? Insets.i15 : Insets.i40,top: isBooking ?Insets.i20:0),
          if(isInk == true)
            Text(language(context, inkText!),style: appCss.dmDenseMedium16
                .textColor(appColor(context).appTheme.primary)).inkWell(onTap: inkOnTap).paddingOnly(bottom: Insets.i40)
        ],
      )
    ]).paddingSymmetric(horizontal: Insets.i20);
  }
}
