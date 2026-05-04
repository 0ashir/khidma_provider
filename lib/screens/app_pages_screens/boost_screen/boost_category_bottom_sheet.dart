import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';
import '../../../providers/app_pages_provider/boost_provider.dart';

class BoostCategoryBottomSheet extends StatelessWidget {
  const BoostCategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer<BoostProvider>(builder: (context1, value, child) {
        return StatefulBuilder(builder: (context1, setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
                initialChildSize: value.newCatList.isNotEmpty
                    ? value.newCatList.length > 5
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
                                language(
                                    context, translations!.selectServiceOnly),
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
                              value.getCategory();
                            } else if (v.length > 2) {
                              value.getCategory(search: v);
                            }
                          },
                          onFieldSubmitted: (v) {
                            value.getCategory(
                                search: value.filterSearchCtrl.text);
                            /*if (value.selectIndex == 0) {
                                          value.getCategory(search: value.filterSearchCtrl.text);
                                        }*/
                          }).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      if (value.newCatList.isEmpty) const CommonEmpty(),
                      if (value.newCatList.isNotEmpty)
                        ...value.newCatList.asMap().entries.map((e) =>
                            ListTileLayout(
                                data: e.value,
                                selectedCategory: value.categories,
                                isAddService: true,
                                onTap: () => value.onChangeCategory(
                                    e.value, e.value.id)).inkWell(
                                onTap: () => value.onChangeCategory(
                                    e.value, e.value.id)))
                    ])
                        .paddingSymmetric(vertical: Insets.i20)
                        .marginOnly(bottom: Insets.i50),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomSheetButtonCommon(
                                textOne: translations!.clearAll,
                                textTwo: translations!.apply,
                                applyTap: () {
                                  log("newCatList::${value.categories}");
                                  route.pop(context);
                                  //  value.searchService(context, isPop: true);
                                },
                                clearTap: () {
                                  value.categories = [];
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
