import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';

class StaffChatLayout extends StatelessWidget {
  final Map<String, dynamic>? data;
  final bool isMe;

  const StaffChatLayout({super.key, this.data, required this.isMe});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (data!.containsKey('message') && data!['message'] != null)
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.i15, vertical: Insets.i15),
            decoration: BoxDecoration(
                color: isMe
                    ? appColor(context).appTheme.primary
                    : appColor(context).appTheme.fieldCardBg,
                borderRadius: rtl(context)
                    ? BorderRadius.only(
                        topRight: const Radius.circular(Insets.i20),
                        topLeft: const Radius.circular(Insets.i20),
                        bottomRight: Radius.circular(isMe ? Insets.i20 : 0),
                        bottomLeft: Radius.circular(isMe ? 0 : Insets.i20))
                    : BorderRadius.only(
                        topRight: const Radius.circular(Insets.i20),
                        topLeft: const Radius.circular(Insets.i20),
                        bottomRight: Radius.circular(isMe ? 0 : Insets.i20),
                        bottomLeft: Radius.circular(isMe ? Insets.i20 : 0))),
            child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data!['message'].toString(),
                      style: appCss.dmDenseMedium14.textColor(isMe
                          ? appColor(context).appTheme.whiteColor
                          : appColor(context).appTheme.darkText)),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    if (data!['isRead'] == true)
                      SvgPicture.asset(eSvgAssets.doubleTick)
                          .paddingOnly(right: Insets.i5),
                    Text(
                        DateFormat('hh:mm a').format(data!['timestamp'] is Timestamp
                            ? (data!['timestamp'] as Timestamp).toDate()
                            : DateTime.fromMillisecondsSinceEpoch(int.tryParse(
                                    data!['timestamp'].toString()) ??
                                DateTime.now().millisecondsSinceEpoch)),
                        softWrap: true,
                        style: appCss.dmDenseRegular13.textColor(isMe
                            ? appColor(context).appTheme.whiteColor
                            : appColor(context).appTheme.lightText))
                  ])
                ]),
          ).paddingDirectional(horizontal: Insets.i20, vertical: Sizes.s5),
        if (data!.containsKey('images') &&
            data!['images'] != null &&
            (data!['images'] is List
                ? data!['images'].isNotEmpty
                : data!['images'] is String))
          Material(
                  elevation: 1,
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                        width: Sizes.s160,
                        decoration: ShapeDecoration(
                          color: appColor(context).appTheme.primary,
                          shadows: [
                            BoxShadow(
                                color: appColor(context)
                                    .appTheme.darkText
                                    .withOpacity(0.06),
                                blurRadius: 12,
                                spreadRadius: 0,
                                offset: const Offset(0, 2))
                          ],
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 10, cornerSmoothing: 1)),
                        )),
                    imageUrl: (data!['images'] is List
                            ? (data!['images'] as List).isNotEmpty ? data!['images'][0] : ""
                            : data!['images'])
                        .toString(),
                    width: Sizes.s160,
                    fit: BoxFit.fill,
                  ))
              .padding(
                  horizontal: Insets.i20,
                  top: Insets.i10,
                  vertical: Insets.i10),
      ],
    );
  }
}
