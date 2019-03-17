enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {
  static Flavor appFlavor;

  static String get toasterHost {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'https://burntoast.herokuapp.com';
      case Flavor.DEVELOPMENT:
      default:
        return 'http://192.168.1.5:3000';
    }
  }
}
