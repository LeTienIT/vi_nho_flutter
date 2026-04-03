import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/transactionVM.dart';

class FilterSection extends StatefulWidget {
  final TransactionVM vm;

  const FilterSection({super.key, required this.vm});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  DateTime? startDate;
  DateTime? endDate;

  int? year;
  int? month;
  int? day;

  int? week;

  @override
  void initState() {
    super.initState();

    final vm = widget.vm;

    startDate = vm.startDate;
    endDate = vm.endDate;

    year = vm.year;
    month = vm.month;
    day = vm.day;

    week = vm.week;
  }

  String get rangeText {
    if (startDate == null || endDate == null) {
      return "Chọn khoảng thời gian";
    }
    return "${startDate!.day}/${startDate!.month} - ${endDate!.day}/${endDate!.month}";
  }

  String get yearText => year?.toString() ?? "--";
  String get monthText => month?.toString().padLeft(2, '0') ?? "--";
  String get dayText => day?.toString().padLeft(2, '0') ?? "--";
  String get weekText => week != null ? "Tuần $week" : "--";

  Widget _buildBox({required String label, required String value, required VoidCallback onTap,}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickDateRange() async {
    DateTime tempStart = startDate ?? DateTime.now();
    DateTime tempEnd = endDate ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Chọn khoảng thời gian"),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tempStart,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) tempStart = picked;
                  },
                  child: const Text("Chọn ngày bắt đầu"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tempEnd,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) tempEnd = picked;
                  },
                  child: const Text("Chọn ngày kết thúc"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  startDate = tempStart;
                  endDate = tempEnd;

                  year = null;
                  month = null;
                  day = null;
                  week = null;
                });
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  int daysInMonth(int year, int month) {
    final firstDayNextMonth =
    (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }
  Future<int?> showWheelPicker({required BuildContext context, required List<int> values, int? initialValue,}) async {
    int selected = initialValue ?? values.first;

    return await showModalBottomSheet<int>(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: values.indexOf(selected),
                  ),
                  onSelectedItemChanged: (index) {
                    selected = values[index];
                  },
                  children: values.map((e) => Center(child: Text("$e"))).toList(),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, selected),
                child: const Text("Chọn"),
              )
            ],
          ),
        );
      },
    );
  }

  int weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(firstDayOfYear).inDays;
    return ((days + firstDayOfYear.weekday) / 7).ceil();
  }
  Future<int?> showWeekPicker({required BuildContext context, int? initialValue,}) async {
    final nowWeek = weekOfYear(DateTime.now());
    int selected = initialValue ?? nowWeek;

    return await showModalBottomSheet<int>(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                "Chọn tuần",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: (selected - 1).clamp(0, 52),
                  ),
                  onSelectedItemChanged: (index) {
                    selected = index + 1;
                  },
                  children: List.generate(
                    53,
                        (i) => Center(child: Text("Tuần ${i + 1}")),
                  ),
                ),
              ),

              TextButton(
                onPressed: () => Navigator.pop(context, selected),
                child: const Text("Chọn"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// TITLE
            const Text(
              "Bộ lọc",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            const Divider(),

            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// RANGE
                    const Text(
                      "Khoảng thời gian",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),

                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final result = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDateRange:
                          startDate != null && endDate != null ? DateTimeRange(start: startDate!, end: endDate!) : null,
                        );

                        if (result != null) {
                          setState(() {
                            startDate = result.start;
                            endDate = result.end;

                            year = null;
                            month = null;
                            day = null;
                            week = null;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: (startDate != null && endDate != null) ? Colors.blue : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(rangeText),
                            const Icon(Icons.calendar_today_outlined, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Theo ngày",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _buildBox(
                          label: "Năm",
                          value: yearText,
                          onTap: () async {
                            final result = await showWheelPicker(
                              context: context,
                              values: List.generate(50, (i) => 2000 + i),
                              initialValue: year ?? DateTime.now().year,
                            );

                            if (result != null) {
                              setState(() {
                                year = result;
                                startDate = null;
                                endDate = null;
                                week = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildBox(
                          label: "Tháng",
                          value: monthText,
                          onTap: () async {
                            final result = await showWheelPicker(
                              context: context,
                              values: List.generate(12, (i) => i + 1),
                              initialValue: month ?? DateTime.now().month,
                            );

                            if (result != null) {
                              setState(() {
                                month = result;
                                year ??= DateTime.now().year;

                                startDate = null;
                                endDate = null;
                                week = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildBox(
                          label: "Ngày",
                          value: dayText,
                          onTap: () async {
                            final now = DateTime.now();

                            final y = year ?? now.year;
                            final m = month ?? now.month;

                            final maxDays = daysInMonth(y, m);

                            final result = await showWheelPicker(
                              context: context,
                              values: List.generate(maxDays, (i) => i + 1),
                              initialValue: day ?? DateTime.now().day,
                            );

                            if (result != null) {
                              setState(() {
                                day = result;
                                month ??= m;
                                year ??= y;

                                startDate = null;
                                endDate = null;
                                week = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Theo tuần",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildBox(
                          label: "Tuần",
                          value: weekText,
                          onTap: () async {
                            final result = await showWeekPicker(
                              context: context,
                              initialValue: week,
                            );

                            if (result != null) {
                              setState(() {
                                week = result;

                                startDate = null;
                                endDate = null;
                                year = null;
                                month = null;
                                day = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        vm.clearFilter();
                        Navigator.pop(context);
                      },
                      child: const Text("Đặt lại"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        /// APPLY
                        if (startDate != null && endDate != null) {
                          vm.setDateRange(startDate!, endDate!);
                        } else if (year != null ||
                            month != null ||
                            day != null) {
                          if (year != null) vm.setYear(year!);
                          if (month != null) vm.setMonth(month!);
                          if (day != null) vm.setDay(day!);
                        } else if (week != null) {
                          vm.setWeek(week!);
                        }

                        vm.filterTransaction();

                        Navigator.pop(context);
                      },
                      child: const Text("Áp dụng"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}