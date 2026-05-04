import '../../../config.dart';

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppSettingProvider, ThemeService>(
        builder: (context1, settingCtrl, theme, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(const Duration(milliseconds: 150),
            () => settingCtrl.onReady(context)),
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leadingWidth: 80,
                leading: CommonArrow(
                        arrow: rtl(context)
                            ? eSvgAssets.arrowRight
                            : eSvgAssets.arrowLeft,
                        onTap: () => route.pushReplacementNamed(context,
                            routeName.dashboard) /*route.pop(context)*/)
                    .paddingAll(Insets.i8),
                title: Text(language(context, translations!.appSetting),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText))),
            body: const AppSettingLayout()),
      );
    });
  }
}
