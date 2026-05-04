// // ignore_for_file: avoid_print

// import 'dart:developer';
// import 'package:fixit_provider/providers/app_pages_provider/offer_chat_provider.dart';
// import 'package:fixit_provider/screens/app_pages_screens/chat_screen/layouts/video_message_layout.dart';
// import 'package:intl/intl.dart';

// import '../../../../config.dart';
// import '../../provider_chat_screen/provider_chat_layout.dart';

// class ChatLayout extends StatelessWidget {
//   final MessageModel? document;
//   final AlignmentGeometry? alignment;
//   final bool? isSentByMe;
//   final bool isEmailOrPhone;

//   final int? index;

//   const ChatLayout(
//       {super.key,
//       this.document,
//       this.alignment,
//       this.isSentByMe,
//       this.isEmailOrPhone = false,
//       this.index});

//   @override
//   Widget build(BuildContext context) {
//    // log("isVideo:: $index");
//     return Consumer<OfferChatProvider>(builder: (context, value, child) {
//       final isThisExpanded = value.isExpanded(index ?? 0);
//       return Row(
//           mainAxisAlignment: isSentByMe == true
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           children: [
//             if (MessageType.offer.name == document!.type)
//               Stack(alignment: Alignment.bottomCenter, children: [
//                 Container(
//                         width: 240,
//                         padding: const EdgeInsets.all(Sizes.s12),
//                         decoration: BoxDecoration(
//                             color: document!.content!['ended_at'] ==
//                                         DateFormat('dd-MM-yyy')
//                                             .format(DateTime.now()) ||
//                                     document!.content['status'] == "rejected"
//                                 ? appColor(context)
//                                     .appTheme
//                                     .lightText
//                                     .withValues(alpha: 0.2)
//                                 : appColor(context).appTheme.primary,
//                             borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(Sizes.s20),
//                                 topRight: Radius.circular(Sizes.s20),
//                                 bottomLeft: Radius.circular(Sizes.s20),
//                                 bottomRight: Radius.circular(Sizes.s20))),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(document!.content!["title"],
//                                   style: appCss.dmDenseSemiBold15.textColor(
//                                       document!.content['ended_at'] ==
//                                                   DateFormat('dd-MM-yyy')
//                                                       .format(DateTime.now()) ||
//                                               document!.content['status'] ==
//                                                   "rejected"
//                                           ? appColor(context).appTheme.lightText
//                                           : appColor(context)
//                                               .appTheme
//                                               .whiteColor)),
//                               const VSpace(Sizes.s6),
//                               // const VSpace(Sizes.s10),
//                               if (value.isExpanded(index!))
//                                 Text(document!.content!["description"],
//                                     style: appCss.dmDenseMedium12.textColor(
//                                         document!.content['ended_at'] ==
//                                                     DateFormat('dd-MM-yyy')
//                                                         .format(
//                                                             DateTime.now()) ||
//                                                 document!.content['status'] ==
//                                                     "rejected"
//                                             ? appColor(context)
//                                                 .appTheme
//                                                 .lightText
//                                             : appColor(context)
//                                                 .appTheme
//                                                 .whiteColor)),
//                               if (value.isExpanded(index!))
//                                 const VSpace(Sizes.s10),
//                               ProviderChatLayout().commonSvgRowText(context,
//                                   mainTitle: appFonts.amount,
//                                   isExpired: document!.content['ended_at'] ==
//                                       DateFormat('dd-MM-yyy')
//                                           .format(DateTime.now()),
//                                   rejected:
//                                       document!.content['status'] == "rejected",
//                                   valueText: symbolPosition
//                                       ? " ${getSymbol(context)}${document!.content!["price"]}"
//                                       : " ${document!.content!["price"]}${getSymbol(context)}",
//                                   svg: eSvgAssets.dollar),
//                               if (value.isExpanded(index!))
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     const VSpace(Sizes.s10),
//                                     ProviderChatLayout().commonSvgRowText(
//                                         context,
//                                         mainTitle: appFonts.date,
//                                         valueText:
//                                             "${document!.content!["started_at"]} ${document!.content!["ended_at"]}",
//                                         isExpired:
//                                             document!.content['ended_at'] ==
//                                                 DateFormat('dd-MM-yyy')
//                                                     .format(DateTime.now()),
//                                         rejected: document!.content['status'] ==
//                                             "rejected",
//                                         svg: eSvgAssets.clock),
//                                     const VSpace(Sizes.s10),
//                                     ProviderChatLayout().commonSvgRowText(
//                                         context,
//                                         mainTitle: "Service staff required",
//                                         rejected: document!.content['status'] ==
//                                             "rejected",
//                                         isExpired:
//                                             document!.content['ended_at'] ==
//                                                 DateFormat('dd-MM-yyy')
//                                                     .format(DateTime.now()),
//                                         valueText:
//                                             "${document!.content!["required_servicemen"] ?? 1}",
//                                         svg: eSvgAssets.serviceStaff),
//                                     if (document!.content['ended_at'] ==
//                                         DateFormat('dd-MM-yyy')
//                                             .format(DateTime.now()))
//                                       DividerCommon(
//                                         color: document!.content['ended_at'] ==
//                                                 DateFormat('dd-MM-yyy')
//                                                     .format(DateTime.now())
//                                             ? appColor(context)
//                                                 .appTheme
//                                                 .lightText
//                                                 .withValues(alpha: 0.2)
//                                             : appColor(context)
//                                                 .appTheme
//                                                 .primary,
//                                       ).paddingDirectional(vertical: Sizes.s14),
//                                     if (document!.content['ended_at'] ==
//                                         DateFormat('dd-MM-yyy')
//                                             .format(DateTime.now()))
//                                       Text(
//                                           language(
//                                               context, "appFonts.offerExpired"),
//                                           style: appCss.dmDenseMedium12
//                                               .textColor(document!.content[
//                                                           'ended_at'] ==
//                                                       DateFormat('dd-MM-yyy')
//                                                           .format(
//                                                               DateTime.now())
//                                                   ? appColor(context)
//                                                       .appTheme
//                                                       .lightText
//                                                       .withValues(alpha: 0.5)
//                                                   : appColor(context)
//                                                       .appTheme
//                                                       .whiteColor))
//                                   ],
//                                 )
//                             ]).paddingOnly(bottom: Sizes.s10))
//                     .paddingOnly(
//                         right: Sizes.s20, left: Sizes.s90, bottom: Sizes.s15),
//                 Positioned(
//                     right: Sizes.s120,
//                     bottom: 4,
//                     child: CommonArrow(
//                         svgColor: appColor(context).appTheme.primary,
//                         arrow: value.isExpanded(index!)
//                             ? eSvgAssets.upDoubleArrow
//                             : eSvgAssets.downDoubleArrow,
//                         isThirteen: true,
//                         onTap: () => value.toggleExpand(index!),
//                         color: const Color(0xFFEEF0FF)))
//                 // .padding(left: Sizes.s80,bottom:-12 )
//               ])
//             else
//               Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: Insets.i15, vertical: Insets.i15),
//                   decoration: ShapeDecoration(
//                       color: isSentByMe == true
//                           ? appColor(context).appTheme.primary
//                           : appColor(context).appTheme.fieldCardBg,
//                       shape: SmoothRectangleBorder(
//                           borderRadius: rtl(context)
//                               ? SmoothBorderRadius.only(
//                                   topRight: const SmoothRadius(
//                                       cornerRadius: 20, cornerSmoothing: 1),
//                                   topLeft: const SmoothRadius(
//                                       cornerRadius: 20, cornerSmoothing: 1),
//                                   bottomRight: SmoothRadius(
//                                       cornerRadius: isSentByMe == true
//                                           ? Insets.i20
//                                           : Insets.i20,
//                                       cornerSmoothing: 1),
//                                   bottomLeft: SmoothRadius(
//                                       cornerRadius: isSentByMe == true
//                                           ? Insets.i20
//                                           : Insets.i20,
//                                       cornerSmoothing: 1))
//                               : SmoothBorderRadius.only(
//                                   topRight: const SmoothRadius(
//                                       cornerRadius: 20, cornerSmoothing: 1),
//                                   topLeft: const SmoothRadius(
//                                       cornerRadius: 20, cornerSmoothing: 1),
//                                   bottomRight: SmoothRadius(
//                                       cornerRadius: isSentByMe == true ? Insets.i20 : Insets.i20,
//                                       cornerSmoothing: 1),
//                                   bottomLeft: SmoothRadius(cornerRadius: isSentByMe == true ? Insets.i20 : Insets.i20, cornerSmoothing: 1)))),
//                   child: Column(crossAxisAlignment: isSentByMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
//                     if (MessageType.image.name == document!.type)
//                       CachedNetworkImage(
//                           imageUrl: document!.content!,
//                           imageBuilder: (context, imageProvider) => CachedNetworkImage(
//                               imageUrl: document!.content!,
//                               imageBuilder: (context, imageProvider) => Container(
//                                   height: Sizes.s200,
//                                   width: Sizes.s200,
//                                   decoration: ShapeDecoration(
//                                       shape: SmoothRectangleBorder(
//                                           borderRadius: SmoothBorderRadius(
//                                               cornerRadius: 20,
//                                               cornerSmoothing: 1)),
//                                       image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit
//                                               .cover))) /*.inkWell(onTap: () => route.push(context, CommonPhotoView(image: document!.content)))*/),
//                           placeholder: (context, url) => Container(
//                               height: Sizes.s200,
//                               width: Sizes.s200,
//                               decoration: ShapeDecoration(
//                                   shape: SmoothRectangleBorder(
//                                       borderRadius:
//                                           SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1)),
//                                   image: DecorationImage(image: AssetImage(eImageAssets.noImageFound2), fit: BoxFit.cover))),
//                           errorWidget: (context, url, error) => Container(height: Sizes.s200, width: Sizes.s200, decoration: ShapeDecoration(shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1)), image: DecorationImage(image: AssetImage(eImageAssets.noImageFound2), fit: BoxFit.cover)))),
//                     if (MessageType.video.name == document!.type)
//                       ChatVideo(snapshot: document!.content!),
//                     if (MessageType.text.name == document!.type)
//                       Text(
//                           isEmailOrPhone
//                               ? "The content of this message is confidential"
//                               : document!.content.toString(),
//                           style: appCss.dmDenseMedium14.textColor(
//                               isSentByMe == true
//                                   ? appColor(context).appTheme.whiteColor
//                                   : appColor(context).appTheme.darkText)),
//                     const VSpace(Sizes.s5),
//                     Row(children: [
//                       Text(
//                           DateFormat('hh:mm a').format(
//                               DateTime.fromMillisecondsSinceEpoch(
//                                   int.parse(document!.timestamp!))),
//                           style: appCss.dmDenseRegular12.textColor(
//                               isSentByMe == true
//                                   ? appColor(context).appTheme.whiteColor
//                                   : appColor(context).appTheme.lightText))
//                     ])
//                   ])).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i10)
//           ]);
//     });
//   }
// }
// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:fixit_provider/providers/app_pages_provider/offer_chat_provider.dart';
import 'package:fixit_provider/screens/app_pages_screens/chat_screen/layouts/video_message_layout.dart';
import 'package:intl/intl.dart';

import '../../../../config.dart';
import '../../provider_chat_screen/provider_chat_layout.dart';

class ChatLayout extends StatelessWidget {
  final MessageModel? document;
  final AlignmentGeometry? alignment;
  final bool? isSentByMe;
  final bool isEmailOrPhone;
  final int? index;

  const ChatLayout({
    super.key,
    this.document,
    this.alignment,
    this.isSentByMe,
    this.isEmailOrPhone = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferChatProvider>(builder: (context, value, child) {
      return Row(
        mainAxisAlignment: isSentByMe == true
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          /// ================= OFFER MESSAGE =================
          if (MessageType.offer.name == document!.type)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(Sizes.s12),
                  decoration: BoxDecoration(
                    color: document!.content!['ended_at'] ==
                                DateFormat('dd-MM-yyy')
                                    .format(DateTime.now()) ||
                            document!.content['status'] == "rejected"
                        ? appColor(context)
                            .appTheme
                            .lightText
                            .withValues(alpha: 0.2)
                        : appColor(context).appTheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.s20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        document!.content!["title"],
                        style: appCss.dmDenseSemiBold15.textColor(
                          document!.content['status'] == "rejected"
                              ? appColor(context).appTheme.lightText
                              : appColor(context).appTheme.whiteColor,
                        ),
                      ),
                      const VSpace(Sizes.s6),
                      if (value.isExpanded(index!))
                        Text(
                          document!.content!["description"],
                          style: appCss.dmDenseMedium12.textColor(
                            document!.content['status'] == "rejected"
                                ? appColor(context).appTheme.lightText
                                : appColor(context).appTheme.whiteColor,
                          ),
                        ),
                    ],
                  ),
                ).paddingOnly(
                    right: Sizes.s20, left: Sizes.s90, bottom: Sizes.s15),
                Positioned(
                  right: Sizes.s120,
                  bottom: 4,
                  child: CommonArrow(
                    svgColor: appColor(context).appTheme.primary,
                    arrow: value.isExpanded(index!)
                        ? eSvgAssets.upDoubleArrow
                        : eSvgAssets.downDoubleArrow,
                    isThirteen: true,
                    onTap: () => value.toggleExpand(index!),
                    color: const Color(0xFFEEF0FF),
                  ),
                ),
              ],
            )

          /// ================= NORMAL MESSAGE =================
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, // ✅ 75%
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.i15,
                  vertical: Insets.i15,
                ),
                decoration: ShapeDecoration(
                  color: isSentByMe == true
                      ? appColor(context).appTheme.primary
                      : appColor(context).appTheme.fieldCardBg,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                      topLeft: const SmoothRadius(
                          cornerRadius: AppRadius.r20, cornerSmoothing: 1),
                      topRight: const SmoothRadius(
                          cornerRadius: AppRadius.r20, cornerSmoothing: 1),
                      bottomLeft: SmoothRadius(
                          cornerRadius: isSentByMe == true ? AppRadius.r20 : 0,
                          cornerSmoothing: 1),
                      bottomRight: SmoothRadius(
                          cornerRadius: isSentByMe == true ? 0 : AppRadius.r20,
                          cornerSmoothing: 1),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isSentByMe == true
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // ✅ dynamic height
                  children: [
                    /// IMAGE MESSAGE
                    if (MessageType.image.name == document!.type)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                        child: CachedNetworkImage(
                          imageUrl: document!.content!,
                          height: Sizes.s200,
                          width: Sizes.s200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                              height: Sizes.s200,
                              width: Sizes.s200,
                              color: appColor(context)
                                  .appTheme
                                  .lightText
                                  .withOpacity(0.1),
                              child: const Center(
                                  child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Image.asset(
                              eImageAssets.noImageFound2,
                              height: Sizes.s200,
                              width: Sizes.s200,
                              fit: BoxFit.cover),
                        ),
                      ),

                    /// VIDEO MESSAGE
                    if (MessageType.video.name == document!.type)
                      ChatVideo(snapshot: document!.content!),

                    /// TEXT MESSAGE
                    if (MessageType.text.name == document!.type)
                      Text(
                        isEmailOrPhone
                            ? "The content of this message is confidential"
                            : document!.content.toString(),
                        softWrap: true, // ✅ multiline
                        style: appCss.dmDenseMedium14.textColor(
                          isSentByMe == true
                              ? appColor(context).appTheme.whiteColor
                              : appColor(context).appTheme.darkText,
                        ),
                      ),

                    const VSpace(Sizes.s5),

                    /// TIME
                    Text(
                      DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document!.timestamp!),
                        ),
                      ),
                      style: appCss.dmDenseRegular12.textColor(
                        isSentByMe == true
                            ? appColor(context).appTheme.whiteColor
                            : appColor(context).appTheme.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i10),
        ],
      );
    });
  }
}
