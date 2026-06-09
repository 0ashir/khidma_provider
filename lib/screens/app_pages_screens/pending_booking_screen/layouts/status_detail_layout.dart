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
                                "${data!.address!.area != null ? "${data!.address!.area}, " : ""}${data!.address!.address ?? ''},${data!.address?.country?.name == null ? "" : " ${data!.address?.country?.name},"}${data!.address?.state?.name == null ? "" : " ${data!.address?.state?.name},"} ${data!.address!.postalCode ?? ''}",
                                overflow: TextOverflow.fade,
                                style: appCss.dmDenseRegular12.textColor(
                                  appColor(context).appTheme.darkText,
                                ),
                              ),
                            ),
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
                  ),
                if (data!.description != null && data!.description!.isNotEmpty) ...[
                  const DottedLines(),
                  const VSpace(Sizes.s10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        eSvgAssets.description,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language(context, "Details"),
                              style: appCss.dmDenseRegular12.textColor(
                                appColor(context).appTheme.lightText,
                              ),
                            ),
                            const VSpace(Sizes.s4),
                            Text(
                              data!.description!,
                              style: appCss.dmDenseRegular12.textColor(
                                appColor(context).appTheme.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).padding(horizontal: Insets.i10, bottom: Insets.i15),
                ],
                // if (data!.bookingStatus != null &&
                //     data!.address != null)
                //   if (data!.bookingStatus!.slug != "cancel")
                //     ViewLocationCommon(address: data!.address!)
              ],
            ).boxBorderExtension(
              context,
              bColor: appColor(context).appTheme.stroke,
            ),
            if (data!.consumer != null &&
                data?.bookingStatus?.slug != 'completed')
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
            if (!isServiceman && isFreelancer == false)
              if (data!.servicemen != null && data!.servicemen!.isNotEmpty)
                ...data!.servicemen!.asMap().entries.map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VSpace(Sizes.s15),
                        CustomerDetailsLayout(
                            onTapMore: () => route.pushNamed(
                                context, routeName.servicemanDetail,
                                arg: {"detail": e.value.id}),
                            onTapPhone: () => launchCall(
                                context, e.value.phone?.toString()),
                            title: translations!.servicemanDetail,
                            data: e.value,
                            onTapChat: () => route.pushNamed(
                                    context, routeName.chat, arg: {
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
                                  "chatId": Provider.of<ChatProvider>(
                                          context,
                                          listen: false)
                                      .buildChatId(
                                          bookingId: data!.id.toString(),
                                          partnerId: e.value.id.toString()),
                                  "bookingId": data!.id.toString(),
                                  "bookingNumber": data!.bookingNumber
                                }).then((_) {
                                  Provider.of<ChatHistoryProvider>(
                                          context,
                                          listen: false)
                                      .onReady(context);
                                }),
                            isMore: true,
                            index: e.key,
                            list: data!.servicemen)
                      ],
                    ))
              else ...[
                if (data?.bookingStatus?.slug == translations!.assigned)
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const VSpace(Sizes.s15),
                    Text(language(context, translations!.serviceAssignedToYou),
                        style: appCss.dmDenseRegular13.textColor(
                            appColor(context).appTheme.darkText)),
                  ]).paddingOnly(left: Insets.i15)
                else if (data?.bookingStatus?.slug == translations!.ongoing)
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const VSpace(Sizes.s15),
                    Text(language(context, translations!.currentlyHandlingService),
                        style: appCss.dmDenseRegular13.textColor(
                            appColor(context).appTheme.darkText)),
                  ]).paddingOnly(left: Insets.i15)
                else if (data?.bookingStatus?.slug == 'completed')
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const VSpace(Sizes.s15),
                    Text(language(context, translations!.serviceDoneByYou),
                        style: appCss.dmDenseRegular13.textColor(
                            appColor(context).appTheme.darkText)),
                  ]).paddingOnly(left: Insets.i15)
              ],
            if (isServiceman && data!.provider != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VSpace(Sizes.s15),
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
                          }).then((_) {
                            Provider.of<ChatHistoryProvider>(context,
                                    listen: false)
                                .onReady(context);
                          }))
                ],
              ),
          ],
        )
            .paddingAll(Insets.i15)
            .boxBorderExtension(context,
                isShadow: true, radius: AppRadius.r12),
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
      ],
    );
  }
}

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
