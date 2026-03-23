import '../../../../config.dart';

class HourLayout extends StatelessWidget {
 final int hours;
 final int? index,selectIndex;

  const HourLayout({super.key, required this.hours, this.index, this.selectIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      hours.toString(),
      style: index == selectIndex ? appCss.dmDenseMedium24.textColor(appColor(context).appTheme.primary) : appCss.dmDenseMedium20.textColor(appColor(context).appTheme.lightText) ,
    );
  }
}