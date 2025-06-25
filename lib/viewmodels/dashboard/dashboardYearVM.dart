import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../../models/transactionModel.dart';

class DashboardYearVM extends ChangeNotifier{
  List<TransactionModel> listTransaction;
  int year;

  double totalIncome = 0;
  double totalExpense = 0;
  double get averageIn => totalIncome / 12;
  double get averageEx => totalExpense / 12;
  double get balance => totalIncome - totalExpense;
  late double percentIn, percentEx, balancePercent;

  Map<String, double> categoryIncomeMap = {}; // Biểu đồ tròn thu
  Map<String, double> categoryExpenseMap = {}; // Biểu đồ tròn chi
  List<FlSpot> monthIncomeSpots = []; // Biểu đồ đường Thu
  List<FlSpot> monthExpenseSpots = []; // Biểu đồ đường chi
  List<MapEntry<String, double>> topCategories = []; // Danh sách top các category chi nhiều nhất => lấy TOP 5
  List<TransactionModel> listTransactionSort = []; // Danh sách các giao dịch chi nhiều nhất => lấy TOP 5

  List<MapEntry<int, double>> topMonthEx = [], topMonthIn = [];
  DashboardYearVM({required this.listTransaction, required this.year}){
    _initData();
    notifyListeners();
  }

  void _initData(){
    totalIncome = 0;totalExpense = 0;percentEx = 0.0; percentIn = 0.0;balancePercent = 0.0;
    categoryIncomeMap.clear();categoryExpenseMap.clear();
    monthExpenseSpots.clear();topCategories.clear();listTransactionSort.clear();
    topMonthEx.clear(); topMonthIn.clear();

    final currentList = listTransaction.where((t) => t.dateTime.year == year).toList();
    listTransactionSort = currentList..sort((a,b) => b.amount.compareTo(a.amount));
    listTransactionSort = listTransactionSort.where((t) => t.type != 'Thu').toList();
    listTransaction = listTransaction.take(5).toList();

    final monthExMap = <int, double>{};
    final monthInMap = <int, double>{};
    for(var tx in currentList) {
      if (tx.type == 'Thu') {
        totalIncome += tx.amount;
        categoryIncomeMap[tx.category] = (categoryIncomeMap[tx.category] ?? 0) + tx.amount;
        monthInMap[tx.dateTime.month] = (monthInMap[tx.dateTime.month] ?? 0 )+ tx.amount;

      } else {
        totalExpense += tx.amount;
        categoryExpenseMap[tx.category] = (categoryExpenseMap[tx.category] ?? 0) + tx.amount;
        int month = tx.dateTime.month;
        monthExMap[month] = (monthExMap[month] ?? 0) + tx.amount;
      }
    }
    final sortedMonths = monthExMap.keys.toList()..sort();
    monthExpenseSpots = sortedMonths
        .map((month) => FlSpot(month.toDouble(), monthExMap[month]!))
        .toList();

    final sortedSaveMonths = monthInMap.keys.toList()..sort();
    monthIncomeSpots = sortedSaveMonths
        .map((month) => FlSpot(month.toDouble(), monthInMap[month]!))
        .toList();

    // Top category
    topCategories = categoryExpenseMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    topMonthIn = monthInMap.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    topMonthIn = topMonthIn.take(5).toList();

    topMonthEx = monthExMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    topMonthEx = topMonthEx.take(5).toList();

    final lastList = listTransaction.where((t) => t.dateTime.year == (year-1)).toList();
    if(lastList.isNotEmpty){
      double totalIncomeLast = 0.0, totalExpenseLast = 0.0;
      for(var t in lastList){
        if(t.type == 'Thu'){
          totalIncomeLast+=t.amount;
        }else{
          totalExpenseLast+=t.amount;
        }
      }
      percentIn = ((totalIncome - totalIncomeLast) / totalIncomeLast ) * 100;
      percentEx = ((totalExpense - totalExpenseLast) / totalExpenseLast ) * 100;
      final balanceTmp = percentIn - percentEx;
      balancePercent = ((balance - balanceTmp) / balanceTmp ) * 100;
    }
  }

  void update(int year){
    this.year = year;
    _initData();
    notifyListeners();
  }

}