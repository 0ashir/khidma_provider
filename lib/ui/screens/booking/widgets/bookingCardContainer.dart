import 'package:edemand_partner/ui/widgets/bottomSheets/layouts/cancelReasonBottomSheet.dart';
import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class BookingCardContainer extends StatefulWidget {
  const BookingCardContainer({
    super.key,
    required this.bookingModel,
    this.isFrom,
    this.onTap,
    this.isLead = false,
  });

  final BookingsModel bookingModel;
  final String? isFrom;
  final VoidCallback? onTap;
  final bool isLead;

  @override
  State<BookingCardContainer> createState() => _BookingCardContainerState();
}

class _BookingCardContainerState extends State<BookingCardContainer> {
  BookingsModel? bookingModel;

  @override
  void initState() {
    bookingModel = widget.bookingModel;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BookingCardContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    bookingModel = widget.bookingModel;
  }

  String _getTranslatedStatus(String status) {
    final Map<String, String> statusMap = {
      'awaiting': 'awaiting',
      'assigned': 'assigned',
      'accepted': 'accepted',
      'confirmed': 'confirmed',
      'on_the_way': 'on_the_way',
      'arrived': 'arrived',
      'started': 'started',
      'rescheduled': 'rescheduled',
      'booking_ended': 'booking_ended',
      'completed': 'completed',
      'rejected': 'rejected',
      'cancelled': 'cancelled',
    };
    return statusMap[status.toLowerCase()]?.translate(context: context) ??
        status;
  }

  Widget invoiceAndStatus(BookingsModel bookingModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: CustomText(
                  'invoiceNumber'.translate(context: context),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 5),
              CustomText(
                bookingModel.invoiceNo ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.colorScheme.accentColor,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: CustomText(
                  bookingModel.translatedStatus.toString().capitalize(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: UiUtils.getStatusColor(
                    context: context,
                    statusVal: bookingModel.status.toString(),
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 5),
              CustomSvgPicture(
                svgImage: AppAssets.arrowNext,
                color: context.colorScheme.lightGreyColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context
        .watch<FetchSystemSettingsCubit>()
        .state; // Use watch for UI updates
    final bool systemWisePostbooking = (state is FetchSystemSettingsSuccess)
        ? state.chatSettings.isPostBookingChatAllowed
        : false;

    final bool systemWisePrebooking = (state is FetchSystemSettingsSuccess)
        ? state.chatSettings.isPreBookingChatAllowed
        : false;

    final bool phoneAndChatStatusActive =
        bookingModel!.status.toString() == "cancelled" ||
            bookingModel!.status.toString() == "completed"
        ? false
        : true;

    final String paymentStatus = (bookingModel!.paymentStatus ?? '')
        .toLowerCase();
    // COD bookings sit at "pending" until settled on delivery, so only
    // block for online payments that are genuinely pending/failed.
    final bool isPaymentBlocking =
        bookingModel!.paymentMethod?.toLowerCase() != 'cod' &&
        (paymentStatus == 'pending' ||
            paymentStatus == 'failed' ||
            paymentStatus == '0' ||
            paymentStatus == '2');

    // Handyman: show chat only when they are the lead on the booking,
    // gated by system-wide settings (no provider-level toggle applies).
    // Provider: use both system-wide and provider-level toggles.
    final bool shouldShowChat;
    if (HiveRepository.isHandymanSession) {
      shouldShowChat =
          widget.isLead && (systemWisePrebooking || systemWisePostbooking);
    } else {
      final providerInfo = context
          .read<ProviderDetailsCubit>()
          .state
          .providerDetails
          .providerInformation;
      final bool isPreBookingChat =
          providerInfo?.isPreBookingChatAllowed == '1';
      final bool isPostBookingChat =
          providerInfo?.isPostBookingChatAllowed == '1';
      shouldShowChat =
          (systemWisePrebooking && isPreBookingChat) ||
          (systemWisePostbooking && isPostBookingChat);
    }

    return GestureDetector(
      onTap:
          widget.onTap ??
          () {
            Navigator.pushNamed(
              context,
              Routes.bookingDetails,
              arguments: {'bookingId': bookingModel?.id?.toString()},
            );
          },
      child: CustomContainer(
        padding: const EdgeInsetsDirectional.all(10),
        borderRadius: UiUtils.borderRadiusOf10,
        color: Theme.of(context).colorScheme.secondaryColor,
        border: Border.all(
          color: context.colorScheme.lightGreyColor,
          width: 0.2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            invoiceAndStatus(bookingModel!),
            CustomDivider(
              color: context.colorScheme.lightGreyColor,
              thickness: 0.2,
            ),
            if (bookingModel!.addressId != "0")
              Row(
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.mapPic,
                    color: context.colorScheme.accentColor,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomText(bookingModel!.address ?? '', maxLines: 1),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            DateAndTime(bookingModel: bookingModel!),
            if (bookingModel!.services != null &&
                bookingModel!.services!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomText(
                  bookingModel!.services![0].serviceTitle ?? '',
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                ),
              ),
              if (bookingModel!.services!.length >= 2) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomText(
                    bookingModel!.services![1].serviceTitle ?? '',
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                  ),
                ),
                if (bookingModel!.services!.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomText(
                      "+${bookingModel!.services!.length - 2} ${'moreServices'.translate(context: context)}",
                      fontWeight: FontWeight.w500,
                      color: context.colorScheme.accentColor,
                      showUnderline: true,
                      underlineOrLineColor: context.colorScheme.accentColor,
                    ),
                  ),
              ],
            ],
            if (widget.isFrom == "home") const Spacer(),
            const SizedBox(height: 8),
            CustomText(
              (bookingModel!.finalTotal ?? "0")
                  .replaceAll(',', '')
                  .toString()
                  .priceFormat(
                    context,
                    currencySymbol: bookingModel!.currencySymbol,
                    decimalPlaces: bookingModel!.currencyDecimalPlaces,
                  ),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            CustomDivider(
              color: context.colorScheme.lightGreyColor,
              thickness: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'customer'.translate(context: context),
                        color: context.colorScheme.lightGreyColor,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        bookingModel!.customer ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                bookingModel!.status.toString() == 'awaiting' &&
                        !isPaymentBlocking
                    ? BlocConsumer<
                        UpdateBookingStatusCubit,
                        UpdateBookingStatusState
                      >(
                        listener:
                            (
                              BuildContext context,
                              UpdateBookingStatusState updateState,
                            ) {
                              if (updateState is UpdateBookingStatusSuccess) {
                                if (updateState.error == 'true') {
                                  return;
                                }

                                context
                                    .read<FetchBookingsCubit>()
                                    .updateBookingDetailsLocally(
                                      bookingID: updateState.orderId.toString(),
                                      bookingStatus: updateState.status,
                                      bookingTranslatedStatus:
                                          updateState.translatedStatus,
                                      listOfUploadedImages:
                                          updateState.imagesList,
                                    );
                              }
                            },
                        builder:
                            (
                              BuildContext context,
                              UpdateBookingStatusState updateState,
                            ) {
                              return Row(
                                children: [
                                  CustomInkWellContainer(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () async {
                                      if (updateState
                                          is UpdateBookingStatusInProgress) {
                                        return;
                                      }
                                      final reasons = await BookingsRepository()
                                          .getCancellationReasons();
                                      if (!context.mounted) return;
                                      String? cancelReasonId;
                                      String? additionalInfo;
                                      if (reasons.isNotEmpty) {
                                        final result =
                                            await UiUtils.showModelBottomSheets(
                                              context: context,
                                              enableDrag: true,
                                              child:
                                                  const CancelReasonBottomSheet(),
                                            );
                                        if (result == null ||
                                            !context.mounted) {
                                          return;
                                        }
                                        cancelReasonId =
                                            result['reasonId'] as String?;
                                        additionalInfo =
                                            result['additionalInfo'] as String?;
                                      }
                                      context
                                          .read<UpdateBookingStatusCubit>()
                                          .updateBookingStatus(
                                            orderId: int.parse(
                                              bookingModel!.id!,
                                            ),
                                            translatedStatus:
                                                _getTranslatedStatus(
                                                  'cancelled',
                                                ),
                                            customerId: int.parse(
                                              bookingModel!.customerId!,
                                            ),
                                            status: 'cancelled',
                                            otp: '',
                                            cancelReasonId: cancelReasonId,
                                            additionalInfo: additionalInfo,
                                          );
                                    },
                                    child: CustomContainer(
                                      height: 36,
                                      width: 36,
                                      padding: const EdgeInsets.all(5),
                                      borderRadius: 5,
                                      color: AppColors.redColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      child: CustomSvgPicture(
                                        svgImage: AppAssets.close,
                                        color:
                                            updateState
                                                is UpdateBookingStatusInProgress
                                            ? AppColors.redColor.withValues(
                                                alpha: 0.3,
                                              )
                                            : AppColors.redColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  CustomInkWellContainer(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      if (updateState
                                          is UpdateBookingStatusInProgress) {
                                        return;
                                      }
                                      context
                                          .read<UpdateBookingStatusCubit>()
                                          .updateBookingStatus(
                                            orderId: int.parse(
                                              bookingModel!.id!,
                                            ),
                                            translatedStatus:
                                                _getTranslatedStatus(
                                                  'confirmed',
                                                ),
                                            customerId: int.parse(
                                              bookingModel!.customerId!,
                                            ),
                                            status: 'confirmed',
                                            otp: '',
                                          );
                                    },
                                    child: CustomContainer(
                                      padding: const EdgeInsets.all(5),
                                      height: 36,
                                      width: 36,
                                      borderRadius: 5,
                                      color: AppColors.greenColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      child: CustomSvgPicture(
                                        svgImage: AppAssets.check,
                                        color:
                                            updateState
                                                is UpdateBookingStatusInProgress
                                            ? AppColors.greenColor.withValues(
                                                alpha: 0.3,
                                              )
                                            : AppColors.greenColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                      )
                    : Row(
                        children: [
                          if (shouldShowChat)
                            CustomInkWellContainer(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                if (!phoneAndChatStatusActive) {
                                  return;
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.chatMessages,
                                    arguments: {
                                      "chatUser": ChatUser(
                                        customerId:
                                            bookingModel!.customerId ?? "",
                                        bookingId: bookingModel!.id.toString(),
                                        bookingStatus: bookingModel!.status
                                            .toString(),
                                        bookingTranslatedStatus:
                                            bookingModel!.translatedStatus,
                                        customerName: bookingModel!.customer
                                            .toString(),
                                        chatUserType:
                                            ChatUserType.providerBooking,
                                        unReadChats: 0,
                                        image: bookingModel!.profileImage,
                                      ),
                                    },
                                  );
                                }
                              },
                              child: CustomContainer(
                                height: 36,
                                width: 36,
                                borderRadius: UiUtils.borderRadiusOf5,
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                color: phoneAndChatStatusActive
                                    ? Theme.of(context).colorScheme.accentColor
                                          .withValues(alpha: 0.1)
                                    : context.colorScheme.lightGreyColor
                                          .withValues(alpha: 0.1),
                                child: CustomSvgPicture(
                                  svgImage: AppAssets.drChat,
                                  color: phoneAndChatStatusActive
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.accentColor
                                      : context.colorScheme.lightGreyColor,
                                ),
                              ),
                            ),
                          if (shouldShowChat) const SizedBox(width: 10),
                          CustomInkWellContainer(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              if (bookingModel!.status.toString() ==
                                      "cancelled" ||
                                  bookingModel!.status.toString() ==
                                      "completed") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        'youCantCallToProviderMessage'
                                            .translate(context: context),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'ok'.translate(context: context),
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.accentColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                try {
                                  launchUrl(
                                    Uri.parse(
                                      "tel:${bookingModel!.customerNo}",
                                    ),
                                  );
                                } catch (e) {
                                  UiUtils.showMessage(
                                    context,
                                    'somethingWentWrongTitle',
                                    ToastificationType.error,
                                  );
                                }
                              }
                            },
                            child: CustomContainer(
                              height: 36,
                              width: 36,
                              borderRadius: 5,
                              color: !phoneAndChatStatusActive
                                  ? context.colorScheme.lightGreyColor
                                        .withValues(alpha: 0.1)
                                  : Theme.of(context).colorScheme.accentColor
                                        .withValues(alpha: 0.1),
                              child: Icon(
                                Icons.call,
                                color: !phoneAndChatStatusActive
                                    ? context.colorScheme.lightGreyColor
                                    : Theme.of(context).colorScheme.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
