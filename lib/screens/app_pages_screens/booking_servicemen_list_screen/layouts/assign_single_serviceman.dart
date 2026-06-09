import 'dart:developer';

import '../../../../config.dart';

class AssignSingleServiceman extends StatelessWidget {
  final List<ServicemanModel>? selectService;
  const AssignSingleServiceman({super.key, this.selectService});

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
            log("aaaaaaa lllllllll single servicemen");
            final service =
            Provider.of<BookingServicemenListProvider>(context, listen: false);
            service.isAssignLoading = true;
            service.notifyListeners();

            // Capture stable references BEFORE popping anything — once the
            // dialog route is popped, `context` belongs to a deactivated
            // widget and reusing it for a second Navigator.pop throws
            // "deactivated widget" (silently swallowed), so the screen below
            // never receives the result. That's why assign required two tries.
            final navigator = Navigator.of(context);
            final userApi =
            Provider.of<UserDataApiProvider>(context, listen: false);
            final common = Provider.of<CommonApiProvider>(context, listen: false);

            await Future.delayed(const Duration(seconds: 1));

            await createBookingNotification(
                NotificationType.updateBookingStatusEvent);
            await createBookingNotification(NotificationType.assignBooking);

            navigator.pop();
            navigator.pop(selectService);

            userApi.getBookingHistory(context);
            if (!isFreelancer) {
              log("AssignSingleServiceman : $selectService");
              userApi.getServicemenByProviderId();
              common.getDashBoardApi(context);
            }
          });
    });
  }
}
