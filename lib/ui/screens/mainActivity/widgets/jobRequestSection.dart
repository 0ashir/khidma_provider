import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomJobRequestSection extends StatelessWidget {
  const CustomJobRequestSection({super.key, required this.jobRequests});
  final String jobRequests;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.jobRequestScreen);
      },
      child: CustomContainer(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(10),
        color: context.colorScheme.secondaryColor,
        borderRadius: UiUtils.borderRadiusOf10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomContainer(
              height: 50,
              width: 50,
              borderRadius: UiUtils.borderRadiusOf10,
              color: Theme.of(context).colorScheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
                  child: const CustomSvgPicture(svgImage: AppAssets.bagImage),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "jobRequestsForYouLbl".translate(context: context),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.blackColor,
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        CustomText(
                          jobRequests,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.accentColor,
                        ),
                        const SizedBox(width: 3),
                        CustomText(
                          jobRequests.toInt() > 1
                              ? "requestsLbl".translate(context: context)
                              : "requestLbl".translate(context: context),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.accentColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: context.colorScheme.accentColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
