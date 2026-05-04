import '../../../../config.dart';

class SocialLayout extends StatelessWidget {
  final dynamic data;
  final List? list;
  final int? index;
  final GestureTapCallback? onTap;
  const SocialLayout({super.key,this.list,this.index,this.data,this.onTap});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SvgPicture.asset(data,colorFilter: ColorFilter.mode(appColor(context).appTheme.darkText, BlendMode.srcIn),height: Sizes.s20,),
          if(index != list!.length -1)
          VerticalDivider(width: 1,color: appColor(context).appTheme.primary.withOpacity(0.3),thickness: 1).paddingSymmetric(horizontal: Insets.i12)
        ]
      ).inkWell(onTap: onTap)
    );
  }
}
