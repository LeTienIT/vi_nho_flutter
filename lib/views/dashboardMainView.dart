import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/core/tool.dart';
import 'package:vi_nho/viewmodels/dashboardMainVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/dashboard/lineChart.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/dashboard/pieChart.dart';
import 'package:vi_nho/widgets/dashboard/summaryCard.dart';
import 'package:vi_nho/widgets/dashboard/topCategory.dart';
import '../core/const_running.dart';
import '../viewmodels/categoryVM.dart';
import '../widgets/welcomePopup.dart';

class DashboardMainView extends StatefulWidget{
  const DashboardMainView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardMainView();
  }

}
class _DashboardMainView extends State<DashboardMainView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WelcomePopup.showIfFirstTime(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();
    final categoryVM = context.watch<CategoryVM>();
    final vm = context.watch<DashboardMainViewModel>();
    if(!transactionVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }
    if(!categoryVM.isLoad){
      return Center(child: CircularProgressIndicator());
    }
    if(!vm.isLoading){
      return Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(title: Text('Tổng quát chi tiêu tuần ${Tool.getWeekOfYear(DateTime.now())}')),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SummaryCard(tongThu: vm.totalIncome,
                  tongChi: vm.totalExpense,
                  chechLech: vm.balance,
                  tieuDe: 'Tổng quát chi tiêu',
                  percentIn: vm.percentIn,
                  percentEx: vm.percentEx,
                  noZero: true,
                ),
                SizedBox(height: 10),
                SummaryCard(
                  tieuDe1: 'TB mỗi ngày thu',
                  tieuDe2: 'TB mỗi lần tiêu',
                  tongThu: vm.averageIn,
                  tongChi: vm.averageEx,
                  tieuDe: 'Trung bình mỗi ngày',
                  noZero: true,
                ),
                SizedBox(height: 10),
                PieChartWidget(vm.categoryChart,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: false,),
                SizedBox(height: 10),
                LineChartWidget(vm.dailyChart, tieuDe: 'Biểu đồ chi tiêu theo ngày',),
                SizedBox(height: 10,),
                TopCategory(vm.topCategory),
              ],
            ),
          ),
        ),
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
                child: const Icon(Icons.add_shopping_cart),
                label: 'Thêm giao dịch',
                onTap: () {
                  if (categoryVM.categorySelect == null) {
                    categoryVM.setSelect(categoryVM.categoryList.first);
                  }
                  Navigator.pushNamed(context, '/transaction-add');
                },
              ),
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
          )
      ),
    );
  }


}
