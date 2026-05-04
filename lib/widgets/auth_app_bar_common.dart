import '../config.dart';

class AuthAppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  final GestureTapCallback? onTap;
  const AuthAppBarCommon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: 80,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(eImageAssets.appLogo,
              height: Sizes.s34, width: Sizes.s34),
          const HSpace(Sizes.s5),
          Text(language(context, translations!.fixit),
              style: appCss.outfitBold38
                  .textColor(appColor(context).appTheme.darkText))
        ]),
        centerTitle: true,
        leading: CommonArrow(
                arrow:
                    rtl(context) ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
                onTap: onTap ?? () => route.pop(context))
            .padding(vertical: Insets.i8));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(70);
}
