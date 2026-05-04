import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class BookingStatusDialog extends StatelessWidget {
  final BookingModel? bookingModel;
  const BookingStatusDialog({super.key, this.bookingModel});
  @override
  Widget build(BuildContext context) {
    return /* bookingModel == null
        ? Container()
        : */
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(language(context, translations!.bookingStatus),
                style: appCss.dmDenseMedium18
                    .textColor(appColor(context).appTheme.darkText)),
            const Icon(CupertinoIcons.multiply)
                .inkWell(onTap: () => route.pop(context))
          ]).paddingSymmetric(horizontal: Insets.i20),
          SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                      height: Sizes.s46,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(eImageAssets.bookingStatusBg))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "\u2022 ${language(context, translations!.bookingId)}",
                                style: appCss.dmDenseMedium12.textColor(
                                    appColor(context).appTheme.primary)),
                            Text("#${bookingModel!.bookingNumber}",
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.primary))
                          ]).paddingSymmetric(
                          horizontal: MediaQuery.of(context).size.width / 20))
                  .paddingOnly(top: Insets.i25, bottom: Insets.i20),
              if (bookingModel!.bookingStatusLogs!.isNotEmpty)
                ...bookingModel!.bookingStatusLogs!.reversed
                    .toList()
                    .asMap()
                    .entries
                    .map((e) => StatusStepsLayout(
                        data: e.value,
                        index: e.key,
                        id: bookingModel!.id,
                        selectIndex: 0,
                        list: bookingModel!.bookingStatusLogs))
            ]).paddingSymmetric(horizontal: Insets.i20),
          ),
        ]).paddingSymmetric(vertical: Insets.i20).bottomSheetExtension(context);
  }
}
