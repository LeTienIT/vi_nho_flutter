import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/transactionModel.dart';

import '../../viewmodels/categoryVM.dart';
import '../transaction/transactionItem.dart';

class ListViewTransaction extends StatelessWidget{
  List<TransactionModel> data;
  String titleList;
  ListViewTransaction({super.key, required this.data, this.titleList = 'Danh sách'});

  @override
  Widget build(BuildContext context) {
    if(!data.isNotEmpty) {
      return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Top các giao dịch trong tuần',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(16),
                child: Text('Không có dữ liệu',style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,),
              )
            ],
          )
      );
    }
    final categoryVM = context.watch<CategoryVM>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Top các giao dịch',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          )
        ),
        ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = data[index];
            final category = categoryVM.findName(item.category);
            String? path;
            if (category != null && category.icon?.trim().isNotEmpty == true) {
              path = category.icon;
            }
            return TransactionItem(
              transactionModel: item,
              path: path,
              isActive: false,
              onTap: () {},
              onDetailPressed: () {},
            );
          },
        ),
      ],
    );
  }

}