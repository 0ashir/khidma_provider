import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/address_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../../config.dart';
import '../../../../services/user_services.dart';
import 'category_selection.dart';

class FormCategoryLayout extends StatelessWidget {
  const FormCategoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddNewServiceProvider>(context);
    return Consumer2<UserDataApiProvider, LanguageProvider>(
        builder: (context, userCtrl, lang, child) {
      // log("address.address ::${addressList.last.address}//${addressList.last.area}//");
      return Column(children: [
        ContainerWithTextLayout(
                title: language(context, translations!.selectZone))
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        ZoneDropDownLayout(
            doc: value.zoneIndex,
            icon: eSvgAssets.receiptDiscount,
            hintText: translations!.selectZone,
            isIcon: true,
            zone: zoneList,
            onChanged: (val) {
              value.onChangeZone(context, val);
            }).padding(horizontal: Sizes.s20),
        ContainerWithTextLayout(
                title: "${language(context, translations!.categories)} *")
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        const CategorySelectionLayout().padding(horizontal: Sizes.s20),
/*        ContainerWithTextLayout(
                title: language(context, translations!.applicableCommission))
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        Column(children: [
          Container(
              decoration: ShapeDecoration(
                  color: appColor(context).appTheme.stroke,
                  shape: RoundedRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: AppRadius.r8, cornerSmoothing: 0))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      SvgPicture.asset(eSvgAssets.commission,
                          colorFilter: ColorFilter.mode(
                              appColor(context).appTheme.lightText,
                              BlendMode.srcIn)),
                      const HSpace(Sizes.s10),
                      Text("${value.commission}%",
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.lightText))
                    ]),
                    Text(language(context, translations!.percentage),
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).appTheme.lightText))
                  ]).paddingAll(Insets.i15)),
          const VSpace(Sizes.s2),
          Text(language(context, translations!.noteHighest),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.red))
        ]).paddingSymmetric(horizontal: Insets.i20),*/
        ContainerWithTextLayout(
                title:
                    "${language(context, translations!.perServicemanCommission)} *")
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        TextFieldCommon(
          validator: (name) => validation.serviceNameValidation(context, name),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          focusNode: value.perServicemanCommissionFocus,
          controller: value.perServicemanCommission,
          hintText: translations!.perServicemanCommission!,
          prefixIcon: eSvgAssets.commission,
          inputFormatters: [
            OneDecimalTextInputFormatter(),
          ],
        ).paddingSymmetric(horizontal: Insets.i20),
        ContainerWithTextLayout(title: language(context, "Content*"))
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        Stack(
          children: [
            HtmlEditor(
              controller: value.description,
              htmlEditorOptions: const HtmlEditorOptions(
                hint: "Your text here...",
                shouldEnsureVisible: true,
              ),
              htmlToolbarOptions: const HtmlToolbarOptions(
                toolbarType: ToolbarType.nativeScrollable,
              ),
              otherOptions: const OtherOptions(
                height: 400,
              ),
            ),
            const Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        /* CommonDescriptionBox(
            focusNode: value.descriptionFocus, description: value.description), */
        ContainerWithTextLayout(
                title:
                    "${language(context, translations!.timeForCompletion)} *")
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: TextFieldCommon(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2)
                    ],
                    validator: (name) => validation.dynamicTextValidation(
                        context, name, "Add Service Time"),
                    focusNode: value.durationFocus,
                    controller: value.duration,
                    hintText: translations!.addServiceTime!,
                    prefixIcon: eSvgAssets.timer)),
            const HSpace(Sizes.s6),
            Expanded(
                child: DarkDropDownLayout(
                    svgColor: appColor(context).appTheme.lightText,
                    border: CommonWidgetLayout().noneDecoration(
                        radius: 0, color: appColor(context).appTheme.trans),
                    isBig: true,
                    val: value.durationValue,
                    hintText: translations?.duration,
                    isIcon: false,
                    durationList: appArray.durationList,
                    onChanged: (val) => value.onChangeDuration(val)))
          ]).paddingSymmetric(horizontal: Insets.i20),
        ContainerWithTextLayout(
                title: "${language(context, translations!.selectOption)} *")
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        Column(
                children: appArray.serviceType
                    .asMap()
                    .entries
                    .map((e) => Row(children: [
                          Container(
                              width: Sizes.s20,
                              height: Sizes.s20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: value.serviceOption ==
                                              e.value['val']
                                          ? appColor(context)
                                              .appTheme
                                              .primary
                                              .withOpacity(0.12)
                                          : appColor(context).appTheme.stroke),
                                  color: value.serviceOption == e.value['val']
                                      ? appColor(context)
                                          .appTheme
                                          .primary
                                          .withOpacity(0.12)
                                      : appColor(context).appTheme.whiteBg),
                              child: value.serviceOption == e.value['val']
                                  ? Icon(Icons.circle,
                                      color: appColor(context).appTheme.primary,
                                      size: Sizes.s10)
                                  : null),
                          const HSpace(Sizes.s10),
                          Text(language(context, e.value['title']),
                              style: appCss.dmDenseRegular14.textColor(
                                  value.serviceOption == e.value['val']
                                      ? appColor(context).appTheme.darkText
                                      : appColor(context).appTheme.lightText))
                        ])
                            .marginOnly(
                                bottom: e.key != appArray.serviceType.length - 1
                                    ? Sizes.s20
                                    : 0)
                            .inkWell(
                                onTap: () => value
                                    .onSelectServiceTypeOption(e.value['val'])))
                    .toList())
            .paddingAll(15)
            .boxShapeExtension(
                color: appColor(context).appTheme.whiteBg, radius: 8)
            .paddingSymmetric(horizontal: Insets.i20),
        /* value.serviceOption == "provider_site"
            ? */
        if (value.serviceOption == "provider_site")
          Column(children: [
            ContainerWithTextLayout(
                    title: "${language(context, translations!.location)} *")
                .paddingOnly(top: Insets.i24, bottom: Insets.i12),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.s20, vertical: Sizes.s20),
                decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 8, cornerSmoothing: 1)),
                    color: appColor(context).appTheme.whiteBg),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      value.selectedAddress == null
                          ? Text(language(context, translations!.location),
                              style: appCss.dmDenseMedium14.textColor(
                                  appColor(context).appTheme.lightText))
                          : Expanded(
                              child: Text(
                                  value.selectedAddress!.area != null
                                      ? "${value.selectedAddress!.area} , ${value.selectedAddress!.address}, ${value.selectedAddress!.city}"
                                      : value.selectedAddress!.address != null
                                          ? "${value.selectedAddress!.address}, ${value.selectedAddress!.city}"
                                          : value.selectedAddress!.city != null
                                              ? "${value.selectedAddress!.city}"
                                              : translations!.location!,
                                  /* addressList.isEmpty
                                      ? value.areaData.toString()
                                      : "${addressList.last.area} , ${addressList.last.address}, ${addressList.last.city}"
                                          .toString() */ /* value.areaData.toString() */
                                  style: appCss.dmDenseMedium14.textColor(
                                      appColor(context).appTheme.darkText))),
                      SvgPicture.asset(eSvgAssets.locationOut).inkWell(
                          onTap: () {
                        value.getLocationData(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressListScreen()));
                      } /* value.getLocation(context) */)
                    ]).marginOnly(bottom: Sizes.s10))
          ]) /*   : Container() */,
        ContainerWithTextLayout(
                title: language(context, translations!.faq),
                title2: translations!.addFaq,
                onTap: () => value.addFaq(context))
            .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
            padding: const EdgeInsets.all(Sizes.s15),
            decoration: ShapeDecoration(
                color: appColor(context).appTheme.whiteBg,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 8, cornerSmoothing: 1))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (value.faqList.isNotEmpty)
                    ...value.faqList
                        .asMap()
                        .entries
                        .where((e) =>
                            e.value['question'] != null &&
                            e.value['question'].toString().trim().isNotEmpty &&
                            e.value['answer'] != null &&
                            e.value['answer'].toString().trim().isNotEmpty)
                        .map((e) => Container(
                            margin:
                                const EdgeInsets.symmetric(vertical: Sizes.s8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.s20),
                            decoration: ShapeDecoration(
                                shadows: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: appColor(context)
                                          .appTheme
                                          .darkText
                                          .withOpacity(0.06))
                                ],
                                color: appColor(context).appTheme.fieldCardBg,
                                shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: 8, cornerSmoothing: 1))),
                            child: ExpansionTile(
                                expansionAnimationStyle:
                                    AnimationStyle(curve: Curves.fastOutSlowIn),
                                key: Key(e.key.toString()),
                                // Ensure each key is unique
                                initiallyExpanded: e.key == value.selected,
                                onExpansionChanged: (newState) =>
                                    value.onExpansionChange(newState, e.key),
                                tilePadding: EdgeInsets.zero,
                                collapsedIconColor:
                                    appColor(context).appTheme.darkText,
                                dense: true,
                                iconColor: appColor(context).appTheme.darkText,
                                title: Text("${e.value['question']}",
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).appTheme.darkText)),
                                children: <Widget>[
                                  Divider(
                                    color: appColor(context).appTheme.stroke,
                                    height: .5,
                                    thickness: 0,
                                  ),
                                  ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: Sizes.s5),
                                      title: Text("${e.value['answer']}",
                                          style: appCss.dmDenseLight14
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .darkText
                                                  .withOpacity(.8))))
                                ]))),
                  if (value.faqList.isEmpty)
                    Row(children: [
                      SvgPicture.asset(eSvgAssets.faq,
                          fit: BoxFit.scaleDown,
                          height: Sizes.s20,
                          colorFilter: ColorFilter.mode(
                              appColor(context).appTheme.lightText,
                              BlendMode.srcIn)),
                      const HSpace(Sizes.s15),
                      Text(language(context, translations!.addFaq),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.lightText)),
                    ]).paddingSymmetric(horizontal: Sizes.s5)
                ])),
        if (!isFreelancer)
          ContainerWithTextLayout(
                  title: language(context, translations!.minRequiredServiceman))
              .paddingOnly(top: Insets.i24, bottom: Insets.i12),
        if (!isFreelancer)
          TextFieldCommon(
                  validator: (name) => validation.dynamicTextValidation(context,
                      name, "Please enter the minimum number of servicemen"),
                  keyboardType: TextInputType.number,
                  focusNode: value.minRequiredFocus,
                  controller: value.minRequired,
                  hintText: translations!.addNoOfServiceman!,
                  prefixIcon: eSvgAssets.tagUser)
              .paddingSymmetric(horizontal: Insets.i20)
      ]);
    });
  }
}

class OneDecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) return newValue;

    // Match only numbers with optional 1 digit after decimal
    final regex = RegExp(r'^\d*\.?\d{0,2}$');

    if (regex.hasMatch(text)) {
      return newValue;
    }

    // Reject new input, keep old value
    return oldValue;
  }
}
