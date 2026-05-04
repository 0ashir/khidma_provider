import 'package:fixit_provider/providers/app_pages_provider/boost_provider.dart';
import '../../../../config.dart';

class CommonBillSummary extends StatelessWidget {
  const CommonBillSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoostProvider>(builder: (context, value, child) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(appColor(context).appTheme.isDark
                      ? eImageAssets.bookingDetailBg
                      : eImageAssets.pendingBillBg),
                  fit: BoxFit.fill)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BillRowCommon(
                    title: language(context, translations!.availableBal),
                    styleTitle: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.primary),
                    price: symbolPosition
                        ? "${getSymbol(context)}${(userModel!.providerWallet != null ? double.parse(userModel!.providerWallet!.balance.toString()) : 0.0)}"
                        : "${(userModel!.providerWallet != null ? double.parse(userModel!.providerWallet!.balance.toString()) : 0.0)}${getSymbol(context)}",
                    color: appColor(context).appTheme.primary)
                .paddingDirectional(bottom: Sizes.s10),
            /*   Text(value.selectPage) */
            if (value.selectPage == "Home")
              BillRowCommon(
                  title: "Home Screen Price :",
                  price: symbolPosition
                      ? "${getSymbol(context)} ${settingAdvertisementModel != null ? settingAdvertisementModel['home_screen_price'] : "0"}"
                      : " ${settingAdvertisementModel != null ? settingAdvertisementModel['home_screen_price'] : "0"}${getSymbol(context)}",
                  color: appColor(context).appTheme.online),
            if (value.selectPage == "categories")
              BillRowCommon(
                      title: value.choseValue == "Image"
                          ? "${translations?.categoryScreenPricePerImage} :"
                          : "${translations?.categoryScreenPricePerVideo} :",
                      price: symbolPosition
                          ? "${getSymbol(context)} ${settingAdvertisementModel != null ? settingAdvertisementModel['category_screen_price'] : "0"}"
                          : " ${settingAdvertisementModel != null ? settingAdvertisementModel['category_screen_price'] : "0"}${getSymbol(context)}",
                      color: appColor(context).appTheme.online)
                  .padding(vertical: Sizes.s5),
            BillRowCommon(
                title: value.choseValue == "Image"
                    ? "${translations?.totalNoOfImage} :"
                    : value.serviceBanner == "Banner" &&
                            value.choseValue == "Video"
                        ? "${translations?.totalNoOfVideo} :"
                        : "${translations?.totalNoOfService} :",
                price: value.choseValue == "Image"
                    ? '${value.bannerImage.length}'
                    : value.serviceBanner == "Banner" &&
                            value.choseValue == "Video"
                        ? "1"
                        : "${value.selectedServices.length}",
                color: appColor(context).appTheme.darkText),
            BillRowCommon(
                    title: "${translations?.totalNoOfDays} :",
                    price: "${value.differenceInDays}",
                    color: appColor(context).appTheme.darkText)
                .padding(vertical: Sizes.s5, bottom: Sizes.s15),
            Divider(
                    color: appColor(context).appTheme.stroke,
                    thickness: 1,
                    height: 1,
                    indent: 6,
                    endIndent: 6)
                .paddingOnly(bottom: Insets.i10),
            BillRowCommon(
                title: translations!.totalAmount,
                price: symbolPosition
                    ? "${getSymbol(context)}${(value.selectPage == "Home" ? int.parse(settingAdvertisementModel?['home_screen_price']?.toString() ?? "0") : int.parse(settingAdvertisementModel?['category_screen_price']?.toString() ?? "0")) * value.differenceInDays * int.parse((value.choseValue == "Image" ? value.bannerImage.length.toString() : value.serviceBanner == "Banner" && value.choseValue == "Video" ? "1" : value.selectedServices.length.toString()))}"
                    : "${(value.selectPage == "Home" ? int.parse(settingAdvertisementModel?['home_screen_price']?.toString() ?? "0") : int.parse(settingAdvertisementModel?['category_screen_price']?.toString() ?? "0")) * value.differenceInDays * int.parse((value.choseValue == "Image" ? value.bannerImage.length.toString() : value.serviceBanner == "Banner" && value.choseValue == "Video" ? "1" : value.selectedServices.length.toString()))}${getSymbol(context)}",
                styleTitle: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText),
                style: appCss.dmDenseBold16
                    .textColor(appColor(context).appTheme.primary))
          ]).paddingSymmetric(vertical: Insets.i20));
    });
  }
}
