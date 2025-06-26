import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardMonthVM.dart';
import 'package:vi_nho/widgets/dashboard/monthPicker.dart';
import 'package:vi_nho/widgets/dashboard/summaryItem.dart';

import '../../widgets/dashboard/cardTitle.dart';
import '../../widgets/dashboard/lineChart.dart';
import '../../widgets/dashboard/listView.dart';
import '../../widgets/dashboard/menu.dart';
import '../../widgets/dashboard/pieChart.dart';
import '../../widgets/dashboard/summaryCard.dart';
import '../../widgets/dashboard/topCategory.dart';

class DashboardMonthView extends StatelessWidget{
  const DashboardMonthView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardMonthVM = context.watch<DashboardMonthVM>();
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo tháng'),),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MonthPicker(
                monthCurrent: dashboardMonthVM.monthNumber,
                year: dashboardMonthVM.year,
                onChanged: (value){
                  if(value!=null){
                    dashboardMonthVM.updateDate(DateTime.now().year, value);
                  }
                }),

            SummaryCard(
              tongThu: dashboardMonthVM.totalIncome,
              tongChi: dashboardMonthVM.totalExpense,
              tieuDe: 'Tổng quát chi tiêu',
              percentIn: dashboardMonthVM.percentIn,
              percentEx: dashboardMonthVM.percentEx,
            ),

            SummaryCard(
              tieuDe1: 'TB mỗi ngày thu',
              tieuDe2: 'TB mỗi lần tiêu',
              tongThu: dashboardMonthVM.averageIn,
              tongChi: dashboardMonthVM.averageEx,
              tieuDe: 'Trung bình mỗi ngày',
            ),

            SizedBox(height: 10),

            PieChartWidget(dashboardMonthVM.categoryExpenseMap,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: false,),
            SizedBox(height: 10),
            LineChartWidget(dashboardMonthVM.dailyExpenseSpots, tieuDe: 'Biểu đồ chi tiêu theo ngày',),

            SizedBox(height: 10,),
            TopCategory(dashboardMonthVM.topCategories),

            SizedBox(height: 10,),
            ListViewTransaction(data: dashboardMonthVM.listTransactionSort,titleList: 'Top các giao dịch',),
          ],
        ),
      ),
    );
  }

}