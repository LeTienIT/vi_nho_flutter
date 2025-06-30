import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowCustomPlanDialog {
  static Future<Map<String, dynamic>?> showCustomPlanDialog(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;
    String frequency = 'Ngày';
    final amountController = TextEditingController();

    String formatDate(DateTime? date) {
      if (date == null) return 'Chọn ngày';
      return DateFormat('dd/MM/yyyy').format(date);
    }

    Future<void> pickDate({required bool isStart}) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: isStart ? DateTime.now() : (startDate ?? DateTime.now()).add(const Duration(days: 1)),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      }
    }

    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Tùy chỉnh gói tiết kiệm'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Bắt đầu: "),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await pickDate(isStart: true);
                          setState(() {});
                        },
                        child: Text(formatDate(startDate)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Kết thúc: "),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await pickDate(isStart: false);
                          setState(() {});
                        },
                        child: Text(formatDate(endDate)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Tần suất: "),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: frequency,
                        items: {'Ngày', 'Tuần', 'Tháng'}.map((freq) {
                          return DropdownMenuItem(
                            value: freq,
                            child: Text(freq),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => frequency = val);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Số tiền mục tiêu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // cancel
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                child: const Text("Xác nhận"),
                onPressed: () {
                  final goal = double.tryParse(amountController.text);
                  if (startDate == null || endDate == null) {
                    showError("Chọn ngày chưa đủ");
                    return;
                  }
                  if (startDate!.isAfter(endDate!)) {
                    showError("Ngày bắt đầu phải trước ngày kết thúc");
                    return;
                  }
                  if (goal == null || goal <= 0) {
                    showError("Số tiền không hợp lệ");
                    return;
                  }

                  final days = endDate!.difference(startDate!).inDays + 1;
                  int periods;

                  if (frequency == 'Ngày') {
                    periods = days;
                  } else if (frequency == 'Tuần') {
                    periods = (days / 7).floor();
                  } else if (frequency == 'Tháng') {
                    periods = ((endDate!.year - startDate!.year) * 12 +
                        endDate!.month -
                        startDate!.month + 1);
                  } else {
                    periods = 0;
                  }

                  if (periods < 1) {
                    showError("Không đủ thời gian để tích lũy theo tần suất đã chọn");
                    return;
                  }

                  final perPeriodAmount = goal / periods;

                  Navigator.pop(context, {
                    'startDate': startDate,
                    'endDate': endDate,
                    'frequency': frequency,
                    'goal': goal,
                    'perPeriod': perPeriodAmount,
                  });
                },
              ),
            ],
          ),
        );
      },
    );

    // ✅ Trả kết quả về cho caller
    return result;
  }
}
