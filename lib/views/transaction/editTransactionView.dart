import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/widgets/transaction/categoryPicker.dart';

import '../../core/input_validators.dart';
import '../../viewmodels/categoryVM.dart';
import '../../viewmodels/planVM.dart';
import '../../viewmodels/transactionVM.dart';
import '../../widgets/dateTimeInput.dart';
import '../../widgets/numberForm.dart';
import '../../widgets/sessionTitle.dart';
import '../../widgets/textForm.dart';
import '../../widgets/typeSelector.dart';

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
  late bool _showDiaLog;
  @override
  void initState(){
    super.initState();
    categoryVM = context.read<CategoryVM>();

    _type = widget.transactionModel.type;
    _amount = TextEditingController(text: widget.transactionModel.amount.toString());
    _note = TextEditingController(text: widget.transactionModel.note);
    dateTime = widget.transactionModel.dateTime;
    _showDiaLog = false;
  }

  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlanVM>();
    if(!vm.isLoad){
      return Center(child: CircularProgressIndicator(),);
    }
    int planID = -1;
    bool enable = true;
    if(vm.checkOpenPlan()['rs'] == 1){
      planID = vm.checkOpenPlan()['id']!;
      if(planID != widget.transactionModel.savingID){
        planID = -1;
      }
    }

    if(widget.transactionModel.type == 'Tiết kiệm'){
      final p = vm.getP(widget.transactionModel.savingID!);
      final now = DateTime.now();
      if(p.ngayKT.isBefore(DateTime(now.year,now.month,now.day))){
        enable = false;
        if(!_showDiaLog)
        {
          _showDiaLog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
                context: context,
                builder: (_){
                  return AlertDialog(
                    title: Text('Thông báo'),
                    content: Text('Giao dịch này thuộc 1 gòi tiết kiệm.\n Và gói tiết kiệm hiện tại đã kết thúc (hết hạn).\nVì vậy không thể chỉnh sửa.'),
                    actions: [
                      IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.close)),
                    ],
                  );
                }
            );
          });
        }
      }
    }
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
                    planID: planID,
                    enable: enable,
                  ),

                  SessionTitle(title: 'Loại', subtitle: 'Phân loại để quản lý chi tiêu',),
                  CategoryPicker(enable: enable,),

                  SessionTitle(title: 'Số lượng', subtitle: 'Số tiền chi trả cho việc này',),
                  NumberForm(amount: _amount, title: 'Số tiền', hint: 'VD: 20.000', validator: InputValidators.amountValidator,readOnly: !enable,),

                  SessionTitle(title: 'Note',subtitle: 'Ghi chú để xem lại',),
                  TextForm(category: _note, title: 'Ghi chú', hint: 'ghi lại nhưng gì cần', readOnly: !enable,),

                  SessionTitle(title: 'Thời gian',subtitle: 'Ngày thực hiện',),
                  DateTimeInput(dateTime: dateTime, enable: enable, onPressed:  (newDate) { setState(() {dateTime = newDate;});}),

                  Divider(),

                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton.icon(
                            onPressed: enable ? () async{
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
                                final p = vm.getP(widget.transactionModel.savingID!);
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
                                  id: widget.transactionModel.id,
                                  type: _type!,
                                  amount: double.parse(_amount.text),
                                  category: context.read<CategoryVM>().categorySelect!.name,
                                  note: _note.text,
                                  dateTime: dateTime!,
                                  savingID: _type == 'Tiết kiệm' ? widget.transactionModel.savingID : -1
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
                              }
                              catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lỗi khi cập nhật dữ liệu: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } : null,
                            label: Text('Lưu'),
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