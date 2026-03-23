import 'dart:developer';

import 'package:fixit_provider/providers/app_pages_provider/boost_provider.dart';
import 'package:fixit_provider/screens/auth_screens/sign_up_company_screen/layouts/zone_list_layout.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class BoostZoneBottomSheet extends StatelessWidget {
  const BoostZoneBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer<BoostProvider>(builder: (context1, value, child) {
        return StatefulBuilder(builder: (context1, setState) {
          log("value.zonesList::${value.zonesList}");
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
                initialChildSize: value.zonesList.isNotEmpty
                    ? value.zonesList.length > 5
                        ? .8
                        : .5
                    : 0.8,
                maxChildSize: 0.95,
                minChildSize: 0.3,
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Stack(children: [
                    ListView(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(language(context, translations!.selectZone),
                                style: appCss.dmDenseMedium18.textColor(
                                    appColor(context).appTheme.darkText)),
                            const Icon(CupertinoIcons.multiply)
                                .inkWell(onTap: () => route.pop(context))
                          ]).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      if (value.zonesList.isNotEmpty)
                        ...value.zonesList.asMap().entries.map((e) => Text(
                                language(context, e.value.name),
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText))
                            .paddingSymmetric(
                                vertical: Insets.i10, horizontal: Insets.i15)
                            .boxBorderExtension(context, isShadow: true)
                            .padding(horizontal: Insets.i20, bottom: Insets.i15)
                            .inkWell(
                                onTap: () =>
                                    value.onZoneSelect(e.value, context))),
                    ])
                        .paddingSymmetric(vertical: Insets.i20)
                        .marginOnly(bottom: Insets.i50),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomSheetButtonCommon(
                                textOne: translations!.clearAll,
                                textTwo: translations!.apply,
                                applyTap: () {
                                  route.pop(context);
                                  //  value.searchService(context, isPop: true);
                                },
                                clearTap: () {
                                  value.zoneSelect = [];
                                  value.notifyListeners();
                                  route.pop(context);
                                })
                            .padding(horizontal: Sizes.s20, bottom: Sizes.s20))
                  ]).bottomSheetExtension(context);
                }),
          );
        });
      });
    });
  }
}
