class GeneralUtils {
  static String validateUsername(String name) {
    if (name == null || name.isEmpty) {
      return 'Oops! Usernames can\'t be blank';
    }
    if (name.length > 24) {
      return 'Sorry, usernames have to be shorter than 24 characters';
    }
    var allow = '0123456789abcdefghijklmnopqrstuvwxyz._'.split('');
    if (!name.split('').every((char) => allow.contains(char))) {
      return 'Sorry, usernames can only have lowercase letters, numbers, underscores, and periods';
    }
    return null;
  }

  static String validateDisplayName(String name) {
    if (name == null || name.isEmpty) {
      return 'Oops! Display names can\'t be blank';
    }
    if (name.length > 12) {
      return 'Sorry, display names have to be shorter than 12 characters';
    }
    var allow = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    if (!name.split('').every((char) => allow.contains(char))) {
      return 'Sorry, display names can only have letters';
    }
    return null;
  }
}
