import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class BookingDetailsLayout extends StatelessWidget {
  final BookingModel? data;

  const BookingDetailsLayout({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingDetailsProvider>(builder: (context, value, child) {
      // log("data::${data?.toJson()}");
      return /* data == null
          ? EmptyLayout(
              isButton: false,
              title: translations!.ohhNoListEmpty,
              subtitle: translations!.yourBookingList,
              widget: Stack(
                children: [
                  Image.asset(
                    isFreelancer
                        ? eImageAssets.noListFree
                        : eImageAssets.noBooking,
                    height: Sizes.s306,
                  ),
                ],
              ),
            )
          : */
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          : AssetImage(eImageAssets.noImageFound1)
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(SmoothRadius(
                            cornerRadius: AppRadius.r10,
                            cornerSmoothing: 1))))),
            const HSpace(Sizes.s10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("#${data!.bookingNumber ?? ''}",
                      style: appCss.dmDenseMedium16
                          .textColor(appColor(context).appTheme.primary)),
                  const VSpace(Sizes.s10),
                  Text(data!.service!.title!,
                          style: appCss.dmDenseMedium16
                              .textColor(appColor(context).appTheme.darkText))
                      .width(Sizes.s150)
                ]).paddingOnly(top: Insets.i6)
          ]),
          const VSpace(Sizes.s15),
          Column(children: [
            Row(children: [
              DescriptionLayoutCommon(
                  icon: eSvgAssets.calender,
                  title: DateFormat("dd MMM, yyyy")
                      .format(DateTime.parse(data!.dateTime!)),
                  subtitle: translations!.date),
              Container(
                      height: Sizes.s70,
                      width: 1,
                      color: appColor(context).appTheme.stroke)
                  .paddingOnly(left: Insets.i27, right: Insets.i20),
              DescriptionLayoutCommon(
                  icon: eSvgAssets.clockOut,
                  title: DateFormat("hh:mm aa")
                      .format(DateTime.parse(data!.dateTime!)),
                  subtitle: translations!.time)
            ]).paddingSymmetric(horizontal: Insets.i10),
            const DividerCommon(),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SvgPicture.asset(eSvgAssets.locationOut,
                  colorFilter: ColorFilter.mode(
                      appColor(context).appTheme.darkText, BlendMode.srcIn)),
              Container(
                      height: Sizes.s15,
                      width: 1,
                      color: appColor(context).appTheme.stroke)
                  .paddingSymmetric(horizontal: Insets.i9),
              if (data!.address != null)
                Expanded(
                    child: Text(language(context, data!.address!.address ?? ''),
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.darkText)))
            ]).paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i10)
          ]).boxBorderExtension(context,
              bColor: appColor(context).appTheme.stroke),
          if (data!.description != null)
            Text(language(context, translations!.description),
                    style: appCss.dmDenseRegular12
                        .textColor(appColor(context).appTheme.lightText))
                .paddingOnly(top: Insets.i15, bottom: Insets.i5),
          Text(data!.description ?? "",
              style: appCss.dmDenseRegular14
                  .textColor(appColor(context).appTheme.darkText)),
          const VSpace(Sizes.s15),
          CustomerLayout(
              title: translations!.customerDetails,
              data: data!.consumer,
              isDetailShow: false,
              onTapChat: () => route.pushNamed(context, routeName.chat, arg: {
                    "image": data!.consumer!.media != null &&
                            data!.consumer!.media!.isNotEmpty
                        ? data!.consumer!.media![0].originalUrl!
                        : "",
                    "name": data!.consumer!.name,
                    "role": "user",
                    "userId": data!.consumer!.id.toString(),
                    "token": data!.consumer!.fcmToken,
                    "phone": data!.consumer!.phone.toString(),
                    "code": data!.consumer!.code.toString(),
                    "chatId": Provider.of<ChatProvider>(context, listen: false)
                        .buildChatId(
                            bookingId: data!.id.toString(),
                            partnerId: data!.consumer!.id.toString()),
                    "bookingId": data!.id.toString(),
                    "bookingNumber": data!.bookingNumber
                  }).then((e) {
                    final chat = Provider.of<ChatHistoryProvider>(context,
                        listen: false);
                    chat.onReady(context);
                  }),
              onTapPhone: () =>
                  value.onTapPhone(data!.consumer!.phone, data!.consumer!.code)),
          const VSpace(Sizes.s15),
          if (isFreelancer == false)
            ...data!.servicemen!.asMap().entries.map((e) =>
                CustomerDetailsLayout(
                    onTapMore: () => route.pushNamed(
                        context, routeName.servicemanDetail,
                        arg: {"detail": e.value.id}),
                    onTapPhone: () =>
                        value.onTapPhone(e.value.phone, e.value.code),
                    title: translations!.servicemanDetail,
                    data: e.value,
                    onTapChat: () =>
                        route.pushNamed(context, routeName.chat, arg: {
                          "image":
                              e.value.media != null && e.value.media!.isNotEmpty
                                  ? e.value.media![0].originalUrl!
                                  : "",
                          "name": e.value.name,
                          "role": "serviceman",
                          "userId": e.value.id.toString(),
                          "token": e.value.fcmToken,
                          "phone": e.value.phone.toString(),
                          "code": e.value.code.toString(),
                          "chatId":
                              Provider.of<ChatProvider>(context, listen: false)
                                  .buildChatId(
                                      bookingId: data!.id.toString(),
                                      partnerId: e.value.id.toString()),
                          "bookingId": data!.id.toString(),
                          "bookingNumber": data!.bookingNumber
                        }).then((e) {
                          final chat = Provider.of<ChatHistoryProvider>(context,
                              listen: false);
                          chat.onReady(context);
                        }),
                    isMore: true,
                    index: e.key,
                    list: data!.servicemen))
        ])
            .paddingAll(Insets.i15)
            .boxBorderExtension(context, isShadow: true, radius: AppRadius.r12),
        Text(language(context, translations!.commissionHistory),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
            .paddingOnly(top: Insets.i20, bottom: Insets.i10),
        Container(
            // height: Sizes.s245,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(appColor(context).appTheme.isDark
                        ? eImageAssets.bookingDetailBg
                        : eImageAssets.commissionBg),
                    fit: BoxFit.fill)),
            child: Column(children: [
              CommissionRowLayout(
                  isCommission: true,
                  data: data!.total,
                  title: translations!.servicePrice,
                  style: appCss.dmDenseblack14
                      .textColor(appColor(context).appTheme.darkText)),
              CommissionRowLayout(
                  isCommission: true,
                  title: translations!.adminCommission,
                  data: value.commission!.adminCommission),
              CommissionRowLayout(
                  isCommission: true,
                  title: translations!.platformFees,
                  data: data!.platformFees),
              if (isFreelancer == false)
                ...value.commission!.servicemanCommissions!.map((charge) {
                  return CommissionRowLayout(
                      isCommission: true,
                      title: translations!.servicemenCommission,
                      data: charge.commission);
                }),
              /*  CommissionRowLayout(
                    isCommission: true,
                    title: translations!.servicemenCommission,
                    data: value
                        .commission!.servicemanCommissions?.first.commission), */
              if (isServiceman == false)
                CommissionRowLayout(
                    title: translations!.yourCommission,
                    color: appColor(context).appTheme.primary,
                    data: isFreelancer
                        ? value.commission!.providerCommission
                        : value.commission!.providerNetCommission)
            ]).padding(horizontal: Insets.i15, top: Sizes.s20))
      ]);
    });
  }
}
