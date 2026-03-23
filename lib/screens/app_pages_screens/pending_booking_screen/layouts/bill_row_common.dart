import '../../../../config.dart';

class BillRowCommon extends StatelessWidget {
  final String? title,price;
  final Color? color;
  final TextStyle? style,styleTitle;
  const BillRowCommon({super.key,this.title,this.price,this.color,this.style,this.styleTitle});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(language(context, title!),
            style: styleTitle ?? appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.lightText)),
        Text(price!,
            style: style ?? appCss.dmDenseMedium14
                .textColor( color ?? appColor(context).appTheme.darkText))
      ],
    ).paddingSymmetric(horizontal: Insets.i15);
  }
}
