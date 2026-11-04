import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsContainer extends StatelessWidget {
  final bool? showLoading;
  final bool isActiveSubscription;
  final bool isAvailableForPurchase;
  final bool isPreviousSubscription;
  final bool needToShowPaymentStatus;
  final SubscriptionInformation subscriptionDetails;
  final Function onBuyButtonPressed;

  const SubscriptionDetailsContainer({
    super.key,
    required this.subscriptionDetails,
    required this.onBuyButtonPressed,
    required this.isActiveSubscription,
    required this.isAvailableForPurchase,
    required this.isPreviousSubscription,
    this.showLoading,
    required this.needToShowPaymentStatus,
  });

  /// Formats [amount] in the plan's own currency (`subscription_information`);
  /// the system currency when the plan carries none.
  String _price(BuildContext context, String? amount) =>
      (amount ?? '0').priceFormat(
        context,
        currencySymbol: subscriptionDetails.currencySymbol,
        decimalPlaces: subscriptionDetails.currencyDecimalPlaces,
        currencyCode: subscriptionDetails.currency,
      );

  Widget getPaymentStatusContainer({
    required String paymentStatus,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(
          paymentStatus == "0"
              ? Icons.pending
              : paymentStatus == "1"
              ? Icons.done
              : Icons.close,
          size: 16,
          color: paymentStatus == "0"
              ? AppColors.starRatingColor
              : paymentStatus == "1"
              ? AppColors.greenColor
              : AppColors.redColor,
        ),
        const SizedBox(width: 5),
        Text(
          paymentStatus == "0"
              ? "paymentPending".translate(context: context)
              : paymentStatus == "1"
              ? "paymentSuccess".translate(context: context)
              : "paymentFailed".translate(context: context),
          style: TextStyle(
            color: paymentStatus == "0"
                ? AppColors.starRatingColor
                : paymentStatus == "1"
                ? AppColors.greenColor
                : AppColors.redColor,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ],
    );
  }

  Widget getTitle({required String title, required BuildContext context}) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.blackColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }

  Widget setSubscriptionPlanDetailsPoint({
    required final String title,
    required final BuildContext context,
  }) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: isAvailableForPurchase
              ? context.colorScheme.blackColor
              : AppColors.greenColor,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget buyButton({
    required final bool isLoading,
    required final String subscriptionId,
    required final String subscriptionPrice,
    required BuildContext context,
    required Function onBuyButtonPressed,
  }) {
    return CustomRoundedButton(
      widthPercentage: 0.3,
      width: double.infinity,
      height: 40,
      textSize: 14,
      radius: UiUtils.borderRadiusOf10,
      backgroundColor: Theme.of(context).colorScheme.blackColor,
      buttonTitle: "upgradeNow".translate(context: context),
      showBorder: false,
      titleColor: context.colorScheme.secondaryColor,
      onTap: () {
        if (subscriptionPrice == "0") {
          onBuyButtonPressed.call();
        } else {
          // Check if online payment is enabled
          // The provider's country decides; the system flag only applies
          // until the country settings load.
          final isOnlinePaymentEnabled =
              context.read<FetchCountrySettingsCubit>().hasOnlinePayment ??
              (context.read<FetchSystemSettingsCubit>().state
                          as FetchSystemSettingsSuccess)
                      .paymentGatewaysSettings
                      .isOnlinePaymentEnable !=
                  "0";

          if (!isOnlinePaymentEnabled) {
            UiUtils.showMessage(
              context,
              'noPaymentServiceAvailable',
              ToastificationType.error,
            );
          } else {
            onBuyButtonPressed.call();
          }
        }
      },
      child: isLoading
          ? CustomContainer(
              height: 30,
              child: FittedBox(
                child: CustomCircularProgressIndicator(
                  color: AppColors.whiteColors,
                  strokeWidth: 2,
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<FetchSystemSettingsCubit>().subscriptionsEnabled) {
      return const SizedBox.shrink();
    }
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      width: MediaQuery.sizeOf(context).width,
      border: isAvailableForPurchase
          ? Border.all(color: context.colorScheme.lightGreyColor)
          : Border.all(color: context.colorScheme.accentColor),
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomContainer(
                borderRadius: UiUtils.borderRadiusOf6,
                color: isAvailableForPurchase
                    ? context.colorScheme.blackColor.withAlpha(20)
                    : context.colorScheme.accentColor.withAlpha(20),
                padding: const EdgeInsetsDirectional.all(8),
                child: CustomSvgPicture(
                  svgImage: AppAssets.crown,
                  color: isAvailableForPurchase
                      ? context.colorScheme.blackColor
                      : context.colorScheme.accentColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: getTitle(
                  title: subscriptionDetails.translatedName ?? '',
                  context: context,
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Text(
                    (subscriptionDetails.discountPrice ?? "0") != "0"
                        ? _price(
                            context,
                            subscriptionDetails.discountPriceWithTax,
                          )
                        : (subscriptionDetails.priceWithTax ?? "0") == "0"
                        ? "free".translate(context: context)
                        : _price(context, subscriptionDetails.priceWithTax),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  if ((subscriptionDetails.discountPrice ?? "0") != "0") ...[
                    const SizedBox(width: 3),
                    CustomText(
                      _price(context, subscriptionDetails.priceWithTax),
                      color: isAvailableForPurchase
                          ? context.colorScheme.blackColor
                          : context.colorScheme.accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      underlineOrLineColor: context.colorScheme.blackColor,
                      showLineThrough: true,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),
          if ((subscriptionDetails.taxPercenrage ?? "0") != "0")
            setSubscriptionPlanDetailsPoint(
              context: context,
              title:
                  "${subscriptionDetails.taxPercenrage ?? "0"}% ${"taxIncludedInPrice".translate(context: context)}",
            ),
          setSubscriptionPlanDetailsPoint(
            context: context,
            title:
                (subscriptionDetails.maxOrderLimit ?? '') != '' &&
                    (subscriptionDetails.maxOrderLimit ?? '') != "0" &&
                    (subscriptionDetails.maxOrderLimit ?? '') != "-"
                ? "${"enjoyGenerousOrderLimitOf".translate(context: context)} ${subscriptionDetails.maxOrderLimit ?? "0"} ${"ordersDuringYourSubscriptionPeriod".translate(context: context)}"
                : "enjoyUnlimitedOrders".translate(context: context),
          ),
          const SizedBox(height: 5),
          setSubscriptionPlanDetailsPoint(
            context: context,
            title:
                (subscriptionDetails.duration ?? '') != '' &&
                    (subscriptionDetails.duration ?? '') != "unlimited"
                ? "${"yourSubscriptionWillBeValidFor".translate(context: context)} ${subscriptionDetails.duration ?? ''} ${"days".translate(context: context)} "
                : "enjoySubscriptionForUnlimitedDays".translate(
                    context: context,
                  ),
          ),

          const SizedBox(height: 5),
          setSubscriptionPlanDetailsPoint(
            context: context,
            title: (subscriptionDetails.isCommision == "yes")
                ? "${subscriptionDetails.commissionPercentage ?? ''}% ${"commissionWillBeAppliedToYourEarnings".translate(context: context)}"
                : "noNeedToPayExtraCommission".translate(context: context),
          ),
          const SizedBox(height: 5),
          setSubscriptionPlanDetailsPoint(
            context: context,
            title: subscriptionDetails.isCommision == "yes"
                ? "${"commissionThreshold".translate(context: context)} ${_price(context, subscriptionDetails.commissionThreshold)} ${"AmountIsReached".translate(context: context)}"
                : "noThresholdOnPayOnDeliveryAmount".translate(
                    context: context,
                  ),
          ),
          if (subscriptionDetails.isOneTimePurchase == true) ...[
            const SizedBox(height: 5),
            setSubscriptionPlanDetailsPoint(
              context: context,
              title: "oneTimePurchaseOnlyLbl".translate(context: context),
            ),
          ],

          if (isAvailableForPurchase) ...[const SizedBox(height: 5)],
          if (isActiveSubscription || isPreviousSubscription) ...[
            SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    child: CustomContainer(
                      padding: const EdgeInsets.only(top: 10),
                      borderRadius: UiUtils.borderRadiusOf10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "purchasedOn".translate(context: context),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.accentColor,
                          ),
                          Text(
                            (subscriptionDetails.purchaseDate ?? '')
                                .formatDate(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.colorScheme.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomContainer(
                      padding: const EdgeInsets.only(top: 10),
                      borderRadius: UiUtils.borderRadiusOf10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            isPreviousSubscription
                                ? "expiredOn".translate(context: context)
                                : "validTill".translate(context: context),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.accentColor,
                          ),
                          Text(
                            (subscriptionDetails.duration ?? '') != '' &&
                                    (subscriptionDetails.duration ?? '') !=
                                        "unlimited"
                                ? (subscriptionDetails.expiryDate ?? '')
                                      .formatDate()
                                : "-",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.colorScheme.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if ((subscriptionDetails.translatedDescription ?? '') != '') ...[
            const SizedBox(height: 5),
            CustomContainer(
              constraints: const BoxConstraints(minHeight: 65),
              child: CustomReadMoreTextContainer(
                text: subscriptionDetails.translatedDescription ?? '',
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.lightGreyColor,
                  fontSize: 12,
                ),
                trimLines: 2,
              ),
            ),
            if (isAvailableForPurchase)
              Align(
                alignment: Alignment.center,
                child: buyButton(
                  subscriptionId: subscriptionDetails.id ?? "0",
                  isLoading: showLoading ?? false,
                  context: context,
                  onBuyButtonPressed: onBuyButtonPressed.call,
                  subscriptionPrice: subscriptionDetails.discountPrice != "0"
                      ? subscriptionDetails.discountPriceWithTax ?? "0"
                      : subscriptionDetails.priceWithTax ?? "0",
                ),
              ),
          ],
        ],
      ),
    );
  }
}
