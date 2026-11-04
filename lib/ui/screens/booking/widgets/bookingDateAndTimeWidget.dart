import '../../../../app/generalImports.dart';

class BookingDateAndTimeWidget extends StatelessWidget {
  const BookingDateAndTimeWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'bookingAt'.translate(context: context),
                color: context.colorScheme.lightGreyColor,
              ),
              CustomText(
                bookingsModel.addressId == "0"
                    ? 'store'.translate(context: context)
                    : "doorstep".translate(context: context),
                color: context.colorScheme.accentColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (bookingsModel.addressId != "0")
            CustomInkWellContainer(
              showSplashEffect: false,
              onTap: () => _handleAddressTap(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.mapPic,
                    color: context.colorScheme.accentColor,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(child: CustomText(bookingsModel.address ?? '')),
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (bookingsModel.addressId != "0" &&
              (bookingsModel.customerNo?.isNotEmpty ?? false)) ...[
            CustomInkWellContainer(
              showSplashEffect: false,
              onTap: () => _handleNumberTap(
                context,
                bookingsModel.customerNo.toString(),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.call,
                    color: context.colorScheme.accentColor,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(child: CustomText(bookingsModel.customerNo ?? '')),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (bookingsModel.multipleDaysBooking != null)
            MultiDayDateAndTime(booking: bookingsModel.multipleDaysBooking!)
          else
            DateAndTime(bookingModel: bookingsModel),
        ],
      ),
    );
  }

  Future<void> _handleNumberTap(
    BuildContext context,
    String phoneNumber,
  ) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }

  Future<void> _handleAddressTap(BuildContext context) async {
    UiUtils.openMap(
      context,
      latitude: bookingsModel.latitude,
      longitude: bookingsModel.longitude,
    );
  }
}
