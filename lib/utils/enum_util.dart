class EnumUtil {
  static T fromString<T>(Iterable<T> values, String string) {
    return values.firstWhere(
        (f)=> "${f.toString().substring(f.toString().indexOf('.')+1)}".toString()
        == string, orElse: () => null);
  }

  static String toString(String string) {
    return string.split('.')[1];
  }
}
