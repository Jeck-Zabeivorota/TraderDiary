class DateDuration {
  late int days, months, years;

  static int daysInMonth(int month, int year) {
    DateTime d1 = DateTime(year, month);
    month++;
    if (month == 13) {
      month = 1;
      year++;
    }
    DateTime d2 = DateTime(year, month);
    return d2.difference(d1).inDays;
  }

  bool get isNullPeriod => days == 0 && months == 0 && years == 0;

  DateTime addTo(DateTime date) {
    int newYear = date.year + years + months ~/ 12;
    int newMonth = date.month + months % 12;
    if (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }

    int maxDay = daysInMonth(newMonth, newYear);
    int newDay = date.day <= maxDay ? date.day : maxDay;

    return DateTime(newYear, newMonth, newDay).add(Duration(days: days));
  }

  DateTime removeFrom(DateTime date) {
    int newYear = date.year - years - months ~/ 12;
    int newMonth = date.month - (months % 12);
    if (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    int maxDay = daysInMonth(newMonth, newYear);
    int newDay = date.day <= maxDay ? date.day : maxDay;

    return DateTime(newYear, newMonth, newDay)
        .subtract(Duration(days: days));
  }

  Map<String, int> toMap() => {
        'days': days,
        'months': months,
        'years': years,
      };

  DateDuration.fromMap(Map<String, int> map) {
    days = map['days']!;
    months = map['months']!;
    years = map['years']!;
  }

  DateDuration({
    this.days = 0,
    this.months = 0,
    this.years = 0,
  });
}
