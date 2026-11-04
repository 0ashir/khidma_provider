import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/ui/screens/services/enum/statusEnum.dart';
import 'package:edemand_partner/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class ServiceContainer extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final bool listingUI;

  const ServiceContainer({
    Key? key,
    required this.service,
    this.onTap,
    required this.listingUI,
  }) : super(key: key);

  Widget setImage({required String imageURL}) {
    return CustomContainer(
      borderRadius: UiUtils.borderRadiusOf10,
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
          child: CustomCachedNetworkImage(imageUrl: imageURL, fit: BoxFit.fill),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StateStatus status = StateStatus.fromApi(service.status!);
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        border: listingUI
            ? Border.all(color: context.colorScheme.primaryColor)
            : null,
        padding: const EdgeInsets.all(15),
        color: context.colorScheme.secondaryColor,
        borderRadius: listingUI ? UiUtils.borderRadiusOf10 : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !listingUI
                ? SizedBox(
                    height: 120.rh(context),
                    width: 100.rw(context),
                    child: setImage(imageURL: service.imageOfTheService!),
                  )
                : const SizedBox.shrink(),
            !listingUI ? const SizedBox(width: 10) : const SizedBox.shrink(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listingUI
                      ? Row(
                          children: [
                            CustomSvgPicture(
                              svgImage: status.svgImage,
                              color: status.getStatusColor(context),
                            ),
                            const SizedBox(width: 5),
                            CustomText(
                              service.translatedStatus.toString(),
                              //status.label.translate(context: context),
                              fontSize: 14,
                              color: status.getTextColor(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 5),
                  CustomText(
                    service.getTranslatedTitle(
                          HiveRepository.getCurrentLanguage()?.languageCode ??
                              'en',
                        ) ??
                        service.title ??
                        '',
                    fontSize: 16,
                    color: context.colorScheme.blackColor,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  if (double.parse(service.rating!).toStringAsFixed(1) != '0.0')
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          const CustomSvgPicture(
                            svgImage: AppAssets.star,
                            height: 16,
                            width: 16,
                            color: AppColors.starRatingColor,
                          ),
                          const SizedBox(width: 5),
                          CustomText(
                            double.parse(service.rating!).toStringAsFixed(1),
                            fontSize: 14,
                            color: context.colorScheme.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          VerticalDivider(
                            color: context.colorScheme.lightGreyColor,
                            thickness: 0.2,
                          ),
                          CustomText(
                            '${service.numberOfRatings!} ${'reviewsTitleLbl'.translate(context: context)}',
                            fontSize: 14,
                            color: context.colorScheme.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 5,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSvgPicture(
                            svgImage: AppAssets.group,
                            height: 16,
                            width: 16,
                            color: context.colorScheme.accentColor,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: CustomText(
                              "${service.numberOfMembersRequired} ${'persons'.translate(context: context)}",
                              fontSize: 12,
                              color: context.colorScheme.blackColor,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSvgPicture(
                            svgImage: AppAssets.duration,
                            height: 16,
                            width: 16,
                            color: context.colorScheme.accentColor,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: CustomText(
                              "${service.duration} ${service.durationTypeLabelKey.translate(context: context)}",
                              fontSize: 12,
                              color: context.colorScheme.blackColor,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      if (service.discountedPrice != '0') ...[
                        CustomText(
                          (service.discountedPrice ?? "0")
                              .replaceAll(',', '')
                              .toString()
                              .providerPriceFormat(context),
                          color: context.colorScheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          (service.price ?? "0")
                              .replaceAll(',', '')
                              .toString()
                              .providerPriceFormat(context),
                          color: context.colorScheme.accentColor,
                          underlineOrLineColor: context.colorScheme.accentColor,
                          showLineThrough: true,
                          fontSize: 12,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ] else ...[
                        CustomText(
                          (service.price ?? "0")
                              .replaceAll(',', '')
                              .toString()
                              .providerPriceFormat(context),
                          color: context.colorScheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            listingUI
                ? SizedBox(
                    height: 120.rh(context),
                    width: 100.rw(context),
                    child: setImage(imageURL: service.imageOfTheService!),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
