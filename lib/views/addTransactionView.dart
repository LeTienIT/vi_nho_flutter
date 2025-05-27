import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/sessionTitle.dart';

class AddTransactionView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddTransactionView();

}
class _AddTransactionView extends State<AddTransactionView>{
  String? _type = 'Chi';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RadioListTile<String>(
                          value: 'Thu',
                          title: Text('Tiền vào'),
                          groupValue: _type,
                          onChanged: (value){
                            setState(() {
                              _type = value;
                            });
                          }),
                      RadioListTile(
                          value: 'Chi',
                          title: Text('Tiền ra'),
                          groupValue: _type,
                          onChanged: (value){
                            setState(() {
                              _type = value;
                            });
                          }),
                    ],
                  ),
                ),

                SessionTitle(title: 'Loại', subtitle: 'Phân loại để quản lý chi tiêu',),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _category,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Phân loại giao dịch'),
                          hintText: 'VD: ăn uống, mua sắm, ...'
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Hãy nhập giá trị';
                        }
                      },
                    )
                ),

                SessionTitle(title: 'Số lượng', subtitle: 'Số tiền chi trả cho việc này',),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Số tiền'),
                          hintText: '2.000 vnđ'
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Hãy nhập giá trị';
                        }
                        if(double.tryParse(value) == null){
                          return 'Hãy nhập đúng định dạng số tiền';
                        }
                      },
                    )
                ),

                SessionTitle(title: 'Note',subtitle: 'Ghi chú để xem lại',),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _note,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Ghi chú'),
                          hintText: 'Một khoản nhỏ mua niềm vui của đứa trẻ'
                      ),
                    )
                ),

                SessionTitle(title: 'Thời gian',subtitle: 'Ngày thực hiện',),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        dateTime == null ? 'Chưa chọn ngày' : 'Ngày chọn: ${DateFormat('dd/MM/yyyy').format(dateTime!)}',
                        style: TextStyle(
                            color: dateTime == null ? Colors.grey : null,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text('Chọn ngày'),
                        onPressed: () async{
                          var pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            if(pickedDate!=null){
                              dateTime = pickedDate;
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),

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
                            TransactionModel t = new TransactionModel(
                                type: _type!,
                                amount: double.parse(_amount.text),
                                category: _category.text,
                                note: _note.text,
                                dateTime: dateTime!
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
                          label: Text('Add'),
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