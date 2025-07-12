import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vi_nho/core/tool.dart';
import '../../models/transactionModel.dart';

class DashboardMonthVM extends ChangeNotifier{
  List<TransactionModel> listTransaction;
  int year;
  int monthNumber;

  double totalIncome = 0;
  double totalExpense = 0;
  double averageIn = 0;
  double averageEx  = 0;
  double get balance => totalIncome - totalExpense;
  late double percentIn, percentEx;

  Map<String, double> categoryExpenseMap = {}; // PieChart
  List<FlSpot> dailyExpenseSpots = []; // LineChart
  List<MapEntry<String, double>> topCategories = [];
  List<TransactionModel> listTransactionSort = [];
  DashboardMonthVM({required this.listTransaction, required this.year, required this.monthNumber}){
    _initData();
    notifyListeners();
  }

  void _initData(){
    totalIncome = 0;totalExpense = 0;percentEx = 0.0; percentIn = 0.0; averageIn = 0; averageEx = 0;
    categoryExpenseMap.clear();dailyExpenseSpots.clear();topCategories.clear();listTransactionSort.clear();

    final currentList = listTransaction.where((t) => t.dateTime.month == monthNumber && t.dateTime.year == year).toList();
    listTransactionSort = currentList..sort((a,b) => b.amount.compareTo(a.amount));
    listTransactionSort = listTransactionSort.where((t) => t.type != 'Thu').toList();
    listTransactionSort = listTransactionSort.take(5).toList();
    final dailyMap = <int, double>{};
    for(var tx in currentList){
      if (tx.type == 'Thu') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;

        categoryExpenseMap[tx.category] =
            (categoryExpenseMap[tx.category] ?? 0) + tx.amount;

        int day = tx.dateTime.day;
        dailyMap[day] = (dailyMap[day] ?? 0) + tx.amount;
      }
    }
    averageIn = totalIncome / DateTime(year,monthNumber+1,0).day;
    averageEx = totalExpense / dailyMap.length;

    final sortedDays = dailyMap.keys.toList()..sort();
    dailyExpenseSpots = sortedDays
        .map((day) => FlSpot(day.toDouble(), dailyMap[day]!))
        .toList();

    // Top category
    topCategories = categoryExpenseMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if(monthNumber > 1){
      double totalIncomeLast = 0.0, totalExpenseLast = 0.0;
      final lastList = listTransaction.where((t) => t.dateTime.month == monthNumber-1 && t.dateTime.year == year);
      for(var t in lastList){
        if(t.type == 'Thu'){
          totalIncomeLast+=t.amount;
        }else{
          totalExpenseLast+=t.amount;
        }
      }
      percentIn = ((totalIncome - totalIncomeLast) / totalIncomeLast ) * 100;
      percentEx = ((totalExpense - totalExpenseLast) / totalExpenseLast ) * 100;
    }
  }

  void updateDate(int year, int month){
    monthNumber = month;
    year = year;
    _initData();
    notifyListeners();
  }
}