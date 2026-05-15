import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../core/const_running.dart';

class MonthPicker extends StatefulWidget {
  int monthCurrent, year;
  final ValueChanged<int?> onChanged;

  MonthPicker({
    super.key,
    required this.monthCurrent,
    required this.year,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _MonthPicker();
}

class _MonthPicker extends State<MonthPicker> {

  void _openPicker() {
    final controller = FixedExtentScrollController(
      initialItem: widget.monthCurrent - 1,
    );

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 260,
          color: Colors.white,
          child: Column(
            children: [
              /// Toolbar iOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Huỷ'),
                    onPressed: () => Navigator.pop(context),
                  ),

                  /// 👇 NÚT HIỆN TẠI
                  CupertinoButton(
                    child: Text(
                      'Hiện tại',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      final currentMonth = DateTime.now().month;

                      controller.animateToItem(
                        currentMonth - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                      setState(() => widget.monthCurrent = currentMonth);
                      widget.onChanged(currentMonth);
                      Running.dashboardMonth = currentMonth;
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
                    setState(() => widget.monthCurrent = value);
                    widget.onChanged(value);
                    Running.dashboardMonth = value;
                  },
                  children: List.generate(12, (index) {
                    return Center(
                      child: Text('Tháng ${index + 1}'),
                    );
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Bộ lọc',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            /// Field hiển thị
            GestureDetector(
              onTap: _openPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Chọn tháng'),
                    Row(
                      children: [
                        Text(
                          'Tháng ${widget.monthCurrent}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
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