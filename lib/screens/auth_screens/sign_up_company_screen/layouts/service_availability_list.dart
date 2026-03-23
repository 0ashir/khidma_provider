// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, unnecessary_to_list_in_spreads

import 'dart:developer';

import '../../../../config.dart';

class ServiceAvailabilityList extends StatelessWidget {
  final TickerProvider? sync;
  const ServiceAvailabilityList({super.key, this.sync});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SignUpCompanyProvider, CommonApiProvider>(
        builder: (context1, value, api, child) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(language(context, translations!.serviceAvailableArea),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.lightText)),
          Text(language(context, "+${language(context, translations!.add)}"),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.primary))
              .inkWell(
                  onTap: () => route.pushNamed(context, routeName.location,
                          arg: {"radius": value.slider}).then((e) {
                        value.notifyListeners();
                        log("appArray.serviceAvailableAreaList L${appArray.serviceAvailableAreaList}");
                      }))
        ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i10),
        ...appArray.serviceAvailableAreaList
            .asMap()
            .entries
            .map((e) => ServicemanListLayout(
                    addList: e.value,
                    onDelete: () =>
                        value.onLocationDelete(e.key, context, sync),
                    index: e.key,
                    list: appArray.serviceAvailableAreaList)
                .paddingSymmetric(horizontal: Insets.i20))
            .toList()
      ]);
    });
  }
}
