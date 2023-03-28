extension Validation on String? {
  String? checkEmpty(String message) {
    if (this?.isEmpty ?? true) {
      return message;
    }
    return null;
  }
}

extension ParseDateTime on String? {
  bool checkHourMinute(String? microsecondsSinceEpochMatch) {
    if (this == null || microsecondsSinceEpochMatch == null) return false;
    int firstTime = int.parse(this!);
    int secondTime = int.parse(microsecondsSinceEpochMatch);
    DateTime firstDateTime = DateTime.fromMillisecondsSinceEpoch(firstTime);
    DateTime secondDateTime = DateTime.fromMillisecondsSinceEpoch(secondTime);
    if (firstDateTime.hour == secondDateTime.hour &&
        firstDateTime.minute == secondDateTime.minute) return true;
    return false;
  }
}
