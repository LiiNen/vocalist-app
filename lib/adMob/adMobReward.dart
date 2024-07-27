// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:vocalist/collections/function.dart';
//
// import 'adMobHelper.dart';
//
// RewardedAd? _rewardedAd;
// int _numRewardedLoadAttempts = 0;
// int _maxLoadAttempts = 3;
//
// initAdMobRewarded() async {
//   await RewardedAd.load(
//     adUnitId: AdHelper.rewardedAdUnitId,
//     request: AdRequest(),
//     rewardedAdLoadCallback: RewardedAdLoadCallback(
//       onAdLoaded: (RewardedAd ad) {
//         _rewardedAd = ad;
//         _numRewardedLoadAttempts = 0;
//       },
//       onAdFailedToLoad: (LoadAdError error) {
//         print('RewardedAd failed to load: $error');
//         _rewardedAd = null;
//         _numRewardedLoadAttempts += 1;
//         if(_numRewardedLoadAttempts < _maxLoadAttempts) {
//           initAdMobRewarded();
//         }
//       }
//     )
//   );
// }
//
// showAdMobRewarded({dynamic callback}) {
//   if(_rewardedAd == null) {
//     showToast('시청 가능한 광고가 없습니다.\n나중에 다시 시도해주세요!');
//     return;
//   }
//   _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//     onAdShowedFullScreenContent: (RewardedAd ad) =>
//       print('$ad onAdShowedFullScreenContent.'),
//     onAdDismissedFullScreenContent: (RewardedAd ad) {
//       print('$ad onAdDismissedFullScreenContent.');
//       ad.dispose();
//       initAdMobRewarded();
//     },
//     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//       print('$ad onAdFailedToShowFullScreenContent: $error');
//       ad.dispose();
//     },
//   );
//   _rewardedAd!.setImmersiveMode(true);
//   _rewardedAd!.show(
//     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       callback();
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     }
//   );
//   _rewardedAd = null;
// }