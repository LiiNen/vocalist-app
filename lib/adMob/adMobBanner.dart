import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdMobBanner extends StatefulWidget {
  @override
  State<AdMobBanner> createState() => _AdMobBanner();
}
class _AdMobBanner extends State<AdMobBanner> {
  // late BannerAd _ad;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _ad = BannerAd(
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {},
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _ad.load();
  // }
  //
  // @override
  // void dispose() {
  //   _ad.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: AdWidget(ad: _ad),
      child: Text('ads'),
      width: MediaQuery.of(context).size.width,
      height: 48,
      alignment: Alignment.center,
    );
  }
}