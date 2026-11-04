import 'package:edemand_partner/app/generalImports.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  _BannerAdContainer createState() => _BannerAdContainer();
}

class _BannerAdContainer extends State<BannerAdWidget> {
  BannerAd? _googleBannerAd;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  @override
  void dispose() {
    _googleBannerAd?.dispose();

    super.dispose();
  }

  void _initBannerAd() {
    Future.delayed(Duration.zero, () {
      final systemConfigCubit = context.read<FetchSystemSettingsCubit>();
      if (systemConfigCubit.isAdBannerEnabled) {
        _createGoogleBannerAd();
      }
    });
  }

  Future<void> _createGoogleBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );

    if (size == null) {
      return;
    }

    final BannerAd banner = BannerAd(
      request: const AdRequest(),
      adUnitId: context.read<FetchSystemSettingsCubit>().bannerAdId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _googleBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
      ),
      size: size,
    );
    banner.load();
  }

  @override
  Widget build(BuildContext context) {
    final sysConfig = context.read<FetchSystemSettingsCubit>();
    if (sysConfig.isAdBannerEnabled) {
      return _googleBannerAd != null
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: _googleBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _googleBannerAd!),
            )
          : const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }
}
