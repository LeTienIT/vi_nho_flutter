import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class Tool{
  /// Lấy ngày bắt đầu và kết thúc của 1 tuần
  static List<DateTime> getWeekRange(int year, int week) {
    // Ngày 4 tháng 1 luôn thuộc tuần đầu tiên theo ISO 8601
    final jan4 = DateTime(year, 1, 4);

    // Tìm Thứ Hai của tuần chứa 4/1
    final int diffToMonday = jan4.weekday - DateTime.monday;
    final firstMonday = jan4.subtract(Duration(days: diffToMonday));

    // Tính Thứ Hai của tuần cần tìm
    final monday = firstMonday.add(Duration(days: (week - 1) * 7));
    final sunday = monday.add(Duration(days: 6));

    return [
      DateTime(monday.year, monday.month, monday.day),
      DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999),
    ];
  }


  /// Trả về số tuần trong năm theo chuẩn ISO 8601.
  /// Tuần 1 là tuần có ít nhất 4 ngày thuộc năm đó (tuần chứa ngày 4/1).
  static int getWeekOfYear(DateTime date) {
    // Thứ Năm trong cùng tuần với ngày cần tính
    final thursday = _getThursdayOfWeek(date);

    // Thứ Năm đầu tiên của năm (tuần 1)
    final firstThursday = _getThursdayOfWeek(DateTime(date.year, 1, 4));

    final diff = thursday.difference(firstThursday).inDays;

    return (diff / 7).floor() + 1;
  }

  /// Lấy ngày thứ Năm của tuần có chứa ngày [date]
  static DateTime _getThursdayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 4));
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
Future<void> cleanOnlyCache() async {
  try {
    // 1. Xóa thư mục cache tạm thời (temporary directory)
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      await tempDir.create(); // Tạo lại thư mục rỗng
    }

    // 2. Xóa cache của các package (image, network...)
    await DefaultCacheManager().emptyCache(); // cached_network_image
    // Xóa cache của Dio (nếu dùng)
    final dioCacheDir = Directory('${tempDir.path}/dio');
    if (await dioCacheDir.exists()) await dioCacheDir.delete(recursive: true);

    // 3. Xóa cache WebView (nếu app dùng WebView)
    final appDir = await getApplicationSupportDirectory();
    final webViewCacheDir = Directory('${appDir.path}/WebKit');
    if (await webViewCacheDir.exists()) {
      await webViewCacheDir.delete(recursive: true);
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> getCacheSizeInBytes() async {
  int totalSize = 0;
  final tempDir = await getTemporaryDirectory();

  if (await tempDir.exists()) {
    totalSize = await _getDirectorySize(tempDir);
  }

  return totalSize;
}

Future<int> _getDirectorySize(Directory dir) async {
  int size = 0;
  try {
    final List<FileSystemEntity> entities = dir.listSync(recursive: true, followLinks: false);
    for (final entity in entities) {
      if (entity is File) {
        size += await entity.length();
      }
    }
  } catch (e) {
    throw("Error calculating directory size: $e");
  }
  return size;
}

String formatBytes(int bytes, [int decimals = 2]) {
  if (bytes == 0) return "0 B";
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (bytes > 0) ? (log(bytes) / log(1024)).floor() : 0;
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${sizes[i]}';
}