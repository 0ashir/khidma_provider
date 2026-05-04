import '../../../../config.dart';

class PriceLayout extends StatelessWidget {
  final int? index,selectIndex;
  final GestureTapCallback? onTap;
  final String? title;
  const PriceLayout({super.key,this.index,this.selectIndex,this.onTap,this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonRadio(selectedIndex: selectIndex,index: index,onTap: onTap),
        const HSpace(Sizes.s10),
        Text(language(context, title!),style: appCss.dmDenseMedium12.textColor( selectIndex == index ? appColor(context).appTheme.darkText : appColor(context).appTheme.lightText)).width(Sizes.s92)
      ]
    );
  }
}
