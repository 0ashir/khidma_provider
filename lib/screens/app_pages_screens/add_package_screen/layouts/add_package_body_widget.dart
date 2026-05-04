import 'dart:developer';

import '../../../../config.dart';

class AddPackageBodyWidget extends StatelessWidget {
  const AddPackageBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LanguageProvider, AddPackageProvider,
            SelectServiceProvider>(
        builder: (context1, languageCtrl, value, selectVal, child) {
      return SingleChildScrollView(
          child: Form(
        key: value.addPackageFormKey,
        child: Column(children: [
          /* value.isEdit
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...languageCtrl.languageList.asMap().entries.map((e) {
                        int index = e.key;
                        bool isSelected =
                            languageCtrl.addSelectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            languageCtrl.setSelectedIndex(
                                index, e.value.locale.toString());
                            log("Selected Language: ${languageCtrl.selectedLocaleService}");
                            // Save the selected language persistently
                            languageCtrl.sharedPreferences.setString(
                                "selectedLocaleService",
                                e.value.locale.toString());
                            value.getServiceDetails(context);
                            // Notify listeners to update the UI
                            languageCtrl.notifyListeners();
                          },
                          child: Row(children: [
                            Container(
                                height: Sizes.s16,
                                width: Sizes.s24,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            e.value.flag.toString())))),
                            const HSpace(Sizes.s6),
                            Text(e.value.name.toString(),
                                style: appCss.dmDenseRegular14.textColor(
                                    isSelected
                                        ? appColor(context)
                                            .appTheme
                                            .whiteColor // Change color when selected
                                        : appColor(context).appTheme.darkText))
                          ])
                              .padding(
                                  vertical: Sizes.s11, horizontal: Sizes.s15)
                              .decorated(
                                color: isSelected
                                    ? appColor(context)
                                        .appTheme
                                        .primary // Highlight border
                                    : appColor(context).appTheme.whiteBg,
                                border: Border.all(
                                  color: appColor(context).appTheme.stroke,
                                ),
                                borderRadius: BorderRadius.circular(Sizes.s8),
                              )
                              .padding(horizontal: Sizes.s5, bottom: Sizes.s15),
                        );
                      })
                    ],
                  ))
              : SizedBox(), */
          Stack(children: [
            const FieldsBackground(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ContainerWithTextLayout(
                  title: language(context,
                      "${translations!.packageName} (${languageCtrl.selectedLocaleService})")),
              const VSpace(Sizes.s8),
              TextFieldCommon(
                      focusNode: value.packageFocus,
                      controller: value.packageCtrl,
                      validator: (value) => validation.dynamicTextValidation(
                          context, value, translations!.enterPackageName),
                      hintText:
                          language(context, translations!.enterPackageName),
                      prefixIcon: eSvgAssets.packageName)
                  .padding(horizontal: Insets.i20, bottom: Insets.i15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  const SmallContainer(),
                  const HSpace(Sizes.s20),
                  Text(language(context, translations!.selectServiceOnly),
                          //overflow: TextOverflow.ellipsis,
                          style: appCss.dmDenseSemiBold14
                              .textColor(appColor(context).appTheme.darkText))
                      .width(Sizes.s120)
                ]),
                if (selectVal.selectServiceList.isNotEmpty)
                  Text(language(context, translations!.editService),
                          textAlign:
                              rtl(context) ? TextAlign.end : TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).appTheme.primary))
                      .inkWell(
                          onTap: () =>
                              route.pushNamed(context, routeName.selectService))
                      .paddingSymmetric(horizontal: Insets.i20)
              ]),
              const VSpace(Sizes.s15),
              selectVal.selectServiceList.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                              children: selectVal.selectServiceList
                                  .asMap()
                                  .entries
                                  .map((e) => SelectServiceLayout(
                                      onTapCross: () =>
                                          selectVal.onImageRemove(e.key),
                                      data: e.value))
                                  .toList())
                          .paddingOnly(
                              left: rtl(context) ? 0 : Insets.i20,
                              right: rtl(context) ? Insets.i20 : 0))
                  : AddNewBoxLayout(
                          title: translations!.addNew,
                          onAdd: () =>
                              route.pushNamed(context, routeName.selectService))
                      .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s20),
              const PackageDescriptionForm()
            ]).paddingSymmetric(vertical: Insets.i20)
          ]),
          ButtonCommon(
                  title: value.isEdit
                      ? translations!.updatePackage
                      : translations!.addPackage,
                  onTap: () => value.addData(context))
              .paddingOnly(top: Insets.i40, bottom: Insets.i30)
        ]).paddingSymmetric(horizontal: Insets.i20),
      ));
    });
  }
}
