import 'package:flutter/cupertino.dart';

import '../config.dart';

class AppAlertDialogCommon extends StatelessWidget {
  final bool? isField;
  final String? image, subtext, title, singleText, firstBText, secondBText;
  final double? height;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormState>? globalKey;
  final FocusNode? focusNode;
  final GestureTapCallback? singleTap, firstBTap, secondBTap;
  final bool isLoading;

  const AppAlertDialogCommon(
      {super.key,
      this.isField = false,
      this.image,
      this.height,
      this.subtext,
      this.title,
      this.singleText,
      this.firstBText,
      this.secondBText,
      this.singleTap,
      this.firstBTap,
      this.secondBTap,
      this.controller,
      this.focusNode,
      this.validator,
      this.globalKey,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1))),
        backgroundColor: appColor(context).appTheme.whiteBg,
        content: Stack(alignment: Alignment.topRight, children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            isField == true
                ? Form(
                    key: globalKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language(context, translations!.reason),
                              style: appCss.dmDenseMedium15.textColor(
                                  appColor(context).appTheme.darkText)),
                          const VSpace(Sizes.s8),
                          TextFieldCommon(
                              focusNode: focusNode,
                              validator: validator,
                              fillColor: appColor(context).appTheme.fieldCardBg,
                              controller: controller,
                              hintText: translations!.writeANote!,
                              maxLines: 3,
                              minLines: 3,
                              isNumber: true)
                        ]),
                  )
                : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child:
                            Image.asset(image!, height: height ?? Sizes.s190))
                    .paddingSymmetric(vertical: Insets.i20)
                    .decorated(
                        color: appColor(context).appTheme.fieldCardBg,
                        borderRadius: BorderRadius.circular(AppRadius.r10)),
            // Sub text
            const VSpace(Sizes.s15),
            if (isField == false)
              Text(language(context, subtext!),
                  textAlign: TextAlign.center,
                  style: appCss.dmDenseRegular14
                      .textColor(appColor(context).appTheme.darkText)
                      .textHeight(1.4)),
            const VSpace(Sizes.s20),
            isField == true
                ? ButtonCommon(
                    onTap: singleTap,
                    title: singleText!,
                  )
                : BottomSheetButtonCommon(
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
        ]));
  }
}
