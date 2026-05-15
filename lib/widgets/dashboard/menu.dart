import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/core/const_running.dart';
import 'package:vi_nho/core/tool.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';

import '../../core/clean_cache.dart';

class Menu extends StatefulWidget{
  const Menu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Menu();
  }
}

class _Menu extends State<Menu>{
  String cache = '...';
  @override
  void initState() {
    super.initState();
    loadSizeCache();

  }
  void loadSizeCache() async{
    final sizeBytes = await getCacheSizeInBytes();
    final sizeReadable = formatBytes(sizeBytes);
    setState(() {
      cache = sizeReadable;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionVM = context.watch<TransactionVM>();
    final year = DateTime.now().year;

    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
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
                    initiallyExpanded: true,
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
                                'month' : Running.dashboardMonth > 0 ? Running.dashboardMonth : DateTime.now().month,
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
                title: const Text('Cài đặt'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/setting', (route) => false),
              ),
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Sao lưu dữ liệu'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/backup', (route) => false),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Hướng dẫn'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/about', (route) => false),
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services_sharp),
                title: Text('Dọn dẹp bộ nhớ: $cache'),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text(
                        'Xác nhận dọn dẹp bộ nhớ tạm thời của ứng dụng.\n'
                            'Việc này không ảnh hưởng đến ứng dụng hiện tại\n'
                            'và các ứng dụng khác.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Xóa'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      final result = await cleanOnlyCache();

                      if (result.errors.isNotEmpty) {
                        debugPrint('Lỗi: ${result.errors.join('\n')}');
                      }
                      else{
                        loadSizeCache();
                        showTopToast(context, 'Đã dọn ${result.deletedMB}MB bộ nhớ đệm');
                      }

                    } catch (e) {
                      debugPrint('cleanOnlyCache thất bại: $e');
                    }

                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showTopToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        final topPadding = MediaQuery.of(context).padding.top;

        return Positioned(
          top: topPadding + 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}