import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vi_nho/core/tool.dart';
import 'package:vi_nho/models/transactionModel.dart';

class DashboardWeekVM extends ChangeNotifier{
  List<TransactionModel> listTransaction;
  int year;
  int weekNumber;

  late double totalIncome;
  late double totalExpense;
  late double percentIn, percentEx;
  late List<MapEntry<String, double>> topCategory;
  late List<FlSpot> dailyChart;
  late Map<String, double> categoryChart;
  late List<TransactionModel> listTransactionSort;
  DashboardWeekVM({required this.listTransaction, required this.weekNumber, required this.year}){
    _initData();
    notifyListeners();
  }

  void updateWeek(int newYear, int newWeek) {
    year = newYear;
    weekNumber = newWeek;
    _initData();
    notifyListeners();
  }

  void _initData(){
    totalIncome = 0.0; totalExpense = 0.0; percentEx = 0.0; percentIn = 0.0;
    topCategory = []; dailyChart = []; categoryChart = {}; listTransactionSort = [];

    final dailyMap = <int, double>{};
    final condition = Tool.getWeekRange(year, weekNumber);
    var listTransactionWeek = filterTransactionsByWeek(listTransaction, condition[0], condition[1]);
    for(var t in listTransactionWeek){
      if(t.type == 'Thu'){
        totalIncome+=t.amount;
      }else{
        totalExpense+=t.amount;
        categoryChart[t.category] = (categoryChart[t.category] ?? 0 ) + t.amount;
        dailyMap[t.dateTime.day] = (dailyMap[t.dateTime.day] ?? 0 ) + t.amount;
      }
    }
    topCategory = categoryChart.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    topCategory = topCategory.take(5).toList();

    final dailySort = dailyMap.keys.toList()..sort();
    dailyChart = dailySort.map((d) => FlSpot(d.toDouble(), dailyMap[d]!)).toList();

    listTransactionSort = listTransactionWeek..sort((a,b) => b.amount.compareTo(a.amount));
    listTransactionSort = listTransactionSort.where((t) => t.type != 'Thu').toList();
    listTransactionSort = listTransactionSort.take(5).toList();

    if(weekNumber > 1){
      double totalIncomeLast = 0.0, totalExpenseLast = 0.0;
      final conditionLast = Tool.getWeekRange(year, weekNumber-1);
      var listTransactionLastWeek = filterTransactionsByWeek(listTransaction, conditionLast[0], conditionLast[1]);
      for(var t in listTransactionLastWeek){
        if(t.type == 'Thu'){
          totalIncomeLast+=t.amount;
        }else{
          totalExpenseLast+=t.amount;
        }
        percentIn = ((totalIncome - totalIncomeLast) / totalIncomeLast ) * 100;
        percentEx = ((totalExpense - totalExpenseLast) / totalExpenseLast ) * 100;
      }
    }

  }

  // Lấy ra danh sách giao dịch trong tuần
  List<TransactionModel> filterTransactionsByWeek(List<TransactionModel> all, DateTime from, DateTime to) {
    return all.where((tx) =>
      tx.dateTime.isAfter(from.subtract(Duration(seconds: 1))) && tx.dateTime.isBefore(to.add(Duration(days: 1)))
    ).toList();
  }
}