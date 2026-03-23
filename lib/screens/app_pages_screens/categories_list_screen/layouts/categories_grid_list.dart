import 'dart:developer';

import '../../../../config.dart';

class CategoriesGridList extends StatelessWidget {
  const CategoriesGridList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesListProvider>(builder: (context1, value, child) {
      log("categoryList::${categoryList}");
      return categoryList.isEmpty
          ? const CommonEmpty()
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: value.searchCtrl.text.isNotEmpty
                  ? value.searchList.length
                  : categoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: Sizes.s110,
                  mainAxisSpacing: Sizes.s10,
                  crossAxisSpacing: Sizes.s10),
              itemBuilder: (context, index) {
                // Top Categories lists
                return TopCategoriesLayout(
                    index: index,
                    isCategories: true,
                    selectedIndex: value.selectedIndex,
                    data: value.searchCtrl.text.isNotEmpty
                        ? value.searchList[index]
                        : categoryList[index],
                    onTap: () => route.pushNamed(context, routeName.serviceList,
                        arg: value.searchCtrl.text.isNotEmpty
                            ? value.searchList[index].id
                            : categoryList[index].id));
              });
    });
  }
}
