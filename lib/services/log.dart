class Log {

  static debug(String body) {
    print('[DEBUG] $body');
  }

  static error(String body) {
    print('[ERROR] $body');
  }

  static info(String body) {
    print('[INFO] $body');
  }

  static warn(String body) {
    print('[WARN] $body');
  }

}
