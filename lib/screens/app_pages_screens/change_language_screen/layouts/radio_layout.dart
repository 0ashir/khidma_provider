import '../../../../config.dart';

class RadioLayout extends StatelessWidget {
  const RadioLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCtrl = Provider.of<LanguageProvider>(context, listen: true);
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
      ...languageCtrl.languageList.asMap().entries.map((e) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(e.value.flag.toString())))),
              const HSpace(Sizes.s12),
              Text(language(context, e.value.name),
                  style: appCss.dmDenseRegular14
                      .textColor(appColor(context).appTheme.darkText))
            ]),
            languageCtrl.selectedIndex == e.key
                ? Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColor(context)
                            .appTheme
                            .primary
                            .withOpacity(0.18)),
                    child: Icon(Icons.circle,
                        color: appColor(context).appTheme.primary, size: 13))
                : Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: appColor(context).appTheme.stroke)))
          ]).paddingSymmetric(vertical: Insets.i12),
          Divider(color: appColor(context).appTheme.fieldCardBg, height: 0)
        ])
            .paddingSymmetric(horizontal: Insets.i15)
            .width(MediaQuery.of(context).size.width)
            .inkWell(onTap: () => languageCtrl.setIndex(e.key));
      })
    ]))).decorated(
        color: appColor(context).appTheme.whiteBg,
        border: Border.all(color: appColor(context).appTheme.fieldCardBg),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        boxShadow: [
          BoxShadow(
              color: appColor(context).appTheme.fieldCardBg,
              spreadRadius: 2,
              blurRadius: 4)
        ]).paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i25);
  }
}
