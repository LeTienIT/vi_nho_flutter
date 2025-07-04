import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/transaction/categoryPicker.dart';
import 'package:vi_nho/widgets/sessionTitle.dart';

import '../../viewmodels/planVM.dart';
import '../../widgets/dateTimeInput.dart';
import '../../widgets/numberForm.dart';
import '../../widgets/textForm.dart';
import '../../widgets/typeSelector.dart';

import 'package:vi_nho/core/input_validators.dart';

class AddTransactionView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddTransactionView();

}
class _AddTransactionView extends State<AddTransactionView>{
  String? _type = 'Chi';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  DateTime? dateTime;

  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _note.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlanVM>();
    int planID = -1;
    if(vm.checkOpenPlan()['rs'] == 1){
      planID = vm.checkOpenPlan()['id']!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nhập dữ liệu',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),

                SessionTitle(title: 'Kiểu', subtitle: 'Phân loại thu hay chi',),
                TypeSelector(
                  selected: _type, //
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                    });
                  },
                  planID: planID,
                ),

                SessionTitle(title: 'Loại', subtitle: 'Phân loại để quản lý chi tiêu',),
                CategoryPicker(),

                SessionTitle(title: 'Số lượng', subtitle: 'Số tiền chi trả cho việc này',),
                NumberForm(amount: _amount, title: 'Số tiền', hint: 'VD: 20.000', validator: InputValidators.amountValidator,),

                SessionTitle(title: 'Note',subtitle: 'Ghi chú để xem lại',),
                TextForm(category: _note, title: 'Ghi chú', hint: 'ghi lại nhưng gì cần'),

                SessionTitle(title: 'Thời gian',subtitle: 'Ngày thực hiện',),
                DateTimeInput(dateTime: dateTime, onPressed:  (newDate) { setState(() {dateTime = newDate;});}),

                Divider(),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              if(dateTime == null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ngày thực hiện không được để trống'),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2),
                                    )
                                );
                                return;
                              }
                            }
                            if(_type == 'Tiết kiệm'){
                              final p = vm.getP(planID);
                              if (dateTime!.isBefore(p.ngayBD) || dateTime!.isAfter(p.ngayKT)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Thời gian hiện tại không thuộc gói tiết kiệm! HÃY CHỌN NGÀY HỢP LỆ! THUỘC GÓI TIẾT KIỆM'),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 3),
                                    )
                                );
                                return;
                              }
                            }
                            TransactionModel t = TransactionModel(
                                type: _type!,
                                amount: double.parse(_amount.text),
                                category: context.read<CategoryVM>().categorySelect!.name,
                                note: _note.text,
                                dateTime: dateTime!,
                                savingID: _type == 'Tiết kiệm' ? planID : -1
                            );

                            try {
                              final vm = context.read<TransactionVM>();
                              await vm.insertTransaction(t);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Thêm dữ liệu thành công'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Lỗi khi thêm dữ liệu: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          label: Text('Thêm'),
                          icon: Icon(Icons.add),
                      )
                    )
                  ],
                )

              ],
            ),
        )
      )
    );
  }

}