import '../../../../config.dart';

class AppSettingLayout extends StatelessWidget {
  const AppSettingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final settingCtrl = Provider.of<AppSettingProvider>(context, listen: true);
    return Consumer2<LanguageProvider, ThemeService>(
        builder: (themeContext, lang, theme, child) {
      return SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        ...appArray.appSetting(theme.isDarkMode).asMap().entries.map((e) {
          return Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                CommonArrow(arrow: e.value['icon'].toString()),
                const HSpace(Sizes.s12),
                e.key == 0
                    ? Text(
                        language(context,
                            appArray.themeModeList[themeIndex(context)]),
                        style: appCss.dmDenseRegular14
                            .textColor(appColor(context).appTheme.darkText))
                    : Text(language(context, e.value['title']),
                        style: appCss.dmDenseRegular14
                            .textColor(appColor(context).appTheme.darkText))
              ]),
              if (e.key == 1)
                Consumer<LanguageProvider>(
                    builder: (lanTheme, language, child) {
                  return Theme(
                      data: ThemeData(useMaterial3: false),
                      child: FlutterSwitch(
                          width: Sizes.s32,
                          height: Sizes.s20,
                          toggleSize: Sizes.s12,
                          value: settingCtrl.isNotification,
                          borderRadius: 15,
                          padding: 3,
                          toggleColor: appColor(context).appTheme.whiteBg,
                          inactiveToggleColor:
                              appColor(context).appTheme.lightText,
                          activeColor: appColor(context).appTheme.primary,
                          inactiveColor: appColor(context).appTheme.stroke,
                          onToggle: (val) =>
                              settingCtrl.onNotification(val, context)));
                }),
              if (e.key == 0 || e.key == 2 || e.key == 3 || e.key == 4)
                SvgPicture.asset(
                    rtl(context) ? eSvgAssets.arrowLeft : eSvgAssets.arrowRight,
                    colorFilter: ColorFilter.mode(
                        appColor(context).appTheme.lightText, BlendMode.srcIn))
            ]).paddingSymmetric(vertical: Insets.i12),
            Divider(color: appColor(context).appTheme.fieldCardBg, height: 0)
          ])
              .paddingSymmetric(horizontal: Insets.i15)
              .width(MediaQuery.of(context).size.width)
              .inkWell(onTap: () => settingCtrl.onTapData(context, e.key));
        })
      ]))).decorated(
          color: appColor(context).appTheme.whiteBg,
          border: Border.all(color: appColor(context).appTheme.fieldCardBg),
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
                color: appColor(context).appTheme.fieldCardBg,
                spreadRadius: 2,
                blurRadius: 4)
          ]).marginSymmetric(horizontal: Insets.i15, vertical: Insets.i25);
    });
  }
}
