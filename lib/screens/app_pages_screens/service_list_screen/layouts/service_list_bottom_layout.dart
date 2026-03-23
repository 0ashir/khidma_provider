import 'dart:developer';

import '../../../../common_shimmer/service_shimmer.dart';
import '../../../../config.dart';

class ServiceListBottomLayout extends StatelessWidget {
  final List<CategoryModel>? subCategory;

  const ServiceListBottomLayout({super.key, this.subCategory});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<ServiceListProvider>(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (categoryList[value.selectedIndex].hasSubCategories != null &&
              categoryList[value.selectedIndex].hasSubCategories!.isNotEmpty)
            const ServiceListTabBarCommon()
                .width(MediaQuery.of(context).size.width)
                .decorated(
                    border: Border(
                        bottom: BorderSide(
                            color: appColor(context).appTheme.stroke,
                            width: 2.5))),
          // if (categoryList[value.selectedIndex].hasSubCategories!.isNotEmpty)
          const VSpace(Sizes.s15),
          value.widget1Opacity == 0.0
              ? const ServicesShimmer(count: 3).padding(horizontal: Sizes.s20)
              : value.serviceList.isEmpty
                  ? const CommonEmpty()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return FeaturedServicesLayout(
                          data: value.serviceList[index],
                          onTap: () {
                            route.pushNamed(context, routeName.serviceDetails,
                                arg: value.serviceList[index]);
                          },
                          onToggle: (val) => value.updateActiveStatusService(
                              context, value.serviceList[index].id, val, index),
                        ).paddingSymmetric(horizontal: Insets.i20);
                      },
                      itemCount: value.serviceList.length,
                    )
        ]);
  }
}
