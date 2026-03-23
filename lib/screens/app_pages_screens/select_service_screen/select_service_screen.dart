// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import '../../../config.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SelectServiceProvider, UserDataApiProvider>(
        builder: (context1, value, userApi, child) {
      return Scaffold(
          bottomNavigationBar: ButtonCommon(
                  title: translations!.addService,
                  onTap: () => route.pop(context))
              .paddingOnly(
                  bottom: Insets.i15,
                  top: Insets.i15,
                  left: Insets.i20,
                  right: Insets.i20),
          appBar: AppBarCommon(title: translations!.selectServiceOnly),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(language(context, translations!.selectedService),
                        style: appCss.dmDenseRegular14
                            .textColor(appColor(context).appTheme.lightText))
                    .paddingSymmetric(horizontal: Insets.i20),
                const VSpace(Sizes.s15),
                value.selectServiceList.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: value.selectServiceList
                                      .asMap()
                                      .entries
                                      .map((e) => SelectServiceLayout(
                                          onTapCross: () =>
                                              value.onImageRemove(e.key),
                                          data: e.value))
                                      .toList())
                              .padding(left: Insets.i20, vertical: Insets.i15),
                        ).decorated(
                            color: appColor(context).appTheme.fieldCardBg))
                    : AddNewBoxLayout(
                            title: translations!.addNewService,
                            width: MediaQuery.of(context).size.width)
                        .paddingSymmetric(
                            horizontal: Insets.i20, vertical: Insets.i15)
                        .decorated(
                            color: appColor(context).appTheme.fieldCardBg)
                        .inkWell(
                            onTap: () => route.pushNamed(
                                context, routeName.addNewService)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SearchTextFieldCommon(
                      controller: value.searchCtrl,
                      focusNode: value.searchFocus,
                      onChanged: (v) {
                        if (v.isEmpty) {
                          userApi.getAllServiceList();
                          userApi.notifyListeners();
                        } else if (v.length > 2) {
                          userApi.getAllServiceList(
                              search: value.searchCtrl.text);
                        }
                        /* if (v.isEmpty) {
                          userApi.getAllServiceList();
                          userApi.notifyListeners();a
                        } */
                      },
                      onFieldSubmitted: (v) =>
                          userApi.getAllServiceList(search: v)),
                  Text(language(context, translations!.serviceList),
                          style: appCss.dmDenseRegular14
                              .textColor(appColor(context).appTheme.lightText))
                      .paddingSymmetric(vertical: Insets.i15),
                  ...allServiceList.asMap().entries.map((e) => SelectListLayout(
                          data: e.value,
                          selectedCategory: value.selectServiceList,
                          onTap: () => value.onSelectService(
                              context, e.value.id, e.value, e.key)).inkWell(
                        onTap: () => value.onSelectService(
                            context, e.value.id, e.value, e.key),
                      )),
                  /*     ButtonCommon(
                          title: translations!.addService,
                          onTap: () => route.pop(context))
                      .paddingOnly(bottom: Insets.i15, top: Insets.i15) */
                ]).paddingSymmetric(
                    vertical: Insets.i25, horizontal: Insets.i20)
              ])));
    });
  }
}
