import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transactionModel.dart';

class DashboardMainViewModel extends ChangeNotifier{
  TransactionVM? _transactionVM;
  List<TransactionModel>? transactionList;
  bool isLoading = false;

  DashboardMainViewModel(this._transactionVM) {
    if (_transactionVM != null) {
      if(_transactionVM!.isLoad){
        transactionList =_transactionVM!.transactionList;
        _generateDashboardData();
        isLoading = true;
        notifyListeners();
      }
    }
  }

  void updateData(TransactionVM vm) {
    _transactionVM = vm;
    if(_transactionVM!.isLoad){
      transactionList =_transactionVM!.listCore;
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

  Map<String, double> categoryExpenseMap = {}; // PieChart
  List<FlSpot> dailyExpenseSpots = []; // LineChart
  List<MapEntry<String, double>> topCategories = [];

  // ------------ Hàm xử lý chính -----------------------------

  void _generateDashboardData() {
    if (transactionList == null) return;

    final now = DateTime.now();
    final currentMonthList = transactionList!.where((tx) =>
    tx.dateTime.month == now.month && tx.dateTime.year == now.year);

    totalIncome = 0;
    totalExpense = 0;
    percentEx = 0.0; percentIn = 0.0;
    categoryExpenseMap.clear();

    final dailyMap = <int, double>{}; // day -> amount
    for (var tx in currentMonthList) {
      if (tx.type == 'Thu') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;

        // PieChart - category grouping
        categoryExpenseMap[tx.category] =
            (categoryExpenseMap[tx.category] ?? 0) + tx.amount;

        // LineChart - daily expense
        int day = tx.dateTime.day;
        dailyMap[day] = (dailyMap[day] ?? 0) + tx.amount;
      }
    }

    // LineChart: chuyển dailyMap => FlSpot
    final sortedDays = dailyMap.keys.toList()..sort();
    dailyExpenseSpots = sortedDays
        .map((day) => FlSpot(day.toDouble(), dailyMap[day]!))
        .toList();

    // Top category
    topCategories = categoryExpenseMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if(now.month > 1){
      double totalIncomeLast = 0.0, totalExpenseLast = 0.0;
      final lastList = transactionList!.where((t) => t.dateTime.month == now.month-1 && t.dateTime.year == now.year);
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
}