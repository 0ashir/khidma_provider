import '../../../../config.dart';

class SelectOptionLayout extends StatelessWidget {
  final dynamic data;
  final GestureTapCallback? onTap;
  final List? list;
  final int? index;
  const SelectOptionLayout({super.key,this.onTap,this.data,this.list,this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
              children: [
                SvgPicture.asset(data["image"])
                    .paddingAll(Insets.i10)
                    .decorated(
                    color: appColor(context)
                        .appTheme
                        .primary
                        .withOpacity(0.1),
                    shape: BoxShape.circle),
                const HSpace(Sizes.s15),
                Text(language(context, data["title"]),style: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.darkText))
              ]
          ),
          if( index != list!.length - 1)
            Divider(height: 1,color: appColor(context).appTheme.stroke).paddingSymmetric(vertical: Insets.i20)
        ]
    ).inkWell(onTap: onTap);
  }
}