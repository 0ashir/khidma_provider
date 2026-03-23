import '../config.dart';

class PopupItemRowCommon extends StatelessWidget {
  final dynamic data;
  final int? index;
  final List? list;
  final bool? isIcon;
  const PopupItemRowCommon({super.key,this.index,this.data,this.list,this.isIcon = false });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isIcon == true ?
      Row(
        children: [
          SizedBox(
              height: Sizes.s13,
              width: Sizes.s13,
              child: SvgPicture.asset(data["image"])).paddingAll(Insets.i4).decorated(color: appColor(context).appTheme.fieldCardBg,shape: BoxShape.circle),
          const HSpace(Sizes.s12),
          Text(language(context, data["title"]),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: appCss.dmDenseMedium12.textColor(appColor(context).appTheme.darkText)),
        ],
      ) :  Text(language(context, data),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: appCss.dmDenseMedium12.textColor(appColor(context).appTheme.darkText)),
      if(index != list!.length - 1)
        Divider(height: 1,color: appColor(context).appTheme.stroke, thickness: 1)
            .paddingSymmetric(vertical: Insets.i10)
    ]);
  }
}
