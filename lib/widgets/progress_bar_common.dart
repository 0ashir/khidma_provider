import '../config.dart';

class ProgressBar extends StatelessWidget {
  final double max;
  final String current;
  final Color? color;

  const ProgressBar(
      {Key? key,
        required this.max,
        required this.current,
        this.color,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (double.parse(current) / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 8,
              decoration: BoxDecoration(
                color: appColor(context).appTheme.fieldCardBg,
                borderRadius: BorderRadius.circular(AppRadius.r10)
              )
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: percent,
              height: 8,
              decoration: BoxDecoration(
                color: color ?? const Color(0xffFFC412),
                borderRadius: BorderRadius.circular(AppRadius.r10)
              )
            )
          ]
        );
      },
    );
  }
}