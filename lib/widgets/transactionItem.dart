
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vi_nho/models/transactionModel.dart';

class TransactionItem extends StatelessWidget{
  TransactionModel transactionModel;

  TransactionItem({super.key, required this.transactionModel});

  @override
  Widget build(BuildContext context) {
    final inCome = transactionModel.type == 'Thu';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          Icons.category,
          color: Colors.blueAccent,
        ),
        title: Text(
          '${transactionModel.category} • ${transactionModel.dateTimeString}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          (transactionModel.note?.isEmpty ?? true) ? '...' : transactionModel.note!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          (inCome ? '+' : '-') + transactionModel.amount.toString(),
          style: TextStyle(
            color: inCome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

}