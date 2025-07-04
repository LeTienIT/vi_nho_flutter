import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/dashboardMainVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/dashboard/lineChart.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/dashboard/pieChart.dart';
import 'package:vi_nho/widgets/dashboard/summaryCard.dart';
import 'package:vi_nho/widgets/dashboard/topCategory.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('Tổng quát chi tiêu tháng ${DateTime.now().month}')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SummaryCard(tongThu: vm.totalIncome,
                tongChi: vm.totalExpense,
                chechLech: vm.balance,
                tieuDe: 'Tổng quát tháng ${DateTime.now().month}',
                percentIn: vm.percentIn,
                percentEx: vm.percentEx,
              ),
              SizedBox(height: 10),
              PieChartWidget(vm.categoryExpenseMap,tieuDeBD: 'Biểu đồ phân loại chi tiêu',showTitle: false,),
              SizedBox(height: 10),
              LineChartWidget(vm.dailyExpenseSpots, tieuDe: 'Biểu đồ chi tiêu theo ngày',),
              SizedBox(height: 10,),
              TopCategory(vm.topCategories),
            ],
          ),
        ),
      ),
      drawer: Drawer(child: Menu(),),
    );
  }


}
