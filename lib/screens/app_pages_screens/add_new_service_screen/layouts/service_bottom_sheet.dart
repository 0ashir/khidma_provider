import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';
import '../../../../providers/app_pages_provider/boost_provider.dart';
import '../../../../providers/app_pages_provider/offer_chat_provider.dart';

class ServiceBottomSheet extends StatelessWidget {
  const ServiceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoostProvider, UserDataApiProvider>(
        builder: (context, offer, userApi, child) {
      return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.99,
            minChildSize: 0.3,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              log("allServiceList::$allServiceList");
              return Stack(children: [
                ListView(controller: scrollController, children: [
                  // Top Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, appFonts.pleaseSelectServices),
                          style: appCss.dmDenseMedium18
                              .textColor(appColor(context).appTheme.darkText)),
                      const Icon(CupertinoIcons.multiply)
                          .inkWell(onTap: () => route.pop(context))
                    ],
                  ).paddingSymmetric(horizontal: Insets.i20),

                  const VSpace(Sizes.s10),

                  // Note
                  Text("${language(context, appFonts.note)}${language(context, appFonts.noteForCategorySelection)}",
                          style: appCss.dmDenseLight14
                              .textColor(appColor(context).appTheme.lightText))
                      .paddingSymmetric(horizontal: Insets.i20),

                  const VSpace(Sizes.s15),

                  // Search
                  SearchTextFieldCommon(
                      controller: offer.filterSearchCtrl,
                      focusNode: offer.filterSearchFocus,
                      onChanged: (v) {
                        if (v.isEmpty) {
                          offer.getAllServiceList();
                        } else {
                          offer.getAllServiceList(search: v);
                        }
                      },
                      onFieldSubmitted: (v) {
                        offer.getAllServiceList(
                            search: offer.filterSearchCtrl.text);
                      }).paddingSymmetric(horizontal: Insets.i20),

                  const VSpace(Sizes.s15),

                  // Empty state
                  if (allServiceList.isEmpty)
                    const CommonEmpty()
                  else
                    ...allServiceList.asMap().entries.map(
                          (e) => ServiceListTileLayout(
                              data: e.value,
                              isAddService: true,
                              selectedCategory: offer.selectedServices,
                              onTap: () {
                                offer.onChangeService(e.value, true);
                              }),
                        ),
                ])
                    .paddingSymmetric(vertical: Insets.i20)
                    .marginOnly(bottom: Insets.i50),

                // Bottom Button
                Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomSheetButtonCommon(
                        textOne: appFonts.clearAll,
                        textTwo: appFonts.apply,
                        applyTap: () {
                          offer.selectedServices;
                        },
                        clearTap: () {
                          offer.selectedServices.clear();
                          offer.newServiceList.clear();
                          offer.notifyListeners();
                          route.pop(context);
                        }).padding(horizontal: Sizes.s20, bottom: Sizes.s20))
              ]).bottomSheetExtension(context);
            }),
      );
    });
  }
}

class ServiceListTileLayout extends StatelessWidget {
  final Services? data;
  final dynamic booking;
  final bool? isBooking, isAddService;
  final int? index;
  final GestureTapCallback? onTap;
  final List? selectedCategory;

  const ServiceListTileLayout(
      {super.key,
      this.data,
      this.onTap,
      this.selectedCategory,
      this.booking,
      this.isBooking = false,
      this.isAddService = false,
      this.index});

  @override
  Widget build(BuildContext context) {
    log("value.categories:$selectedCategory");
    // Helper function to check if category is selected
    bool isCategorySelected() {
      if (selectedCategory == null || selectedCategory!.isEmpty) {
        return false;
      }
      // Check if selectedCategory contains objects with 'id' or raw IDs
      final firstElement = selectedCategory!.first;
      if (firstElement is int) {
        return selectedCategory!.any((element) => element == data!.id);
      } else {
        // Assume CategoryModel or similar object with 'id'
        return selectedCategory!.any((element) => element.id == data!.id);
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IntrinsicHeight(
          child: Row(children: [
        data!.media != null && data!.media!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: data?.media?.first.originalUrl ?? "",
                imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s20,
                    width: Sizes.s20,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider))),
                errorWidget: (context, url, error) => Image.asset(
                    eImageAssets.noImageFound1,
                    height: Sizes.s20,
                    width: Sizes.s20))
            : Image.asset(eImageAssets.noImageFound1,
                height: Sizes.s20, width: Sizes.s20),
        VerticalDivider(
                indent: 4,
                endIndent: 4,
                width: 1,
                color: appColor(context).appTheme.stroke)
            .paddingSymmetric(horizontal: Insets.i12),
        Text(language(context, data!.title),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText))
      ])),
      /* Text(
          "${selectedCategory!.where((element) => element.toString() == data!.id.toString()).isNotEmpty}"),
      Text(
          "${selectedCategory!.where((element) => element.id.toString() == data!.id.toString()).isNotEmpty}"),
      Text("${isAddService == true}"), */
      CheckBoxCommon(isCheck: isCategorySelected(), onTap: onTap)
    ])
        .inkWell(onTap: onTap)
        .paddingSymmetric(vertical: Insets.i10, horizontal: Insets.i15)
        .boxBorderExtension(context, isShadow: true)
        .padding(horizontal: Insets.i20, bottom: Insets.i15);
  }
}
