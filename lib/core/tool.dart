class Tool{

  static int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;

    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));

    final diff = date.difference(firstMonday).inDays;
    final weekNumber = (diff / 7).ceil();

    return weekNumber;
  }

  static int getTotalWeeksInYear(int year) {
    final lastDay = DateTime(year, 12, 31);
    return getWeekOfYear(lastDay);
  }
}