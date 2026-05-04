import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';

class ChatHistoryLayout extends StatelessWidget {
  final dynamic data;
  final List? list;
  final int? index;
  final GestureTapCallback? onTap;

  const ChatHistoryLayout({
    super.key,
    this.data,
    this.list,
    this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    log("ˇ$data");

    final isSender = data['senderId'].toString() == userModel!.id.toString();
    final lastMessage = data['lastMessage'] ?? '';
    final messageType = data['messageType'] ?? '';
    final updateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(data["updateStamp"].toString()));

    // Determine the display message
    String displayMessage;
    if (messageType == "image") {
      displayMessage = isSender
          ? "You shared an image"
          : "${data['senderName']} shared an image";
    } else if (messageType == "video") {
      displayMessage = isSender
          ? "You shared a video"
          : "${data['senderName']} shared a video";
    } else if (messageType == MessageType.offer.name) {
      displayMessage = isSender ? "You sent the offer" : lastMessage;
    } else {
      displayMessage = lastMessage;
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar + Name + Last message
            Expanded(
              child: Row(
                children: [
                  // Avatar
                  Container(
                    height: Sizes.s45,
                    width: Sizes.s45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          isSender
                              ? (data['receiverImage'] ??
                                  eImageAssets.noImageFound3)
                              : (data['senderImage'] ??
                                  eImageAssets.noImageFound3),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const HSpace(Sizes.s10),
                  // Name + Last message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Booking #
                        Text(
                          data.containsKey('isOffer')
                              ? (isSender
                                  ? (data['receiverName'] ?? "")
                                  : data['senderName'] ?? "")
                              : (isSender
                                  ? "${data['receiverName']} #${data['bookingNumber'] ?? ''}"
                                  : "${data['senderName']} #${data['bookingNumber'] ?? ''}"),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.darkText),
                        ),
                        const VSpace(Sizes.s2),

                        // Last message
                        Text(
                          displayMessage,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).appTheme.lightText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const HSpace(Sizes.s10),
            // Timestamp + Offer icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('HH:mm').format(updateTime),
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText),
                ),
              ],
            ),
          ],
        ).inkWell(onTap: onTap),

        // Divider
        if (index != list!.length - 1)
          const DividerCommon().paddingSymmetric(vertical: Insets.i15),
      ],
    );
  }
}
