import '../../../config.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesListProvider>(builder: (context1, value, child) {
      return Scaffold(
          appBar: AppBar(
              leadingWidth: 80,
              title: Text(language(context, translations!.categories),
                  style: appCss.dmDenseBold18
                      .textColor(appColor(context).appTheme.darkText)),
              centerTitle: true,
              leading: CommonArrow(
                  arrow: rtl(context)
                      ? eSvgAssets.arrowRight
                      : eSvgAssets.arrowLeft,
                  onTap: () => route.pop(context)).paddingAll(Insets.i8),
              actions: [
                if (categoryList.isNotEmpty)
                  CommonArrow(
                          arrow: value.isGrid
                              ? eSvgAssets.list
                              : eSvgAssets.category,
                          onTap: () => value.onGrid())
                      .paddingOnly(
                          left: rtl(context) ? Insets.i20 : 0,
                          right: rtl(context) ? 0 : Insets.i20)
              ]),
          body: SingleChildScrollView(
              child: Column(children: [
            if (categoryList.isNotEmpty)
              SearchTextFieldCommon(
                focusNode: value.searchFocus,
                onChanged: (v) {
                  if (v.isEmpty) {
                    value.searchCategory(context, value.searchCtrl.text);
                  }
                  if (v.length > 2) {
                    value.searchCategory(context, value.searchCtrl.text);
                  }
                },
                onFieldSubmitted: (v) => value.searchCategory(context, v),
                controller: value.searchCtrl,
              ),
            const VSpace(Sizes.s20),
            value.isGrid
                ? const CategoriesGridList()
                : value.searchCtrl.text.isNotEmpty
                    ? Column(
                        children: value.searchList
                            .asMap()
                            .entries
                            .map((e) => CategoriesListLayout(
                                data: e.value,
                                onTap: () => route.pushNamed(
                                    context, routeName.serviceList,
                                    arg: e.value.id)))
                            .toList())
                    : categoryList.isEmpty
                        ? const CommonEmpty()
                        : Column(
                            children: categoryList
                                .asMap()
                                .entries
                                .map((e) => CategoriesListLayout(
                                    data: e.value,
                                    onTap: () => route.pushNamed(
                                        context, routeName.serviceList,
                                        arg: e.value.id)))
                                .toList())
          ]).paddingAll(Insets.i20)));
    });
  }
}
