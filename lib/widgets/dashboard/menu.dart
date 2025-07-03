import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/core/const_running.dart';
import 'package:vi_nho/core/tool.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();
    final year = DateTime.now().year;

    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: [
              ExpansionTile(
                leading: Icon(Icons.monetization_on),
                title: const Text('Thu chi'),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: const Text('Tổng quát'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (router) => false),
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.analytics_outlined),
                    title: const Text('Báo cáo'),
                    childrenPadding: EdgeInsets.only(left: 16),
                    children: [
                      ListTile(
                        leading: Icon(Icons.dashboard),
                        title: const Text('Báo cáo theo tuần'),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/dashboard-week',
                              (router) => false,
                              arguments:{
                                'week' : Running.dashboardWeek > 0 ? Running.dashboardWeek : Tool.getWeekOfYear(DateTime.now()),
                                'year' : year,
                                'transactions' : transactionVM.listCore
                              }
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.dashboard_customize),
                        title: const Text('Báo cáo theo tháng'),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/dashboard-month',
                                  (router) => false,
                              arguments:{
                                'month' : Running.dashboardWeek > 0 ? Running.dashboardMonth : DateTime.now().month,
                                'year' : year,
                                'transactions' : transactionVM.listCore
                              }
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_month_outlined),
                        title: const Text('Báo cáo năm'),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/dashboard-year',
                                  (router) => false,
                              arguments:{
                                'year' : Running.dashboardYear > 0 ? Running.dashboardYear : year,
                                'transactions' : transactionVM.listCore
                              }
                          );
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Danh sách thu chi'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/transaction-list', (route) => false),
                  ),
                  ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: const Text('Loại giao dịch'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/category-list', (route) => false),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Kế hoạch tiết kiệm'),
                leading: Icon(Icons.savings),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: const Icon(Icons.queue_play_next),
                    title: const Text('Chọn gói tiết kiệm'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/saving-plan', (route) => false),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Cài đặt giao diện'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/setting', (route) => false),
              ),
            ],
          ),
        ),
      ],
    );
  }

}