import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInput extends StatelessWidget {
  final DateTime? dateTime;
  final ValueChanged<DateTime> onPressed;

  const DateTimeInput({super.key, required this.dateTime, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            dateTime == null ? 'Chưa chọn ngày' : 'Ngày chọn: ${DateFormat('dd/MM/yyyy').format(dateTime!)}',
            style: TextStyle(
                color: dateTime == null ? Colors.grey : null,
                fontWeight: FontWeight.bold
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.calendar_today),
            label: Text('Chọn ngày'),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
                initialDate: dateTime ?? DateTime.now(),
              );
              if (pickedDate != null) {
                onPressed(pickedDate);
              }
            }
          ),
        ],
      ),
    );
  }
}