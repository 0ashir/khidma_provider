import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class _AddressInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final BuildContext ctx;

  const _AddressInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: Sizes.s18, color: appColor(ctx).appTheme.lightText),
        const HSpace(Sizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(ctx).appTheme.lightText)),
              Text(value,
                  style: appCss.dmDenseMedium13
                      .textColor(appColor(ctx).appTheme.darkText)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlateBadge extends StatelessWidget {
  final String plateNumber;
  const _PlateBadge({required this.plateNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r4),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Insets.i6, vertical: Insets.i5),
              decoration: BoxDecoration(
                color: appColor(context).appTheme.primary,
                border: Border(
                    right: BorderSide(
                        color: appColor(context).appTheme.primary, width: 1.5)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r4),
                  bottomLeft: Radius.circular(AppRadius.r4),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("U.A.E",
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5)),
                  Text("ر.ع.١",
                      style: TextStyle(fontSize: 7, color: Colors.white)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Insets.i10, vertical: Insets.i6),
              decoration: BoxDecoration(
                color: appColor(context).appTheme.fieldCardBg,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppRadius.r4),
                  bottomRight: Radius.circular(AppRadius.r4),
                ),
              ),
              child: Text(
                plateNumber,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                  TranslatedText(data!.service!.title ?? "",
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
            if (data!.address != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Phone row (hidden when completed)
                  if (data!.bookingStatus?.slug != 'completed' &&
                      ((data!.address?.alternativeName != null &&
                              data!.address!.alternativeName!.isNotEmpty) ||
                          data!.address?.alternativePhone != null))
                    Row(
                      children: [
                        if (data!.address?.alternativeName != null &&
                            data!.address!.alternativeName!.isNotEmpty)
                          Expanded(
                            child: _AddressInfoTile(
                              icon: Icons.person_outline,
                              label: "Name",
                              value: data!.address!.alternativeName!,
                              ctx: context,
                            ),
                          ),
                        if (data!.address?.alternativeName != null &&
                            data!.address!.alternativeName!.isNotEmpty &&
                            data!.address?.alternativePhone != null)
                          Container(
                                  width: 1,
                                  height: Sizes.s40,
                                  color: appColor(context).appTheme.stroke)
                              .paddingSymmetric(horizontal: Insets.i8),
                        if (data!.address?.alternativePhone != null)
                          Expanded(
                            child: _AddressInfoTile(
                              icon: Icons.phone_outlined,
                              label: "Phone No",
                              value: "${data!.address?.code ?? ''}${data!.address!.alternativePhone}",
                              ctx: context,
                            ).inkWell(
                              onTap: () => launchCall(context,
                                  "${data!.address?.code ?? ''}${data!.address!.alternativePhone}"),
                            ),
                          ),
                      ],
                    ).padding(horizontal: Insets.i10, bottom: Insets.i12),
                  // Building No
                  if (data!.address?.postalCode != null &&
                      data!.address!.postalCode!.isNotEmpty)
                    _AddressInfoTile(
                      icon: Icons.home_outlined,
                      label: "Building No",
                      value: data!.address!.postalCode!,
                      ctx: context,
                    ).padding(horizontal: Insets.i10, bottom: Insets.i12),
                  // Full address
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(eSvgAssets.locationOut,
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                appColor(context).appTheme.darkText,
                                BlendMode.srcIn)),
                        VerticalDivider(
                          thickness: 1,
                          indent: 2,
                          endIndent: 20,
                          width: 1,
                          color: appColor(context).appTheme.stroke,
                        ).paddingSymmetric(horizontal: Insets.i9),
                        Expanded(
                            child: TranslatedText(
                                "${data!.address!.area != null ? "${data!.address!.area}, " : ""}${data!.address!.address ?? ''},${data!.address?.country?.name != null ? " ${data!.address!.country!.name}," : ""}${data!.address?.state?.name != null ? " ${data!.address!.state!.name}," : ""} ${data!.address!.postalCode ?? ''}",
                                style: appCss.dmDenseRegular12
                                    .textColor(appColor(context).appTheme.darkText))),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: Insets.i10),
                  const VSpace(Sizes.s10),
                  const DottedLines(),
                  // Google Maps button
                  if (data!.address?.latitude != null &&
                      data!.address?.longitude != null)
                    Row(
                      children: [
                        Icon(Icons.map_outlined,
                            size: Sizes.s18,
                            color: appColor(context).appTheme.primary),
                        const HSpace(Sizes.s6),
                        Text("Google Maps",
                            style: appCss.dmDenseMedium13.textColor(
                                appColor(context).appTheme.primary)),
                        const Spacer(),
                        Text("View Location",
                            style: appCss.dmDenseMedium12.textColor(
                                appColor(context).appTheme.primary)),
                        const HSpace(Sizes.s4),
                        SvgPicture.asset(
                          eSvgAssets.anchorArrowRight,
                          colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    )
                        .inkWell(
                          onTap: () => launchMap(context,
                              "${data!.address!.latitude},${data!.address!.longitude}"),
                        )
                        .padding(
                            horizontal: Insets.i15,
                            top: Insets.i10,
                            bottom: Insets.i15),
                ],
              )
          ]).boxBorderExtension(context,
              bColor: appColor(context).appTheme.stroke),
          if (data!.description != null)
            Text(translations?.customerInstructions ?? "",
                    style: appCss.dmDenseRegular12
                        .textColor(appColor(context).appTheme.lightText))
                .paddingOnly(top: Insets.i15, bottom: Insets.i5),
          TranslatedText(data!.description ?? "",
              style: appCss.dmDenseRegular14
                  .textColor(appColor(context).appTheme.darkText)),
        if (data!.carPlateNumbers != null &&
            data!.carPlateNumbers!.isNotEmpty) ...[
          const VSpace(Sizes.s15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_car,
                      size: Sizes.s28,
                      color: appColor(context).appTheme.primary),
                  const HSpace(Sizes.s10),
                  Expanded(
                    child: Text(
                      data!.service?.categories?.isNotEmpty == true
                          ? data!.service!.categories!.first.title ?? ''
                          : '',
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText),
                    ),
                  ),
                ],
              ),
              const VSpace(Sizes.s8),
              Text(language(context, translations!.services),
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText)),
              Text(data!.service?.title ?? '',
                  style: appCss.dmDenseMedium13
                      .textColor(appColor(context).appTheme.darkText)),
              const VSpace(Sizes.s12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: data!.carPlateNumbers!
                      .map((plate) => Padding(
                            padding: const EdgeInsets.only(right: Insets.i10),
                            child: _PlateBadge(plateNumber: plate),
                          ))
                      .toList(),
                ),
              ),
            ],
          )
              .paddingAll(Insets.i15)
              .boxBorderExtension(context,
                  isShadow: true, radius: AppRadius.r12),
        ],
          if (data?.bookingStatus?.slug != 'completed') ...[
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
          ],
          const VSpace(Sizes.s15),
          if (!isServiceman) ...[
            // Provider view: who carried out the job — assigned servicemen,
            // or a note that the provider completed it themselves.
            if (isFreelancer == false)
              if (data!.servicemen != null && data!.servicemen!.isNotEmpty)
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
                              "image": e.value.media != null &&
                                      e.value.media!.isNotEmpty
                                  ? e.value.media![0].originalUrl!
                                  : "",
                              "name": e.value.name,
                              "role": "serviceman",
                              "userId": e.value.id.toString(),
                              "token": e.value.fcmToken,
                              "phone": e.value.phone.toString(),
                              "code": e.value.code.toString(),
                              "chatId": Provider.of<ChatProvider>(context,
                                      listen: false)
                                  .buildChatId(
                                      bookingId: data!.id.toString(),
                                      partnerId: e.value.id.toString()),
                              "bookingId": data!.id.toString(),
                              "bookingNumber": data!.bookingNumber
                            }).then((e) {
                              final chat = Provider.of<ChatHistoryProvider>(
                                  context,
                                  listen: false);
                              chat.onReady(context);
                            }),
                        isMore: true,
                        index: e.key,
                        list: data!.servicemen))
              else ...[
                if (data?.bookingStatus?.slug == translations!.assigned)
                  Text(language(context, translations!.serviceAssignedToYou),
                          style: appCss.dmDenseRegular13.textColor(
                              appColor(context).appTheme.darkText))
                      .paddingOnly(left: Insets.i15, bottom: Insets.i10)
                else if (data?.bookingStatus?.slug == translations!.ongoing)
                  Text(language(context, translations!.currentlyHandlingService),
                          style: appCss.dmDenseRegular13.textColor(
                              appColor(context).appTheme.darkText))
                      .paddingOnly(left: Insets.i15, bottom: Insets.i10)
                else if (data?.bookingStatus?.slug == 'completed')
                  Text(language(context, translations!.serviceDoneByYou),
                          style: appCss.dmDenseRegular13.textColor(
                              appColor(context).appTheme.darkText))
                      .paddingOnly(left: Insets.i15, bottom: Insets.i10)
              ]
          ] else ...[
            // Serviceman view: the provider who assigned this service to them.
            CustomerDetailsLayout(
                title: translations!.providerDetails,
                data: data!.provider,
                onTapPhone: () =>
                    launchCall(context, data!.provider?.phone),
                onTapChat: () =>
                    route.pushNamed(context, routeName.chat, arg: {
                      "image": data!.provider?.media != null &&
                              data!.provider!.media!.isNotEmpty
                          ? data!.provider!.media![0].originalUrl!
                          : "",
                      "name": data!.provider?.name,
                      "role": "provider",
                      "userId": data!.provider?.id.toString(),
                      "phone": data!.provider?.phone.toString(),
                      "chatId": Provider.of<ChatProvider>(context,
                              listen: false)
                          .buildChatId(
                              bookingId: data!.id.toString(),
                              partnerId: data!.provider!.id.toString()),
                      "bookingId": data!.id.toString(),
                      "bookingNumber": data!.bookingNumber
                    }).then((e) {
                      final chat = Provider.of<ChatHistoryProvider>(
                          context,
                          listen: false);
                      chat.onReady(context);
                    }))
          ]
        ])
            .paddingAll(Insets.i15)
            .boxBorderExtension(context, isShadow: true, radius: AppRadius.r12),
        Text(translations?.commissionHistory ?? "",
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


