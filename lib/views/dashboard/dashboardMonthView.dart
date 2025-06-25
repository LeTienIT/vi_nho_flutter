import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardMonthVM.dart';
import 'package:vi_nho/widgets/dashboard/monthPicker.dart';

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

            CardTitle(
              label: 'TB một ngày thu',
              content: NumberFormat.currency(locale: 'vi').format(dashboardMonthVM.averageIn),
              labelStyle: Theme.of(context).textTheme.titleSmall,
              contentStyle: Theme.of(context).textTheme.headlineSmall,
            ),
            CardTitle(
              label: 'TB một lần tiêu',
              content: NumberFormat.currency(locale: 'vi').format(dashboardMonthVM.averageEx),
              labelStyle: Theme.of(context).textTheme.titleSmall,
              contentStyle: Theme.of(context).textTheme.headlineSmall,
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