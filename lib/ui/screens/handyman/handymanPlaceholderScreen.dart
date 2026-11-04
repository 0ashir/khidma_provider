import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

/// Simple titled placeholder used for the non-dashboard handyman tabs
/// (Jobs / Earnings / Chat). Pure UI, no backend.
class HandymanPlaceholderScreen extends StatelessWidget {
  const HandymanPlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    this.scrollController,
  });

  final String title;
  final String icon;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: context.colorScheme.primaryColor,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: CustomText(
                  title,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.blackColor,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        height: 70,
                        width: 70,
                        borderRadius: UiUtils.borderRadiusOf15,
                        color: context.colorScheme.secondaryColor,
                        alignment: Alignment.center,
                        child: CustomSvgPicture(
                          svgImage: icon,
                          height: 30,
                          width: 30,
                          color: context.colorScheme.accentColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomText(
                        title,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.blackColor,
                      ),
                      const SizedBox(height: 6),
                      CustomText(
                        'Coming soon',
                        fontSize: 13,
                        color: context.colorScheme.lightGreyColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kBottomNavigationBarHeight + 20),
            ],
          ),
        ),
      ),
    );
  }
}
