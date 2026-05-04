import '../../../../config.dart';

class LanguageLayout extends StatelessWidget {
  final String? title;
  const LanguageLayout({super.key,this.title});

  @override
  Widget build(BuildContext context) {
    return Text(language(context, title),
        style: appCss.dmDenseMedium12
            .textColor(appColor(context).appTheme.darkText))
        .paddingSymmetric(
        vertical: Insets.i8, horizontal: Insets.i14)
        .boxShapeExtension(
        color: appColor(context).appTheme.fieldCardBg).paddingOnly(right: Insets.i10);
  }
}
