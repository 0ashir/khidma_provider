import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class AddFloatingButton extends StatelessWidget {
  const AddFloatingButton({
    super.key,
    required this.routeNm,
    this.callWhenComeBack,
    this.buttonColor,
  });
  final String routeNm;
  final Color? buttonColor;
  final Function(dynamic value)? callWhenComeBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final String? isApproved = context
            .read<ProviderDetailsCubit>()
            .providerDetails
            .providerInformation
            ?.isApproved;
        if (isApproved != '1') {
          UiUtils.showAnimatedDialog(
            context: context,
            child: ConfirmationDialog(
              title: 'addServiceBlockedTitle',
              description: 'addServiceBlockedDescription',
              confirmButtonName: 'ok',
              confirmButtonPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
          return;
        }
        Navigator.of(context).pushNamed(routeNm).then((Object? value) {
          callWhenComeBack?.call(value);
        }); //Routes.createService
      },
      child: CustomContainer(
        borderRadius: UiUtils.borderRadiusOf10,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 10),
        height: 56,
        color: Theme.of(context).colorScheme.accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvgPicture(
              svgImage: AppAssets.addCircle,
              color: AppColors.whiteColors,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
            CustomText(
              'addNewService'.translate(context: context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.whiteColors,
            ),
          ],
        ),
      ),
    );
  }
}
