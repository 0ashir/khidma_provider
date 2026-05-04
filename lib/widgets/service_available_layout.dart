import '../../../../config.dart';

class ServicemanListLayout extends StatelessWidget {
  final PrimaryAddress? data;
  final List? list;
  final dynamic addList;
  final int? index;
  final bool? isDetail,isBorder,isCheck;
  final GestureTapCallback? onDelete,onEdit,onIconTap;

  const ServicemanListLayout(
      {Key? key, this.data, this.onDelete,this.index,this.list,this.isDetail = false,this.isBorder = false,this.onEdit, this.isCheck = false, this.onIconTap, this.addList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isBorder == true ? ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: SvgPicture.asset(isCheck == true
            ? eSvgAssets.tick : eSvgAssets.location, colorFilter: ColorFilter.mode(isCheck == true ? appColor(context).appTheme.whiteColor : appColor(context).appTheme.primary, BlendMode.srcIn))
            .paddingAll(Insets.i10)
            .decorated(
            shape: BoxShape.circle,
            color: isCheck == true
                ? appColor(context).appTheme.primary : appColor(context).appTheme.primary.withOpacity(0.1)).inkWell(onTap: onIconTap),
        title: Row(children: [
          Text( data == null ?addList['title'] : "${data!.address!} - ${data!.state!.name},",
              overflow: TextOverflow.ellipsis,
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.darkText)).width(Sizes.s130)
        ]),
        subtitle: Text(data == null ?addList['subtext'] :"${data!.country!.name} - ${data!.postalCode}",
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonArrow(arrow: eSvgAssets.edit,onTap: onEdit,isThirteen: true),
            const HSpace(Sizes.s10),
            CommonArrow(arrow: eSvgAssets.delete,color: appColor(context).appTheme.red.withOpacity(0.1),svgColor: appColor(context).appTheme.red,onTap: onDelete,isThirteen: true)
          ]
        ))
        .paddingSymmetric(horizontal: Insets.i15).
        boxBorderExtension(context,color: appColor(context).appTheme.whiteBg,isShadow: true)
        .paddingOnly(bottom: index != list!.length -1 ? Insets.i15 : 0 ) : ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: SvgPicture.asset(eSvgAssets.location, colorFilter: ColorFilter.mode(appColor(context).appTheme.primary, BlendMode.srcIn))
                .paddingAll(Insets.i10)
                .decorated(
              shape: BoxShape.circle,
                    color: appColor(context).appTheme.primary.withOpacity(0.1)),
            title: Row(children: [
              Text(data == null ?addList['title'] :"${data!.address} - ${data!.state!.name},",
                  overflow: TextOverflow.ellipsis,
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.darkText)).width(Sizes.s130)
            ]),
            subtitle: Text(data == null ?addList['subtext'] :"${data!.country!.name} - ${data!.postalCode}",
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText)),
            trailing: SvgPicture.asset(eSvgAssets.delete, colorFilter: ColorFilter.mode(appColor(context).appTheme.red, BlendMode.srcIn))
                .paddingAll(Insets.i7)
                .decorated(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.red.withOpacity(0.1)).inkWell(onTap: onDelete))
        .paddingSymmetric(horizontal: Insets.i15).
        boxShapeExtension(color: isDetail == true ? appColor(context).appTheme.fieldCardBg : appColor(context).appTheme.whiteBg)
        .paddingOnly(bottom: index != list!.length -1 ? Insets.i15 : 0 );
  }
}
