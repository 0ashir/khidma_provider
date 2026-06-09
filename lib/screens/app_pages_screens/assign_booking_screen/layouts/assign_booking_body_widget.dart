import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

import '../../../../config.dart';

class AssignBookingBodyWidget extends StatelessWidget {
  const AssignBookingBodyWidget({super.key});

  bool _shouldShowActionButtons(BookingModel? bm) {
    if (bm == null) return false;
    final slug = bm.bookingStatus?.slug ?? '';
    // Always show action buttons once past "accepted" (assigned, on-the-way, etc.)
    if (slug == appFonts.accepted || slug.isEmpty) return false;
    // Serviceman in list â€” original check
    final inServicemen = (bm.servicemen ?? [])
        .any((e) => e.id.toString() == (userModel?.id.toString() ?? ''));
    // Provider self-assigned: not a freelancer and it's their own booking
    final selfAssigned =
        !isFreelancer && bm.providerId.toString() == (userModel?.id.toString() ?? '');
    return inServicemen || selfAssigned;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AcceptedBookingProvider, AssignBookingProvider>(
        builder: (context, acpCtrl, value, child) {
      log("value.bookingModel!.service!.type::: ${value.bookingModel!.service!.type}");
      return Stack(alignment: Alignment.bottomCenter, children: [
        SingleChildScrollView(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StatusDetailLayout(
                data: value.bookingModel,
                onTapStatus: () =>
                    showBookingStatus(context, value.bookingModel)),
            if (!isServiceman &&
                value.bookingModel?.bookingStatus?.slug != appFonts.accepted)
              _AssignedToSection(
                bookingModel: value.bookingModel,
                onReassign: () => value.onReassignTap(context),
              ),
            if (value.amount != null)
              ServicemenPayableLayout(amount: value.amount),
            Text(translations?.billSummary ?? '',
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText))
                .paddingOnly(top: Insets.i25, bottom: Insets.i10),
            AssignBillLayout(bookingModel: value.bookingModel),
            const VSpace(Sizes.s5),
            if (value.bookingModel!.advancePaymentEnable!)
              PaymentSummaryWidget(
                booking: value.bookingModel!,
              ),
            if (value.bookingModel!.service!.reviews == null &&
                value.bookingModel!.service!.reviews!.isEmpty)
              const VSpace(Sizes.s100),
            if (value.bookingModel!.service!.reviews != null &&
                value.bookingModel!.service!.reviews!.isNotEmpty)
              Column(
                children: [
                  HeadingRowCommon(
                      isViewAllShow:
                          value.bookingModel!.service!.reviews!.length >= 10,
                      title: translations!.review,
                      onTap: () {
                        Provider.of<ServiceReviewProvider>(context,
                                listen: false)
                            .getMyReview(context);
                        route.pushNamed(context, routeName.serviceReview);
                      }).paddingOnly(bottom: Insets.i12),
                  ...value.bookingModel!.service!.reviews!.asMap().entries.map(
                      (e) => SizedBox(
                                  child:
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: (e.value.consumer!.media!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: e.value.consumer!.media
                                                  ?.first.originalUrl ??
                                              "",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: Sizes.s40,
                                            width: Sizes.s40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CommonCachedImage(
                                                  height: Sizes.s40,
                                                  width: Sizes.s40,
                                                  isCircle: true,
                                                  image: eImageAssets
                                                      .noImageFound1),
                                          errorWidget: (context, url, error) =>
                                              CommonCachedImage(
                                                  height: Sizes.s40,
                                                  width: Sizes.s40,
                                                  isCircle: true,
                                                  image: eImageAssets
                                                      .noImageFound1),
                                        )
                                      : CommonCachedImage(
                                          height: Sizes.s40,
                                          width: Sizes.s40,
                                          isCircle: true,
                                          image: eImageAssets.noImageFound1),
                                  title: Text(
                                    e.value.consumer?.name ?? '',
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).appTheme.darkText),
                                  ),
                                  subtitle: e.value.createdAt != null
                                      ? Text(
                                          getTime(DateTime.parse(
                                              e.value.createdAt.toString())),
                                          style: appCss.dmDenseMedium12
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .lightText),
                                        )
                                      : Container(),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(eSvgAssets.star),
                                      const HSpace(Sizes.s4),
                                      Text(
                                        e.value.rating.toString(),
                                        style: appCss.dmDenseMedium12.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText),
                                      ),
                                    ],
                                  ),
                                ),
                                const VSpace(Sizes.s5),
                                TranslatedText(e.value.description ?? "",
                                        style: appCss.dmDenseRegular12
                                            .textColor(appColor(context)
                                                .appTheme
                                                .darkText))
                                    .paddingOnly(bottom: Insets.i15),
                              ]))
                              .paddingSymmetric(horizontal: Insets.i15)
                              .boxBorderExtension(context,
                                  bColor: appColor(context).appTheme.stroke))
                ],
              )
            /* if (value.bookingModel!.service!.reviews != null &&
                value.bookingModel!.service!.reviews!.isNotEmpty)
              ReviewListWithTitle(
                  reviews: value.bookingModel!.service!.reviews!) */
          ]).padding(
              horizontal: Insets.i20,
              top: Insets.i20,
              bottom: value.isServicemen != true ? Insets.i10 : Insets.i80)
        ])).paddingOnly(bottom: isFreelancer ? Sizes.s80 : Sizes.s10),
        // Show "Assign Now" only while booking is still in accepted state
        if (value.bookingModel?.bookingStatus?.slug == appFonts.accepted)
          ButtonCommon(
                  title: translations!.assignNow,
                  onTap: () => acpCtrl.onAssignTap(context,
                      bookingModel: value.bookingModel))
              .paddingAll(Sizes.s20)
              .backgroundColor(appColor(context).appTheme.whiteBg),
        // Show action buttons when assigned â€” covers both serviceman-in-list
        // and provider self-assign (where provider may not be in servicemen list)
        if (_shouldShowActionButtons(value.bookingModel))
          Material(
              elevation: 20,
              child: (value.bookingModel!.service!.type == "remotely")
                  ? value.bookingModel!.zoomMeeting == null
                      ? ButtonCommon(
                          title: "Get Meeting Link",
                          onTap: () => value.getMeetingLink(
                              bookingId: value.bookingModel?.id,
                              context: context),
                        ).paddingAll(Insets.i20)
                      : ButtonCommon(
                          title: "Join Meeting",
                          onTap: () => value.openZoom(
                              meetingLink: value.bookingModel!.zoomMeeting
                                  ?.startUrl)).paddingAll(Insets.i20)
                  : BottomSheetButtonCommon(
                          textOne: translations!.cancelService,
                          textTwo: translations!.startDriving,
                          clearTap: () => value.onCancel(context),
                          applyTap: () => value.onStartServicePass(context))
                      .paddingAll(Insets.i20)
                      .decorated(color: appColor(context).appTheme.whiteBg))
      ]);
    });
  }
}

class _AssignedToSection extends StatelessWidget {
  final BookingModel? bookingModel;
  final VoidCallback? onReassign;
  const _AssignedToSection({this.bookingModel, this.onReassign});

  @override
  Widget build(BuildContext context) {
    final servicemen = bookingModel?.servicemen ?? [];
    final isSelfAssigned = servicemen.isEmpty &&
        bookingModel?.providerId.toString() ==
            (userModel?.id.toString() ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VSpace(Sizes.s15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language(context, translations!.servicemanDetail),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText),
            ),
            if (!isServiceman && onReassign != null)
              Row(children: [
                Text(language(context, "Reassign"),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.primary)),
                const HSpace(Sizes.s4),
                SvgPicture.asset(eSvgAssets.anchorArrowRight,
                    colorFilter: ColorFilter.mode(
                        appColor(context).appTheme.primary, BlendMode.srcIn)),
              ]).inkWell(onTap: onReassign),
          ],
        ),
        const VSpace(Sizes.s10),
        if (servicemen.isNotEmpty)
          ...servicemen.asMap().entries.map((e) => CustomerDetailsLayout(
                title: translations!.servicemanDetail,
                data: e.value,
                isMore: true,
                index: e.key,
                list: servicemen,
                onTapMore: () => route.pushNamed(
                    context, routeName.servicemanDetail,
                    arg: {"detail": e.value.id}),
                onTapPhone: e.value.phone != null
                    ? () => launchCall(context, e.value.phone.toString())
                    : null,
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
                      "phone": e.value.phone?.toString() ?? "",
                      "code": e.value.code?.toString() ?? "",
                      "chatId": Provider.of<ChatProvider>(context, listen: false)
                          .buildChatId(
                              bookingId: bookingModel!.id.toString(),
                              partnerId: e.value.id.toString()),
                      "bookingId": bookingModel!.id.toString(),
                      "bookingNumber": bookingModel!.bookingNumber,
                    }).then((_) {
                      Provider.of<ChatHistoryProvider>(context, listen: false)
                          .onReady(context);
                    }),
              ))
        else if (isSelfAssigned)
          Row(
            children: [
              CommonCachedImage(
                  image: eImageAssets.noImageFound3,
                  height: Sizes.s38,
                  width: Sizes.s38,
                  isCircle: true),
              const HSpace(Sizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel?.name ?? '',
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      language(context, "Assigned to you"),
                      style: appCss.dmDenseRegular12
                          .textColor(appColor(context).appTheme.primary),
                    ),
                  ],
                ),
              ),
            ],
          )
              .paddingAll(Insets.i15)
              .boxShapeExtension(
                  color: appColor(context).appTheme.fieldCardBg,
                  radius: AppRadius.r10),
      ],
    ).paddingSymmetric(horizontal: Insets.i20).paddingOnly(top: Insets.i5);
  }
}
