class Tool{
  /// Lấy ngày bắt đầu và kết thúc của 1 tuần
  static List<DateTime> getWeekRange(int year, int week) {
    // Lấy ngày đầu tiên của năm
    final janFirst = DateTime(year, 1, 1);

    // Tính ngày ~ đầu tuần (Thứ 2)
    final daysToFirstMonday = (8 - janFirst.weekday) % 7;
    final firstMonday = janFirst.add(Duration(days: daysToFirstMonday));

    // Nếu tuần yêu cầu là tuần 1 nhưng 1/1 chưa đến Thứ 2
    if (week == 1 && daysToFirstMonday >= 7) {
      return [
        DateTime(year, 1, 1),
        firstMonday.subtract(Duration(days: 1))
      ];
    }

    // Tính ngày Thứ 2 của tuần cần lấy
    final monday = firstMonday.add(Duration(days: (week - 1) * 7));
    final sunday = monday.add(Duration(days: 6));

    return [
      DateTime(monday.year, monday.month, monday.day), // 00:00:00 Thứ 2
      DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999) // 23:59:59.999 Chủ Nhật
    ];
  }

  /// Ngày hiện tại thuộc tuần nào trong năm
  static int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;

    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));

    final diff = date.difference(firstMonday).inDays;
    final weekNumber = (diff / 7).ceil();

    return weekNumber;
  }

  /// Lấy tổng số tuần trong năm
  static int getTotalWeeksInYear(int year) {
    final lastDay = DateTime(year, 12, 31);
    return getWeekOfYear(lastDay);
  }

  /// Tổng số ngày trong 1 tháng
  static int daysInMonth(int year, int month) {
    var beginningNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    var lastDayThisMonth = beginningNextMonth.subtract(Duration(days: 1));
    return lastDayThisMonth.day;
  }

  /// Lấy ra danh sách các ngày chủ nhật trong 1 khoảng thời gian
  /// ==========================================================
  /// Danh sách các ngày kết thúc của các tuần
  /// Số lượng tuần trong 1 khoảng thời gian
  static List<DateTime> getWeeklySavingDatesBySunday(DateTime startP, DateTime endP) {
    final now = DateTime.now();
    final start = startP;
    final end = endP;
    DateTime firstSunday;
    if (start.weekday == DateTime.sunday) {
      firstSunday = start;
    } else {
      final daysToNextSunday = 7 - start.weekday;
      firstSunday = start.add(Duration(days: daysToNextSunday));
    }

    DateTime lastSunday;
    if (end.weekday == DateTime.sunday) {
      lastSunday = end;
    } else {
      final daysSinceLastSunday = end.weekday;
      lastSunday = end.subtract(Duration(days: daysSinceLastSunday));
    }

    List<DateTime> sundays = [];
    DateTime current = firstSunday;
    while (!current.isAfter(lastSunday)) {
      sundays.add(current);
      current = current.add(const Duration(days: 7));
    }

    return sundays;
  }

  /// Lấy ra các ngày trong 1 khoảng thời gian theo điều kiện "Ngày - tuần - tháng"
  ///=======================================
  /// Trả về danh sách các ngày trong khoảng thời gian
  static List<DateTime> getDaysInPeriodOfTime(DateTime s, DateTime e, String chuKy){
    DateTime current = s;
    final now = DateTime.now();
    final end = e;
    List<DateTime> dates = [];
    if(chuKy == 'Ngày'){
      while (!current.isAfter(end)) {
        dates.add(current);
        current = current.add(const Duration(days: 1));
      }
    }
    else if(chuKy == 'Tuần'){
      dates = Tool.getWeeklySavingDatesBySunday(s, e);
    }
    else{
      DateTime current = DateTime(s.year, s.month);
      final last = DateTime(end.year, end.month);
      while (!current.isAfter(last)) {
        final lastDay = Tool.daysInMonth(current.year, current.month);
        dates.add(DateTime(current.year, current.month, lastDay));
        current = DateTime(
          current.month == 12 ? current.year + 1 : current.year,
          current.month == 12 ? 1 : current.month + 1,
        );
      }
    }
    return dates;
  }

}