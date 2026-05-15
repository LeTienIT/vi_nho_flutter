import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardMonthVM.dart';
import 'package:vi_nho/widgets/dashboard/monthPicker.dart';
import 'package:vi_nho/widgets/dashboard/summaryItem.dart';

import '../../core/const_running.dart';
import '../../core/db_constants.dart';
import '../../core/tool.dart';
import '../../viewmodels/settingVM.dart';
import '../../viewmodels/transactionVM.dart';
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
    final transactionVM = context.watch<TransactionVM>();

    final dashboardMonthVM = context.watch<DashboardMonthVM>();
    final settingVM = context.watch<SettingVM>();
    final showTitle = (settingVM.getSync(SettingKey.showChartTitle) ?? 'true') == 'true';

    if(!transactionVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo tháng'),),
      drawer: Drawer(child: Menu(),),
      floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 10,
          spaceBetweenChildren: 10,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,

          children: [
            SpeedDialChild(
              child: const Icon(Icons.dashboard),
              label: 'Báo cáo tuần',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard-week',
                        (router) => false,
                    arguments:{
                      'week' : Running.dashboardWeek > 0 ? Running.dashboardWeek : Tool.getWeekOfYear(DateTime.now()),
                      'year' : DateTime.now().year,
                      'transactions' : transactionVM.listCore
                    }
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.dashboard_outlined),
              label: 'Báo cáo năm',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard-year',
                        (router) => false,
                    arguments:{
                      'year' : Running.dashboardYear > 0 ? Running.dashboardYear : DateTime.now().year,
                      'transactions' : transactionVM.listCore
                    }
                );
              },
            ),
          ],
        ),
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

            PieChartWidget(dashboardMonthVM.categoryExpenseMap,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: showTitle,),
            SizedBox(height: 10),
            LineChartWidget(dashboardMonthVM.dailyExpenseSpots, data2: dashboardMonthVM.dailyIncome, tieuDe: 'Biểu đồ chi tiêu theo ngày',),

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