import '../config.dart';

class MoreOptionLayout extends StatelessWidget {
  final String? icon;
  final double? size;
  final Color? color, iconColor;
  final PopupMenuItemSelected? onSelected;
  final bool? isIcon;
  final List list;

  const MoreOptionLayout(
      {super.key,
      this.onSelected,
      required this.list,
      this.icon,
      this.size,
      this.color,
      this.iconColor,
      this.isIcon = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? Sizes.s40,
      width: size ?? Sizes.s40,
      child: PopupMenuButton(
        onSelected: onSelected,
        color: appColor(context).appTheme.whiteBg,
        constraints: BoxConstraints(
            minWidth: isIcon == true ? Sizes.s180 : Sizes.s140,
            maxWidth: isIcon == true ? Sizes.s180 : Sizes.s140),
        position: PopupMenuPosition.under,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.r8))),
        padding: const EdgeInsets.all(0),
        iconSize: Sizes.s20,
        offset: const Offset(5, 20),
        icon: SvgPicture.asset(icon ?? eSvgAssets.more,
            height: Sizes.s20,
            colorFilter: ColorFilter.mode(
                iconColor ?? appColor(context).appTheme.darkText,
                BlendMode.srcIn)),
        itemBuilder: (context) => [
          ...list.asMap().entries.map((e) => buildPopupMenuItem(
                context,
                list,
                position: e.key,
                data: e.value,
                icon: false,
                index: e.key,
              ))
        ],
      ).decorated(
          color: color ?? appColor(context).appTheme.fieldCardBg,
          shape: BoxShape.circle),
    );
  }
}
