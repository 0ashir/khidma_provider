import 'dart:io';

import '../config.dart';

class NoInternetLayout extends StatefulWidget {
  final Widget child;

  const NoInternetLayout({super.key, required this.child});

  @override
  State<NoInternetLayout> createState() => _NoInternetLayoutState();
}

class _NoInternetLayoutState extends State<NoInternetLayout> {
  Connectivity connectivity = Connectivity();
  bool isInternet = false;

  @override
  void initState() {
    debugPrint("isInternet :$isInternet");
    setState(() {});
    fetchNetwork();
    super.initState();
  }

  fetchNetwork() async {
    isInternet = await isNetworkConnection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result.contains(ConnectivityResult.none)) {
        isInternet = false;
        setState(() {});
      } else if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        isInternet = true;
        //setState(() {});
      } else {
        final result = await InternetAddress.lookup(
            'google.com'); //Check For Internet Connection
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isInternet = true;
        } else {
          isInternet = false;
        }
        setState(() {});
      }
    });
    return Stack(
      children: [
        widget.child,
        if (!isInternet)
          Consumer<NoInternetProvider>(builder: (context1, value, child) {
            return Scaffold(
              body: EmptyLayout(
                  isButton: false,
                  title: translations!.oopsYour,
                  subtitle: translations!.clickTheRefresh,
                  buttonText: translations!.refresh,
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
                            left: MediaQuery.of(context).size.height * 0.055,
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
                                              curve: Curves.elasticInOut))
                                          .animate(value.animationController!),
                                      child: Image.asset(eImageAssets.caution,
                                          height: Sizes.s30, width: Sizes.s30)))
                            ]))
                  ])),
            );
          })
      ],
    );
  }
}
