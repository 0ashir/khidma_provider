import 'dart:developer';

import '../../../config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<LanguageProvider, ProfileProvider, ThemeService,
            UserDataApiProvider>(
        builder: (contextTheme, lang, value, theme, userData, child) {
      log("isSer :$isFreelancer");
      return StatefulWrapper(
          onInit: () => Future.delayed(const Duration(milliseconds: 150),
              () => value.onReady(contextTheme)),
          child: Scaffold(
              appBar: AppBar(
                  leadingWidth: 0,
                  centerTitle: false,
                  title: Text(language(context, translations!.profileSetting),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(contextTheme).appTheme.darkText)),
                  actions: [
                    CommonArrow(
                            arrow: eSvgAssets.setting,
                            onTap: () => value.onTapSettingTap(context))
                        .paddingSymmetric(horizontal: Insets.i20)
                  ]),
              body: Stack(
                children: [
                  Consumer2<ThemeService, UserDataApiProvider>(
                      builder: (context, value, userData, child) {
                    return SingleChildScrollView(
                        child: const Column(children: [
                      ProfileSettingTopLayout(),
                      VSpace(Sizes.s15),
                      ProfileOptionsLayout()
                    ]).padding(
                            horizontal: Insets.i20,
                            top: Insets.i20,
                            bottom: Insets.i110));
                  }),
                  if (userData.getDocument == true ||
                      userData.isPackageLoader == true)
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: isDark(context)
                            ? Colors.black.withValues(alpha: 0.3)
                            : appColor(context)
                                .appTheme
                                .darkText
                                .withValues(alpha: 0.2),
                        child: Center(
                            child: Image.asset(eGifAssets.loaderGif,
                                height: Sizes.s100)))
                ],
              )));
    });
  }
}
