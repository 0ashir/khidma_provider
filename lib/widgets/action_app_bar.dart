import '../config.dart';

class ActionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GestureTapCallback? onTap;
  final List<Widget>? actions;
  final String? title;
  const ActionAppBar({super.key,this.onTap, this.actions, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: 80,
        title: Text(language(context, title!),
            style: appCss.dmDenseBold18
                .textColor(appColor(context).appTheme.darkText)),
        centerTitle: true,
        leading: CommonArrow(
            arrow: rtl(context)
                ? eSvgAssets.arrowRight
                : eSvgAssets.arrowLeft,
            onTap: onTap ?? () => route.pop(context)).paddingAll(Insets.i8),
        actions: actions);
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(70);
}
