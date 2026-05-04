import 'package:fixit_provider/screens/app_pages_screens/serviceman_list_screen/layouts/servicemen_list_body_layout.dart';
import 'package:fixit_provider/screens/app_pages_screens/serviceman_list_screen/serviceman_list_shimmer.dart';

import '../../../config.dart';

class ServicemanListScreen extends StatelessWidget {
  const ServicemanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServicemanListProvider>(
        builder: (context1, lang, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
          onInit: () => Future.delayed(Durations.short3)
              .then((val) => value.onReady(context)),
          child: Scaffold(
            appBar: AppBar(
                leadingWidth: 80,
                title: Text(language(context, translations!.servicemanList),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText)),
                centerTitle: true,
                leading: CommonArrow(
                        arrow: rtl(context)
                            ? eSvgAssets.arrowRight
                            : eSvgAssets.arrowLeft,
                        onTap: () => value.onBack(context, true))
                    .paddingAll(Insets.i8),
                actions: [
                  CommonArrow(
                          arrow: eSvgAssets.add,
                          onTap: () => route
                              .pushNamed(context, routeName.addServicemen)
                              .then((e) => value.notifyListeners()))
                      .paddingSymmetric(horizontal: Insets.i20)
                ]),
            body: value.isServicemenLoading
                ? const ServicemanListShimmer()
                : RefreshIndicator(
                    onRefresh: () async {
                      value.onRefresh(context);
                    },
                    child: const ServicemenListBodyLayout()),

            /* SingleChildScrollView(
                      child: Column(children: [
                      if (servicemanList.isNotEmpty)
                        SearchTextFieldCommon(
                                controller: value.searchCtrl,
                                focusNode: value.searchFocus,
                                suffixIcon: value.searchCtrl.text.isNotEmpty
                                    ? Icon(Icons.cancel,
                                            color: appColor(context)
                                                .appTheme
                                                .darkText)
                                        .inkWell(onTap: () {
                                        value.searchList = [];
                                        value.searchCtrl.text = "";
                                        value.notifyListeners();
                                        value
                                            .getServicemenByProviderId(context);
                                      })
                                    : null,
                                onChanged: (v) {
                                  if (v.isEmpty) {
                                    value.searchList = [];
                                    value.notifyListeners();
                                  } else if (v.length > 3) {
                                    value.getServicemenByProviderId(context);
                                  }
                                },
                                onFieldSubmitted: (v) =>
                                    value.getServicemenByProviderId(context))
                            .paddingOnly(top: Insets.i15),
                      if (servicemanList.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(
                                    language(context, translations!.filterBy),
                                    style: appCss.dmDenseRegular14.textColor(
                                        appColor(context).appTheme.lightText))),
                            Expanded(
                              flex: 4,
                              child: DarkDropDownLayout(
                                  svgColor:
                                      appColor(context).appTheme.lightText,
                                  border: CommonWidgetLayout().noneDecoration(
                                      radius: 0,
                                      color: appColor(context).appTheme.trans),
                                  isField: true,
                                  isOnlyText: true,
                                  hintText: translations!.allServicemen,
                                  val: value.expValue,
                                  categoryList:
                                      appArray.servicemenExperienceList,
                                  onChanged: (val) =>
                                      value.onExperience(val, context)),
                            )
                          ],
                        ).paddingSymmetric(vertical: Insets.i20),
                      value.searchCtrl.text.isNotEmpty
                          ? value.searchList.isEmpty
                              ? EmptyLayout(
                                      title: translations!.noMatching,
                                      subtitle: translations!.attemptYourSearch,
                                      isButton: false,
                                      widget: Image.asset(eImageAssets.noSearch,
                                          height: Sizes.s340))
                                  .paddingOnly(top: Insets.i50)
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: value.searchCtrl.text.isNotEmpty
                                      ? value.searchList.length
                                      : servicemanList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 220,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 15),
                                  itemBuilder: (context, index) {
                                    return AvailableServiceLayout(
                                        onTap: () => route.pushNamed(context,
                                                routeName.servicemanDetail,
                                                arg: {
                                                  "detail": value.searchCtrl
                                                          .text.isNotEmpty
                                                      ? value
                                                          .searchList[index].id
                                                      : servicemanList[index]
                                                }),
                                        data: value.searchCtrl.text.isNotEmpty
                                            ? value.searchList[index]
                                            : servicemanList[index]);
                                  })
                          : servicemanList.isEmpty
                              ? const CommonEmpty()
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: servicemanList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 220,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 15),
                                  itemBuilder: (context, index) {
                                    return AvailableServiceLayout(
                                        onTap: () => route.pushNamed(
                                            context, routeName.servicemanDetail,
                                            arg: servicemanList[index]),
                                        data: servicemanList[index]);
                                  })
                    ]).paddingSymmetric(horizontal: Insets.i20)) */
          ),
        ),
      );
    });
  }
}
