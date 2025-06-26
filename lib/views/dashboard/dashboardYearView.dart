import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardYearVM.dart';
import 'package:vi_nho/widgets/dashboard/cardTitle.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/dashboard/yearPicker.dart';

import '../../widgets/dashboard/lineChart.dart';
import '../../widgets/dashboard/listView.dart';
import '../../widgets/dashboard/pieChart.dart';
import '../../widgets/dashboard/summaryCard.dart';
import '../../widgets/dashboard/topCategory.dart';

class DashboardYearView extends StatelessWidget{
  const DashboardYearView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardYearVM = context.watch<DashboardYearVM>();
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo năm'),),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            YearPickerWidget(
                onChanged: (value){
                  if(value != null){
                    dashboardYearVM.update(value);
                  }
                },
                year: dashboardYearVM.year,
            ),
            SummaryCard(
              tongThu: dashboardYearVM.totalIncome,
              tongChi: dashboardYearVM.totalExpense,
              chechLech: dashboardYearVM.balance,
              tieuDe: 'Tổng quát chi tiêu',
              percentIn: dashboardYearVM.percentIn,
              percentEx: dashboardYearVM.percentEx,
              balancePercent: dashboardYearVM.balancePercent,
            ),

            SummaryCard(
              tieuDe1: 'TB mỗi tháng thu',
              tieuDe2: 'TB mỗi tháng tiêu',
              tongThu: dashboardYearVM.averageIn,
              tongChi: dashboardYearVM.averageEx,
              tieuDe: 'Trung bình mỗi tháng',
            ),

            SizedBox(height: 10),
            PieChartWidget(dashboardYearVM.categoryExpenseMap,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: false,),

            SizedBox(height: 10),
            PieChartWidget(dashboardYearVM.categoryIncomeMap,tieuDeBD: 'Biểu đồ phân loại thu',showTitle: false,),

            SizedBox(height: 10),
            LineChartWidget(dashboardYearVM.monthExpenseSpots, tieuDe: 'Biểu đồ chi tiêu', data2: dashboardYearVM.monthIncomeSpots, showBelow: false,),

            SizedBox(height: 10,),
            TopCategory(dashboardYearVM.topCategories),

            SizedBox(height: 10,),
            ListViewTransaction(data: dashboardYearVM.listTransactionSort,titleList: 'Top các giao dịch',)
          ],
        ),
      ),
    );
  }
}