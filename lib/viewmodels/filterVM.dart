import 'package:flutter/material.dart';

import '../models/transactionModel.dart';

class FilterVM extends ChangeNotifier {

  DateTime? startDate;
  DateTime? endDate;

  int? year;
  int? month;
  int? day;

  int? week;

  void setDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;

    year = null;
    month = null;
    day = null;
    week = null;

    notifyListeners();
  }

  void setSpecificDate({
    int? year,
    int? month,
    int? day,
  }) {
    startDate = null;
    endDate = null;

    this.year = year;
    this.month = month;
    this.day = day;

    week = null;

    notifyListeners();
  }

  void setWeek(int week) {
    startDate = null;
    endDate = null;

    year = null;
    month = null;
    day = null;

    this.week = week;

    notifyListeners();
  }

  void clear() {
    startDate = null;
    endDate = null;
    year = null;
    month = null;
    day = null;
    week = null;

    notifyListeners();
  }

  bool get hasFilter {
    return startDate != null ||
        endDate != null ||
        year != null ||
        month != null ||
        day != null ||
        week != null;
  }

  List<TransactionModel> apply(List<TransactionModel> list) {
    final now = DateTime.now();

    /// 🔥 1. RANGE (ưu tiên cao nhất)
    if (startDate != null && endDate != null) {
      final start = _startOfDay(startDate!);
      final end = _endOfDay(endDate!);

      return list.where((e) {
        final d = e.dateTime;
        return !d.isBefore(start) && !d.isAfter(end);
      }).toList();
    }

    /// 🔥 2. SPECIFIC DATE (linh hoạt)
    if (year != null || month != null || day != null) {
      final y = year;
      final m = month;
      final d = day;

      return list.where((e) {
        final date = e.dateTime;

        /// YEAR
        if (y != null && date.year != y) return false;

        /// MONTH
        if (m != null) {
          final usedYear = y ?? now.year;
          if (date.year != usedYear || date.month != m) return false;
        }

        /// DAY
        if (d != null) {
          final usedYear = y ?? now.year;
          final usedMonth = m ?? now.month;

          if (date.year != usedYear ||
              date.month != usedMonth ||
              date.day != d) return false;
        }

        return true;
      }).toList();
    }

    /// 🔥 3. WEEK
    if (week != null) {
      return list.where((e) {
        return _weekOfMonth(e.dateTime) == week;
      }).toList();
    }

    /// 🔹 DEFAULT
    return list;
  }

  /// =========================
  /// 🔹 HELPERS
  /// =========================

  DateTime _startOfDay(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  DateTime _endOfDay(DateTime d) {
    return DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
  }

  int _weekOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final offset = firstDay.weekday - 1; // Monday = 1
    return ((date.day + offset) / 7).ceil();
  }
}