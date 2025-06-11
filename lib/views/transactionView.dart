
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';
import 'package:vi_nho/viewmodels/filterVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/filterSection.dart';
import 'package:vi_nho/widgets/transactionItem.dart';

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

    if(!transactionVM.isLoad || !categoryVM.isLoad){
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
                  return Dismissible(
                    key: Key(transactionVM.transactionList[index].id!.toString()),
                    direction: DismissDirection.endToStart,
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.clear,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              label: 'Thêm giao dịch',
              onTap: (){
                if (categoryVM.categorySelect != null) {
                  categoryVM.setSelect(categoryVM.categoryList.first);
                }
                Navigator.pushNamed(context, '/transaction-add');
              }
          ),
          SpeedDialChild(
              child: Icon(Icons.settings),
              label: 'Cài đặt',
              onTap: (){
                Navigator.pushNamed(context, '/setting');
              }
          )
        ],
      ),
    );
  }
}