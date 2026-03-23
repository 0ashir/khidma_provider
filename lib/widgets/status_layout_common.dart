import '../config.dart';

class StatusLayoutCommon extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool>? onToggle;
  final String? title;
  const StatusLayoutCommon({super.key, this.value, this.onToggle, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 8,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(language(context, title!),
                style: appCss.dmDenseSemiBold14
                    .textColor(appColor(context).appTheme.darkText)),
            Text(language(context, translations!.thisServiceCanBe),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText))
          ])),
      const HSpace(Sizes.s25),
      Expanded(
          flex: 2, child: FlutterSwitchCommon(value: value, onToggle: onToggle))
    ])
        .paddingAll(Insets.i15)
        .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
        .paddingSymmetric(horizontal: Insets.i20);
  }
}
