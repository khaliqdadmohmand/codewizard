import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsUtil {
  int maxFailedLoadAttempts = 3;
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-1515414180407628/2660154406'
            : 'ca-app-pub-1515414180407628/3497813101',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  showInterstitialAd(Function callback) {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      callback();
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        print("hello world");
        ad.dispose();
        createInterstitialAd();
        callback();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
        callback();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }
}
