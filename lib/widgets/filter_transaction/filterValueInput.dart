import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vi_nho/models/filterModel.dart';

import '../../viewmodels/filterVM.dart';

class FilterValueInput extends StatelessWidget{
  final FilterVM filterVM;
  final FilterField? field;

  const FilterValueInput({required this.field, super.key, required this.filterVM});

  @override
  Widget build(BuildContext context) {
    if(field == null) return const Text('Chọn trường');

    switch(field!){
      case FilterField.amount:
        return TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Số tiền'),
          onChanged: (value) => filterVM.setInputValue(double.parse(value!)),
        );

      case FilterField.date:
        DateTime? selectedDate;
        if (filterVM.inputValue is DateTime) {
          selectedDate = filterVM.inputValue as DateTime;
        } else if (filterVM.inputValue is String) {
          selectedDate = DateTime.tryParse(filterVM.inputValue);
        }

        selectedDate ??= DateTime.now();

        return TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate!,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              filterVM.setInputValue(picked);
            }
          },
          child: Text(
            selectedDate != null
                ? 'Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'
                : 'Chọn ngày',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
            ),
          ),
        );

      case FilterField.category:
        final categories = ['Ăn uống', 'Di chuyển', 'Giải trí', 'Khác'];
        return DropdownButtonFormField<String>(
          value: filterVM.inputValue,
          hint: const Text('Chọn loại'),
          onChanged: (value) => filterVM.setInputValue(value),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat),
            );
          }).toList(),
        );

      case FilterField.note:
        return TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Ghi chú'),
          onChanged: (value) => filterVM.setInputValue(value),
        );
    }
  }
}