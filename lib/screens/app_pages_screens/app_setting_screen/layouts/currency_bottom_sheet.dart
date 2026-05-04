import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/app_setting_screen/layouts/bullet_layout.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class CurrencyBottomSheet extends StatelessWidget {
  final String? currencys;
  final GestureTapCallback? onTap;

  const CurrencyBottomSheet({super.key, this.currencys, this.onTap});

  @override
  Widget build(BuildContext context) {
    log("currencys:${currencys}");

    return StatefulBuilder(builder: (context2, setState) {
      return Consumer<AppSettingProvider>(builder: (context1, value, child) {
        // log("select::${currencyList[value.selectIndex].id}");
        // log("select::${currencyList[value.selectIndex].code}");
        // log("currencys:currencys:${value.sharedPreferences.getString("defaultCurrency")}");

        double height = value.heightMQ(context);
        double width = value.widthMQ(context);
        return Container(
            height: height * 0.47,
            width: width,
            decoration: ShapeDecoration(
                shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft: SmoothRadius(
                            cornerRadius: AppRadius.r20, cornerSmoothing: 1),
                        topRight: SmoothRadius(
                            cornerRadius: AppRadius.r20,
                            cornerSmoothing: 0.4))),
                color: appColor(context).appTheme.whiteBg),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, translations!.changeCurrency),
                    style: appCss.dmDenseMedium18
                        .textColor(appColor(context).appTheme.darkText)),
                const Icon(CupertinoIcons.multiply)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingAll(Insets.i20),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: currencyList.length,
                      itemBuilder: (context1, index) {
                        return BulletLayout(
                            data: currencyList[index],
                            index: index,
                            selectedIndex: value.selectIndex,
                            onTap: () => value.onChangeButton(index));
                      })),
              Row(children: [
                Expanded(
                    child: ButtonCommon(
                        onTap: () => route.pop(context),
                        title: translations!.cancel,
                        style: appCss.dmDenseSemiBold16
                            .textColor(appColor(context).appTheme.primary),
                        borderColor: appColor(context).appTheme.primary,
                        color: appColor(context).appTheme.trans)),
                const HSpace(Sizes.s15),
                Expanded(
                    child: ButtonCommon(
                        title: translations!.update,
                        onTap: () => value.onUpdate(
                            context, currencyList[value.selectIndex])))
              ]).padding(horizontal: Insets.i20, bottom: Insets.i18)
            ]));
      });
    });
  }
}
