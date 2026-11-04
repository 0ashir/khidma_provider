import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class CancelReasonWidget extends StatelessWidget {
  const CancelReasonWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  @override
  Widget build(BuildContext context) {
    final cancelReason = bookingsModel.cancelReason;
    final cancelAdditionalInfo = bookingsModel.cancelAdditionalInfo;

    // Only show when the booking is cancelled and has a cancel reason
    if (bookingsModel.status?.toLowerCase() != 'cancelled' ||
        cancelReason == null ||
        cancelReason.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CustomContainer(
          width: context.screenWidth,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              CustomText(
                'cancellationReason'.translate(context: context),
                maxLines: 1,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).colorScheme.blackColor,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CustomText(
                    "${'reason'.translate(context: context)}: ",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                  CustomText(
                    cancelReason,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.lightGreyColor,
                  ),
                ],
              ),
              if (cancelAdditionalInfo != null &&
                  cancelAdditionalInfo.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    CustomText(
                      "${'additionalInfo'.translate(context: context)}: ",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                    CustomText(
                      cancelAdditionalInfo,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.lightGreyColor,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
