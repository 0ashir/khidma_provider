import 'package:edemand_partner/app/generalImports.dart';

/// Removes an open subscription page after a settings refresh disables plans.
class SubscriptionAccessGuard extends StatelessWidget {
  const SubscriptionAccessGuard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<FetchSystemSettingsCubit>();
    if (settings.subscriptionsEnabled) {
      return child ?? const SizedBox.shrink();
    }
    // A request in progress is not evidence that the admin disabled plans.
    if (settings.state is FetchSystemSettingsSuccess &&
        !settings.subscriptionsEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted ||
            settings.state is! FetchSystemSettingsSuccess ||
            settings.subscriptionsEnabled ||
            ModalRoute.of(context)?.isCurrent != true) {
          return;
        }
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.main, (_) => false);
      });
    }
    return const SizedBox.shrink();
  }
}
