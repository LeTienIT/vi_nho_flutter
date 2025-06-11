import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/widgets/categoryPicker.dart';

import '../core/input_validators.dart';
import '../viewmodels/categoryVM.dart';
import '../viewmodels/transactionVM.dart';
import '../widgets/dateTimeInput.dart';
import '../widgets/numberForm.dart';
import '../widgets/sessionTitle.dart';
import '../widgets/textForm.dart';
import '../widgets/typeSelector.dart';

class EditTransactionView extends StatefulWidget{

  TransactionModel transactionModel;

  EditTransactionView({required this.transactionModel, super.key});

  @override
  State<StatefulWidget> createState() => _EditTransactionView();

}

class _EditTransactionView extends State<EditTransactionView> {
  late String? _type;
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late DateTime? dateTime;
  late final CategoryVM categoryVM;

  @override
  void initState(){
    super.initState();
    categoryVM = context.read<CategoryVM>();

    _type = widget.transactionModel.type;
    _amount = TextEditingController(text: widget.transactionModel.amount.toString());
    _note = TextEditingController(text: widget.transactionModel.note);
    dateTime = widget.transactionModel.dateTime;
  }

  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cập nhật dữ liệu',
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
                              TransactionModel t = TransactionModel(
                                  id: widget.transactionModel.id,
                                  type: _type!,
                                  amount: double.parse(_amount.text),
                                  category: context.read<CategoryVM>().categorySelect!.name,
                                  note: _note.text,
                                  dateTime: dateTime!
                              );

                              try {
                                final vm = context.read<TransactionVM>();
                                await vm.updateTransaction(t, widget.transactionModel.id!);
                                if(!mounted)return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Cập nhật dữ liệu thành công'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lỗi khi cập nhật dữ liệu: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            label: Text('Update'),
                            icon: Icon(Icons.update),
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