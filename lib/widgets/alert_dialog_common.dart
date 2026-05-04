import 'package:flutter/cupertino.dart';
import '../config.dart';

class AlertDialogCommon extends StatelessWidget {
  final String? image, title, subtext, bText1, firstBText, secondBText;
  final GestureTapCallback? b1OnTap, firstBTap, secondBTap;
  final double? height;
  final bool? isBooked,isTwoButton;
  final Widget? widget;
  final bool isLoading;


  const AlertDialogCommon(
      {Key? key,
      this.title,
      this.b1OnTap,
      this.bText1,
      this.image,
      this.subtext,
      this.isBooked = false,
      this.widget,
      this.height,this.isTwoButton = false, this.firstBText, this.secondBText, this.firstBTap, this.secondBTap, this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
        contentPadding: EdgeInsets.zero,
        shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
        backgroundColor: appColor(context).appTheme.whiteBg,
        content: Consumer<LanguageProvider>(
          builder: (context, lang, child)  {
            return Stack(alignment: Alignment.topRight, children: [
              Column(
                  mainAxisSize: MainAxisSize.min, children: [
                // Gif
              isBooked == true ? widget! : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(image!, height: height ?? Sizes.s190))
                    .paddingSymmetric(vertical: Insets.i20)
                    .decorated(
                        color: appColor(context).appTheme.fieldCardBg,
                        borderRadius: BorderRadius.circular(AppRadius.r10)),
                // Sub text
                const VSpace(Sizes.s15),
                Text(language(context, subtext!),
                    textAlign: TextAlign.center,
                    style: appCss.dmDenseRegular14
                        .textColor(appColor(context).appTheme.lightText)
                        .textHeight(1.4)),
                const VSpace(Sizes.s20),
                if(isTwoButton != true)
                ButtonCommon(onTap: b1OnTap, title: bText1!),
                if(isTwoButton == true)
                BottomSheetButtonCommon(
                    isLoading: isLoading,
                    clearTap: firstBTap,
                    applyTap: secondBTap,
                    textTwo: secondBText,
                    textOne: firstBText)
              ]).padding(
                  horizontal: Insets.i20, top: Insets.i60, bottom: Insets.i20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Title
                Expanded(
                  child: Text(language(context, title!),
                      overflow: TextOverflow.ellipsis,
                      style: appCss.dmDenseMedium18
                          .textColor(appColor(context).appTheme.darkText)),
                ),
                Icon(CupertinoIcons.multiply,
                        size: Sizes.s20, color: appColor(context).appTheme.darkText)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingAll(Insets.i20)
            ]);
          }
        ));
  }
}
