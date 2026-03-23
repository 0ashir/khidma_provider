import '../../../../config.dart';

class JoiningLayout extends StatelessWidget {
  final dynamic data;
  final int? index,selectedIndex;
  final GestureTapCallback? onTap;
  const JoiningLayout({super.key,this.data,this.index,this.selectedIndex,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(alignment: Alignment.bottomRight, children: [
        Container(
            height: Sizes.s88,
            width: Sizes.s88,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColor(context).appTheme.fieldCardBg,
                border: Border.all(color: selectedIndex == index ? appColor(context).appTheme.primary : appColor(context).appTheme.fieldCardBg) ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(data["image"],
                      width: index == 1 ? Sizes.s70 : Sizes.s50, height: index == 1 ? Sizes.s70 : Sizes.s50)
                ])),
        if(selectedIndex == index)
        Image.asset(eImageAssets.tick, width: Sizes.s22, height: Sizes.s22)
      ]),
      const VSpace(Sizes.s10),
      Text(language(context, data["title"]).toUpperCase(),
          style: appCss.dmDenseMedium15
              .textColor(selectedIndex == index ? appColor(context).appTheme.primary : appColor(context).appTheme.darkText ))
    ]).inkWell(onTap: onTap);
  }
}
