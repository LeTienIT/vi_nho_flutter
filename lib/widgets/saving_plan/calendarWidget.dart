import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget{
  List<DateTime> dates;
  Map<DateTime, double> soNgayThieu;
  DateTime? ngayNopTiepTheo;

  CalendarWidget({super.key, required this.dates, required this.soNgayThieu, this.ngayNopTiepTheo});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);
    
    return Column(
      children: [
        TableCalendar(
          focusedDay: normalizedNow,
          firstDay: dates.first,
          lastDay: dates.last,
          calendarFormat: CalendarFormat.month,
          calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) => _buildDayCell(day, dates, soNgayThieu),
              outsideBuilder: (context, day, _) => _buildDayCell(day, dates, soNgayThieu)
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            _buildLegendItem(Colors.red, 'Bị thiếu'),
            _buildLegendItem(Colors.green, 'Đã hoàn thành'),
            _buildLegendItem(Colors.yellow, 'Các ngày còn lại'),
          ],
        )
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16)
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget? _buildDayCell(DateTime day, List<DateTime> dates, Map<DateTime, double> soNgayThieu){
    final now = DateTime.now();
    final d = DateTime(day.year, day.month, day.day);

    if (!dates.any((dt) =>
    dt.year == d.year && dt.month == d.month && dt.day == d.day)) {
      return null;
    }

    Color bgColor;
    if (soNgayThieu.keys.any((missedDay) =>
    missedDay.year == d.year &&
        missedDay.month == d.month &&
        missedDay.day == d.day)) {
      bgColor = Colors.redAccent;
    } else if (d.isAfter(now)) {
      bgColor = Colors.amber;
    } else {
      bgColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}