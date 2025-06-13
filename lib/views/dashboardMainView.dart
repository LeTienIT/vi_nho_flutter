import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboardMainVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import '../viewmodels/categoryVM.dart';
import '../widgets/money_box.dart';


class DashboardMainView extends StatelessWidget {
  const DashboardMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();
    final categoryVM = context.watch<CategoryVM>();
    if(!transactionVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }
    if(!categoryVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }
    else{
      final vm = context.watch<DashboardMainViewModel>();
      if(!vm.isLoading){
        return Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Tổng quan')),
        drawer: Text('menu'),
        body: vm.isLoading ?
        const Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodaySummary(context, vm),
              const SizedBox(height: 20),
              _buildWeekSummary(context, vm),
              const SizedBox(height: 20),
              _buildMonthSummary(context, vm),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.clear,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add),
                label: 'Thêm giao dịch',
                onTap: (){
                  if (categoryVM.categorySelect == null) {
                    categoryVM.setSelect(categoryVM.categoryList.first);
                  }
                  Navigator.pushNamed(context, '/transaction-add');
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.list),
                label: 'Danh sách',
                onTap: (){
                  Navigator.pushNamed(context, '/transaction-list');
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.settings),
                label: 'Cài đặt',
                onTap: (){
                  Navigator.pushNamed(context, '/setting');
                }
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTodaySummary(BuildContext context, DashboardMainViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hôm nay', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MoneyBox(label: 'Thu', amount: vm.todayIncome, color: Colors.green),
                MoneyBox(label: 'Chi', amount: vm.todayExpense, color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Biểu đồ theo danh mục'),
            const SizedBox(height: 8),
            // PieChartWidget(dataMap: vm.todayCategoryTotals),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary(BuildContext context, DashboardMainViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tuần này', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MoneyBox(label: 'Thu', amount: vm.weekIncome, color: Colors.green),
                MoneyBox(label: 'Chi', amount: vm.weekExpense, color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Biểu đồ theo danh mục'),
            const SizedBox(height: 8),
            // BarChartWidget(dataMap: vm.weekCategoryTotals),
            const SizedBox(height: 12),
            // ThreeStatsWidget(
            //   maxTransaction: vm.weekMaxTransaction,
            //   maxCategoryTotal: vm.weekMaxCategoryTotal,
            //   mostUsedCategory: vm.weekMostUsedCategory,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSummary(BuildContext context, DashboardMainViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tháng này', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MoneyBox(label: 'Thu', amount: vm.monthIncome, color: Colors.green),
                MoneyBox(label: 'Chi', amount: vm.monthExpense, color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Biểu đồ theo danh mục'),
            const SizedBox(height: 8),
            // PieChartWidget(dataMap: vm.monthCategoryTotals),
          ],
        ),
      ),
    );
  }
}
