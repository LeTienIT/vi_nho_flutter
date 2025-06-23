import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transactionModel.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transactionModel;
  final String? path;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDetailPressed;

  const TransactionItem({
    super.key,
    required this.transactionModel,
    this.path,
    required this.isActive,
    required this.onTap,
    required this.onDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final inCome = transactionModel.type == 'Thu';


    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.greenAccent : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: (path!=null && path!.trim().isNotEmpty) ?
                    CircleAvatar(backgroundImage: FileImage(File(path!)), radius: 30,) : Icon(Icons.category,),
                title: Text(
                  '${transactionModel.category} • ${transactionModel.dateTimeString}',
                ),
                subtitle: Text(
                  (transactionModel.note?.isEmpty ?? true)
                      ? '...'
                      : transactionModel.note!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  (inCome ? '+ ' : '- ') + NumberFormat.currency(locale: 'vi').format(transactionModel.amount).toString(),
                  style: TextStyle(
                    color: inCome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Nút chi tiết (chỉ hiện khi active)
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onDetailPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}