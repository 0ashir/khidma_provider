import 'dart:developer';
import '../../../config.dart';
import '../../../providers/app_pages_provider/offer_chat_provider.dart';

class ProviderChatScreen extends StatelessWidget {
  const ProviderChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferChatProvider>(builder: (context1, value, child) {
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
              onInit: () => Future.delayed(const Duration(milliseconds: 50),
                  () => value.onReady(context)),
              child: LoadingComponent(
                  child: Scaffold(
                      body: Column(children: [
                ChatAppBarLayout(
                    onSelected: (index) {
                      log("SE :$index");
                      if (index == 1) {
                        value.onClearChat(context, this);
                      } else {
                        value.onTapPhone(context);
                      }
                    },
                    isOffer: true),
                Expanded(
                    child: ListView(
                  reverse: true,
                  children: [
                    value.timeLayout(context)
                    ],
                )),
                Row(children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                                minLines: 1,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: value.controller,
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText),
                                cursorColor:
                                    appColor(context).appTheme.darkText,
                                decoration: InputDecoration(
                                    fillColor:
                                        appColor(context).appTheme.whiteBg,
                                    filled: true,
                                    isDense: true,
                                    disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(AppRadius.r30)),
                                        borderSide: BorderSide.none),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(AppRadius.r30)),
                                        borderSide: BorderSide.none),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(AppRadius.r30)),
                                        borderSide: BorderSide.none),
                                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.r30)), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: Insets.i15, vertical: Insets.i15),
                                    prefixIcon: SvgPicture.asset(eSvgAssets.gallery, colorFilter: ColorFilter.mode(appColor(context).appTheme.lightText, BlendMode.srcIn)).padding(right: Sizes.s15, left: Sizes.s8).inkWell(onTap: () => value.showLayout(context1)),
                                    hintStyle: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.lightText),
                                    hintText: language(context, appFonts.writeHere),
                                    errorMaxLines: 2))),

                        const HSpace(Sizes.s10),
                        // Send button
                        SizedBox(
                                child: SvgPicture.asset(
                          eSvgAssets.send,
                          colorFilter: ColorFilter.mode(
                              appColor(context).appTheme.primary,
                              BlendMode.srcIn),
                        ).paddingAll(Insets.i8))
                            .decorated(
                                color: appColor(context)
                                    .appTheme
                                    .primary
                                    .withValues(alpha: .15),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppRadius.r30)))
                            .inkWell(onTap: () {
                          if (value.controller.text != '') {
                            value.setMessage(value.controller.text,
                                MessageType.text, context);
                          }
                        }),
                      ],
                    ).padding(horizontal: Sizes.s6).decorated(
                        color: appColor(context).appTheme.whiteBg,
                        boxShadow: [
                          BoxShadow(
                              color: appColor(context)
                                  .appTheme
                                  .darkText
                                  .withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                        borderRadius: const BorderRadius.all(Radius.circular(
                            AppRadius
                                .r30))) /*  .boxBorderExtension(context, isShadow: true, radius: 30)*/,
                  ),
                  // Text Field
                  const HSpace(Sizes.s8),

                  SizedBox(
                          child: SvgPicture.asset(eSvgAssets.add,
                                  fit: BoxFit.fill,
                                  colorFilter: ColorFilter.mode(
                                      appColor(context).appTheme.whiteColor,
                                      BlendMode.srcIn))
                              .paddingAll(Insets.i9))
                      .decorated(
                          color: appColor(context).appTheme.primary,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppRadius.r30)))
                      .inkWell(onTap: () {
                    value.titleCtrl.clear();
                    value.descriptionCtrl.clear();
                    value.controller.clear();
                    value.categories.clear();
                    value.categoryCtrl.clear();
                    value.endDateCtrl.clear();
                    value.startDateCtrl.clear();
                    value.priceCtrl.clear();
                    value.durationValue = null;
                    value.durationCtrl.clear();
                    value.startDateCtrl.clear();
                    value.endDateCtrl.clear();
                    route.pushNamed(context, routeName.offerScreen);
                  }),
                ]).padding(horizontal: Sizes.s20, bottom: Sizes.s20)
              ])))));
    });
  }
}
