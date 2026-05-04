import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class DeleteAccountAlert extends StatelessWidget {
  final bool isPositionedRight, isAnimateOver;
  final Animation<Offset>? offsetAnimation;

  const DeleteAccountAlert(
      {super.key,
      this.isPositionedRight = false,
      this.isAnimateOver = false,
      this.offsetAnimation});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context2, setState) {
      return Consumer2<DeleteDialogProvider, ProfileProvider>(
          builder: (context3, value, profile, child) {
        return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
            contentPadding: EdgeInsets.zero,
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
            backgroundColor: appColor(context).appTheme.whiteBg,
            content: Stack(alignment: Alignment.topRight, children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                // Gif
                Image.asset(
                  eGifAssets
                      .accountDelete, /* height: Sizes.s34, width: Sizes.s34 */
                ),
                // Stack(alignment: Alignment.topCenter, children: [
                //   Stack(alignment: Alignment.bottomCenter, children: [
                //     SizedBox(
                //             width: MediaQuery.of(context).size.width,
                //             child: Stack(alignment: Alignment.center, children: [
                //               SizedBox(
                //                   height: Sizes.s180,
                //                   width: Sizes.s150,
                //                   child: AnimatedContainer(
                //                       duration:
                //                           const Duration(milliseconds: 200),
                //                       curve: isPositionedRight
                //                           ? Curves.bounceIn
                //                           : Curves.bounceOut,
                //                       alignment: isPositionedRight
                //                           ? isAnimateOver
                //                               ? Alignment.center
                //                               : Alignment.topCenter
                //                           : Alignment.centerLeft,
                //                       child: AnimatedContainer(
                //                           duration:
                //                               const Duration(milliseconds: 200),
                //                           height: isPositionedRight ? 88 : 13,
                //                           child: Image.asset(
                //                               eImageAssets.accountDel)))),
                //               Image.asset(eImageAssets.dustbin,
                //                   height: Sizes.s88, width: Sizes.s88)
                //             ]))
                //         .paddingOnly(top: 50)
                //         .decorated(
                //             color: appColor(context).appTheme.fieldCardBg,
                //             borderRadius: BorderRadius.circular(AppRadius.r10)),
                //   ]),
                //   if (offsetAnimation != null)
                //     SlideTransition(
                //         position: offsetAnimation!,
                //         child: (offsetAnimation != null &&
                //                 isAnimateOver == true)
                //             ? Image.asset(eImageAssets.dustbinCover, height: 38)
                //             : const SizedBox())
                // ]),
                // Sub text
                const VSpace(Sizes.s15),
                Text(language(context, translations!.yourAccountWill),
                    textAlign: TextAlign.center,
                    style: appCss.dmDenseRegular14
                        .textColor(appColor(context).appTheme.lightText)
                        .textHeight(1.2)),
                const VSpace(Sizes.s20),
                Row(children: [
                  Expanded(
                      child: ButtonCommon(
                          onTap: () => route.pop(context),
                          title: translations!.cancel!,
                          borderColor: appColor(context).appTheme.red,
                          color: appColor(context).appTheme.whiteBg,
                          style: appCss.dmDenseSemiBold16
                              .textColor(appColor(context).appTheme.red))),
                  const HSpace(Sizes.s15),
                  Expanded(
                      child: ButtonCommon(
                          color: appColor(context).appTheme.red,
                          onTap: () {
                            profile.deleteAccount(context);
                            route.pop(context);
                          },
                          title: translations!.delete!))
                ])
              ]).padding(
                  horizontal: Insets.i20, top: Insets.i60, bottom: Insets.i20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Title
                Text(language(context, translations!.deleteAccount),
                    style: appCss.dmDenseExtraBold18
                        .textColor(appColor(context).appTheme.darkText)),
                Icon(CupertinoIcons.multiply,
                        size: Sizes.s20,
                        color: appColor(context).appTheme.darkText)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingAll(Insets.i20)
            ]));
      });
    });
  }
}
