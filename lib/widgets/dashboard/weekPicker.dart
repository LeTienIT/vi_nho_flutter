import 'package:flutter/material.dart';
import 'package:vi_nho/core/const_running.dart';

import '../../core/tool.dart';

class WeekPicker extends StatefulWidget{
  final int year;
  final int? initWeek;
  final ValueChanged<int> onChange;

  const WeekPicker({super.key, required this.year, required this.onChange, this.initWeek});

  @override
  State<StatefulWidget> createState() {
    return _WeekPicker();
  }

}
class _WeekPicker extends State<WeekPicker>{
  late int selectedWeek;
  late int totalWeeks;
  @override
  void initState() {
    super.initState();
    selectedWeek = widget.initWeek ?? Tool.getWeekOfYear(DateTime.now());
    totalWeeks = Tool.getTotalWeeksInYear(widget.year);
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Bộ lọc',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Chọn tuần'),
                DropdownButton<int>(
                  value: selectedWeek,
                  icon: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.calendar_view_week),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedWeek = value);
                      widget.onChange(value);
                      Running.dashboardWeek = value;
                    }
                  },
                  items: List.generate(totalWeeks, (index) {
                    final week = index + 1;
                    return DropdownMenuItem(
                      value: week,
                      child: Text('Tuần $week'),
                    );
                  }),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}