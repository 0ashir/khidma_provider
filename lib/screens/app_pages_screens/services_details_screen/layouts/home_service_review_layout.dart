import '../../../../config.dart';

class HomeServiceReviewLayout extends StatelessWidget {
  final dynamic data;
  final List? list;
  final int? index;
  final bool? isSetting;
  final GestureTapCallback? onTap;

  const HomeServiceReviewLayout(
      {super.key,
      this.data,
      this.index,
      this.list,
      this.isSetting = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: data['media'] != [] && data['media'].isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: data!.media![0].originalUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider))),
                  placeholder: (context, url) => CommonCachedImage(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      isCircle: true,
                      image: eImageAssets.noImageFound1),
                  errorWidget: (context, url, error) => CommonCachedImage(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      isCircle: true,
                      image: eImageAssets.noImageFound1))
              : CommonCachedImage(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  isCircle: true,
                  image: eImageAssets.noImageFound1),
          title: Text(data['consumer']['name'],
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
          subtitle: data['created_At'] != null
              ? Text(getTime(DateTime.parse(data!.createdAt!)),
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).appTheme.lightText))
              : Container(),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            SvgPicture.asset(eSvgAssets.star),
            const HSpace(Sizes.s4),
            Text(data['rating'].toString(),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.darkText))
          ])),
      const VSpace(Sizes.s5),
      Text(data['description'] ?? "",
              style: appCss.dmDenseRegular12
                  .textColor(appColor(context).appTheme.darkText))
          .paddingOnly(bottom: Insets.i15),
    ])).paddingSymmetric(horizontal: Insets.i15).boxBorderExtension(context,
        bColor: appColor(context).appTheme.stroke);
  }
}
