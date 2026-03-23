import '../../../../config.dart';

class ChooseServicemanLayout extends StatelessWidget {
  final String? title;
  final int? selectIndex,index;
  final List? list;
  final GestureTapCallback? onTap;
  const ChooseServicemanLayout({super.key,this.onTap,this.selectIndex,this.title,this.index,this.list});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language(context, title!),
                  style: appCss.dmDenseRegular14
                      .textColor(appColor(context).appTheme.darkText)),
               CommonRadio(onTap: onTap,index: index,selectedIndex: selectIndex)
            ]
        ),
        if(index != list!.length -1)
        Divider(height: 1,thickness: 1,color: appColor(context).appTheme.stroke).paddingSymmetric(vertical: Insets.i20)
      ],
    );
  }
}
