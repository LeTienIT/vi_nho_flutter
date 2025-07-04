import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/planVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/saving_plan/planItem.dart';

class PlanView extends StatelessWidget{
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final planVM = context.watch<PlanVM>();
    final transactionVM = context.watch<TransactionVM>();
    if(!planVM.isLoad){
      return Center(child: CircularProgressIndicator(),);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách các kế hoạch'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(planVM.list.isEmpty)...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8)
              ),
              width: double.infinity,
              child: Text(
                'Không có dữ liệu',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                ),
              ),
            ),
          ]
          else
            Expanded(
                child: ListView.builder(
                  itemCount: planVM.list.length,
                  itemBuilder: (context, idx){
                    final item = planVM.list[idx];
                    return Dismissible(
                      key: Key(item.id!.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('CẢNH BÁO'),
                            content: const Text(
                                'Bạn có chắc chắn muốn xóa kế hoạch này không?\n\n'
                                    'Việc xóa KẾ HOẠCH này sẽ đồng nghĩa XÓA CÁC GIAO DỊCH thuộc KẾ HOẠCH này!'
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('HỦY'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('XÓA', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },

                      onDismissed: (direction) async {
                        await planVM.delete(item.id!);
                        transactionVM.deleteSavingID(item.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã xóa kế hoạch'), duration: Duration(seconds: 1)),
                        );
                      },

                      child: PlanItem(plan: item),
                    );
                  },
                )
            )
        ]
      ),
    );
  }

}