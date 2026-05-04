import '../config.dart';

class SliderLabelCommon extends StatelessWidget {
  final double? val;
  final String? title;
  const SliderLabelCommon({super.key, this.val, this.title});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 4,
          width: 2,
          color: val == 0.0 ||
              val == 5.0 ||
              val == 10.0 ||
              val == 15.0||
              val == 20.0||
              val == 25.0||
              val == 30.0
              ? appColor(context)
              .appTheme
              .darkText
              : appColor(context).appTheme.stroke,
        ),
        const VSpace(Sizes.s3),
        Text(title!,
            textAlign: TextAlign.center,
            style: appCss.dmDenseMedium12
                .textColor(val == 0.0 ||
                val == 5.0 ||
                val == 10.0 ||
                val == 15.0||
                val == 20.0||
                val == 25.0||
                val == 30.0
                ? appColor(context)
                .appTheme
                .darkText
                : appColor(context).appTheme.stroke)
                .textHeight(1)),
      ],
    );
  }
}
