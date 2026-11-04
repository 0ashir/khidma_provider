import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class DateAndTime extends StatelessWidget {
  final BookingsModel bookingModel;
  const DateAndTime({super.key, required this.bookingModel});

  @override
  Widget build(BuildContext context) {
    // Date/time format comes from the country settings; rebuild when they load.
    context.watch<FetchCountrySettingsCubit>();
    return IntrinsicHeight(
      child: Row(
        children: [
          CustomSvgPicture(
            svgImage: AppAssets.bCalender,
            height: 16,
            width: 16,
            color: context.colorScheme.accentColor,
          ),
          const SizedBox(width: 5),
          CustomText(
            bookingModel.dateOfService.toString().formatDate(
              withTime: bookingModel.startingTime,
            ),
            fontSize: 14,
            color: context.colorScheme.blackColor,
            fontWeight: FontWeight.w600,
          ),
          VerticalDivider(
            color: context.colorScheme.lightGreyColor,
            thickness: 0.2,
          ),
          CustomSvgPicture(
            svgImage: AppAssets.bClock,
            height: 16,
            width: 16,
            color: context.colorScheme.accentColor,
          ),
          const SizedBox(width: 5),
          CustomText(
            (bookingModel.startingTime ?? '').toString().formatTime(
              onDate: bookingModel.dateOfService,
            ),
            fontSize: 14,
            color: context.colorScheme.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

/// Start and end day of a booking that spans several days.
class MultiDayDateAndTime extends StatelessWidget {
  const MultiDayDateAndTime({super.key, required this.booking});

  final MultipleDaysBooking booking;

  @override
  Widget build(BuildContext context) {
    // Date/time format comes from the country settings; rebuild when they load.
    context.watch<FetchCountrySettingsCubit>();
    return Column(
      children: [
        _row(context, 'fromDate', booking.startDate, booking.startTime),
        const SizedBox(height: 8),
        _row(
          context,
          'toDate',
          booking.endDate.isEmpty ? booking.startDate : booking.endDate,
          booking.endTime,
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String labelKey, String date, String time) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              labelKey.translate(context: context),
              fontSize: 14,
              color: context.colorScheme.lightGreyColor,
            ),
          ),
          CustomSvgPicture(
            svgImage: AppAssets.bCalender,
            height: 16,
            width: 16,
            color: context.colorScheme.accentColor,
          ),
          const SizedBox(width: 5),
          CustomText(
            date.formatDate(withTime: time),
            fontSize: 14,
            color: context.colorScheme.blackColor,
            fontWeight: FontWeight.w600,
          ),
          if (time.isNotEmpty) ...[
            VerticalDivider(
              color: context.colorScheme.lightGreyColor,
              thickness: 0.2,
            ),
            CustomSvgPicture(
              svgImage: AppAssets.bClock,
              height: 16,
              width: 16,
              color: context.colorScheme.accentColor,
            ),
            const SizedBox(width: 5),
            CustomText(
              time.formatTime(onDate: date),
              fontSize: 14,
              color: context.colorScheme.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ],
      ),
    );
  }
}
