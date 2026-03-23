import '../../../../config.dart';

class AssignStatusLayout extends StatelessWidget {
  final String? title, status;
  final bool? isGreen;

  const AssignStatusLayout(
      {super.key, this.title, this.isGreen = false, this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
            mainAxisAlignment: title!.length > 30
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  language(context,
                      "${language(context, status) ?? language(context, translations!.status)}:"),
                  style: appCss.dmDenseMedium14.textColor(isGreen == true
                      ? appColor(context).appTheme.online
                      : appColor(context).appTheme.red)),
              const HSpace(Sizes.s10),
              title!.length > 30
                  ? Expanded(
                      child: Text(language(context, title),
                          overflow: TextOverflow.clip,
                          style: appCss.dmDenseRegular14.textColor(
                              isGreen == true
                                  ? appColor(context).appTheme.online
                                  : appColor(context).appTheme.red)),
                    )
                  : Text(language(context, title),
                      overflow: TextOverflow.clip,
                      style: appCss.dmDenseRegular14.textColor(isGreen == true
                          ? appColor(context).appTheme.online
                          : appColor(context).appTheme.red))
            ]).paddingAll(Insets.i15).boxShapeExtension(
            radius: 0,
            color: isGreen == true
                ? appColor(context).appTheme.online.withOpacity(0.1)
                : appColor(context).appTheme.red.withOpacity(0.1)));
  }
}
