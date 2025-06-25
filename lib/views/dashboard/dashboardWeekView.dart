import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardWeekVM.dart';
import 'package:vi_nho/widgets/dashboard/listView.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/dashboard/weekPicker.dart';
import '../../widgets/dashboard/lineChart.dart';
import '../../widgets/dashboard/pieChart.dart';
import '../../widgets/dashboard/summaryCard.dart';
import '../../widgets/dashboard/topCategory.dart';

class DashboardWeekView extends StatelessWidget{
  const DashboardWeekView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardWeekVM = context.watch<DashboardWeekVM>();
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo tuần'),),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WeekPicker(
                year: DateTime.now().year,
                initWeek: dashboardWeekVM.weekNumber,
                onChange: (value){
                  dashboardWeekVM.updateWeek(DateTime.now().year, value);
                }
            ),
            SummaryCard(
              tongThu: dashboardWeekVM.totalIncome,
              tongChi: dashboardWeekVM.totalExpense,
              tieuDe: 'Tổng quát chi tiêu',
              percentIn: dashboardWeekVM.percentIn,
              percentEx: dashboardWeekVM.percentEx,
            ),
            SizedBox(height: 10),

            PieChartWidget(dashboardWeekVM.categoryChart,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: false,),
            SizedBox(height: 10),
            LineChartWidget(dashboardWeekVM.dailyChart, tieuDe: 'Biểu đồ chi tiêu theo ngày',),

            SizedBox(height: 10,),
            TopCategory(dashboardWeekVM.topCategory),

            SizedBox(height: 10,),
            ListViewTransaction(data: dashboardWeekVM.listTransactionSort,titleList: 'Top các giao dịch',),
          ],
        ),
      )
    );
  }

}