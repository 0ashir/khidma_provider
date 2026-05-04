import '../config.dart';
import '../providers/app_pages_provider/job_request_providers/job_request_details_provider.dart';

class BottomSheetButtonCommon extends StatelessWidget {
  final GestureTapCallback? clearTap, applyTap;
  final String? textOne, textTwo;
  final bool? isLoading;

  const BottomSheetButtonCommon(
      {super.key,
      this.applyTap,
      this.clearTap,
      this.textOne,
      this.textTwo,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    var pending = Provider.of<PendingBookingProvider>(context);
    var job = Provider.of<JobRequestDetailsProvider>(context);
    return Row(children: [
      Expanded(
          child: ButtonCommon(
              title: textOne!,
              onTap: clearTap,
              style: appCss.dmDenseRegular16
                  .textColor(appColor(context).appTheme.primary),
              color: appColor(context).appTheme.trans,
              borderColor: appColor(context).appTheme.primary)),
      const HSpace(Sizes.s15),
      Expanded(
          child: pending.loading == true ||
                  job.isBidLoading == true ||
                  isLoading == true
              ? Container(
                  height: Sizes.s50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appColor(context).appTheme.primary),
                  child: CircularProgressIndicator(
                          color: appColor(context).appTheme.whiteBg)
                      .center())
              : ButtonCommon(title: textTwo!, onTap: applyTap))
    ]);
  }
}
