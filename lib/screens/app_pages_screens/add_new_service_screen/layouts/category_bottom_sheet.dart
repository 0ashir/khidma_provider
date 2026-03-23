import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';
import '../../../../providers/app_pages_provider/offer_chat_provider.dart';

class CategoryBottomSheet extends StatefulWidget {
  final bool isOffer;

  const CategoryBottomSheet({super.key, this.isOffer = false});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer2<AddNewServiceProvider, OfferChatProvider>(
          builder: (context1, value, offer, child) {
        return StatefulBuilder(builder: (context1, setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                // initialChildSize: widget.isOffer
                //     ? offer.newCatList.isNotEmpty
                //         ? offer.newCatList.length > 5
                //             ? .8
                //             : .5
                //         : 0.8
                //     : value.newCatList.isNotEmpty
                //         ? value.newCatList.length > 1
                //             ? .8
                //             : .5
                //         : 0.8,
                maxChildSize: 0.99,
                minChildSize: 0.3,
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Stack(children: [
                    ListView(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(language(context, appFonts.selectCategory),
                                style: appCss.dmDenseMedium18.textColor(
                                    appColor(context).appTheme.darkText)),
                            const Icon(CupertinoIcons.multiply)
                                .inkWell(onTap: () => route.pop(context))
                          ]).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s10),
                      Text("${language(context, appFonts.note)}${language(context, language(context, appFonts.noteForCategorySelection))}",
                              style: appCss.dmDenseLight14.textColor(
                                  appColor(context).appTheme.lightText))
                          .paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      SearchTextFieldCommon(
                          controller: widget.isOffer
                              ? offer.filterSearchCtrl
                              : value.filterSearchCtrl,
                          focusNode: widget.isOffer
                              ? offer.filterSearchFocus
                              : value.filterSearchFocus,
                          onChanged: (v) {
                            offer.getCategory();
                            if (v.isEmpty) {
                              if (widget.isOffer) {

                              } else {
                                value.getCategory();
                              }
                            } else if (v.length > 0) {
                              if (widget.isOffer) {
                                offer.getCategory(search: v);
                              } else {
                                value.getCategory(search: v);
                              }
                            }
                          },
                          onFieldSubmitted: (v) {
                            widget.isOffer
                                ? offer.getCategory(
                                    search: offer.filterSearchCtrl.text)
                                : value.getCategory(
                                    search: value.filterSearchCtrl.text);
                            /*if (value.selectIndex == 0) {
                                          value.getCategory(search: value.filterSearchCtrl.text);
                                        }*/
                          }).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      if (widget.isOffer)
                        if (offer.newCatList.isEmpty) const CommonEmpty(),
                      if (widget.isOffer)
                        if (offer.newCatList.isNotEmpty)
                          ...offer.newCatList.asMap().entries.map((e) =>
                              ListTileLayout(
                                  data: e.value,
                                  isAddService: true,
                                  selectedCategory: widget.isOffer
                                      ? offer.categories
                                      : value.categories,
                                  onTap: () {
                                    log("selectedCategory::${e.value.id}");
                                    offer.onChangeCategory(
                                        e.value, e.value.id, true);
                                  })),
                      if (value.newCatList.isEmpty) const CommonEmpty(),
                      if (value.newCatList.isNotEmpty)
                        ...value.newCatList
                            .asMap()
                            .entries
                            .map((e) => ListTileLayout(
                                data: e.value,
                                selectedCategory: value.categories,
                                onTap: () {
                                  log("selectedCategory::${e.value.id}");
                                  value.onChangeCategory(
                                      e.value, e.value.id, true);
                                }))
                    ])
                        .paddingSymmetric(vertical: Insets.i20)
                        .marginOnly(bottom: Insets.i50),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomSheetButtonCommon(
                                textOne: appFonts.clearAll,
                                textTwo: appFonts.apply,
                                applyTap: () {
                                  route.pop(context);
                                  //  value.searchService(context, isPop: true);
                                },
                                clearTap: () {
                                  if (widget.isOffer) {
                                    offer.categories = [];
                                    offer.notifyListeners();
                                  } else {
                                    value.categories = [];
                                    value.notifyListeners();
                                  }
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
