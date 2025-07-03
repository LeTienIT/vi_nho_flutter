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
    final inSaving = transactionModel.type == 'Tiết kiệm';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: inSaving
              ? Colors.orangeAccent.withValues(alpha: 0.2)
              : (isActive ? Colors.greenAccent : Theme.of(context).cardTheme.color),
          borderRadius: BorderRadius.circular(12),
          border: inSaving
              ? Border.all(color: Colors.orange, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: inSaving ? Colors.orange.withOpacity(0.4) : Colors.black12,
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: (path != null && path!.trim().isNotEmpty)
              ? CircleAvatar(
            backgroundImage: FileImage(File(path!)),
            radius: 30,
          )
              : const Icon(Icons.category),
          title: Text(
            '${transactionModel.category} • ${transactionModel.dateTimeString}',
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            (transactionModel.note?.isEmpty ?? true)
                ? '...'
                : transactionModel.note!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (inSaving)
                    const Icon(Icons.savings, color: Colors.orange, size: 20),
                  Text(
                        NumberFormat.currency(locale: 'vi')
                            .format(transactionModel.amount)
                            .toString(),
                    style: TextStyle(
                      color: inSaving ? Colors.orange : (inCome ? Colors.green : Colors.red),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (isActive)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 21),
                  onPressed: onDetailPressed,
                  padding: const EdgeInsets.only(left: 8.0),
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );

  }
}