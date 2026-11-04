import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../app/generalImports.dart';

class MaintenanceModeScreen extends StatelessWidget {
  const MaintenanceModeScreen({super.key, required this.message});

  final String message;

  static Route<MaintenanceModeScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) =>
          MaintenanceModeScreen(message: routeSettings.arguments as String),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = context.read<FetchSystemSettingsCubit>().appSetting;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: Lottie.asset(
                  'assets/animation/maintenance_mode.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'underMaintenance'.translate(context: context),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              if (appSettings.providerAppMaintenanceModeStartDateTime != null &&
                  appSettings.providerAppMaintenanceModeEndDateTime != null)
                CustomText(
                  '${UiUtils.formatDateTime(appSettings.providerAppMaintenanceModeStartDateTime!, convertToLocal: true)} ${'to'.translate(context: context).toLowerCase()} ${UiUtils.formatDateTime(appSettings.providerAppMaintenanceModeEndDateTime!, convertToLocal: true)}',
                  color: context.colorScheme.blackColor,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  (message.isNotEmpty)
                      ? message
                      : 'underMaintenanceSubTitle'.translate(context: context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomRoundedButton(
                  buttonTitle: "checkAgain".translate(context: context),
                  showBorder: false,
                  widthPercentage: 0.5,
                  backgroundColor: context.colorScheme.accentColor,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(Routes.splash, (_) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
