import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';

class KnownLanguageBottomSheet extends StatelessWidget {
  const KnownLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context2, setState) {
      return Consumer2<AddServicemenProvider, CommonApiProvider>(
          builder: (context1, value, commonApi, child) {
        return StatefulBuilder(builder: (context1, setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
                initialChildSize: knownLanguageList.isNotEmpty
                    ? knownLanguageList.length > 5
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
                            Text(
                                language(context, translations!.selectLanguage),
                                style: appCss.dmDenseMedium18.textColor(
                                    appColor(context).appTheme.darkText)),
                            const Icon(CupertinoIcons.multiply)
                                .inkWell(onTap: () => route.pop(context))
                          ]).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      SearchTextFieldCommon(
                          controller: value.filterSearchCtrl,
                          focusNode: value.filterSearchFocus,
                          onChanged: (v) {
                            if (v.isEmpty) {
                              commonApi.getKnownLanguage();
                            } else if (v.length > 2) {
                              commonApi.getKnownLanguage(search: v);
                            }
                          },
                          onFieldSubmitted: (v) {
                            commonApi.getKnownLanguage(search: v);
                          }).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      if (knownLanguageList.isEmpty) const CommonEmpty(),
                      if (knownLanguageList.isNotEmpty)
                        ...knownLanguageList.asMap().entries.map((e) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text(e.value.key!,
                                          style: appCss.dmDenseMedium14
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .darkText)),
                                      CheckBoxCommon(
                                          isCheck:
                                              value.isLanguageSelected(e.value),
                                          onTap: () =>
                                              value.onLanguageSelect(e.value))
                                    ])
                                    .padding(
                                        vertical: Insets.i10,
                                        horizontal: Insets.i15)
                                    .boxBorderExtension(context, isShadow: true)
                                    .padding(
                                        horizontal: Insets.i20,
                                        bottom: Insets.i15)
                            /*ListTileLayout(
                                data: e.value,
                                selectedCategory: value.categories,
                                onTap: () => value.onChangeCategory(
                                    e.value, e.value.id))*/
                            )
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
                                clearTap: () => value.clearTap(context))
                            .padding(horizontal: Sizes.s20, bottom: Sizes.s20))
                  ]).bottomSheetExtension(context);
                }),
          );
        });
      });
    });
  }
}
