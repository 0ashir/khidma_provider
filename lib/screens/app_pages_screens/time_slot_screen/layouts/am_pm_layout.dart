import '../../../../config.dart';

class AmPmLayout extends StatelessWidget {
  final bool isItAm;
  final int? index,selectIndex;
  
  const AmPmLayout({super.key, required this.isItAm, this.index, this.selectIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      isItAm == true ? 'A.M' : 'P.M',
      style: index == selectIndex ? appCss.dmDenseMedium24.textColor(appColor(context).appTheme.primary) : appCss.dmDenseMedium20.textColor(appColor(context).appTheme.lightText) 
    );
  }
}