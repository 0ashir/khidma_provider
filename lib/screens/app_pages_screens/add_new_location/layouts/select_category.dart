import '../../../../config.dart';

class SelectCategory extends StatelessWidget {
  final dynamic data;
  final int? index,selectedIndex;
  final GestureTapCallback? onTap;
  const SelectCategory({super.key,this.onTap,this.index,this.selectedIndex,this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: Sizes.s22,
            height: Sizes.s22,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:index== selectedIndex ? appColor(context).appTheme.trans : appColor(context).appTheme.stroke),
                color: index== selectedIndex! ? appColor(context).appTheme.primary.withOpacity(0.18) :  appColor(context).appTheme.trans ),
            child:  index== selectedIndex! ? Icon(Icons.circle,
                color: appColor(context).appTheme.primary, size: 13) : null).inkWell(onTap: onTap),
        const HSpace(Sizes.s8),
        Text(language(context, data),style: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.lightText))
      ]
    );
  }
}
