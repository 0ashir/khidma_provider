// ignore_for_file: prefer_typing_uninitialized_variables

import '../../../../config.dart';

class FeaturedServicesLayout extends StatelessWidget {
  final data;
  final GestureTapCallback? onTap;
  final int? index;
  final ValueChanged<bool>? onToggle;

  const FeaturedServicesLayout(
      {super.key, this.data, this.onTap, this.index, this.onToggle});

  @override
  Widget build(BuildContext context) {
    // final value = Provider.of<HomeProvider>(context, listen: true);
    return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              data!.media != null &&
                      data!.media!.isNotEmpty &&
                      data!.media![0].originalUrl != null
                  ? CachedNetworkImage(
                      imageUrl: data!.media!.first.originalUrl!,
                      imageBuilder: (context, imageProvider) => Container(
                          height: Sizes.s150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.r6),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover))),
                      placeholder: (context, url) => CommonCachedImage(
                            height: Sizes.s150,
                            width: MediaQuery.of(context).size.width,
                            radius: AppRadius.r6,
                            boxFit: BoxFit.cover,
                            image: eImageAssets.noImageFound2,
                          ),
                      errorWidget: (context, url, error) => CommonCachedImage(
                            height: Sizes.s150,
                            width: MediaQuery.of(context).size.width,
                            radius: AppRadius.r6,
                            boxFit: BoxFit.cover,
                            image: eImageAssets.noImageFound2,
                          ))
                  : CommonCachedImage(
                      height: Sizes.s150,
                      width: MediaQuery.of(context).size.width,
                      radius: AppRadius.r6,
                      boxFit: BoxFit.cover,
                      image: eImageAssets.noImageFound2,
                    ),
              const VSpace(Sizes.s12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(capitalizeFirstLetter(data!.title),
                            style: appCss.dmDenseSemiBold15.textColor(
                                appColor(context).appTheme.darkText)),
                      ),
                      Text(
                          symbolPosition
                              ? "${getSymbol(context)}${(currency(context).currencyVal * (data!.price!)).toStringAsFixed(2)}"
                              : "${(currency(context).currencyVal * (data!.price!)).toStringAsFixed(2)}${getSymbol(context)}",
                          style: appCss.dmDenseBold16
                              .textColor(appColor(context).appTheme.darkText))
                    ]),
                const VSpace(Sizes.s8),
                IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        if (data!.categories != null &&
                            data!.categories!.isNotEmpty)
                          Text(
                            data!.categories!
                                .map((cat) => "• ${cat.title}")
                                .join('\n'),
                            style: appCss.dmDenseMedium12.textColor(
                                appColor(context).appTheme.lightText),
                          ),
                        /*  Text("0${data!.categories![0].title}",
                              style: appCss.dmDenseMedium12.textColor(
                                  appColor(context).appTheme.lightText)), */
                        if (data!.categories != null &&
                            data!.categories!.isNotEmpty)
                          VerticalDivider(
                                  width: 1,
                                  color: appColor(context).appTheme.stroke,
                                  thickness: 1,
                                  indent: 3,
                                  endIndent: 3)
                              .paddingSymmetric(horizontal: Insets.i6),
                        SvgPicture.asset(eSvgAssets.receipt),
                        const HSpace(Sizes.s5),
                        Text(
                            "${data!.bookingsCount ?? 0} ${language(context, translations!.booked)}",
                            style: appCss.dmDenseMedium12.textColor(
                                appColor(context).appTheme.lightText))
                      ]),
                      if (data!.ratingCount != null)
                        Row(children: [
                          SvgPicture.asset(eSvgAssets.star),
                          const HSpace(Sizes.s3),
                          Text(
                              data!.ratingCount != null
                                  ? data!.ratingCount.toString()
                                  : "0",
                              style: appCss.dmDenseMedium13.textColor(
                                  appColor(context).appTheme.darkText))
                        ])
                    ])),
                const VSpace(Sizes.s10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, translations!.activeStatus),
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).appTheme.darkText)),
                      Theme(
                          data: ThemeData(useMaterial3: false),
                          child: FlutterSwitchCommon(
                              value: data!.status == 1 ? true : false,
                              onToggle: onToggle))
                    ]).paddingAll(Insets.i15).boxShapeExtension(
                    color: appColor(context).appTheme.fieldCardBg,
                    radius: AppRadius.r10)
              ])
            ]))
        .paddingAll(Insets.i15)
        .boxBorderExtension(context,
            isShadow: true, bColor: appColor(context).appTheme.stroke)
        .inkWell(onTap: onTap)
        .paddingOnly(bottom: Insets.i15);
  }
}
