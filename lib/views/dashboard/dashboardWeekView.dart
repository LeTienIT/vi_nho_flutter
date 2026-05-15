import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardWeekVM.dart';
import 'package:vi_nho/widgets/dashboard/listView.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/dashboard/weekPicker.dart';
import '../../core/const_running.dart';
import '../../core/db_constants.dart';
import '../../core/tool.dart';
import '../../viewmodels/settingVM.dart';
import '../../viewmodels/transactionVM.dart';
import '../../widgets/dashboard/lineChart.dart';
import '../../widgets/dashboard/pieChart.dart';
import '../../widgets/dashboard/summaryCard.dart';
import '../../widgets/dashboard/topCategory.dart';

class DashboardWeekView extends StatelessWidget{
  const DashboardWeekView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();

    final dashboardWeekVM = context.watch<DashboardWeekVM>();
    final settingVM = context.watch<SettingVM>();
    final showTitle = (settingVM.getSync(SettingKey.showChartTitle) ?? 'true') == 'true';

    if(!transactionVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo tuần'),),
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
              noZero: true,
            ),
            SizedBox(height: 10),
            SummaryCard(
              tieuDe1: 'TB mỗi ngày thu',
              tieuDe2: 'TB mỗi lần tiêu',
              tongThu: dashboardWeekVM.averageIn,
              tongChi: dashboardWeekVM.averageEx,
              tieuDe: 'Trung bình mỗi ngày',
              noZero: true,
            ),

            SizedBox(height: 10),

            PieChartWidget(dashboardWeekVM.categoryChart,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: showTitle,),
            SizedBox(height: 10),
            LineChartWidget(dashboardWeekVM.dailyChart, data2: dashboardWeekVM.dailyIncome, tieuDe: 'Biểu đồ chi tiêu theo ngày',),

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