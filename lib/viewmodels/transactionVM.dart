import 'package:flutter/material.dart';
import 'package:vi_nho/core/db_constants.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/services/database.dart';
class TransactionVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  final List<TransactionModel> _transactionList = [];

  final List<TransactionModel> transactionList = [];

  Future<void> initData() async{
    final data = await _db.selectAll();
    _transactionList.addAll(data);
    transactionList.addAll(data);
    isLoad = true;
    notifyListeners();
  }

  Future<void> insertTransaction(TransactionModel t) async{
    final id = await _db.insert(t);
    t.id = id;
    _transactionList.add(t);
    transactionList.add(t);
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async{
    await _db.delete(id);
    _transactionList.removeWhere((t) => t.id == id);
    transactionList.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}