import 'package:intl/intl.dart';

import '../../../../config.dart';

class StatusDetailLayout extends StatelessWidget {
  final BookingModel? data;
  final GestureTapCallback? onPhone, onTapStatus;

  const StatusDetailLayout({
    super.key,
    this.data,
    this.onPhone,
    this.onTapStatus,
  });


  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Sizes.s84,
                  width: Sizes.s84,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: (data?.service?.media != null &&
                              data!.service!.media!.isNotEmpty &&
                              data!.service!.media!.first.originalUrl != null &&
                              data!.service!.media!.first.originalUrl!
                                  .isNotEmpty)
                          ? NetworkImage(
                                  data!.service!.media!.first.originalUrl!)
                              as ImageProvider
                          : AssetImage(eImageAssets.noImageFound1),
                      fit: BoxFit.cover,
                    ),
                    shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(
                          cornerRadius: AppRadius.r10,
                          cornerSmoothing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const HSpace(Sizes.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#${data!.bookingNumber ?? ''}",
                            style: appCss.dmDenseMedium16
                                .textColor(appColor(context).appTheme.primary),
                          ),
                          Row(
                            children: [
                              Text(
                                language(context, translations!.viewStatus),
                                style: appCss.dmDenseMedium12.textColor(
                                    appColor(context).appTheme.primary),
                              ),
                              const HSpace(Sizes.s5),
                              SvgPicture.asset(
                                eSvgAssets.anchorArrowRight,
                                colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          )
                              .paddingSymmetric(
                                  horizontal: Insets.i12, vertical: Insets.i8)
                              .boxShapeExtension(
                                radius: AppRadius.r4,
                                color: appColor(context)
                                    .appTheme
                                    .primary
                                    .withOpacity(0.1),
                              )
                              .inkWell(onTap: onTapStatus),
                        ],
                      ),
                      const VSpace(Sizes.s10),
                      Text(
                        data!.service?.title ?? '',
                        style: appCss.dmDenseMedium16
                            .textColor(appColor(context).appTheme.darkText),
                      ).width(Sizes.s150),
                    ],
                  ).paddingOnly(top: Insets.i6),
                ),
              ],
            ),
            const VSpace(Sizes.s15),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DescriptionLayout(
                        icon: eSvgAssets.calender,
                        title: data?.dateTime == null
                            ? ""
                            : DateFormat("dd MMM, yyyy").format(
                                DateTime.parse(data!.dateTime!),
                              ),
                        subTitle: translations!.date,
                        padding: 0,
                      ),
                    ),
                    Container(
                      height: Sizes.s78,
                      width: 2,
                      color: appColor(context).appTheme.stroke,
                    ).paddingSymmetric(horizontal: Insets.i20),
                    Expanded(
                      child: DescriptionLayout(
                        icon: eSvgAssets.clock,
                        title: data?.dateTime == null
                            ? ""
                            : DateFormat("hh:mm aa").format(
                                DateTime.parse(data!.dateTime!),
                              ),
                        subTitle: translations!.time,
                        padding: 0,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: Insets.i10),
                if (data!.address != null) const DottedLines(),
                if (data!.address != null) const VSpace(Sizes.s17),
                if (data!.address != null)
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          eSvgAssets.locationOut,
                          fit: BoxFit.scaleDown,
                          colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.darkText,
                            BlendMode.srcIn,
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          indent: 2,
                          endIndent: 20,
                          width: 1,
                          color: appColor(context).appTheme.stroke,
                        ).paddingSymmetric(horizontal: Insets.i9),
                        Expanded(
                          child: Text(
                            data!.address != null
                                ? "${data!.address!.area != null ? "${data!.address!.area}, " : ""}${data!.address!.address},${data!.address?.country?.name == null ? "" : " ${data!.address?.country?.name},"}${data!.address?.state?.name == null ? "" : " ${data!.address?.state?.name},"}${data!.address!.postalCode}"
                                : "",
                            overflow: TextOverflow.fade,
                            style: appCss.dmDenseRegular12.textColor(
                              appColor(context).appTheme.darkText,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          eSvgAssets.locationOut,
                          height: Sizes.s18,
                          colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ).inkWell(
                    onTap: () {
                      final addr = data!.address?.address;
                      if (addr != null && addr.isNotEmpty) {
                        launchMap(context, Uri.encodeComponent(addr));
                      }
                    },
                  ).padding(
                    horizontal: Insets.i10,
                    bottom: Insets.i15,
                  ),
                // if (data!.bookingStatus != null &&
                //     data!.address != null)
                //   if (data!.bookingStatus!.slug != "cancel")
                //     ViewLocationCommon(address: data!.address!)
              ],
            ).boxBorderExtension(
              context,
              bColor: appColor(context).appTheme.stroke,
            ),
            if (data!.consumer != null)
              CustomerLayout(
                isDetailShow: false,
                title: translations!.customerDetails,
                data: data!.consumer,
                onTapChat: () {
                  final consumer = data!.consumer!;
                  final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                  final chatHistoryProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
                  route.pushNamed(context, routeName.chat, arg: {
                    "image": consumer.media != null && consumer.media!.isNotEmpty
                        ? consumer.media![0].originalUrl!
                        : "",
                    "name": consumer.name,
                    "role": "user",
                    "userId": consumer.id.toString(),
                    "token": consumer.fcmToken,
                    "phone": consumer.phone?.toString() ?? "",
                    "code": consumer.code?.toString() ?? "",
                    "chatId": chatProvider.buildChatId(
                            bookingId: data!.id.toString(),
                            partnerId: consumer.id.toString()),
                    "bookingId": data!.id.toString(),
                    "bookingNumber": data!.bookingNumber
                  }).then((_) {
                    chatHistoryProvider.onReady(context);
                  });
                },
                onTapPhone: data!.consumer!.phone != null
                    ? () => launchCall(context, data!.consumer!.phone.toString())
                    : null,
              ),
          ],
        )
            .paddingAll(Insets.i15)
            .boxBorderExtension(context,
                isShadow: true, radius: AppRadius.r12),
      ],
    );
  }
}
