import '../../../../config.dart';

class ServiceReviewLayout extends StatelessWidget {
  final Reviews data;
  final List? list;
  final int? index;
  final bool? isSetting;
  final GestureTapCallback? onTap;

  const ServiceReviewLayout({
    super.key,
    required this.data,
    this.index,
    this.list,
    this.isSetting = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // log("data::${jsonEncode(data.toJson())}"); // assuming you have a `toJson()` in Reviews model

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: (data.consumer?.media != null &&
                    data.consumer!.media!.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: data.consumer!.media!.first.originalUrl ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider),
                      ),
                    ),
                    placeholder: (context, url) => CommonCachedImage(
                        height: Sizes.s40,
                        width: Sizes.s40,
                        isCircle: true,
                        image: eImageAssets.noImageFound1),
                    errorWidget: (context, url, error) => CommonCachedImage(
                        height: Sizes.s40,
                        width: Sizes.s40,
                        isCircle: true,
                        image: eImageAssets.noImageFound1),
                  )
                : CommonCachedImage(
                    height: Sizes.s40,
                    width: Sizes.s40,
                    isCircle: true,
                    image: eImageAssets.noImageFound1),
            title: Text(
              data.consumer?.name ?? '',
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText),
            ),
            subtitle: data.createdAt != null
                ? Text(
                    getTime(DateTime.parse(data.createdAt!)),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.lightText),
                  )
                : Container(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(eSvgAssets.star),
                const HSpace(Sizes.s4),
                Text(
                  data.rating?.toString() ?? '0.0',
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).appTheme.darkText),
                ),
              ],
            ),
          ),
          const VSpace(Sizes.s5),
          Text(data.description ?? "",
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.darkText))
              .paddingOnly(bottom: Insets.i15),
          // Uncomment if needed
          // if (isSetting == true)
          //   ReviewBottomLayout(
          //     serviceName: data.service?.title ??
          //         data.serviceman?.name ??
          //         data.provider?.name ?? '',
          //     onTap: onTap,
          //   ),
        ],
      ),
    )
        .paddingSymmetric(horizontal: Insets.i15)
        .boxBorderExtension(context, bColor: appColor(context).appTheme.stroke);
  }
}

// class ServiceReviewLayout extends StatelessWidget {
//   final dynamic data;
//   final List? list;
//   final int? index;
//   final bool? isSetting;
//   final GestureTapCallback? onTap;

//   const ServiceReviewLayout(
//       {super.key,
//       this.data,
//       this.index,
//       this.list,
//       this.isSetting = false,
//       this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     log("data::${jsonEncode(data)}");
//     return SizedBox(
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       ListTile(
//         dense: true,
//         contentPadding: EdgeInsets.zero,
//         leading: (data['consumer']['media'] is List &&
//                 data['consumer']['media'].isNotEmpty)
//             ? CachedNetworkImage(
//                 imageUrl: data['consumer']['media'][0]['original_url'] ?? "",
//                 imageBuilder: (context, imageProvider) => Container(
//                   height: Sizes.s40,
//                   width: Sizes.s40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(image: imageProvider),
//                   ),
//                 ),
//                 placeholder: (context, url) => CommonCachedImage(
//                     height: Sizes.s40,
//                     width: Sizes.s40,
//                     isCircle: true,
//                     image: eImageAssets.noImageFound1),
//                 errorWidget: (context, url, error) => CommonCachedImage(
//                     height: Sizes.s40,
//                     width: Sizes.s40,
//                     isCircle: true,
//                     image: eImageAssets.noImageFound1),
//               )
//             : CommonCachedImage(
//                 height: Sizes.s40,
//                 width: Sizes.s40,
//                 isCircle: true,
//                 image: eImageAssets.noImageFound1),
//         title: Text(
//           data['consumer']?['name'] ?? '',
//           style: appCss.dmDenseMedium14
//               .textColor(appColor(context).appTheme.darkText),
//         ),
//         subtitle: data['created_at'] != null
//             ? Text(
//                 getTime(DateTime.parse(data['created_at'])),
//                 style: appCss.dmDenseMedium12
//                     .textColor(appColor(context).appTheme.lightText),
//               )
//             : Container(),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(eSvgAssets.star),
//             const HSpace(Sizes.s4),
//             Text(
//               data['rating'].toString(),
//               style: appCss.dmDenseMedium12
//                   .textColor(appColor(context).appTheme.darkText),
//             ),
//           ],
//         ),
//       ),

//       // ListTile(
//       //     dense: true,
//       //     contentPadding: EdgeInsets.zero,
//       //     leading: data!.consumer?.media != null && data!.consumer!.media!.isNotEmpty
//       //         ? CachedNetworkImage(
//       //             imageUrl: data!.consumer?.media!.first.originalUrl ?? "",
//       //             imageBuilder: (context, imageProvider) => Container(
//       //                 height: Sizes.s40,
//       //                 width: Sizes.s40,
//       //                 decoration: BoxDecoration(
//       //                     shape: BoxShape.circle,
//       //                     image: DecorationImage(image:  data?.consumer?.media?.isNotEmpty ?? false
//       //                         ? NetworkImage(data.consumer.media.first.originalUrl)
//       //                         : AssetImage(eImageAssets.noImageFound1) as ImageProvider,))),
//       //             placeholder: (context, url) => CommonCachedImage(
//       //                 height: Sizes.s40,
//       //                 width: Sizes.s40,
//       //                 isCircle: true,
//       //                 image: eImageAssets.noImageFound1),
//       //             errorWidget: (context, url, error) => CommonCachedImage(
//       //                 height: Sizes.s40,
//       //                 width: Sizes.s40,
//       //                 isCircle: true,
//       //                 image: eImageAssets.noImageFound1))
//       //         : CommonCachedImage(
//       //             height: Sizes.s40,
//       //             width: Sizes.s40,
//       //             isCircle: true,
//       //             image: eImageAssets.noImageFound1),
//       //     title: Text(data!.consumer?.name ?? '',
//       //         style: appCss.dmDenseMedium14
//       //             .textColor(appColor(context).appTheme.darkText)),
//       //     subtitle: data!.createdAt != null
//       //         ? Text(getTime(DateTime.parse(data!.createdAt!)),
//       //             style: appCss.dmDenseMedium12
//       //                 .textColor(appColor(context).appTheme.lightText))
//       //         : Container(),
//       //     trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//       //       SvgPicture.asset(eSvgAssets.star),
//       //       const HSpace(Sizes.s4),
//       //       Text(data!.rating.toString(),
//       //           style: appCss.dmDenseMedium12
//       //               .textColor(appColor(context).appTheme.darkText))
//       //     ])),
//       const VSpace(Sizes.s5),
//       Text(data!['description'] ?? "",
//               style: appCss.dmDenseRegular12
//                   .textColor(appColor(context).appTheme.darkText))
//           .paddingOnly(bottom: Insets.i15),
//       // if (isSetting == true)
//       //   ReviewBottomLayout(
//       //       serviceName: data!.service != null
//       //           ? data!.service!.title
//       //           : data!.serviceman != null
//       //               ? data!.serviceman!.name
//       //               : data!.provider!.name,
//       //       onTap: onTap)
//     ])).paddingSymmetric(horizontal: Insets.i15).boxBorderExtension(context,
//         bColor: appColor(context).appTheme.stroke);
//   }
// }
