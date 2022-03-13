import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2157411230431534/9542973323';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2157411230431534/8377231313';
    }
    throw new UnsupportedError("Unsupported platform");
  }

}