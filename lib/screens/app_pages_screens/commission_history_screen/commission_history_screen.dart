import 'dart:developer';

import '../../../config.dart';

class CommissionHistory extends StatelessWidget {
  const CommissionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommissionHistoryProvider, UserDataApiProvider>(
        builder: (context1, value, userApi, child) {
      return Scaffold(
          appBar:
              ActionAppBar(title: translations!.commissionHistory, actions: [
            if (!isServiceman && !isFreelancer)
              CommonArrow(
                      arrow: eSvgAssets.about,
                      onTap: () =>
                          route.pushNamed(context, routeName.commissionInfo))
                  .paddingOnly(right: Insets.i20)
          ]),
          body: userApi.isLodingForCommissionHistory == true ||
                  commissionList == null
              ? Image.asset(eGifAssets.loaderGif, height: Sizes.s100).center()
              : /* commissionList == null
                  ? const CommonEmpty()
                  :*/
              SingleChildScrollView(
                  child: Column(children: [
                  Container(
                      height: Sizes.s64,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(eImageAssets.balanceContainer),
                              fit: BoxFit.fill)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Image.asset(eImageAssets.discount,
                                  width: Sizes.s40, height: Sizes.s40),
                              const HSpace(Sizes.s10),
                              Text(
                                      language(
                                          context,
                                          translations!
                                              .totalReceivedCommission),
                                      style: appCss.dmDenseMedium15.textColor(
                                          appColor(context)
                                              .appTheme
                                              .whiteColor
                                              .withOpacity(0.7)))
                                  .width(Sizes.s110)
                            ]),
                            Text(
                                symbolPosition
                                    ? "${getSymbol(context)}${(currency(context).currencyVal * commissionList!.total!).toStringAsFixed(2)}"
                                    : "${(currency(context).currencyVal * commissionList!.total!).toStringAsFixed(2)}${getSymbol(context)}",
                                style: appCss.dmDenseblack20.textColor(
                                    appColor(context).appTheme.whiteColor))
                          ]).paddingSymmetric(horizontal: Insets.i12)),
                  // const VSpace(Sizes.s20),
                  // if (!isServiceman && !isFreelancer)
                  //   Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         SizedBox(
                  //             width: Sizes.s200,
                  //             child: Text(
                  //                 language(
                  //                     context, translations!.onlyCompletedByMe),
                  //                 style: appCss.dmDenseMedium12.textColor(value
                  //                         .isCompletedMe
                  //                     ? appColor(context).appTheme.primary
                  //                     : appColor(context).appTheme.darkText))),
                  //         FlutterSwitchCommon(
                  //             value: value.isCompletedMe,
                  //             onToggle: (val) =>
                  //                 value.onTapSwitch(val, context))
                  //       ]).paddingAll(Insets.i15).boxShapeExtension(
                  //       color: value.isCompletedMe
                  //           ? appColor(context)
                  //               .appTheme
                  //               .primary
                  //               .withOpacity(0.15)
                  //           : appColor(context).appTheme.fieldCardBg,
                  //       radius: AppRadius.r10),
                  if (!isServiceman && !isFreelancer) const VSpace(Sizes.s20),
                  if (commissionList!.histories!.isEmpty) const CommonEmpty(),
                  if (commissionList!.histories!.isNotEmpty)
                    commissionList!.histories!.isEmpty
                        ? CommonEmpty()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: commissionList!.histories?.length,
                            itemBuilder: (contest, index) {
                              return CommissionHistoryLayout(
                                  data: commissionList!.histories![index],
                                  onTap: () => route.pushNamed(
                                      context, routeName.bookingDetails,
                                      arg: commissionList!.histories![index]));
                            })
                ]).paddingSymmetric(horizontal: Insets.i20)));
    });
  }
}
