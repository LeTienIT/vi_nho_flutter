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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
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

  Future<void> _submit(vm, planID) async {
    if (!_formKey.currentState!.validate()) return;

    if (dateTime == null) {
      _showError('Ngày không được để trống');
      return;
    }

    if (_type == 'Tiết kiệm') {
      final p = vm.getP(planID);
      if (dateTime!.isBefore(p.ngayBD) || dateTime!.isAfter(p.ngayKT)) {
        _showError('Ngày không thuộc gói tiết kiệm');
        return;
      }
    }

    final t = TransactionModel(
      type: _type!,
      amount: double.parse(_amount.text),
      category: context.read<CategoryVM>().categorySelect!.name,
      note: _note.text,
      dateTime: dateTime!,
      savingID: _type == 'Tiết kiệm' ? planID : -1,
    );

    try {
      final vm = context.read<TransactionVM>();
      await vm.insertTransaction(t);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thêm thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showError('Lỗi: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
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
        title: const Text('Nhập dữ liệu'),
        centerTitle: true,
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: (){
            _submit(vm, planID);
          },
          icon: const Icon(Icons.add),
          label: const Text('Thêm giao dịch'),
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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            children: [

              _buildCard(
                title: 'Kiểu giao dịch',
                subtitle: 'Phân loại thu / chi',
                child: TypeSelector(
                  selected: _type,
                  onChanged: (value) {
                    setState(() => _type = value);
                  },
                  planID: planID,
                ),
              ),
              _buildCard(
                title: 'Loại',
                subtitle: 'Phân loại để quản lý',
                child: CategoryPicker(),
              ),
              _buildCard(
                title: 'Số tiền',
                subtitle: 'Nhập số tiền',
                child: NumberForm(
                  amount: _amount,
                  title: 'Số tiền',
                  hint: 'VD: 20.000',
                  validator: InputValidators.amountValidator,
                ),
              ),
              _buildCard(
                title: 'Ghi chú',
                subtitle: 'Thông tin thêm',
                child: TextForm(
                  category: _note,
                  title: 'Ghi chú',
                  hint: 'Nhập nội dung...',
                ),
              ),

              /// 🔹 DATE
              _buildCard(
                title: 'Thời gian',
                subtitle: 'Ngày thực hiện',
                child: DateTimeInput(
                  dateTime: dateTime,
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