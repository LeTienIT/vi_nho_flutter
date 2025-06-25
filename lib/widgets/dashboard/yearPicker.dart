import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vi_nho/core/const_running.dart';

class YearPickerWidget extends StatefulWidget{
  int? year;
  final ValueChanged<int?> onChanged;

  YearPickerWidget({super.key, this.year, required this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _YearPickerWidget();
  }

}

class _YearPickerWidget extends State<YearPickerWidget> {
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.year!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Năm: ", style: Theme.of(context).textTheme.titleMedium),
                OutlinedButton(
                  onPressed: () => _showDialog(),
                  child: Text(selectedYear.toString()),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    int tempYear = selectedYear;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Chọn năm'),
            content: SizedBox(
              height: 150,
              child: NumberPicker(
                value: tempYear,
                minValue: 2002,
                maxValue: DateTime.now().year,
                itemCount: 3,
                textStyle: Theme.of(context).textTheme.titleSmall,
                selectedTextStyle: Theme.of(context).textTheme.titleLarge,
                onChanged: (value) {
                  setStateDialog(() {
                    tempYear = value;
                  });
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedYear = tempYear;
                  });
                  widget.onChanged(selectedYear);
                },
                child: const Text('Chọn'),
              ),
            ],
          ),
        );
      },
    );
  }
}