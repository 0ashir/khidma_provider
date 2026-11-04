import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomWarningBottomSheet extends StatelessWidget {
  const CustomWarningBottomSheet({
    super.key,
    required this.conformText,
    required this.onTapConformText,
    required this.closeText,
    required this.onTapCloseText,
    required this.detailsWarningMessage,
    this.conformButtonColor,
  });
  final String conformText;
  final VoidCallback onTapConformText;
  final String closeText;
  final VoidCallback onTapCloseText;
  final String detailsWarningMessage;
  final Color? conformButtonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomSvgPicture(
            svgImage: AppAssets.closeService,
            boxFit: BoxFit.fill,
          ),
          const SizedBox(height: 20),
          Text(
            "areYouSure?".translate(context: context),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.blackColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            detailsWarningMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomRoundedButton(
                  onTap: onTapConformText,
                  widthPercentage: 1,
                  backgroundColor:
                      conformButtonColor ??
                      Theme.of(context).colorScheme.accentColor,
                  showBorder: false,
                  borderColor:
                      conformButtonColor ??
                      Theme.of(context).colorScheme.accentColor,
                  buttonTitle: conformText,
                  titleColor: AppColors.whiteColors,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomRoundedButton(
                  onTap: onTapCloseText,
                  widthPercentage: 1,
                  backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                  showBorder: true,
                  borderColor: Theme.of(context).colorScheme.blackColor,
                  buttonTitle: closeText,
                  titleColor: Theme.of(context).colorScheme.blackColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
