class Tool{
  // Lấy ngày bắt đầu và kết thúc của 1 tuần
  static List<DateTime> getWeekRange(int year, int week) {
    final janFirst = DateTime(year, 1, 1);
    final daysToAdd = (week - 1) * 7;
    final approx = janFirst.add(Duration(days: daysToAdd));

    final weekday = approx.weekday;
    final monday = approx.subtract(Duration(days: weekday - 1));

    final sunday = monday.add(Duration(days: 6));

    return [monday, sunday];
  }

  // Ngày hiện tại thuộc tuần nào trong năm
  static int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;

    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));

    final diff = date.difference(firstMonday).inDays;
    final weekNumber = (diff / 7).ceil();

    return weekNumber;
  }

  // Lấy tổng số tuần trong năm
  static int getTotalWeeksInYear(int year) {
    final lastDay = DateTime(year, 12, 31);
    return getWeekOfYear(lastDay);
  }

  // Tổng số ngày trong 1 tháng
  static int daysInMonth(int year, int month) {
    var beginningNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    var lastDayThisMonth = beginningNextMonth.subtract(Duration(days: 1));
    return lastDayThisMonth.day;
  }
}