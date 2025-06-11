import 'package:flutter/material.dart';
import 'package:vi_nho/models/filterModel.dart';
import 'package:vi_nho/viewmodels/filterVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/filterValueInput.dart';

class FilterSection extends StatelessWidget{
  final FilterVM filterVM;
  final TransactionVM transactionVM;
  const FilterSection({required this.filterVM, required this.transactionVM, super.key});


  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    if (filterVM.inputValue is DateTime) {
      selectedDate = filterVM.inputValue as DateTime;
    } else if (filterVM.inputValue is String) {
      selectedDate = DateTime.tryParse(filterVM.inputValue);
    }

    selectedDate ??= DateTime.now();
    return Card(
        margin: const EdgeInsets.all(12),
        // color: Theme.of(context).cardColor,
        child: ExpansionTile(
          title: Text("Bộ lọc",),
          leading: Icon(Icons.filter_alt),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                       SizedBox(
                        width: 100,
                        child: Text("Trường",),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<FilterField>(
                          value: filterVM.selectedField,
                          hint: Text('Chọn trường'),
                          items: FilterField.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) => filterVM.setField(value),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Điều kiện"),

                      ),
                      Expanded(
                        child: DropdownButtonFormField<FilterOperator>(
                          value: filterVM.selectedOperator,
                          hint: Text('Chọn điều kiện'),
                          items: FilterOperator.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) => filterVM.setOperator(value),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Giá trị"),

                      ),
                      Expanded(
                       child: FilterValueInput(field: filterVM.selectedField, filterVM: filterVM),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton.icon(
                        onPressed: (){
                          filterVM.clear();
                          transactionVM.clearFilter();
                        },
                        icon: Icon(Icons.filter_alt_off_outlined),
                        label: Text('Xóa bộ lọc'),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: (){
                          FilterCondition? filter = filterVM.buildCondition();
                          transactionVM.applyFilter(filter);
                        },
                        icon: Icon(Icons.filter_alt),
                        label: Text('Áp dụng'),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]
          )
    );
  }

}