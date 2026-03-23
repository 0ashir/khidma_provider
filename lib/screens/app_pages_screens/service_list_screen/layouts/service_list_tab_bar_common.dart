import 'dart:developer';

import '../../../../config.dart';

class ServiceListTabBarCommon extends StatelessWidget {
  final dynamic sync;

  const ServiceListTabBarCommon({super.key, this.sync});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceListProvider>(builder: (context, value, child) {
      return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  categoryList[value.selectedIndex].hasSubCategories!.isNotEmpty
                      ? Row(
                          children: categoryList[value.selectedIndex]
                              .hasSubCategories!
                              .asMap()
                              .entries
                              .map((e) {
                            return IntrinsicWidth(
                              child: Column(
                                children: [
                                  Text(e.value.title!,
                                          style: value.tabIndex == e.key
                                              ? appCss.dmDenseSemiBold14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .primary)
                                              : appCss.dmDenseRegular14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .lightText),
                                          textAlign: TextAlign.center)
                                      .inkWell(onTap: () {
                                    log("SSS ");
                                    value.onTapTab(context, e.key, e.value.id!);
                                  }).padding(
                                          bottom: Insets.i10,
                                          horizontal: Insets.i20),
                                  Container(
                                    height: 2.5,
                                    decoration: BoxDecoration(
                                        color: value.tabIndex == e.key
                                            ? appColor(context).appTheme.primary
                                            : appColor(context).appTheme.trans,
                                        borderRadius: BorderRadius.circular(2)),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ).paddingSymmetric(horizontal: Insets.i20)
                      : Container())
          .width(MediaQuery.of(context).size.width);
    });

/*    return categoryList[value.selectedIndex].hasSubCategories!.isNotEmpty && value.controller != null ? DefaultTabController(
      length: categoryList[value.selectedIndex].hasSubCategories!.length,
      initialIndex: 0,
      child: DecoratedTabBar(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: appColor(context).appTheme.stroke, width: 3.0))),
          tabBar: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicator:
                  CustomTabIndicator(color: appColor(context).appTheme.primary),
              onTap: (val) => value.onTapTab(context,val,sync),

              indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: Insets.i20, vertical: 0.5),
              controller: value.controller,
              tabs: [
                ...categoryList[value.selectedIndex].hasSubCategories!
                    .asMap()
                    .entries
                    .map((e) => Text(e.value.title!,
                            style: appCss.dmDenseMedium14.textColor(
                                value.controller!.index == e.key
                                    ? appColor(context).appTheme.primary
                                    : appColor(context).appTheme.lightText),
                            textAlign: TextAlign.center).inkWell(onTap: (){
                              log("SSS ");
                              value.onTapTab(context, e.key, sync);
                })
                        .paddingOnly(bottom: Insets.i10))
                    .toList()
              ])),
    ):Container();*/
  }
}
