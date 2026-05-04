import '../../../config.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  // defining the Offset of the animation
  Animation<Offset>? _offsetAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);

    _offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.1, 0.0))
            .animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));
    // _initializeIAP();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionPlanProvider>(builder: (context, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              if (didPop) return;
              route.pushReplacementNamed(context, routeName.dashboard);
            },
            child: Scaffold(
                body: Stack(children: [
              Stack(alignment: Alignment.bottomCenter, children: [
                SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(alignment: Alignment.topCenter, children: [
                          SizedBox(
                                  height: Sizes.s250,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                            height: Sizes.s150,
                                            width: Sizes.s150,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xffad96ff),
                                                      blurRadius: 100)
                                                ])),
                                        Image.asset(eImageAssets.planBoy,
                                            height: Sizes.s250,
                                            width: Sizes.s300)
                                      ]))
                              .paddingOnly(
                                  top: MediaQuery.of(context).size.height / 7.8)
                        ]))
                    .decorated(
                        gradient: LinearGradient(colors: [
                  Color(0xFF8054FF),
                  appColor(context).appTheme.primary,
                  Color(0xFF4154FF)
                ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
                SubscriptionPlanLayout(
                    position: _offsetAnimation!,
                    data: value.subscriptionPlanModel)
              ]),
              Align(
                alignment: Alignment.topRight,
                child: CommonArrow(
                        onTap: () => route.pushReplacementNamed(
                            context, routeName.planDetails),
                        arrow: eSvgAssets.cross,
                        svgColor: appColor(context).appTheme.whiteColor,
                        color: appColor(context)
                            .appTheme
                            .whiteColor
                            .withOpacity(0.3))
                    .paddingSymmetric(
                        vertical: Insets.i40, horizontal: Insets.i20),
              )
            ])),
          ));
    });
  }
}
