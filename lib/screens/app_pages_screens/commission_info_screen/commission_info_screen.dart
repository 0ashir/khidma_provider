import '../../../config.dart';

class CommissionInfoScreen extends StatelessWidget {
  const CommissionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommissionInfoProvider>(builder: (context, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 50), () => value.onReady(context)),
          child: LoadingComponent(
            child: Scaffold(
                appBar: AppBarCommon(title: translations!.commissionInfo),
                body: SingleChildScrollView(
                  child: Column(children: [
                    SearchTextFieldCommon(
                        focusNode: value.searchFocus,
                        controller: value.searchCtrl,
                        onChanged: (v) {
                          if (v.isEmpty) {
                            value.searchList = [];
                            value.notifyListeners();
                          }
                        },
                        onFieldSubmitted: (v) => value.searchCategory(context)),
                    const VSpace(Sizes.s20),
                    if (value.searchCtrl.text.isNotEmpty)
                      ...value.searchList.asMap().entries.map((e) =>
                          CategoriesListLayout(
                              data: e.value,
                              isCommission: true,
                              onTap: () => route.pushNamed(
                                  context, routeName.commissionDetail))),
                    if (value.searchCtrl.text.isEmpty)
                      if (categoryList.isEmpty) const CommonEmpty(),
                    if (categoryList.isNotEmpty)
                      ...categoryList
                          .asMap()
                          .entries
                          .map((e) => CategoriesListLayout(
                              data: e.value,
                              isCommission: true,
                              onTap: () {
                                if (e.value.hasSubCategories != null &&
                                    e.value.hasSubCategories!.isNotEmpty) {
                                  route.pushNamed(
                                      context, routeName.commissionDetail,
                                      arg: e.value);
                                }
                              }))
                  ]).paddingSymmetric(horizontal: Insets.i20),
                )),
          ));
    });
  }
}
