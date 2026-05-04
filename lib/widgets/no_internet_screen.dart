import '../config.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoInternetProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 50), () => value.onAnimate(this)),
          child: Scaffold(
              appBar: const AppBarCommon(title: ""),
              body: EmptyLayout(
                  title: translations!.oopsYour,
                  subtitle: translations!.clickTheRefresh,
                  buttonText: translations!.refresh,
                  isButton: true,
                  bTap: () {
                    value.animationController!.dispose();
                    route.pushReplacementNamed(context, routeName.splash);
                  },
                  widget: Stack(children: [
                    Image.asset(
                        isFreelancer
                            ? eImageAssets.noInternetFree
                            : eImageAssets.notiBoy,
                        height: Sizes.s346),
                    if (isFreelancer != true)
                      if (value.animationController != null)
                        Positioned(
                            top: MediaQuery.of(context).size.height * 0.03,
                            left: MediaQuery.of(context).size.height * 0.02,
                            child:
                                Stack(alignment: Alignment.topRight, children: [
                              Image.asset(eImageAssets.wifi,
                                      height: Sizes.s40, width: Sizes.s40)
                                  .paddingOnly(top: Insets.i12),
                              Positioned(
                                  bottom: 17,
                                  left: 12,
                                  child: RotationTransition(
                                      turns: Tween(begin: 0.05, end: -.1)
                                          .chain(CurveTween(
                                              curve: Curves.easeInOutCubic))
                                          .animate(value.animationController!),
                                      child: Image.asset(eImageAssets.caution,
                                          height: Sizes.s30, width: Sizes.s30)))
                            ]))
                  ]))));
    });
  }
}
