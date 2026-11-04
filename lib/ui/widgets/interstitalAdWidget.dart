import 'package:edemand_partner/app/generalImports.dart';

class InterstitialAdWidget extends StatelessWidget {
  final Widget child;

  const InterstitialAdWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InterstitialAdCubit>(
      create: (context) => InterstitialAdCubit(),
      child: InterstitialAds(child: child),
    );
  }
}

class InterstitialAds extends StatefulWidget {
  final Widget child;

  const InterstitialAds({super.key, required this.child});

  @override
  State<InterstitialAds> createState() => _InterstitialAd();
}

class _InterstitialAd extends State<InterstitialAds> {
  @override
  void initState() {
    context.read<InterstitialAdCubit>().loadInterstitialAd(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        context.read<InterstitialAdCubit>().showAd(context);
      },
      child: widget.child,
    );
  }
}
