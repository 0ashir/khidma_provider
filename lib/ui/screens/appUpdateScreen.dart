import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../app/generalImports.dart';

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key, required this.isForceUpdate});

  final bool isForceUpdate;

  static Route route(RouteSettings settings) {
    final Map arguments = settings.arguments as Map;
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return AppUpdateScreen(isForceUpdate: arguments['isForceUpdate']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: context.screenWidth * 0.6,
                width: context.screenWidth * 0.9,
                child: Lottie.asset(
                  'assets/animation/maintenance_mode.json',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'updateAppTitle'.translate(context: context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  isForceUpdate
                      ? 'compulsoryUpdateSubTitle'.translate(context: context)
                      : 'normalUpdateSubTitle'.translate(context: context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomRoundedButton(
                  onTap: () {
                    final String storeURL = context
                        .read<FetchSystemSettingsCubit>()
                        .getProviderAppURL;
                    launchUrl(
                      Uri.parse(storeURL),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  widthPercentage: 1,
                  titleColor: AppColors.whiteColors,
                  backgroundColor: Theme.of(context).colorScheme.accentColor,
                  showBorder: false,
                  buttonTitle: 'update'.translate(context: context),
                ),
              ),
              if (!isForceUpdate)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomRoundedButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    widthPercentage: 1,
                    backgroundColor: Theme.of(context).colorScheme.primaryColor,
                    showBorder: true,
                    borderColor: Theme.of(context).colorScheme.blackColor,
                    buttonTitle: 'notNow'.translate(context: context),
                    titleColor: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
