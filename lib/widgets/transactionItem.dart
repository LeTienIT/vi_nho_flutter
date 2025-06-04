import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/transactionModel.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transactionModel;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDetailPressed;

  const TransactionItem({
    super.key,
    required this.transactionModel,
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
          color: isActive ? Colors.greenAccent : Colors.white,
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
        child: Row(
          children: [
            Expanded(
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
                  (transactionModel.note?.isEmpty ?? true)
                      ? '...'
                      : transactionModel.note!,
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
              ), // Giữ nguyên như cũ
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