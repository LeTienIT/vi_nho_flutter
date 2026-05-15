import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vi_nho/core/const_running.dart';

class YearPickerWidget extends StatefulWidget {
  int? year;
  final ValueChanged<int?> onChanged;

  YearPickerWidget({
    super.key,
    this.year,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _YearPickerWidget();
}

class _YearPickerWidget extends State<YearPickerWidget> {
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.year ?? DateTime.now().year;
  }

  void _openPicker() {
    final currentYear = DateTime.now().year;

    final years = List.generate(
      currentYear - 2002 + 1,
          (i) => 2002 + i,
    );

    final controller = FixedExtentScrollController(
      initialItem: years.indexOf(selectedYear),
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
                      final index = years.indexOf(currentYear);

                      controller.animateToItem(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                      setState(() => selectedYear = currentYear);
                      widget.onChanged(currentYear);
                      Running.dashboardYear = currentYear;
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
                    final value = years[index];
                    setState(() => selectedYear = value);
                    widget.onChanged(value);
                    Running.dashboardYear = value;
                  },
                  children: years.map((year) {
                    return Center(
                      child: Text('Năm $year'),
                    );
                  }).toList(),
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

            /// Field giống Month + Week
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
                    const Text('Chọn năm'),
                    Row(
                      children: [
                        Text(
                          '$selectedYear',
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