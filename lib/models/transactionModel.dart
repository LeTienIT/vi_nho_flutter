
import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:vi_nho/core/db_constants.dart';
class TransactionModel{
  int? id;
  String type;
  double amount;
  String category;
  String? note;
  DateTime dateTime;

  TransactionModel({
      this.id,
      required this.type,
      required this.amount,
      required this.category,
      this.note = '...',
      required this.dateTime});

  Map<String, dynamic> toMap() => {
    DBConstants.columnId : id,
    DBConstants.columnType: type,
    DBConstants.columnAmount: amount,
    DBConstants.columnCategory: category,
    DBConstants.columnNote: note,
    DBConstants.columnDateTime: dateTime.toIso8601String()
  };

  factory TransactionModel.fromMap(Map<String, dynamic> transaction){
    return TransactionModel(
        id: transaction[DBConstants.columnId] as int?,
        type: transaction[DBConstants.columnType] as String,
        amount: transaction[DBConstants.columnAmount] as double,
        category: transaction[DBConstants.columnCategory] as String,
        note: (transaction[DBConstants.columnNote]?.isEmpty ?? true) ? '...' : transaction[DBConstants.columnNote]!,
        dateTime: DateTime.parse(transaction[DBConstants.columnDateTime] as String)
    );
  }

  String get dateTimeString => DateFormat('dd/MM/yyyy').format(dateTime);

}