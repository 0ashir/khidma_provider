import 'dart:developer';

import 'package:fixit_provider/model/dash_board_model.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';

class HomeLatestBlogLayout extends StatelessWidget {
  final LatestBlog? data;
  final GestureTapCallback? onTap;
  final double? rPadding;
  final bool? isView;

  const HomeLatestBlogLayout(
      {super.key, this.onTap, this.data, this.rPadding, this.isView = false});

  @override
  Widget build(BuildContext context) {
    var blog = Provider.of<LatestBLogDetailsProvider>(context);
    return SizedBox(
            width: Sizes.s257,
            child: Column(children: [
              CommonImageLayout(
                image: data!.media != null && data!.media!.isNotEmpty
                    ? data!.media!.first.originalUrl!
                    : "",
                assetImage: eImageAssets.noImageFound2,
                height: Sizes.s155,
              ),
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
                    /* if (isView == true)
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
                      ) */
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
                      Text(DateFormat("dd MMM, yyyy").format(data!.createdAt!),
                          style: appCss.dmDenseRegular12
                              .textColor(appColor(context).appTheme.lightText)),
                      Text(
                        "- By ${data?.createdBy?.name.toString().split('.').last}",
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).appTheme.lightText),
                      )
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
      blog.getBlogDetails(context, id: data!.id);
      route.pushNamed(context, routeName.latestBlogDetails);

      // blog.fetchBlog(id: data!.id);
    }).padding(right: rPadding ?? Insets.i15, vertical: Insets.i15);
  }
}
