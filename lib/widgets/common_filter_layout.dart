import '../../../../config.dart';

class CommonFilterLayout extends StatelessWidget {
  final int? index,selectedIndex;
  final dynamic data;
  final GestureTapCallback? onTap;
  const CommonFilterLayout({super.key,this.data,this.onTap,this.index,this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
        child: Container(
            height: height * 0.1,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: index == selectedIndex
                    ? appColor(context).appTheme.primary
                    : appColor(context).appTheme.fieldCardBg,
                borderRadius: rtl(context) ? BorderRadius.only(
                    bottomLeft: Radius.circular(index == 0 ? 0 : index == 1 ? 0 : AppRadius.r30),
                    topLeft: Radius.circular(index == 0 ? 0: index == 1 ? 0  : AppRadius.r30),
                    topRight: Radius.circular(index == 0 ? AppRadius.r30: index == 1 ? 0  : 0),
                    bottomRight: Radius.circular(index == 0 ? AppRadius.r30: index == 1 ? 0  : 0))

                    : BorderRadius.only(
                  topRight: Radius.circular(index == 0 ? 0: index == 1 ? 0  : AppRadius.r30),
                  bottomRight: Radius.circular(index == 0 ? 0: index == 1 ? 0  : AppRadius.r30),
                  bottomLeft: Radius.circular(index == 0 ? AppRadius.r30 : index == 1 ? 0 : 0),
                  topLeft: Radius.circular(index == 0 ? AppRadius.r30: index == 1 ? 0  : 0),
                )),
            child: Text(language(context, data),
                style: appCss.dmDenseMedium14.textColor(index == selectedIndex
                    ? appColor(context).appTheme.whiteBg
                    : appColor(context).appTheme.lightText))).inkWell(onTap: onTap)
    );
  }
}
