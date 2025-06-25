import 'package:flutter/material.dart';

import '../../core/const_running.dart';

class MonthPicker extends StatefulWidget{
  int monthCurrent, year;
  final ValueChanged<int?> onChanged;

  MonthPicker({super.key, required this.monthCurrent, required this.year, required this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _MonthPicker();
  }

}

class _MonthPicker extends State<MonthPicker>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
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
                Text('Chọn tháng'),
                DropdownButton<int>(
                    value: widget.monthCurrent,
                    icon: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.calendar_month),
                    ),
                    items: List.generate(12, (idx){
                      final month = idx + 1;
                      return DropdownMenuItem(
                          value: month,
                          child: Text('Tháng $month')
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => widget.monthCurrent = value);
                        widget.onChanged(value);
                        Running.dashboardMonth = value;
                      }
                    }
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}