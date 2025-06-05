import 'package:flutter/material.dart';
import 'package:vi_nho/core/db_constants.dart';
import 'package:vi_nho/models/filterModel.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/services/database.dart';
class TransactionVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  int? _activeItemId;
  FilterCondition? _filterCondition;

  final List<TransactionModel> _transactionList = [];
  List<TransactionModel> _transactionFilter = [];

  List<TransactionModel> get transactionList => _transactionFilter;

  void setActiveItem(int? id) {
    _activeItemId = id;
    notifyListeners();
  }

  bool isActive(int id) {
    return _activeItemId == id;
  }

  Future<void> initData() async{
    final data = await _db.selectAllTransaction();
    _transactionList.addAll(data);
    _transactionFilter = List.from(_transactionList);
    isLoad = true;
    notifyListeners();
  }

  Future<void> insertTransaction(TransactionModel t) async{
    final id = await _db.insert(t);
    t.id = id;
    _transactionList.add(t);
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
    }
    else{
      _filterTransaction();
    }
  }

  Future<void> updateTransaction(TransactionModel t, int id) async{
    await _db.update(t, id);

    int indexPrivate =_transactionList.indexWhere((t) => t.id == id) as int;
    if(indexPrivate != -1){
      _transactionList[indexPrivate] = t;
      if(_filterCondition == null){
        _transactionFilter = List.from(_transactionList);
        notifyListeners();
      }
      else{
        _filterTransaction();
      }
    }
  }

  Future<void> deleteTransaction(int id) async{
    await _db.delete(id);
    _transactionList.removeWhere((t) => t.id == id);
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
    }
    else{
      _filterTransaction();
    }
  }

  void _filterTransaction(){
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
      return;
    }

    final condition = _filterCondition!;
    _transactionFilter = _transactionList.where((e){
      switch(condition.field){
        case FilterField.amount:
          final amount = e.amount;
          final filterValue = condition.value as double;
          switch (condition.operator) {
            case FilterOperator.greaterThan:
              return amount > filterValue;
            case FilterOperator.lessThan:
              return amount < filterValue;
            case FilterOperator.equal:
              return amount == filterValue;
            default:
              return true;
          }
        case FilterField.date:
          final date = e.dateTime;
          final filterValue = condition.value as DateTime;
          return date.year == filterValue.year &&
              date.month == filterValue.month &&
              date.day == filterValue.day;

        case FilterField.category:
          final cat = e.category.toLowerCase();
          final val = (condition.value as String).toLowerCase();
          return cat.contains(val);

        case FilterField.note:
          if(e.note != null){
            final note = e.note!.toLowerCase();
            final val = (condition.value as String).toLowerCase();
            return note.contains(val);
          }
          else {
            return false;
          }
      }
    }).toList();

    notifyListeners();
  }

  void applyFilter(FilterCondition? condition){
    _filterCondition = condition;
    _filterTransaction();
  }

  void clearFilter(){
    _filterCondition = null;
    _filterTransaction();
  }

}