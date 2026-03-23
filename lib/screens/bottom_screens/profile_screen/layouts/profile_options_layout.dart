// ignore_for_file: unnecessary_to_list_in_spreads, use_build_context_synchronously

import '../../../../config.dart';

class ProfileOptionsLayout extends StatefulWidget {
  const ProfileOptionsLayout({super.key});

  @override
  State<ProfileOptionsLayout> createState() => _ProfileOptionsLayoutState();
}

class _ProfileOptionsLayoutState extends State<ProfileOptionsLayout>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileProvider, LanguageProvider, ThemeService>(
        builder: (context, value, lang, theme, child) {
      return StatefulWrapper(
        onInit: () =>
            Future.delayed(const Duration(milliseconds: 150)).then((valuee) {
          value.onReady(context);
        }),
        child: Column(
                children: value.profileLists
                    .asMap()
                    .entries
                    .map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (e.key != 3)
                                e.key == 2
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: Insets.i15))
                                    : Text(
                                            e.value.title
                                                .toString()
                                                .toUpperCase(),
                                            style: appCss.dmDenseBold14
                                                .textColor(e.key == 2
                                                    ? appColor(context)
                                                        .appTheme
                                                        .red
                                                    : appColor(context)
                                                        .appTheme
                                                        .primary))
                                        .paddingSymmetric(vertical: Insets.i15),
                              if (e.value.data != null)
                                Container(
                                    decoration: ShapeDecoration(
                                        color: e.key == 2
                                            ? appColor(context)
                                                .appTheme
                                                .red
                                                .withValues(alpha: 0.1)
                                            : appColor(context)
                                                .appTheme
                                                .whiteBg,
                                        shadows: e.key == 2
                                            ? null
                                            : [
                                                BoxShadow(
                                                    color: appColor(context)
                                                        .appTheme
                                                        .darkText
                                                        .withValues(
                                                            alpha: 0.06),
                                                    spreadRadius: 1,
                                                    blurRadius: 2)
                                              ],
                                        shape: SmoothRectangleBorder(
                                            side: BorderSide(
                                                color: appColor(context)
                                                    .appTheme
                                                    .fieldCardBg),
                                            borderRadius: SmoothBorderRadius(
                                                cornerRadius: AppRadius.r12,
                                                cornerSmoothing: 1))),
                                    child: Column(children: [
                                      ...e.value.data!
                                          .asMap()
                                          .entries
                                          .map((s) => ProfileOptionLayout(
                                              indexMain: e.key,
                                              data: s.value,
                                              index: s.key,
                                              list: e.value.data,
                                              onTap: () {
                                                value.onTapOption(
                                                    s.value, context, this);
                                              } /* => value. onTapOption(s.value, context,this) */))
                                          .toList()
                                    ]).paddingAll(Insets.i15))
                            ]))
                    .toList())
            .padding(bottom: Sizes.s30),
      );
    });
  }
}
