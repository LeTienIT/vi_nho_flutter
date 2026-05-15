import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vi_nho/core/const_running.dart';

import '../../core/tool.dart';

class WeekPicker extends StatefulWidget {
  final int year;
  final int? initWeek;
  final ValueChanged<int> onChange;

  const WeekPicker({
    super.key,
    required this.year,
    required this.onChange,
    this.initWeek,
  });

  @override
  State<StatefulWidget> createState() => _WeekPicker();
}

class _WeekPicker extends State<WeekPicker> {
  late int selectedWeek;
  late int totalWeeks;

  @override
  void initState() {
    super.initState();
    selectedWeek = widget.initWeek ?? Tool.getWeekOfYear(DateTime.now());
    totalWeeks = Tool.getTotalWeeksInYear(widget.year);
  }

  void _openPicker() {
    final controller = FixedExtentScrollController(
      initialItem: selectedWeek - 1,
    );

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 260,
          color: Colors.white,
          child: Column(
            children: [
              /// Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Huỷ'),
                    onPressed: () => Navigator.pop(context),
                  ),

                  /// 👇 NÚT HIỆN TẠI
                  CupertinoButton(
                    child: const Text('Hiện tại'),
                    onPressed: () {
                      final currentWeek =
                      Tool.getWeekOfYear(DateTime.now());

                      controller.animateToItem(
                        currentWeek - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                      setState(() => selectedWeek = currentWeek);
                      widget.onChange(currentWeek);
                      Running.dashboardWeek = currentWeek;
                    },
                  ),

                  CupertinoButton(
                    child: const Text('Chọn'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              Expanded(
                child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 40,
                  useMagnifier: true,
                  magnification: 1.1,
                  onSelectedItemChanged: (index) {
                    final value = index + 1;
                    setState(() => selectedWeek = value);
                    widget.onChange(value);
                    Running.dashboardWeek = value;
                  },
                  children: List.generate(totalWeeks, (index) {
                    return Center(child: Text('Tuần ${index + 1}'));
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Bộ lọc',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            /// Field hiển thị value
            GestureDetector(
              onTap: _openPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Chọn tuần'),
                    Row(
                      children: [
                        Text(
                          'Tuần $selectedWeek',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}