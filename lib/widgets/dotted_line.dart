import '../config.dart';


class DottedLines extends StatelessWidget {
  final Color? color;
  final double? width;
  final Axis? direction;
  const DottedLines({Key? key,this.color,this.width,this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedLine(
        direction: direction ?? Axis.horizontal,
      lineLength: width ?? double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: color ?? appColor(context).appTheme.stroke,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }
}
