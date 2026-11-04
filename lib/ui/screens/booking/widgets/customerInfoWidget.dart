import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class CustomerInfoWidget extends StatelessWidget {
  const CustomerInfoWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  @override
  Widget build(BuildContext context) {
    final bool phoneAndChatStatusActive =
        bookingsModel.status.toString() == "cancelled" ||
            bookingsModel.status.toString() == "completed"
        ? false
        : true;

    final state = context.watch<FetchSystemSettingsCubit>().state;
    final bool systemWisePostbooking = (state is FetchSystemSettingsSuccess)
        ? state.chatSettings.isPostBookingChatAllowed
        : false;

    final bool systemWisePrebooking = (state is FetchSystemSettingsSuccess)
        ? state.chatSettings.isPreBookingChatAllowed
        : false;

    final bool isPreBookingChat =
        context
            .read<ProviderDetailsCubit>()
            .state
            .providerDetails
            .providerInformation!
            .isPreBookingChatAllowed ==
        '1';
    final bool isPostBookingChat =
        context
            .read<ProviderDetailsCubit>()
            .state
            .providerDetails
            .providerInformation!
            .isPostBookingChatAllowed ==
        '1';

    // Check if chat should be shown - show if either pre-booking or post-booking chat is enabled
    final bool shouldShowChat =
        (systemWisePrebooking && isPreBookingChat) ||
        (systemWisePostbooking && isPostBookingChat);

    return CustomContainer(
      borderRadius: 0,
      color: Theme.of(context).colorScheme.secondaryColor,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomText(
              'customer'.translate(context: context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ),
          const SizedBox(height: 5),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomContainer(
                          height: 50,
                          width: 50,
                          shape: BoxShape.circle,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              UiUtils.borderRadiusOf50,
                            ),
                            child: CustomCachedNetworkImage(
                              imageUrl: bookingsModel.profileImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                bookingsModel.customer ?? '',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.blackColor,
                              ),
                              _buildTitleAndValueRowWidget(
                                value: CustomText(
                                  bookingsModel.customerNo ?? '',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: context.colorScheme.lightGreyColor,
                                ),
                                onTap: () {
                                  try {
                                    launchUrl(
                                      Uri.parse(
                                        "tel:${bookingsModel.customerNo}",
                                      ),
                                    );
                                  } catch (e) {
                                    UiUtils.showMessage(
                                      context,
                                      "somethingWentWrongTitle",
                                      ToastificationType.error,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        CustomInkWellContainer(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            if (!phoneAndChatStatusActive) {
                              return;
                            } else {
                              try {
                                launchUrl(
                                  Uri.parse("tel:${bookingsModel.customerNo}"),
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
                            height: 40,
                            width: 40,
                            borderRadius: UiUtils.borderRadiusOf5,
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            color: !phoneAndChatStatusActive
                                ? Theme.of(context).colorScheme.lightGreyColor
                                      .withValues(alpha: 0.1)
                                : Theme.of(context).colorScheme.accentColor
                                      .withValues(alpha: 0.1),
                            child: CustomSvgPicture(
                              svgImage: AppAssets.call,
                              color: !phoneAndChatStatusActive
                                  ? Theme.of(context).colorScheme.lightGreyColor
                                  : Theme.of(context).colorScheme.accentColor,
                            ),
                          ),
                        ),
                        if (shouldShowChat) ...[
                          const SizedBox(width: 10),
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
                                          bookingsModel.customerId ?? "-",
                                      bookingId: bookingsModel.id.toString(),
                                      bookingStatus: bookingsModel.status
                                          .toString(),
                                      bookingTranslatedStatus:
                                          bookingsModel.translatedStatus,
                                      customerName: bookingsModel.customer
                                          .toString(),
                                      chatUserType:
                                          ChatUserType.providerBooking,
                                      unReadChats: 0,
                                      image: bookingsModel.profileImage,
                                    ),
                                  },
                                );
                              }
                            },
                            child: CustomContainer(
                              height: 40,
                              width: 40,
                              borderRadius: UiUtils.borderRadiusOf5,
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              color: !phoneAndChatStatusActive
                                  ? Theme.of(context).colorScheme.lightGreyColor
                                        .withValues(alpha: 0.1)
                                  : Theme.of(context).colorScheme.accentColor
                                        .withValues(alpha: 0.1),
                              child: CustomSvgPicture(
                                svgImage: AppAssets.drChat,
                                color: !phoneAndChatStatusActive
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.lightGreyColor
                                    : Theme.of(context).colorScheme.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTitleAndValueRowWidget(
                      value: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomSvgPicture(
                                svgImage: AppAssets.letter,
                                color: context.colorScheme.accentColor,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 5),
                              CustomText(
                                bookingsModel.customerEmail ?? '',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          CustomSvgPicture(
                            svgImage: AppAssets.arrowNext,
                            color: context.colorScheme.accentColor,
                          ),
                        ],
                      ),
                      onTap: () {
                        try {
                          launchUrl(
                            Uri.parse("mailto:${bookingsModel.customerEmail}"),
                          );
                        } catch (e) {
                          UiUtils.showMessage(
                            context,
                            "somethingWentWrongTitle",
                            ToastificationType.error,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndValueRowWidget({
    required Widget value,
    VoidCallback? onTap,
  }) {
    return CustomInkWellContainer(
      onTap: onTap,
      child: Row(children: [Expanded(child: value)]),
    );
  }
}
