import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-2157411230431534/9542973323'; // for release
      return 'ca-app-pub-3940256099942544/6300978111'; // for test
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-2157411230431534/8377231313'; // for release
      return 'ca-app-pub-3940256099942544/2934735716'; // for test
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5354046379'; // for test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // for test
    }
    throw new UnsupportedError("Unsupported platform");
  }

}