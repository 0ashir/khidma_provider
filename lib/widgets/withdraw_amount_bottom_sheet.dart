import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../config.dart';

class WithdrawAmountBottomSheet extends StatelessWidget {
  const WithdrawAmountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, WalletProvider>(
        builder: (context1, value, wallet, child) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.90,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  language(
                                      context, translations!.withdrawMoney),
                                  style: appCss.dmDenseMedium18.textColor(
                                      appColor(context).appTheme.darkText)),
                              const Icon(CupertinoIcons.multiply)
                                  .inkWell(onTap: () => route.pop(context))
                            ]).paddingSymmetric(horizontal: Insets.i20),
                        Expanded(
                            child: Form(
                          key: wallet.withdrawKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VSpace(Sizes.s25),
                                Expanded(
                                    child: SingleChildScrollView(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                language(context,
                                                    translations!.amount),
                                                style: appCss.dmDenseMedium14
                                                    .textColor(appColor(context)
                                                        .appTheme
                                                        .darkText)),
                                            /*  Text(
                                                language(
                                                    context,
                                                    symbolPosition
                                                        ? "${language(context, translations!.availableBal)} : ${getSymbol(context)}${(userModel!.providerWallet != null ? double.parse(userModel!.providerWallet!.balance.toString()) : 0.0)}"
                                                        : "${language(context, translations!.availableBal)} : ${(userModel!.providerWallet != null ? double.parse(userModel!.providerWallet!.balance.toString()) : 0.0)}${getSymbol(context)}"),
                                                style: appCss.dmDenseMedium14
                                                    .textColor(appColor(context)
                                                        .appTheme
                                                        .primary)) */
                                          ]).paddingOnly(bottom: Insets.i8),
                                      TextFieldCommon(
                                          keyboardType: TextInputType.number,
                                          focusNode: wallet.amountFocus,
                                          controller: wallet.withDrawAmountCtrl,
                                          validator: (value) =>
                                              validation.dynamicTextValidation(
                                                  context,
                                                  value,
                                                  translations!.enterAmount),
                                          hintText: translations!.enterAmount!,
                                          prefixIcon: eSvgAssets.earning),
                                      const VSpace(Sizes.s20),
                                      Text(
                                              language(context,
                                                  translations!.customMessage),
                                              style: appCss.dmDenseMedium14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText))
                                          .paddingOnly(bottom: Insets.i8),
                                      Stack(children: [
                                        TextFieldCommon(
                                            focusNode: value.messageFocus,
                                            isNumber: true,
                                            controller: wallet.messageCtrl,
                                            hintText:
                                                translations!.enterDetails!,
                                            maxLines: 3,
                                            minLines: 3,
                                            isMaxLine: true),
                                        SvgPicture.asset(eSvgAssets.details,
                                                fit: BoxFit.scaleDown,
                                                colorFilter: ColorFilter.mode(
                                                    !value.messageFocus.hasFocus
                                                        ? wallet.messageCtrl
                                                                .text.isNotEmpty
                                                            ? appColor(context)
                                                                .appTheme
                                                                .darkText
                                                            : appColor(context)
                                                                .appTheme
                                                                .lightText
                                                        : appColor(context)
                                                            .appTheme
                                                            .darkText,
                                                    BlendMode.srcIn))
                                            .paddingOnly(
                                                left: rtl(context)
                                                    ? 0
                                                    : Insets.i15,
                                                right: rtl(context)
                                                    ? Insets.i15
                                                    : 0,
                                                top: Insets.i13)
                                      ]),
                                      if ((wallet.showValidationError))
                                        Text(
                                          validation.dynamicTextValidation(
                                            context,
                                            wallet.messageCtrl.text,
                                            translations!.enterDescription,
                                          ),
                                          style: appCss.dmDenseRegular12
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .errorColor),
                                        ).padding(
                                            horizontal: Sizes.s20,
                                            vertical: Sizes.s5)
                                    ]).paddingAll(Insets.i15).boxShapeExtension(
                                                color: appColor(context)
                                                    .appTheme
                                                    .fieldCardBg,
                                                radius: AppRadius.r15))
                                        .paddingSymmetric(
                                            horizontal: Insets.i20)),
                                BottomSheetButtonCommon(
                                        textOne: translations!.cancel,
                                        textTwo: translations!.withdraw,
                                        applyTap: () {
                                          if (wallet.isWithDrow == true) {
                                            log("message=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
                                          } else {
                                            wallet.withdrawRequest(context);
                                          }
                                        },
                                        clearTap: () {
                                          wallet.amountCtrl.text = "";
                                          wallet.withDrawAmountCtrl.text = "";
                                          wallet.messageCtrl.text = "";
                                          wallet.showValidationError = false;

                                          route.pop(context);
                                        })
                                    .padding(
                                        horizontal: Insets.i20,
                                        bottom: Insets.i20)
                              ]),
                        ))
                      ]).paddingOnly(top: Insets.i20))
              .bottomSheetExtension(context),
        ),
      );
    });
  }
}
