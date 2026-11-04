import 'package:edemand_partner/app/generalImports.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class InterstitialAdState {}

class InterstitialAdInitial extends InterstitialAdState {}

class InterstitialAdLoaded extends InterstitialAdState {}

class InterstitialAdLoadInProgress extends InterstitialAdState {}

class InterstitialAdFailToLoad extends InterstitialAdState {}

class InterstitialAdCubit extends Cubit<InterstitialAdState> {
  InterstitialAdCubit() : super(InterstitialAdInitial());

  InterstitialAd? _interstitialAd;

  InterstitialAd? get interstitialAd => _interstitialAd;

  void _createGoogleInterstitialAd(BuildContext context) {
    InterstitialAd.load(
      adUnitId: context.read<FetchSystemSettingsCubit>().interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          emit(InterstitialAdLoaded());
        },
        onAdFailedToLoad: (err) {
          emit(InterstitialAdFailToLoad());
        },
      ),
    );
  }

  void loadInterstitialAd(BuildContext context) {
    final systemConfigCubit = context.read<FetchSystemSettingsCubit>();
    if (systemConfigCubit.isAdBannerEnabled) {
      emit(InterstitialAdLoadInProgress());

      _createGoogleInterstitialAd(context);
    }
  }

  Future<void> showAd(BuildContext context, [Function()? callback]) async {
    final sysConfigCubit = context.read<FetchSystemSettingsCubit>();
    if (sysConfigCubit.isAdBannerEnabled) {
      if (state is InterstitialAdLoaded) {
        interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {
            if (callback != null) {
              callback.call();
            }
          },
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError error) {
                ad.dispose();
              },
        );
        interstitialAd?.show();
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      } else if (state is InterstitialAdFailToLoad) {
        loadInterstitialAd(context);
      }
    }
  }

  @override
  Future<void> close() async {
    _interstitialAd?.dispose();

    return super.close();
  }
}
