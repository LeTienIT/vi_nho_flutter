import 'package:flutter/material.dart';

class Menu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
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
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.dashboard_customize),
                        title: const Text('Báo cáo theo tháng'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.dashboard_customize_outlined),
                        title: const Text('Báo cáo theo năm'),
                        onTap: () {},
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
                    title: const Text('Quản lý loại giao dịch'),
                    onTap: () {},
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