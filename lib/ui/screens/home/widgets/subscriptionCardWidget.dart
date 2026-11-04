import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/generalImports.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final SubscriptionInformation? subscriptionInformation;
  final String? localLanguageCode;
  final VoidCallback? onTap;

  const SubscriptionCardWidget({
    super.key,
    this.subscriptionInformation,
    this.localLanguageCode,
    this.onTap,
  });

  String getPendingDays(String expireDate) {
    final String dateString = expireDate;
    final DateTime enteredDate = DateTime.parse(dateString);

    DateTime currentDate = DateTime.now();
    currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    final int pendingDays = enteredDate.difference(currentDate).inDays;
    return pendingDays.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<FetchSystemSettingsCubit>().subscriptionsEnabled) {
      return const SizedBox.shrink();
    }
    // If subscription is null, show a different UI
    if (subscriptionInformation == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: onTap,
          child: CustomContainer(
            padding: const EdgeInsets.all(15),
            borderRadius: UiUtils.borderRadiusOf10,
            color: AppColors.pendingPaymentStatusColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomContainer(
                  color: AppColors.whiteColors.withValues(alpha: 0.2),
                  borderRadius: UiUtils.borderRadiusOf10,
                  padding: const EdgeInsets.all(10),
                  child: CustomSvgPicture(
                    svgImage: AppAssets.crown,
                    color: AppColors.whiteColors,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Subscription Name
                      CustomText(
                        'upgradetoPremium'.translate(context: context),
                        color: AppColors.whiteColors,
                        fontSize: 18,
                        maxLines: 1,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 5),
                      // Subscription Details Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomText(
                              'withoutPremiumyourservicewontbeshowntocustomers.'
                                  .translate(context: context),
                              fontSize: 12,
                              color: AppColors.whiteColors.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          // Days Left
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.whiteColors,
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Active subscription UI
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: onTap,
        child: CustomContainer(
          padding: const EdgeInsets.all(15),
          borderRadius: UiUtils.borderRadiusOf10,
          color: context.colorScheme.accentColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                color: AppColors.whiteColors.withValues(alpha: 0.2),
                borderRadius: UiUtils.borderRadiusOf10,
                padding: const EdgeInsets.all(10),
                child: CustomSvgPicture(
                  svgImage: AppAssets.crown,
                  color: AppColors.whiteColors,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subscription Name
                    CustomText(
                      subscriptionInformation!.name!,
                      color: AppColors.whiteColors,
                      fontSize: 18,
                      maxLines: 1,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 5),
                    // Subscription Details Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Valid Till Date
                        Expanded(
                          child:
                              subscriptionInformation!.duration != "unlimited"
                              ? CustomText(
                                  '${'validTill'.translate(context: context)} ${DateFormat("d MMM yyyy", localLanguageCode).format(DateTime.parse(subscriptionInformation!.expiryDate!))}',
                                  fontSize: 12,
                                  color: AppColors.whiteColors.withValues(
                                    alpha: 0.5,
                                  ),
                                  maxLines: 1,
                                )
                              : CustomText(
                                  'yoursforlifeNoexpiry'.translate(
                                    context: context,
                                  ),
                                  fontSize: 12,
                                  color: AppColors.whiteColors.withValues(
                                    alpha: 0.5,
                                  ),
                                  maxLines: 1,
                                ),
                        ),

                        // Days Left
                        if (subscriptionInformation!.duration !=
                            "unlimited") ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: CustomText(
                              '${getPendingDays(subscriptionInformation!.expiryDate!)} ${'daysLeft'.translate(context: context)}',
                              color: AppColors.whiteColors,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
