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
    if(_transactionVM!.isLoad && !isLoading){
      transactionList =_transactionVM!.transactionList;
      _generateDashboardData();
      isLoading = true;
      notifyListeners();
    }
  }

  double totalIncome = 0;
  double totalExpense = 0;
  double get balance => totalIncome - totalExpense;

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
  }
}