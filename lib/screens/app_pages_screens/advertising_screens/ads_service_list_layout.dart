// import 'package:fixit_provider/providers/app_pages_provider/ads_detail_provider.dart';
// import '../../../../config.dart';

// class AdsServiceListLayout extends StatelessWidget {
//   const AdsServiceListLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final value = Provider.of<AdsDetailProvider>(context);
//     // log("value.serviceList:${value.advertisingModel?.services!.first.media!.first.originalUrl}");
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           value.advertisingModel == null
//               ? const CommonEmpty()
//               : RefreshIndicator(
//                   onRefresh: () => value.getAdvertisementList(
//                       context, value.advertisingModel?.id),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         value.advertisingModel!.services!.isNotEmpty &&
//                                 value.advertisingModel?.services?.first.media !=
//                                     null &&
//                                 value.advertisingModel!.services!.first.media!
//                                     .isNotEmpty
//                             ? CachedNetworkImage(
//                                 imageUrl: value.advertisingModel!.services![0]
//                                     .media!.first.originalUrl!,
//                                 imageBuilder: (context, imageProvider) =>
//                                     Container(
//                                         height: Sizes.s150,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 AppRadius.r6),
//                                             image: DecorationImage(
//                                                 image: imageProvider,
//                                                 fit: BoxFit.cover))),
//                                 placeholder: (context, url) =>
//                                     CommonCachedImage(
//                                       height: Sizes.s150,
//                                       width: MediaQuery.of(context).size.width,
//                                       radius: AppRadius.r6,
//                                       boxFit: BoxFit.cover,
//                                       image: eImageAssets.noImageFound2,
//                                     ),
//                                 errorWidget: (context, url, error) =>
//                                     CommonCachedImage(
//                                       height: Sizes.s150,
//                                       width: MediaQuery.of(context).size.width,
//                                       radius: AppRadius.r6,
//                                       boxFit: BoxFit.cover,
//                                       image: eImageAssets.noImageFound2,
//                                     ))
//                             : CommonCachedImage(
//                                 height: Sizes.s150,
//                                 width: MediaQuery.of(context).size.width,
//                                 radius: AppRadius.r6,
//                                 boxFit: BoxFit.cover,
//                                 image: eImageAssets.noImageFound2,
//                               ),
//                         const VSpace(Sizes.s12),
//                         if (value.advertisingModel!.services!.isNotEmpty)
//                           SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Row(children: [
//                                 Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: value.advertisingModel!
//                                         .services![value.selectedIndex].media!
//                                         .asMap()
//                                         .entries
//                                         .map((e) => Container(
//                                               height: Sizes.s60,
//                                               width: Sizes.s60,
//                                               margin:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: Insets.i5),
//                                               child: Image.network(
//                                                   e.value.originalUrl ?? "",
//                                                   height: Sizes.s60,
//                                                   width: Sizes.s60,
//                                                   fit: BoxFit.cover),
//                                             ).inkWell(onTap: () {
//                                               value.onHomeImageChange(
//                                                   e.key, e.value.originalUrl);
//                                             }))
//                                         .toList())
//                               ])),
//                         const VSpace(Sizes.s20),
//                         Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                               const VSpace(Sizes.s10),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: DescriptionLayoutCommon(
//                                             icon: eSvgAssets.status,
//                                             title: language(
//                                                 context,
//                                                 translations!
//                                                     .status) /* translations!.duration */,
//                                             subtitle: value
//                                                     .advertisingModel?.status ??
//                                                 "")
//                                         .paddingSymmetric(
//                                             horizontal: Insets.i25),
//                                   ),
//                                   Container(
//                                       height: Sizes.s38,
//                                       width: 1,
//                                       color: appColor(context).appTheme.stroke),
//                                   Expanded(
//                                     child: DescriptionLayoutCommon(
//                                             icon: eSvgAssets.appScreen,
//                                             title: language(
//                                                 context,
//                                                 translations!
//                                                     .screen /* "Screen" */) /* translations!.duration */,
//                                             subtitle: value
//                                                     .advertisingModel?.screen ??
//                                                 "")
//                                         .paddingSymmetric(
//                                             horizontal: Insets.i25),
//                                   ),
//                                 ],
//                               ),
//                               const VSpace(Sizes.s20),
//                               DescriptionLayoutCommon(
//                                       icon: eSvgAssets.clock,
//                                       title: translations!.duration,
//                                       subtitle:
//                                           "${value.advertisingModel!.startDate}  - ${value.advertisingModel?.endDate}")
//                                   .paddingSymmetric(horizontal: Insets.i25),
//                               const VSpace(Sizes.s20),
//                               DescriptionLayoutCommon(
//                                       icon: eSvgAssets.adsType,
//                                       title: language(
//                                           context, "Advertisement Type"),
//                                       subtitle:
//                                           value.advertisingModel?.type ?? "")
//                                   .paddingSymmetric(horizontal: Insets.i25),
//                               const VSpace(Sizes.s20),
//                             ])
//                             .decorated(
//                                 color: appColor(context).appTheme.whiteBg,
//                                 boxShadow: [
//                                   BoxShadow(
//                                       blurRadius: 3,
//                                       spreadRadius: 2,
//                                       color: appColor(context)
//                                           .appTheme
//                                           .darkText
//                                           .withOpacity(0.06))
//                                 ],
//                                 borderRadius:
//                                     BorderRadius.circular(AppRadius.r10))
//                             .padding(horizontal: Sizes.s20, top: Sizes.s10)
//                       ],
//                     ),
//                   ),
//                 ) /*SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(children: [
//                     value.advertisingModel!.services!.isNotEmpty &&
//                             value.advertisingModel?.services?.first.media !=
//                                 null &&
//                             value.advertisingModel!.services!.first.media!
//                                 .isNotEmpty
//                         ? CachedNetworkImage(
//                             imageUrl: value.advertisingModel!.services![0]
//                                 .media!.first.originalUrl!,
//                             imageBuilder: (context, imageProvider) => Container(
//                                 height: Sizes.s150,
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.circular(AppRadius.r6),
//                                     image: DecorationImage(
//                                         image: imageProvider,
//                                         fit: BoxFit.cover))),
//                             placeholder: (context, url) => CommonCachedImage(
//                                   height: Sizes.s150,
//                                   width: MediaQuery.of(context).size.width,
//                                   radius: AppRadius.r6,
//                                   boxFit: BoxFit.cover,
//                                   image: eImageAssets.noImageFound2,
//                                 ),
//                             errorWidget: (context, url, error) =>
//                                 CommonCachedImage(
//                                   height: Sizes.s150,
//                                   width: MediaQuery.of(context).size.width,
//                                   radius: AppRadius.r6,
//                                   boxFit: BoxFit.cover,
//                                   image: eImageAssets.noImageFound2,
//                                 ))
//                         : CommonCachedImage(
//                             height: Sizes.s150,
//                             width: MediaQuery.of(context).size.width,
//                             radius: AppRadius.r6,
//                             boxFit: BoxFit.cover,
//                             image: eImageAssets.noImageFound2,
//                           ),
//                     const VSpace(Sizes.s12),
//                     Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                       value.advertisingModel!.services!.isEmpty
//                                           ? ''
//                                           : capitalizeFirstLetter(value
//                                               .advertisingModel!
//                                               .services![value.selectedIndex]
//                                               .title),
//                                       style: appCss.dmDenseSemiBold15.textColor(
//                                           appColor(context).appTheme.darkText)),
//                                 ),
//                               ]),
//                           const VSpace(Sizes.s8),
//                           */ /*              IntrinsicHeight(
//                               child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                 Row(children: [
//                                   if (value.advertisingModel?.
//                                               .categories !=
//                                           null &&
//                                       .categories!.isNotEmpty)
//                                     Text("\u2022 ${.categories![0].title}",
//                                         style: appCss.dmDenseMedium12.textColor(
//                                             appColor(context)
//                                                 .appTheme
//                                                 .lightText)),
//                                   if (.categories != null &&
//                                       .categories!.isNotEmpty)
//                                     VerticalDivider(
//                                             width: 1,
//                                             color: appColor(context)
//                                                 .appTheme
//                                                 .stroke,
//                                             thickness: 1,
//                                             indent: 3,
//                                             endIndent: 3)
//                                         .paddingSymmetric(
//                                             horizontal: Insets.i6),
//                                   SvgPicture.asset(eSvgAssets.receipt),
//                                   const HSpace(Sizes.s5),
//                                   Text(
//                                       "${.bookingsCount ?? 0} ${language(context, translations!.booked)}",
//                                       style: appCss.dmDenseMedium12.textColor(
//                                           appColor(context).appTheme.lightText))
//                                 ]),
//                                 if (.ratingCount != null)
//                                   Row(children: [
//                                     SvgPicture.asset(eSvgAssets.star),
//                                     const HSpace(Sizes.s3),
//                                     Text(
//                                         .ratingCount != null
//                                             ? .ratingCount.toString()
//                                             : "0",
//                                         style: appCss.dmDenseMedium13.textColor(
//                                             appColor(context)
//                                                 .appTheme
//                                                 .darkText))
//                                   ])
//                               ])),*/ /*
//                         ])
//                   ])).padding(horizontal: Sizes.s20)*/
//         ]);
//   }
// }

import 'package:fixit_provider/providers/app_pages_provider/ads_detail_provider.dart';
import '../../../../config.dart';

class AdsServiceListLayout extends StatelessWidget {
  const AdsServiceListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AdsDetailProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        value.advertisingModel == null
            ? const CommonEmpty()
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: () => value.getAdvertisementList(
                      context, value.advertisingModel?.id),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Top Banner
                        if (value.advertisingModel!.services!.isNotEmpty &&
                            value.advertisingModel!.services!.first.media!
                                .isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: value.advertisingModel!.services!.first
                                .media!.first.originalUrl!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: Sizes.s150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r6),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => CommonCachedImage(
                              height: Sizes.s150,
                              width: MediaQuery.of(context).size.width,
                              radius: AppRadius.r6,
                              boxFit: BoxFit.cover,
                              image: eImageAssets.noImageFound2,
                            ),
                            errorWidget: (context, url, error) =>
                                CommonCachedImage(
                              height: Sizes.s150,
                              width: MediaQuery.of(context).size.width,
                              radius: AppRadius.r6,
                              boxFit: BoxFit.cover,
                              image: eImageAssets.noImageFound2,
                            ),
                          )
                        else
                          CommonCachedImage(
                            height: Sizes.s150,
                            width: MediaQuery.of(context).size.width,
                            radius: AppRadius.r6,
                            boxFit: BoxFit.cover,
                            image: eImageAssets.noImageFound2,
                          ),

                        const VSpace(Sizes.s12),

                        /// Thumbnails Row
                        if (value.advertisingModel!.services!.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: value.advertisingModel!
                                  .services![value.selectedIndex].media!
                                  .asMap()
                                  .entries
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          value.onHomeImageChange(
                                              e.key, e.value.originalUrl);
                                        },
                                        child: Container(
                                          height: Sizes.s60,
                                          width: Sizes.s60,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: Insets.i5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  e.value.originalUrl ?? ""),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),

                        const VSpace(Sizes.s20),

                        /// Info Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.s20, vertical: Sizes.s20),
                          decoration: BoxDecoration(
                            color: appColor(context).appTheme.whiteBg,
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 2,
                                color: appColor(context)
                                    .appTheme
                                    .darkText
                                    .withOpacity(0.06),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: Insets.i10),
                                      child: DescriptionLayoutCommon(
                                        icon: eSvgAssets.status,
                                        title: language(
                                            context, translations!.status),
                                        subtitle:
                                            value.advertisingModel?.status ??
                                                "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: Sizes.s38,
                                    width: 1,
                                    color: appColor(context).appTheme.stroke,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: Insets.i10),
                                      child: DescriptionLayoutCommon(
                                        icon: eSvgAssets.appScreen,
                                        title: language(
                                            context, translations!.screen),
                                        subtitle:
                                            value.advertisingModel?.screen ??
                                                "",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const VSpace(Sizes.s20),
                              DescriptionLayoutCommon(
                                icon: eSvgAssets.clock,
                                title: translations!.duration,
                                subtitle:
                                    "${value.advertisingModel!.startDate} - ${value.advertisingModel!.endDate}",
                              ),
                              const VSpace(Sizes.s20),
                              DescriptionLayoutCommon(
                                icon: eSvgAssets.adsType,
                                title: language(context, "Advertisement Type"),
                                subtitle: value.advertisingModel?.type ?? "",
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
