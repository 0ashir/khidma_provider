import '../../../../config.dart';

class WalletBalanceLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  const WalletBalanceLayout({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
            height: Sizes.s70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(eImageAssets.roundBg), fit: BoxFit.fill)),
            child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    SvgPicture.asset(eSvgAssets.walletFill)
                        .paddingAll(Insets.i8)
                        .decorated(
                            color: appColor(context).appTheme.whiteColor,
                            shape: BoxShape.circle),
                    const HSpace(Sizes.s10),
                    /* isServiceman
                        ? Text(language(context, translations!.walletBal),
                            style: appCss.dmDenseMedium15
                                .textColor(appColor(context).appTheme.stroke))
                        : */
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language(context, translations!.walletBal),
                              style: appCss.dmDenseMedium15.textColor(
                                  appColor(context).appTheme.whiteColor)),
                          isServiceman
                              ? Text(
                                  appSettingModel?.general?.defaultCurrency
                                              ?.symbolPosition ==
                                          "left"
                                      ? "${getSymbol(context)}${(currency(context).currencyVal * double.parse(userModel!.servicemanWallet != null && userModel!.servicemanWallet!.balance != null ? userModel!.servicemanWallet!.balance.toString() : "00")).toStringAsFixed(2)}"
                                      : "${(currency(context).currencyVal * double.parse(userModel!.servicemanWallet != null && userModel!.servicemanWallet!.balance != null ? userModel!.servicemanWallet!.balance.toString() : "00")).toStringAsFixed(2)} ${getSymbol(context)}",
                                  style: appCss.dmDenseBold16.textColor(
                                      appColor(context).appTheme.whiteColor))
                              : Text(
                                  symbolPosition
                                      ? "${getSymbol(context)}${(currency(context).currencyVal * ((double.tryParse(userModel?.providerWallet?.balance?.toString() ?? '') ?? 0.0))).toStringAsFixed(2)}"
                                      : "${(currency(context).currencyVal * ((double.tryParse(userModel?.providerWallet?.balance?.toString() ?? '') ?? 0.0))).toStringAsFixed(2)}${getSymbol(context)}",
                                  style: appCss.dmDenseBold20.textColor(
                                      appColor(context).appTheme.whiteColor))
                        ])
                  ]),
                  Spacer(),
                  /*  isServiceman
                      ? Text(
                          appSettingModel?.general?.defaultCurrency
                                      ?.symbolPosition ==
                                  "left"
                              ? "${getSymbol(context)}${(currency(context).currencyVal * double.parse(userModel!.servicemanWallet != null && userModel!.servicemanWallet!.balance != null ? userModel!.servicemanWallet!.balance.toString() : "00")).toStringAsFixed(2)}"
                              : "${(currency(context).currencyVal * double.parse(userModel!.servicemanWallet != null && userModel!.servicemanWallet!.balance != null ? userModel!.servicemanWallet!.balance.toString() : "00")).toStringAsFixed(2)} ${getSymbol(context)}",
                          style: appCss.dmDenseBold16
                              .textColor(appColor(context).appTheme.whiteColor))
                      : */
                  (userModel?.providerWallet?.balance ?? 0) <= 0.0
                      ? const SizedBox.shrink()
                      : Text(language(context, translations!.withdraw),
                              style: appCss.dmDenseBold14.textColor(
                                  appColor(context).appTheme.primary))
                          .paddingSymmetric(
                              vertical: Insets.i11, horizontal: Insets.i20)
                          .boxShapeExtension(
                              radius: 20,
                              color: appColor(context).appTheme.whiteColor)
                          .inkWell(onTap: onTap),
                  (userModel?.servicemanWallet?.balance ?? 0) <= 0.0
                      ? const SizedBox.shrink()
                      : Text(language(context, translations!.withdraw),
                              style: appCss.dmDenseBold14.textColor(
                                  appColor(context).appTheme.primary))
                          .paddingSymmetric(
                              vertical: Insets.i11, horizontal: Insets.i20)
                          .boxShapeExtension(
                              radius: 20,
                              color: appColor(context).appTheme.whiteColor)
                          .inkWell(onTap: onTap)
                ]).paddingSymmetric(horizontal: Insets.i12))
        .paddingSymmetric(horizontal: Insets.i20);
  }
}
