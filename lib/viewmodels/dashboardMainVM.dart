import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vi_nho/core/tool.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transactionModel.dart';

class DashboardMainViewModel extends ChangeNotifier{
  TransactionVM? _transactionVM;
  List<TransactionModel>? listTransaction;
  bool isLoading = false;
  int year = DateTime.now().year;
  int weekNumber = Tool.getWeekOfYear(DateTime.now());

  DashboardMainViewModel(this._transactionVM) {
    if (_transactionVM != null) {
      if(_transactionVM!.isLoad){
        listTransaction =_transactionVM!.transactionList;
        _generateDashboardData();
        isLoading = true;
        notifyListeners();
      }
    }
  }

  void updateData(TransactionVM vm) {
    _transactionVM = vm;
    if(_transactionVM!.isLoad){
      listTransaction =_transactionVM!.listCore;
      _generateDashboardData();
      isLoading = true;
      notifyListeners();
    }
  }
  void _onTransactionChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    if(_transactionVM!=null){
      _transactionVM!.removeListener(_onTransactionChanged);
    }

    super.dispose();
  }


  double totalIncome = 0;
  double totalExpense = 0;
  double get balance => totalIncome - totalExpense;
  late double percentIn, percentEx;
  Map<String, double> categoryChart = {}; // PieChart
  List<FlSpot> dailyChart = []; // LineChart
  List<MapEntry<String, double>> topCategory = [];
  late List<TransactionModel> listTransactionSort;

  double averageIn = 0;
  double averageEx  = 0;

  // ------------ Hàm xử lý chính -----------------------------

  void _generateDashboardData() {
    if (listTransaction == null) return;

    totalIncome = 0.0; totalExpense = 0.0; percentEx = 0.0; percentIn = 0.0; averageIn = 0; averageEx = 0;
    topCategory = []; dailyChart = []; categoryChart = {}; listTransactionSort = [];

    final dailyMap = <int, double>{};
    final condition = Tool.getWeekRange(year, weekNumber);
    print(weekNumber);
    print(condition);
    var listTransactionWeek = filterTransactionsByWeek(listTransaction!, condition[0], condition[1]);
    print(listTransactionWeek);
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

      averageIn = totalIncome / 7;
      if(dailyMap.isNotEmpty) {
        averageEx = totalExpense / dailyMap.length;
      }

      double totalIncomeLast = 0.0, totalExpenseLast = 0.0;
      final conditionLast = Tool.getWeekRange(year, weekNumber-1);
      var listTransactionLastWeek = filterTransactionsByWeek(listTransaction!, conditionLast[0], conditionLast[1]);
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

  List<TransactionModel> filterTransactionsByWeek(
      List<TransactionModel> transactions,
      DateTime startDate,
      DateTime endDate,
      ) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    return transactions.where((tx) {
      final txDate = DateTime(tx.dateTime.year, tx.dateTime.month, tx.dateTime.day);
      return txDate.isAtSameMomentAs(start) ||
          txDate.isAtSameMomentAs(end) ||
          (txDate.isAfter(start) && txDate.isBefore(end));
    }).toList();
  }
}