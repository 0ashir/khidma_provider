import 'dart:developer';

import '../../../../config.dart';
import '../../../../providers/app_pages_provider/offer_chat_provider.dart';

class ChatAppBarLayout extends StatelessWidget {
  final PopupMenuItemSelected? onSelected;
  final bool isOffer;

  const ChatAppBarLayout({super.key, this.onSelected, this.isOffer = false});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, OfferChatProvider>(
      builder: (context1, value, offer, child) {
        log(
          "ChatAppBarLayout: isOffer=$isOffer, offer.name=${offer.name}, value.name=${value.bookingNumber}",
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              // Arrow
              CommonArrow(
                onTap: () => isOffer
                    ? offer.onBack(context, true)
                    : value.onBack(context, true),
                arrow:
                    rtl(context) ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
                color: appColor(context).appTheme.primary.withOpacity(0.15),
              ),
              const HSpace(Sizes.s15),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                        isOffer
                            ? offer.name ?? ""
                            : value.bookingNumber != null &&
                                    value.bookingNumber != ""
                                ? "${value.name} #${value.bookingNumber}"
                                : "${value.name}",
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.darkText)),
                    // const VSpace(Sizes.s2),
                    // // Status
                    // Text(language(context, value.activeStatus),
                    //     style: appCss.dmDenseMedium12.textColor(isOffer
                    //         ? offer.activeStatus == "Online"
                    //             ? appColor(context).appTheme.online
                    //             : appColor(context).appTheme.red
                    //         : value.activeStatus == "Online"
                    //             ? appColor(context).appTheme.online
                    //             : appColor(context).appTheme.red))
                  ])
            ]),
            // SizedBox(
            //   height: Sizes.s40,
            //   width: Sizes.s40,
            //   child:
            //       PopupMenuButton(
            //         color: appColor(context).appTheme.whiteBg,
            //         position: PopupMenuPosition.under,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(AppRadius.r8),
            //           ),
            //         ),
            //         onSelected: onSelected,
            //         padding: const EdgeInsets.all(0),
            //         iconSize: Sizes.s20,
            //         offset: const Offset(5, 20),
            //         icon: SvgPicture.asset(
            //           eSvgAssets.more,
            //           height: Sizes.s20,
            //           colorFilter: ColorFilter.mode(
            //             appColor(context).appTheme.darkText,
            //             BlendMode.srcIn,
            //           ),
            //         ),
            //         itemBuilder: (context) => [
            //           ...appArray.optionList.asMap().entries.map(
            //             (e) => buildPopupMenuItem(
            //               context,
            //               appArray.optionList,
            //               position: e.key,
            //               data: e.value,
            //               index: e.key,
            //             ),
            //           ),
            //         ],
            //       ).decorated(
            //         color: appColor(context).appTheme.primary.withOpacity(0.15),
            //         shape: BoxShape.circle,
            //       ),
            // ),
          ],
        ).paddingOnly(
          right: Insets.i20,
          left: Insets.i20,
          top: isOffer ? Sizes.s50 : Insets.i10,
        );
      },
    );
  }
}
