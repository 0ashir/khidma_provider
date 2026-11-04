import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';

class SlotManagementScreen extends StatelessWidget {
  const SlotManagementScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => const SlotManagementScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'slotManagement'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
        ),
        backgroundColor: context.colorScheme.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _OptionTile(
                icon: AppAssets.bClock,
                title: 'workingHours'.translate(context: context),
                subtitle: 'configureWorkingSchedule'.translate(
                  context: context,
                ),
                onTap: () => Navigator.pushNamed(context, Routes.workingHours),
              ),
              const SizedBox(height: 12),
              _OptionTile(
                icon: AppAssets.bCalender,
                title: 'slotConfiguration'.translate(context: context),
                subtitle: 'configureSlotIntervalsDesc'.translate(
                  context: context,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, Routes.slotConfiguration),
              ),
              const SizedBox(height: 12),
              _OptionTile(
                icon: AppAssets.bCalender,
                title: 'setLeave'.translate(context: context),
                subtitle: 'setLeaveDesc'.translate(context: context),
                onTap: () => Navigator.pushNamed(context, Routes.leaveScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomInkWellContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
      child: CustomContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: UiUtils.borderRadiusOf10,
        color: context.colorScheme.secondaryColor,
        border: Border.all(
          color: context.colorScheme.lightGreyColor,
          width: 0.3,
        ),
        child: Row(
          children: [
            CustomContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: UiUtils.borderRadiusOf8,
              color: context.colorScheme.accentColor.withValues(alpha: 0.1),
              child: CustomSvgPicture(
                svgImage: icon,
                color: context.colorScheme.accentColor,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(title, fontWeight: FontWeight.w600, fontSize: 16),
                  const SizedBox(height: 4),
                  CustomText(
                    subtitle,
                    fontSize: 13,
                    color: context.colorScheme.lightGreyColor,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CustomSvgPicture(
              svgImage: AppAssets.arrowNext,
              color: context.colorScheme.lightGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
