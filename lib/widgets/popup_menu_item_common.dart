import '../config.dart';

PopupMenuItem buildPopupMenuItem(context, list,
    {position, bool icon = false, data, index}) {
  return PopupMenuItem(
    value: position,
    onTap: () {
      if (icon) {
      } else {
        if (data == translations!.call) {}
      }
    },
    padding:
        const EdgeInsets.symmetric(horizontal: Insets.i12, vertical: Insets.i2),
    height: 30,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == true
              ? Row(
                  children: [
                    SizedBox(
                            height: Sizes.s13,
                            width: Sizes.s13,
                            child: SvgPicture.asset(data["image"]))
                        .paddingAll(Insets.i4)
                        .decorated(
                            color: appColor(context).appTheme.fieldCardBg,
                            shape: BoxShape.circle),
                    const HSpace(Sizes.s12),
                    Text(language(context, data["title"]),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.darkText)),
                  ],
                )
              : Text(language(context, data),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.darkText))
                  .alignment(Alignment.centerLeft),
          /*  if (index != list.length - 1)
            Divider(
                    height: 1,
                    color: appColor(context).appTheme.stroke,
                    thickness: 1)
                .paddingSymmetric(vertical: Insets.i10) */
        ]),
  );
}
