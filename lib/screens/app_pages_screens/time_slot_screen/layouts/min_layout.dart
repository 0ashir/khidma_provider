import '../../../../config.dart';

class MyMinutes extends StatelessWidget {
 final int min;
 final int? index,selectIndex;


  const MyMinutes({super.key, required this.min,this.index,this.selectIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      min < 10 ? '0$min' : min.toString(),
      style: index == selectIndex ? appCss.dmDenseMedium24.textColor(appColor(context).appTheme.primary) : appCss.dmDenseMedium20.textColor(appColor(context).appTheme.lightText) ,
    );
  }
}