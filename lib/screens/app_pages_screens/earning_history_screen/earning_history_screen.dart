import '../../../config.dart';

class EarningHistoryScreen extends StatelessWidget {
  const EarningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<UserDataApiProvider, LanguageProvider,
            EarningHistoryProvider>(
        builder: (context, userApi, lang, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 100), () => value.onInit()),
          child: Scaffold(
              appBar: AppBar(
                  leadingWidth: 80,
                  title: Text(language(context, translations!.earningHistory),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).appTheme.darkText)),
                  centerTitle: true,
                  leading: CommonArrow(
                      arrow: rtl(context)
                          ? eSvgAssets.arrowRight
                          : eSvgAssets.arrowLeft,
                      onTap: () {
                        userApi.commissionHistory(false, context);
                        route.pop(context);
                      }).padding(vertical: Insets.i8),
                  actions: [
                    CommonArrow(arrow: eSvgAssets.calender)
                        .paddingSymmetric(horizontal: Insets.i20)
                        .inkWell(onTap: () => value.onTapCalender(context))
                  ]),
              body: SingleChildScrollView(
                  child: Column(children: [
                /*      Row(children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                          language(context, translations!.sortByCategories),
                          style: appCss.dmDenseMedium14.textColor(
                              appColor(context).appTheme.lightText))),
                  Expanded(
                      flex: 3,
                      child: DarkDropDownLayout(
                          svgColor: appColor(context).appTheme.lightText,
                          border: CommonWidgetLayout().noneDecoration(
                              radius: 0,
                              color: appColor(context).appTheme.trans),
                          hintText: "All categories",
                          val: value.countryValue,
                          isOnlyText: true,
                          isIcon: false,
                          isField: true,
                          categoryList: appArray.allCategories,
                          onChanged: (val) => value.onChangeCountry(val)))
                ]).paddingSymmetric(vertical: Insets.i20),*/
                const VSpace(Sizes.s20),
                if (commissionList == null ||
                    commissionList!.histories!.isEmpty)
                  EmptyLayout(
                    widget:
                        Image.asset(eImageAssets.noSearch, height: Sizes.s380),
                    title: translations!.noDataFound,
                    subtitle: '',
                  ).center().padding(top: Sizes.s100),
                if (commissionList != null ||
                    commissionList!.histories!.isNotEmpty)
                  ...commissionList!.histories!
                      .asMap()
                      .entries
                      .map((e) => HistoryLayout(data: e.value))
              ]).paddingSymmetric(horizontal: Insets.i20))));
    });
  }
}
