import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../config.dart';
import '../../../../providers/app_pages_provider/offer_chat_provider.dart';

class CategorySelectionLayout extends StatefulWidget {
  final bool isOffer;

  const CategorySelectionLayout({super.key, this.isOffer = false});

  @override
  State<CategorySelectionLayout> createState() =>
      _CategorySelectionLayoutState();
}

class _CategorySelectionLayoutState extends State<CategorySelectionLayout> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AddNewServiceProvider, OfferChatProvider>(
        builder: (context1, value, offer, child) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s15, vertical: Sizes.s10),
        decoration: BoxDecoration(
            color: appColor(context).appTheme.whiteBg,
            border: Border.all(color: appColor(context).appTheme.stroke),
            borderRadius: BorderRadius.circular(Sizes.s8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Row(children: [
              SvgPicture.asset(eSvgAssets.categorySmall,
                      colorFilter: ColorFilter.mode(
                          widget.isOffer
                              ? offer.categories.isNotEmpty
                                  ? appColor(context).appTheme.darkText
                                  : appColor(context).appTheme.lightText
                              : value.categories.isNotEmpty
                                  ? appColor(context).appTheme.darkText
                                  : appColor(context).appTheme.lightText,
                          BlendMode.srcIn))
                  .padding(
                      left: Insets.i5,
                      right: rtl(context) ? Insets.i5 : 0,
                      top: Sizes.s5,
                      vertical: Sizes.s5),
              const HSpace(Sizes.s12),
              if (widget.isOffer)
                if (offer.categories.isNotEmpty)
                  Expanded(
                    child: Wrap(
                        direction: Axis.horizontal,
                        children: offer.categories
                            .asMap()
                            .entries
                            .map((e) => Container(
                                    margin: EdgeInsets.only(
                                        bottom: widget.isOffer
                                            ? offer.categories.length - 1 != e.key
                                                ? Sizes.s8
                                                : 0
                                            : value.categories.length - 1 != e.key
                                                ? Sizes.s8
                                                : 0,
                                        right: Sizes.s5),
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: Sizes.s9,
                                            vertical: Sizes.s5),
                                    decoration: ShapeDecoration(
                                        shape: SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: 8,
                                              cornerSmoothing: 1),
                                        ),
                                        color: appColor(context).appTheme.stroke),
                                    child:
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          SvgPicture.asset(
                                            eSvgAssets.cross,
                                            height: 16,
                                            colorFilter: ColorFilter.mode(
                                                appColor(context)
                                                    .appTheme
                                                    .primary,
                                                BlendMode.srcIn),
                                          ),
                                          const HSpace(Sizes.s2),
                                          Expanded(
                                            child: Text(e.value.title!,
                                                style: appCss.dmDenseLight14
                                                    .textColor(appColor(context)
                                                        .appTheme
                                                        .primary)),
                                          )
                                        ]))
                                .inkWell(
                                    onTap: () => offer.onChangeCategory(
                                        e.value, e.value.id, true)))
                            .toList()),
                  ),
              // Text("${value.categories.length ?? 0}"),
              if (value.categories.isNotEmpty)
                Expanded(
                  child: Wrap(
                      direction: Axis.horizontal,
                      children: value.categories
                          .asMap()
                          .entries
                          .map((e) => Container(
                                  margin: EdgeInsets.only(
                                      bottom: value.categories.length - 1 !=
                                              e.key
                                          ? Sizes.s8
                                          : 0,
                                      right: Sizes.s5),
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal: Sizes.s9, vertical: Sizes.s5),
                                  decoration: ShapeDecoration(
                                      shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 8,
                                            cornerSmoothing: 1),
                                      ),
                                      color: const Color
                                          .fromRGBO(84, 101, 255, 0.1)),
                                  child:
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        SvgPicture.asset(
                                          eSvgAssets.cross,
                                          height: 16,
                                          colorFilter: ColorFilter.mode(
                                              appColor(context)
                                                  .appTheme
                                                  .primary,
                                              BlendMode.srcIn),
                                        ).inkWell(onTap: () {
                                          value.categories.removeAt(e.key);
                                          // value.newCatList.removeAt(e.key);
                                          setState(() {});
                                          log("message===== is Category${value.categories.removeAt(e.key)}");
                                        }),
                                        const HSpace(Sizes.s3),
                                        Expanded(
                                          child: Text(e.value.title!,
                                              style: appCss.dmDenseLight14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .primary)),
                                        )
                                      ]))
                              .inkWell(
                                  onTap: () => value.onChangeCategory(
                                      e.value, e.value.id, true)))
                          .toList()),
                ),

              // Expanded(
              //   child: Wrap(
              //       direction: Axis.horizontal,
              //       children: value.newCategoryList
              //           .asMap()
              //           .entries
              //           .map((e) => Container(
              //                   margin: EdgeInsets.only(
              //                       bottom: value.newCategoryList.length -
              //                                   1 !=
              //                               e.key
              //                           ? Sizes.s8
              //                           : 0,
              //                       right: Sizes.s5),
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: Sizes.s9, vertical: Sizes.s5),
              //                   decoration: ShapeDecoration(
              //                       shape: SmoothRectangleBorder(
              //                         borderRadius: SmoothBorderRadius(
              //                             cornerRadius: 8,
              //                             cornerSmoothing: 1),
              //                       ),
              //                       color: Color.fromRGBO(84, 101, 255, 0.1)),
              //                   child:
              //                       Row(
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: [
              //                         SvgPicture.asset(
              //                           eSvgAssets.cross,
              //                           height: 16,
              //                           colorFilter: ColorFilter.mode(
              //                               appColor(context)
              //                                   .appTheme
              //                                   .primary,
              //                               BlendMode.srcIn),
              //                         ).inkWell(onTap: () {
              //                           value.newCategoryList.removeAt(e.key);
              //                           // value.newCatList.removeAt(e.key);
              //                           setState(() {});
              //                           log("message===== is Category${value.newCategoryList.removeAt(e.key)}");
              //                         }),
              //                         const HSpace(Sizes.s3),
              //                         Expanded(
              //                           child: Text(e.value.title!,
              //                               style: appCss.dmDenseLight14
              //                                   .textColor(appColor(context)
              //                                       .appTheme
              //                                       .primary)),
              //                         )
              //                       ]))
              //               .inkWell(
              //                   onTap: () => value.onChangeCategory(
              //                       e.value, e.value.id, true)))
              //           .toList()),
              // ),
              if (widget.isOffer)
                if (offer.categories.isEmpty)
                  Text(language(context, appFonts.categories),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.lightText)),
              if (!widget.isOffer)
                if (value.categories.isEmpty)
                  Text(language(context, appFonts.categories),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.lightText))
            ])),
            SvgPicture.asset(eSvgAssets.dropDown,
                colorFilter: ColorFilter.mode(
                    widget.isOffer
                        ? offer.categories.isNotEmpty
                            ? appColor(context).appTheme.darkText
                            : appColor(context).appTheme.lightText
                        : value.categories.isNotEmpty
                            ? appColor(context).appTheme.darkText
                            : appColor(context).appTheme.lightText,
                    BlendMode.srcIn))
          ],
        ),
      ).inkWell(
          onTap: () => widget.isOffer
              ? offer.onBottomSheet(context)
              : value.onBottomSheet(context));
    });
  }
}
