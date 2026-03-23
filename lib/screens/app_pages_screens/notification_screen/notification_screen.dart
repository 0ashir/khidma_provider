import 'dart:developer';

import '../../../config.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context1, value, child) {
      log("value.notificationList::${value.notificationList}");
      return StatefulWrapper(
          onInit: () => Future.delayed(Durations.short3)
              .then((_) => value.onAnimate(this, context)),
          child: Scaffold(
              appBar: AppBar(
                  leadingWidth: 80,
                  title: Text(language(context, translations!.notification),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).appTheme.darkText)),
                  centerTitle: true,
                  leading: CommonArrow(
                      arrow: rtl(context)
                          ? eSvgAssets.arrowRight
                          : eSvgAssets.arrowLeft,
                      onTap: () => route.pop(context)).paddingAll(Insets.i8),
                  actions: [
                    if (value.notificationList.isNotEmpty)
                      CommonArrow(arrow: eSvgAssets.readAll),
                    const HSpace(Sizes.s10),
                    if (value.notificationList.isNotEmpty)
                      CommonArrow(
                              onTap: () =>
                                  value.onDeleteNotification(context, this),
                              arrow: eSvgAssets.delete,
                              svgColor: appColor(context).appTheme.red,
                              color: appColor(context)
                                  .appTheme
                                  .red
                                  .withOpacity(0.1))
                          .paddingOnly(
                              right: rtl(context) ? 0 : Insets.i20,
                              left: rtl(context) ? Insets.i20 : 0)
                  ]),
              body: notificationList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                              children: notificationList
                                  .asMap()
                                  .entries
                                  .map((e) => NotificationLayout(data: e.value, onTap: () => value.onTap(e.value, context)))
                                  .toList())
                          .paddingAll(Insets.i20))
                  : EmptyLayout(
                      isButton: false,
                      title: translations!.nothingHere,
                      subtitle: translations!.clickTheRefresh,
                      buttonText: translations!.refresh,
                      bTap: () => value.onRefresh(context),
                      widget: Stack(children: [
                        Image.asset(eImageAssets.notiBoy, height: Sizes.s346),
                        if (value.animationController != null)
                          Positioned(
                              top: MediaQuery.of(context).size.height * 0.04,
                              left: MediaQuery.of(context).size.height * 0.01,
                              child: RotationTransition(
                                  turns: Tween(begin: 0.05, end: -.1)
                                      .chain(CurveTween(
                                          curve: Curves.elasticInOut))
                                      .animate(value.animationController!),
                                  child: Image.asset(
                                      eImageAssets.notificationBell,
                                      height: Sizes.s40,
                                      width: Sizes.s40)))
                      ]))));
    });
  }
}
