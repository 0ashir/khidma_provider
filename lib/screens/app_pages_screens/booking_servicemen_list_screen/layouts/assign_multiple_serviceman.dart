import 'dart:developer';

import '../../../../config.dart';

class AssignMultipleServiceman extends StatelessWidget {
  final List<ServicemanModel> selectService;
  const AssignMultipleServiceman({super.key, required this.selectService});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingServicemenListProvider>(builder: (context, value, child) {
      return AlertDialogCommon(
          isLoading: value.isAssignLoading,
          title: translations!.assignToServicemen,
          subtext: translations!.areYouSureServicemen,
          isBooked: true,
          isTwoButton: true,
          widget: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Stack(alignment: Alignment.topRight, children: [
                Image.asset(eImageAssets.assignServicemen,
                    height: Sizes.s145, width: Sizes.s130),
                SizedBox(
                    height: Sizes.s34,
                    width: Sizes.s34,
                    child: Image.asset(eGifAssets.tick,
                        height: Sizes.s34, width: Sizes.s34))
                    .paddingOnly(top: Insets.i30)
              ]))
              .paddingOnly(top: Insets.i15)
              .decorated(
              color: appColor(context).appTheme.fieldCardBg,
              borderRadius: BorderRadius.circular(AppRadius.r10)),
          height: Sizes.s145,
          firstBText: translations!.cancel,
          firstBTap: () => route.pop(context),
          secondBText: translations!.yes,
          secondBTap: () async {
            final service =
            Provider.of<BookingServicemenListProvider>(context, listen: false);
            service.isAssignLoading = true;
            service.notifyListeners();
            await Future.delayed(const Duration(seconds: 1));

            await createBookingNotification(
                NotificationType.updateBookingStatusEvent);
            await createBookingNotification(NotificationType.assignBooking);

            route.pop(context);
            /* route.pop(context); */
            route.pop(context, arg: selectService);
            final userApi =
            Provider.of<UserDataApiProvider>(context, listen: false);

            userApi.getBookingHistory(context);
            route.pop(context);
            log("AssignMultipleServiceman : $selectService");
            // route.pop(context, arg: selectService);
          });
    });
  }
}
