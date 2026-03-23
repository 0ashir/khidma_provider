import 'package:fixit_provider/screens/app_pages_screens/provider_chat_screen/provider_chat_layout.dart';
import 'package:flutter/services.dart';
import '../../../config.dart';
import '../../../providers/app_pages_provider/offer_chat_provider.dart';
import '../add_new_service_screen/layouts/category_selection.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferChatProvider>(builder: (context, offerCtrl, child) {
      return StatefulWrapper(
        onInit: () {},
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                centerTitle: true,
                leadingWidth: Sizes.s80,
                leading: CommonArrow(
                    arrow: rtl(context)
                        ? eSvgAssets.arrowRight
                        : eSvgAssets.arrowLeft,
                    onTap: () => route.pop(context)).padding(all: Sizes.s7),
                title: Text(language(context, appFonts.addOffer),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText))),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const FieldsBackground(),
                      Form(
                        key: offerCtrl.addOffer,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const VSpace(Sizes.s20),
                              ProviderChatLayout().txtWithTextField(context,
                                  controller: offerCtrl.titleCtrl,
                                  title: appFonts.title,
                                  hintText: appFonts.write,
                                  svg: eSvgAssets.email),
                              const VSpace(Sizes.s16),
                              ContainerWithTextLayout(
                                  title:
                                      language(context, appFonts.chargesTitle)),
                              const VSpace(Sizes.s8),
                              Stack(children: [
                                TextFieldCommon(
                                    focusNode: offerCtrl.descriptionFocus,
                                    isNumber: true,
                                    controller: offerCtrl.descriptionCtrl,
                                    hintText: appFonts.writeANote,
                                    validator: (value) =>
                                        validation.dynamicTextValidation(
                                            context,
                                            value,
                                            appFonts.enterDescription),
                                    maxLines: 3,
                                    minLines: 3,
                                    isMaxLine: true),
                                SvgPicture.asset(eSvgAssets.details,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: ColorFilter.mode(
                                            !offerCtrl.descriptionFocus.hasFocus
                                                ? offerCtrl.descriptionCtrl.text
                                                        .isNotEmpty
                                                    ? appColor(context)
                                                        .appTheme
                                                        .darkText
                                                    : appColor(context)
                                                        .appTheme
                                                        .lightText
                                                : appColor(context)
                                                    .appTheme
                                                    .darkText,
                                            BlendMode.srcIn))
                                    .paddingOnly(
                                        left: rtl(context) ? 0 : Insets.i15,
                                        right: rtl(context) ? Insets.i15 : 0,
                                        top: Insets.i13)
                              ])
                                  .padding(all: Sizes.s2)
                                  .decorated(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s10),
                                      border: Border.all(
                                          color: appColor(context)
                                              .appTheme
                                              .stroke))
                                  .paddingDirectional(horizontal: Sizes.s20),
                              const VSpace(Sizes.s16),
                              ProviderChatLayout().txtWithTextField(context,
                                  controller: offerCtrl.priceCtrl,
                                  title: appFonts.amount,
                                  keyboardType: TextInputType.number,
                                  hintText: appFonts.enterAmount,
                                  svg: eSvgAssets.dollar),
                              const VSpace(Sizes.s16),
                              ContainerWithTextLayout(
                                  title: language(context, appFonts.duration)),
                              Row(children: [
                                Expanded(
                                    flex: 1,
                                    child: TextFieldCommon(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(Sizes.s8),
                                            borderSide: BorderSide(
                                                color: appColor(context)
                                                    .appTheme
                                                    .stroke)),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[1-9]")),
                                        ],
                                        focusNode: offerCtrl.durationFocus,
                                        controller: offerCtrl.durationCtrl,
                                        hintText: appFonts.addServiceTime,
                                        prefixIcon: eSvgAssets.timer)),
                                const HSpace(Sizes.s6),
                                Expanded(
                                    child: DarkDropDownLayout(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(Sizes.s8),
                                            borderSide: BorderSide(
                                                color: appColor(context)
                                                    .appTheme
                                                    .trans)),
                                        isBig: true,
                                        val: offerCtrl.durationValue,
                                        hintText: appFonts.hour,
                                        isIcon: false,
                                        durationList: appArray.durationList,
                                        onChanged: (val) =>
                                            offerCtrl.onChangeDuration(val)))
                              ]).paddingDirectional(
                                horizontal: Sizes.s20,
                              ),
                              const VSpace(Sizes.s16),
                              Row(children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      ContainerWithTextLayout(
                                          title: language(
                                              context, appFonts.startDate)),
                                      VSpace(Sizes.s10),
                                      TextFieldCommon(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: appColor(context)
                                                          .appTheme
                                                          .stroke),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Sizes.s8)),
                                              isEnable: false,
                                              focusNode:
                                                  offerCtrl.startDateFocus,
                                              controller:
                                                  offerCtrl.startDateCtrl,
                                              style: appCss.dmDenseMedium13
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText),
                                              validator: (value) =>
                                                  validation.dynamicTextValidation(
                                                      context,
                                                      value,
                                                      appFonts
                                                          .pleaseSelectStartDate),
                                              hintText: appFonts.startDate,
                                              prefixIcon: eSvgAssets.calender)
                                          .inkWell(
                                              onTap: () =>
                                                  offerCtrl.onDateSelect(context, offerCtrl.startDateCtrl.text))
                                          .paddingOnly(left: Sizes.s15)
                                    ])),
                                const HSpace(Sizes.s15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      ContainerWithTextLayout(
                                          title: language(
                                              context, appFonts.endDate)),
                                      VSpace(Sizes.s10),
                                      TextFieldCommon(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: appColor(context)
                                                          .appTheme
                                                          .stroke)),
                                              isEnable: false,
                                              focusNode: offerCtrl.endDateFocus,
                                              controller: offerCtrl.endDateCtrl,
                                              hintText: appFonts.endDate,
                                              style: appCss.dmDenseMedium13
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText),
                                              validator: (value) => validation
                                                  .dynamicTextValidation(
                                                      context,
                                                      value,
                                                      appFonts
                                                          .pleaseSelectEndDate),
                                              prefixIcon: eSvgAssets.calender)
                                          .inkWell(
                                              onTap: () =>
                                                  offerCtrl.onDateSelect(
                                                      context,
                                                      offerCtrl
                                                          .endDateCtrl.text))
                                          .paddingOnly(right: Sizes.s15)
                                    ]))
                              ]),
                              ContainerWithTextLayout(
                                      title: language(
                                          context, appFonts.categories))
                                  .paddingOnly(
                                      top: Insets.i24, bottom: Insets.i12),
                              const CategorySelectionLayout(isOffer: true)
                                  .paddingDirectional(horizontal: Sizes.s20),
                              const VSpace(Sizes.s16),
                              Row(children: [
                                CheckBoxCommon(
                                    isCheck: offerCtrl.isCheck,
                                    onTap: () => offerCtrl.checkBox()),
                                const HSpace(Sizes.s10),
                                Text(
                                    language(context,
                                        appFonts.isServiceStaffRequired),
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).appTheme.darkText))
                              ]).paddingDirectional(horizontal: Sizes.s20),
                              if (offerCtrl.isCheck) const VSpace(Sizes.s18),
                              if (offerCtrl.isCheck)
                                ProviderChatLayout()
                                    .txtWithTextFieldWithoutValidation(context,
                                        controller: offerCtrl.servicemenCtrl,
                                        title: appFonts.requiredServiceman,
                                        hintText: appFonts.write,
                                        svg: eSvgAssets.box),
                              // const VSpace(Sizes.s40),
                            ]).padding(bottom: Sizes.s30),
                      ),
                    ],
                  ).paddingDirectional(horizontal: Sizes.s20),
                  ButtonCommon(
                    title: appFonts.bookAdSpace,
                    onTap: () {
                      offerCtrl.saveOfferInChatInFirebase(
                        context,
                      );
                    },
                  ).paddingDirectional(
                      horizontal: Sizes.s20, vertical: Sizes.s30)
                ],
              ),
            )),
      );
    });
  }
}
