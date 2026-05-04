import '../../../../config.dart';

class ServicemanListLayout extends StatelessWidget {
  final dynamic data;
  final List? selList;
  final int? index;
  final GestureTapCallback? onTap;
  const ServicemanListLayout({Key? key,this.selList,this.index,this.data,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Container(
          height: Sizes.s40,
          width: Sizes.s40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(data["image"]))),
        ),
        title: IntrinsicHeight(
          child: Row(children: [
            Text(language(context, data["title"]),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: appColor(context).appTheme.stroke,
                indent: 6,
                endIndent: 6).paddingSymmetric(horizontal: Insets.i6),
            Row(children: [
              SvgPicture.asset(eSvgAssets.star),
              const HSpace(Sizes.s4),
              Text(data["rate"],
                  style: appCss.dmDenseMedium13
                      .textColor(appColor(context).appTheme.darkText))
            ])
          ]),
        ),
        subtitle: Text(language(context, "${data["exp"]} years of experience"),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText)),
        trailing: selList!.length <= 1 ? Container(
            width: Sizes.s22,
            height: Sizes.s22,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selList!.contains(index) ? appColor(context).appTheme.trans : appColor(context).appTheme.stroke),
                color: selList!.contains(index) ? appColor(context).appTheme.primary.withOpacity(0.18) :  appColor(context).appTheme.trans ),
            child: selList!.contains(index) ? Icon(Icons.circle,
                color: appColor(context).appTheme.primary, size: 13) : null).inkWell(onTap: onTap) :  Container(
            height: Sizes.s20,
            width: Sizes.s20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: selList!.contains(index)
                    ? appColor(context).appTheme.primary
                    : appColor(context).appTheme.whiteBg,
                borderRadius: BorderRadius.circular(AppRadius.r4),
                border: Border.all(color:selList!.contains(index)
                    ? appColor(context).appTheme.trans
                    : appColor(context).appTheme.stroke)),
            child: selList!.contains(index)
                ? Icon(Icons.check,
                size: Sizes.s15,
                color: appColor(context).appTheme.whiteBg)
                : null)
            .inkWell(onTap: onTap) )
        .paddingSymmetric(horizontal: Insets.i15)
        .boxBorderExtension(context,color: appColor(context).appTheme.whiteBg,isShadow: true,radius: AppRadius.r10).paddingOnly(bottom: Insets.i15);
  }
}
