import 'package:flutter/material.dart';
import 'package:vi_nho/core/db_constants.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/services/database.dart';
class TransactionVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  int? _activeItemId;
  final List<TransactionModel> _transactionList = [];

  final List<TransactionModel> transactionList = [];

  void setActiveItem(int? id) {
    _activeItemId = id;
    notifyListeners();
  }

  bool isActive(int id) {
    return _activeItemId == id;
  }

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

  Future<void> updateTransaction(TransactionModel t, int id) async{
    await _db.update(t, id);

    int indexPrivate =_transactionList.indexWhere((t) => t.id == id) as int;
    if(indexPrivate != -1){
      _transactionList[indexPrivate] = t;
    }
    int indexPublic =transactionList.indexWhere((t) => t.id == id) as int;
    if(indexPublic != -1){
      transactionList[indexPublic] = t;
    }
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async{
    await _db.delete(id);
    _transactionList.removeWhere((t) => t.id == id);
    transactionList.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}