import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';

import '../models/transactionModel.dart';

class DashboardMainViewModel extends ChangeNotifier{
  TransactionVM? _transactionVM;
  double todayIncome = 0;
  double todayExpense = 0;

  double weekIncome = 0;
  double weekExpense = 0;

  double monthIncome = 0;
  double monthExpense = 0;

  Map<String, double> todayCategoryTotals = {};
  Map<String, double> weekCategoryTotals = {};
  Map<String, double> monthCategoryTotals = {};

  TransactionModel? largestWeekExpense;
  String? mostUsedCategoryWeek;
  String? categoryWithMaxAmountWeek;

  bool isLoading = false;

  DashboardMainViewModel(this._transactionVM) {
    if (_transactionVM != null) {
      generateDashboard();
    }
  }

  void updateData(TransactionVM vm) {
    _transactionVM = vm;
    generateDashboard();
  }

  void generateDashboard(){
    final list = _transactionVM!.transactionList;

    final now = DateTime.now();
    todayIncome = 0;
    todayExpense = 0;
    weekIncome = 0;
    weekExpense = 0;
    monthIncome = 0;
    monthExpense = 0;

    todayCategoryTotals.clear();
    weekCategoryTotals.clear();
    monthCategoryTotals.clear();

    Map<String, double> categoryAmountWeek = {};
    Map<String, int> categoryCountWeek = {};
    double maxExpense = 0;
    TransactionModel? maxExpenseTx;

    for (final tx in list) {
      final date = tx.dateTime;
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      final isSameWeek = isSameISOWeek(date, now);
      final isSameMonth = date.year == now.year && date.month == now.month;

      if (isToday) {
        if (tx.type == 'Thu') todayIncome += tx.amount;
        if (tx.type == 'Chi') todayExpense += tx.amount;
        todayCategoryTotals[tx.category] = (todayCategoryTotals[tx.category] ?? 0) + tx.amount;
      }

      if (isSameWeek) {
        if (tx.type == 'Thu') weekIncome += tx.amount;
        if (tx.type == 'Chi') {
          weekExpense += tx.amount;
          if (tx.amount > maxExpense) {
            maxExpense = tx.amount;
            maxExpenseTx = tx;
          }
        }
        categoryAmountWeek[tx.category] = (categoryAmountWeek[tx.category] ?? 0) + tx.amount;
        categoryCountWeek[tx.category] = (categoryCountWeek[tx.category] ?? 0) + 1;
        weekCategoryTotals[tx.category] = categoryAmountWeek[tx.category]!;
      }

      if (isSameMonth) {
        if (tx.type == 'Thu') monthIncome += tx.amount;
        if (tx.type == 'Chi') monthExpense += tx.amount;
        monthCategoryTotals[tx.category] = (monthCategoryTotals[tx.category] ?? 0) + tx.amount;
      }
    }

    largestWeekExpense = maxExpenseTx;
    categoryWithMaxAmountWeek = _getMaxKey(categoryAmountWeek);
    mostUsedCategoryWeek = _getMaxKey(categoryCountWeek);
    isLoading = true;
    notifyListeners();
  }

  String? _getMaxKey(Map<String, num> data) {
    if (data.isEmpty) return null;

    // Ép kiểu sang MapEntry<String, double>
    final entries = data.entries
        .map((e) => MapEntry(e.key, e.value.toDouble()))
        .toList();

    return entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  bool isSameISOWeek(DateTime d1, DateTime d2) {
    final monday1 = d1.subtract(Duration(days: d1.weekday - 1));
    final monday2 = d2.subtract(Duration(days: d2.weekday - 1));
    return monday1.year == monday2.year && monday1.month == monday2.month && monday1.day == monday2.day;
  }
}