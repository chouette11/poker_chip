import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key, required this.width, required this.height})
      : super(key: key);
  final double width;
  final double height;

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _ad;

  @override
  void initState() {
    super.initState();
    final AdSize adSize = AdSize(width: widget.width.toInt(), height: widget.height.toInt());

    _ad = BannerAd(
        adUnitId: unitId(AdState.bannerAdUnitId),
        size: adSize,
        request: const AdRequest(),
        listener: AdState.bannerListener);

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (_ad == null) {
      return const SizedBox(height: 50);
    } else {
      return SizedBox(
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        child: AdWidget(ad: _ad),
      );
    }
  }
}

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3443545166967285/5702486847';

  static final BannerAdListener bannerListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}

String unitId(String adUnitId) {
  var isRelease = const bool.fromEnvironment('dart.vm.product');

  if (isRelease) {
    return adUnitId;
  } else {
    return "ca-app-pub-3940256099942544/6300978111";
  }
}