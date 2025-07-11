
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';
import 'package:vi_nho/viewmodels/filterVM.dart';
import 'package:vi_nho/viewmodels/planVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/filter_transaction/filterSection.dart';
import 'package:vi_nho/widgets/transaction/transactionItem.dart';

import '../widgets/dashboard/menu.dart';

class TransactionListView extends StatefulWidget{
  const TransactionListView({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionListView();
}

class _TransactionListView extends State<TransactionListView>{
  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();
    final filterVM = context.watch<FilterVM>();
    final categoryVM = context.watch<CategoryVM>();
    final planVM = context.watch<PlanVM>();

    if(!transactionVM.isLoad || !categoryVM.isLoad || !planVM.isLoad){
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(child: Menu(),),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FilterSection(filterVM: filterVM, transactionVM: transactionVM,),
          Divider(),
          if(transactionVM.transactionList.isEmpty)...[
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
                itemCount: transactionVM.transactionList.length,
                itemBuilder: (context, index){
                  final item = transactionVM.transactionList[index];
                  final category = categoryVM.findName(item.category);
                  String? path;
                  if(category!=null){
                    if(category.icon != null && category.icon!.trim().isNotEmpty) {
                      path = category.icon;
                    }
                  }
                  return Dismissible(
                    key: Key(transactionVM.transactionList[index].id!.toString()),
                    direction: checkDismissDirection(item, planVM),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete),
                    ),
                    onDismissed: (direction){

                      transactionVM.deleteTransaction(transactionVM.transactionList[index].id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã xóa'),duration: Duration(seconds: 1),)
                      );
                    },
                    child: TransactionItem(
                      transactionModel: item,
                      path: path,
                      isActive: transactionVM.isActive(item.id!),
                      onTap: () {
                        transactionVM.setActiveItem(
                            transactionVM.isActive(item.id!) ? null : item.id!
                        );
                      },
                      onDetailPressed: () {
                        final selectedCategory = categoryVM.findName(item.category);
                        if (selectedCategory != null) {
                          categoryVM.setSelect(selectedCategory);
                        }
                        Navigator.pushNamed(context, '/transaction-edit',arguments: item);
                      },
                    ),
                  );
                },
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            if (categoryVM.categorySelect == null) {
              categoryVM.setSelect(categoryVM.categoryList.first);
            }
            Navigator.pushNamed(context, '/transaction-add');
          }
      ),
    );
  }

  DismissDirection checkDismissDirection(TransactionModel t, PlanVM vm){
    if(t.type == 'Tiết kiệm'){
      final p = vm.getP(t.savingID!);
      final now = DateTime.now();
      if(p.ngayKT.isBefore(DateTime(now.year,now.month,now.day))){
        return DismissDirection.none;
      }
    }
    return DismissDirection.endToStart;
  }
}