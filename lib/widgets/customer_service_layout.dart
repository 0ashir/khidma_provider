import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

class CustomerServiceLayout extends StatelessWidget {
  final String? title,
      status,
      name,
      image,
      token,
      phone,
      code,
      bookingId,
      role,
      bookingNumber;
  final double? rate;
  final int? id;
  final GestureTapCallback? phoneTap, moreTap;

  const CustomerServiceLayout(
      {super.key,
      this.title,
      this.status,
      this.phoneTap,
      this.moreTap,
      this.name,
      this.image,
      this.rate,
      this.id,
      this.token,
      this.phone,
      this.code,
      this.bookingId,
      this.role,
      this.bookingNumber});

  @override
  Widget build(BuildContext context) {
    log("ajkdgjkasghd $bookingId");

    return SizedBox(
            child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, title),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText)),
        if (language(context, title) ==
            language(context, translations!.servicemanDetail))
          Row(children: [
            Text(language(context, translations!.view),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.primary)),
            const HSpace(Sizes.s4),
            SvgPicture.asset(eSvgAssets.anchorArrowRight,
                colorFilter: ColorFilter.mode(
                    appColor(context).appTheme.primary, BlendMode.srcIn))
          ]).inkWell(onTap: moreTap)
      ]),
      Divider(height: 1, color: appColor(context).appTheme.stroke)
          .paddingSymmetric(vertical: Insets.i15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          image != null
              ? CachedNetworkImage(
                  imageUrl: image!,
                  imageBuilder: (context, imageProvider) => Container(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover))),
                  errorWidget: (context, url, error) => CommonCachedImage(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      image: eImageAssets.noImageFound3,
                      isCircle: true),
                  placeholder: (context, url) => CommonCachedImage(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      image: eImageAssets.noImageFound3,
                      isCircle: true))
              : CommonCachedImage(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  image: eImageAssets.noImageFound3,
                  isCircle: true),
          const HSpace(Sizes.s12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(capitalizeFirstLetter(name ?? ''),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
            if (language(context, title) !=
                language(context, translations!.customerDetails))
              if (rate != null && rate != 0.0)
                Row(children: [
                  RatingBar(
                      initialRating: rate ?? 3.5,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      maxRating: 5,
                      itemSize: Sizes.s13,
                      ignoreGestures: true,
                      ratingWidget: RatingWidget(
                          full: SvgPicture.asset(eSvgAssets.star),
                          empty: SvgPicture.asset(eSvgAssets.starOut,
                              colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.lightText,
                                  BlendMode.srcIn)),
                          half: SvgPicture.asset(eSvgAssets.star)),
                      onRatingUpdate: (double value) {}),
                  /*SvgPicture.asset(starCondition(rate!)),*/
                  const HSpace(Sizes.s4),
                  Text(rate!.toString(),
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.darkText))
                ])
          ])
        ]),
        if (isFreelancer || isServiceman)
          if (id != null && userModel != null)
            if (id != userModel!.id)
              if (status != "pending")
                Row(children: [
                  SocialIconCommon(
                      icon: eSvgAssets.chatOut,
                      onTap: () =>
                          route.pushNamed(context, routeName.chat, arg: {
                            "image": image,
                            "name": name,
                            "role": role,
                            "userId": id?.toString(),
                            "token": token,
                            "phone": phone?.toString(),
                            "code": code?.toString(),
                            "chatId": Provider.of<ChatProvider>(context,
                                    listen: false)
                                .buildChatId(
                                    bookingId: bookingId.toString(),
                                    partnerId: id.toString()),
                            "bookingId": bookingId?.toString(),
                            "bookingNumber": bookingNumber?.toString()
                          }).then((e) {
                            final chat = Provider.of<ChatHistoryProvider>(
                                context,
                                listen: false);
                            chat.onReady(context);
                          })),
                  /* const HSpace(Sizes.s12),
                SocialIconCommon(
                    icon: eSvgAssets.phone,
                    onTap: () => onTapPhone(phone, context)) */
                ])
      ])
    ]))
        .paddingAll(Insets.i15)
        .boxShapeExtension(color: appColor(context).appTheme.fieldCardBg);
  }

  Future<void> makePhoneCall(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  onTapPhone(phone, context) {
    launchCall(context, phone);
  }
}
