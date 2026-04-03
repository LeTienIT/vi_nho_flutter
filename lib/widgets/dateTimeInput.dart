import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInput extends StatelessWidget {
  final DateTime? dateTime;
  final ValueChanged<DateTime> onPressed;
  final bool enable;

  const DateTimeInput({
    super.key,
    required this.dateTime,
    required this.onPressed,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = dateTime != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enable
            ? () async {
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
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasValue ? Theme.of(context).primaryColor : Colors.grey.shade300,
            ),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 18,
                  color: hasValue
                      ? Theme.of(context).primaryColor
                      : Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasValue
                      ? DateFormat('dd/MM/yyyy').format(dateTime!)
                      : 'Chọn ngày',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: hasValue ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}