import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardYearVM.dart';
import 'package:vi_nho/widgets/dashboard/cardTitle.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/dashboard/yearPicker.dart';

import '../../core/const_running.dart';
import '../../core/db_constants.dart';
import '../../core/tool.dart';
import '../../viewmodels/settingVM.dart';
import '../../viewmodels/transactionVM.dart';
import '../../widgets/dashboard/lineChart.dart';
import '../../widgets/dashboard/listView.dart';
import '../../widgets/dashboard/pieChart.dart';
import '../../widgets/dashboard/summaryCard.dart';
import '../../widgets/dashboard/topCategory.dart';

class DashboardYearView extends StatelessWidget{
  const DashboardYearView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();
    final dashboardYearVM = context.watch<DashboardYearVM>();
    final settingVM = context.watch<SettingVM>();
    final showTitle = (settingVM.getSync(SettingKey.showChartTitle) ?? 'true') == 'true';
    if(!transactionVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo năm'),),
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
              child: const Icon(Icons.dashboard_customize),
              label: 'Báo cáo tháng',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard-month',
                        (router) => false,
                    arguments:{
                      'month' : Running.dashboardWeek > 0 ? Running.dashboardMonth : DateTime.now().month,
                      'year' : DateTime.now().year,
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
            PieChartWidget(dashboardYearVM.categoryExpenseMap,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: showTitle,),

            SizedBox(height: 10),
            PieChartWidget(dashboardYearVM.categoryIncomeMap,tieuDeBD: 'Biểu đồ phân loại thu',showTitle: showTitle,),

            SizedBox(height: 10),
            LineChartWidget(dashboardYearVM.monthExpenseSpots, tieuDe: 'Biểu đồ chi tiêu', data2: dashboardYearVM.monthIncomeSpots, showBelow: true,),

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