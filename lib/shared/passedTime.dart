class PassedTime {
  static String createPassedTime(DateTime now, DateTime createdDate) {
    int duration;
    String result;
    Duration difference = now.difference(createdDate);

    int differToDate = difference.inDays;
    if (differToDate >= 365) {
      duration = differToDate ~/ 365;
      result = duration.toString() + "년 전";
    } else if (differToDate >= 30) {
      duration = differToDate ~/ 30;
      result = duration.toString() + "달 전";
    } else if (differToDate >= 1) {
      duration = differToDate;
      result = duration.toString() + "일 전";
    } else if (difference.inHours >= 1) {
      duration = difference.inHours;
      result = duration.toString() + "시간 전";
    } else if (difference.inMinutes >= 1) {
      duration = difference.inMinutes;
      result = duration.toString() + "분 전";
    } else {
      duration = difference.inSeconds;
      result = duration.toString() + "초 전";
    }
    return result;
  }
}
