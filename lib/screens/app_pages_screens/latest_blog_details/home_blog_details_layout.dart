import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../../../config.dart';

class HomeBlogDetailsLayout extends StatelessWidget {
  const HomeBlogDetailsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<LatestBLogDetailsProvider>(context, listen: true);
    return Column(children: [
      CachedNetworkImage(
          imageUrl: value.data1!.media!.isEmpty
              ? ""
              : value.data1?.media?.first.originalUrl ?? "",
          imageBuilder: (context, imageProvider) => Image(
              image: imageProvider,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill),
          placeholder: (context, url) => Image.asset(eImageAssets.noImageFound2,
              width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
          errorWidget: (context, url, error) => Image.asset(
              eImageAssets.noImageFound2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill)),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              width: Sizes.s190,
              child: Text(language(context, value.data1!.title!),
                  overflow: TextOverflow.ellipsis,
                  style: appCss.dmDenseMedium16
                      .textColor(appColor(context).appTheme.darkText))),
          if (value.blog?.tags?.isNotEmpty == true)
            Text(value.blog?.tags?.first.name ?? "",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: appCss.dmDenseMedium11
                        .textColor(appColor(context).appTheme.primary))
                .paddingSymmetric(horizontal: Insets.i7, vertical: Insets.i5)
                .decorated(
                    borderRadius: BorderRadius.circular(AppRadius.r6),
                    color: appColor(context).appTheme.primary.withOpacity(0.1))
        ]),
        Row(children: [
          Expanded(
              child: Text(
                  language(context, value.blog?.categories?.first.title),
                  overflow: TextOverflow.ellipsis,
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText)))
        ]),
        const VSpace(Sizes.s15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(DateFormat("dd MMM, yyyy").format(value.data1!.createdAt!),
              style: appCss.dmDenseRegular12
                  .textColor(appColor(context).appTheme.lightText)),
          Text(
              "- By ${value.data1?.createdBy?.name.toString().split('.').last}",
              style: appCss.dmDenseRegular12
                  .textColor(appColor(context).appTheme.lightText))
        ]),
        const DottedLines().paddingSymmetric(vertical: Insets.i15),
        Text(language(context, translations!.description),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText)),
        const VSpace(Sizes.s10),
        Html(data: value.blog?.content ?? "", style: {
          "body": Style(
              fontFamily: GoogleFonts.dmSans().fontFamily,
              fontSize: FontSize(12),
              fontWeight: FontWeight.w400)
        })
      ]).paddingAll(Insets.i12)
    ]);
  }
}
