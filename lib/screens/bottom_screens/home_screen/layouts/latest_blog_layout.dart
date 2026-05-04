import 'dart:developer';

import 'package:intl/intl.dart';
import '../../../../config.dart';

class LatestBlogLayout extends StatelessWidget {
  final BlogModel? data;
  final GestureTapCallback? onTap;
  final double? rPadding;
  final bool? isView;

  const LatestBlogLayout(
      {super.key, this.onTap, this.data, this.rPadding, this.isView = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: Sizes.s257,
            child: Column(children: [
              CommonImageLayout(
                image: data!.media != null && data!.media!.isNotEmpty
                    ? data!.media!.first.originalUrl!
                    : "",
                assetImage: eImageAssets.noImageFound2,
                height: Sizes.s155,
                isAllBorderRadius: false,
              ),
              // data!.media!.isNotEmpty
              //     ? CachedNetworkImage(
              //         imageUrl: /* data!.media!.isEmpty
              //             ? ""
              //             : */
              //             data?.media?.first.originalUrl ?? "",
              //         imageBuilder: (context, imageProvider) => Image(
              //             image: imageProvider,
              //             width: MediaQuery.of(context).size.width,
              //             fit: BoxFit.fill),
              //         placeholder: (context, url) =>
              //             Image.asset(eImageAssets.noImageFound2),
              //         errorWidget: (context, url, error) =>
              //             Image.asset(eImageAssets.noImageFound2),
              //       )
              //     : Image.asset(eImageAssets.noImageFound2),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Sizes.s190,
                        child: Text(language(context, data!.title!),
                            overflow: TextOverflow.ellipsis,
                            style: appCss.dmDenseMedium16.textColor(
                                appColor(context).appTheme.darkText))),
                    /*    if (isView == true)
                      SizedBox(
                        width: Sizes.s70,
                        child: Text(data!.tags![0].name!,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: appCss.dmDenseMedium11.textColor(
                                    appColor(context).appTheme.primary))
                            .paddingSymmetric(
                                horizontal: Insets.i7, vertical: Insets.i5)
                            .decorated(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r6),
                                color: appColor(context)
                                    .appTheme
                                    .primary
                                    .withOpacity(0.1)),
                      )*/
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Text(language(context, data!.description!),
                        overflow: TextOverflow.ellipsis,
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).appTheme.lightText)),
                  ),
                ]),
                const VSpace(Sizes.s15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateFormat("dd MMM, yyyy")
                              .format(DateTime.parse(data!.createdAt!)),
                          style: appCss.dmDenseRegular12
                              .textColor(appColor(context).appTheme.lightText)),
                      Text("- By ${language(context, data!.createdBy!.name!)}",
                          style: appCss.dmDenseRegular12
                              .textColor(appColor(context).appTheme.lightText))
                    ])
              ]).paddingAll(Insets.i12)
            ]))
        .decorated(
            color: appColor(context).appTheme.whiteBg,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 2,
                  color: appColor(context).appTheme.darkText.withOpacity(0.06))
            ],
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: appColor(context).appTheme.stroke))
        .inkWell(onTap: () {
      log("data!.id::${data!.id}");
      Provider.of<LatestBLogDetailsProvider>(context, listen: false)
          .getBlogDetails(context, id: data!.id!);
      route.pushNamed(context, routeName.latestBlogDetails);
    }).padding(right: rPadding ?? Insets.i15, vertical: Insets.i15);
  }
}
