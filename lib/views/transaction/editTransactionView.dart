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

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDisableBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Giao dịch thuộc gói tiết kiệm đã kết thúc.\nKhông thể chỉnh sửa.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    if (dateTime == null) {
      SnackBar(
        content: Text('Ngày không được để trống'),
        backgroundColor: Colors.red,
      );
      return;
    }

    final vm = context.read<PlanVM>();

    if (_type == 'Tiết kiệm') {
      final p = vm.getP(widget.transactionModel.savingID!);
      if (dateTime!.isBefore(p.ngayBD) || dateTime!.isAfter(p.ngayKT)) {
        SnackBar(
          content: Text('Ngày không thuộc gói tiết kiệm'),
          backgroundColor: Colors.red,
        );
        return;
      }
    }

    final t = TransactionModel(
      id: widget.transactionModel.id,
      type: _type!,
      amount: double.parse(_amount.text),
      category: context.read<CategoryVM>().categorySelect!.name,
      note: _note.text,
      dateTime: dateTime!,
      savingID: _type == 'Tiết kiệm'
          ? widget.transactionModel.savingID
          : -1,
    );

    try {
      final vm = context.read<TransactionVM>();
      await vm.updateTransaction(t, widget.transactionModel.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
       SnackBar(
        content: Text('$e'),
        backgroundColor: Colors.red,
      );
    }
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
        title: const Text('Cập nhật dữ liệu'),
        centerTitle: true,
      ),

      /// 🔥 BUTTON FIXED
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: enable ? _submitUpdate : null,
          icon: const Icon(Icons.update),
          label: const Text('Lưu thay đổi'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [

              /// 🔥 WARNING (nếu bị disable)
              if (!enable) _buildDisableBanner(),

              /// TYPE
              _buildCard(
                title: 'Kiểu giao dịch',
                subtitle: 'Phân loại thu / chi',
                child: TypeSelector(
                  selected: _type,
                  onChanged: (value) => setState(() => _type = value),
                  planID: planID,
                  enable: enable,
                ),
              ),

              /// CATEGORY
              _buildCard(
                title: 'Danh mục',
                subtitle: 'Phân loại chi tiêu',
                child: CategoryPicker(enable: enable),
              ),

              /// AMOUNT
              _buildCard(
                title: 'Số tiền',
                subtitle: 'Giá trị giao dịch',
                child: NumberForm(
                  amount: _amount,
                  title: 'Số tiền',
                  hint: 'VD: 20.000',
                  validator: InputValidators.amountValidator,
                  readOnly: !enable,
                ),
              ),

              /// NOTE
              _buildCard(
                title: 'Ghi chú',
                subtitle: 'Thông tin thêm',
                child: TextForm(
                  category: _note,
                  title: 'Ghi chú',
                  hint: 'Nhập nội dung...',
                  readOnly: !enable,
                ),
              ),

              /// DATE
              _buildCard(
                title: 'Thời gian',
                subtitle: 'Ngày thực hiện',
                child: DateTimeInput(
                  dateTime: dateTime,
                  enable: enable,
                  onPressed: (newDate) {
                    setState(() => dateTime = newDate);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}