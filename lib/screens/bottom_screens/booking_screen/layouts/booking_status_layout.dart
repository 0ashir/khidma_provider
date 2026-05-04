import '../../../../config.dart';
import '../../../../widgets/radio_button_common.dart';

class BookingStatusFilterLayout extends StatelessWidget {
  final String? title;
  final int? index,selectedIndex;
  final GestureTapCallback? onTap;
  const BookingStatusFilterLayout({Key? key,this.title,this.onTap,this.selectedIndex,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(title!,
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
        ),
        CommonRadio(index: index, selectedIndex: selectedIndex,onTap: onTap)
      ]
    )
        .paddingSymmetric(horizontal: Insets.i15,vertical: Insets.i12)
        .boxBorderExtension(context,
            color: appColor(context).appTheme.whiteBg, isShadow: true)
        .paddingOnly(bottom: Insets.i12);
  }
}
