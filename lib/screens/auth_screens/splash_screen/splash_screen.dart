import 'dart:developer';
import '../../../config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    final SplashProvider splash =
        Provider.of<SplashProvider>(context, listen: false);
    // splash.getAppSettingList(context);
    splash.onReady(this, context);
    // final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    // commonApi.selfApi(context);
    log("message12");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splash, child) {
      return Scaffold(
          body: Stack(alignment: Alignment.center, children: [
        Container(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.7),
            width: double.infinity,
            height: double.infinity,
            child: Opacity(
                opacity: 0.15,
                child: Image.asset(eImageAssets.splashBg, fit: BoxFit.cover))),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const VSpace(Sizes.s15),
          Text(appFonts.fixit,
              style: appCss.outfitSemiBold45
                  .textColor(appColor(context).appTheme.whiteColor))
        ])
      ]));
    });
  }
}
