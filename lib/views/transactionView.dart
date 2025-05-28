
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/transactionItem.dart';

class TransactionListView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TransactionListView();
}

class _TransactionListView extends State<TransactionListView>{
  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/transaction-add');
              },
              icon: Icon(Icons.add)
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(),
          transactionVM.transactionList.isEmpty ?
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
          ) :
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
                    child: TransactionItem(transactionModel: item,
                      isActive: transactionVM.isActive(item.id!),
                      onTap: () {
                        transactionVM.setActiveItem(
                            transactionVM.isActive(item.id!) ? null : item.id!
                        );
                      },
                      onDetailPressed: () {
                        Navigator.pushNamed(context, '/transaction-edit',arguments: item);
                      },
                    ),
                  );
                },
              )
          ),

        ],
      ),
    );
  }
}