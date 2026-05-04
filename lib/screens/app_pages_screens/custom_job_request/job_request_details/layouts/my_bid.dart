import '../../../../../config.dart';

class MyBidHome extends StatelessWidget {
  final dynamic service;
  const MyBidHome({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    var bids = service!.bids;

    List<Widget> bidWidgets = [];

    if (bids is List) {
      bidWidgets = bids.map<Widget>((bid) {
        return buildBidRow(
            context, Map<String, dynamic>.from(bid)); // <--- here
      }).toList();
    } else if (bids is Map) {
      bidWidgets.add(buildBidRow(context, Map<String, dynamic>.from(bids)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language(context, translations!.myBid),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText)),
        const VSpace(Sizes.s8),
        ...bidWidgets
      ],
    );
  }

  Widget buildBidRow(BuildContext context, Map<String, dynamic> bid) {
    // handle possible missing provider
    var provider = bid['provider'];
    List<dynamic> media = provider != null ? (provider['media'] ?? []) : [];

    return Row(
      children: [
        provider != null && media.isNotEmpty
            ? CommonImageLayout(
                image: media[0]['original_url'],
                assetImage: eImageAssets.noImageFound3,
                height: Sizes.s52,
                width: Sizes.s52,
                radius: 8,
              )
            : CommonCachedImage(
                image: eImageAssets.noImageFound3,
                height: Sizes.s52,
                width: Sizes.s52,
                radius: 8),
        const HSpace(Sizes.s10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service!.title!,
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
            const VSpace(Sizes.s8),
            Text(
                symbolPosition
                    ? "${getSymbol(context)}${currency(context).currencyVal * (bid['amount'] ?? 0)}"
                    : "${currency(context).currencyVal * (bid['amount'] ?? 0)}${getSymbol(context)}",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
          ],
        )
      ],
    ).paddingAll(Sizes.s12).boxShapeExtension(
        color: appColor(context).appTheme.primary.withOpacity(.10));
  }
}

class MyBid extends StatelessWidget {
  final dynamic service;
  const MyBid({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    var bid = service!.bids;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language(context, translations!.myBid),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText)),
        const VSpace(Sizes.s8),
        Row(
          children: [
            bid.provider != null && bid.provider!.media!.isNotEmpty
                ? CommonImageLayout(
                    image: bid.provider!.media![0].originalUrl!,
                    assetImage: eImageAssets.noImageFound3,
                    height: Sizes.s52,
                    width: Sizes.s52,
                    radius: 8,
                  )
                : CommonCachedImage(
                    image: eImageAssets.noImageFound3,
                    height: Sizes.s52,
                    width: Sizes.s52,
                    radius: 8),
            const HSpace(Sizes.s10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service!.title!,
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText)),
                const VSpace(Sizes.s8),
                Text(
                    "${getSymbol(context)}${currency(context).currencyVal * bid.amount!}",
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText)),
              ],
            )
          ],
        ).paddingAll(Sizes.s12).boxShapeExtension(
            color: appColor(context).appTheme.primary.withOpacity(.10))
      ],
    );
  }
}
