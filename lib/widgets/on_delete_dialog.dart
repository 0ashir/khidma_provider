import 'package:flutter/cupertino.dart';

import '../config.dart';

class OnDeleteDialog extends StatelessWidget {
  final String? image, title, subtitle;
  final GestureTapCallback? onDelete;

  const OnDeleteDialog(
      {super.key, this.image, this.title, this.subtitle, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context2, setState) {
      return Consumer<DeleteDialogProvider>(builder: (context3, value, child) {
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
                  eGifAssets.delete, /* height: Sizes.s34, width: Sizes.s34 */
                ),
                /*  Stack(alignment: Alignment.topCenter, children: [
                  /*  Image.asset(
                    image!,
                    // width: MediaQuery.of(context).size.width,
                    // fit: BoxFit.cover,
                  ) */
                  Stack(alignment: Alignment.bottomCenter, children: [
                    SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(alignment: Alignment.center, children: [
                              SizedBox(
                                  height: Sizes.s180,
                                  width: Sizes.s150,
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: value.isPositionedRight
                                          ? Curves.bounceIn
                                          : Curves.bounceOut,
                                      alignment: value.isPositionedRight
                                          ? value.isAnimateOver
                                              ? Alignment.center
                                              : Alignment.topCenter
                                          : Alignment.centerLeft,
                                      child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          height:
                                              value.isPositionedRight ? 39 : 13,
                                          child: Image.asset(image!)))),
                              Image.asset(eImageAssets.dustbin,
                                  height: Sizes.s88, width: Sizes.s88)
                            ]))
                        .paddingOnly(top: 50)
                        .decorated(
                            color: appColor(context).appTheme.fieldCardBg,
                            borderRadius: BorderRadius.circular(AppRadius.r10)),
                  ]),
                  if (value.offsetAnimation != null)
                    SlideTransition(
                        position: value.offsetAnimation!,
                        child: (value.offsetAnimation != null &&
                                value.isAnimateOver == true)
                            ? Image.asset(eImageAssets.dustbinCover, height: 38)
                            : const SizedBox())
                ]), */
                // Sub text
                const VSpace(Sizes.s15),
                Text(language(context, subtitle),
                    textAlign: TextAlign.center,
                    style: appCss.dmDenseRegular14
                        .textColor(appColor(context).appTheme.lightText)
                        .textHeight(1.3)),
                const VSpace(Sizes.s20),
                Row(children: [
                  Expanded(
                      child: ButtonCommon(
                          onTap: () => route.pop(context),
                          title: translations!.no,
                          borderColor: appColor(context).appTheme.primary,
                          color: appColor(context).appTheme.whiteBg,
                          style: appCss.dmDenseSemiBold16
                              .textColor(appColor(context).appTheme.primary))),
                  const HSpace(Sizes.s15),
                  Expanded(
                      child: ButtonCommon(
                          onTap: onDelete, title: translations!.yes))
                ])
              ]).padding(
                  horizontal: Insets.i20, top: Insets.i60, bottom: Insets.i20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Title
                Text(language(context, title!),
                    overflow: TextOverflow.ellipsis,
                    style: appCss.dmDenseMedium18
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
