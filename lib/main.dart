import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/services/sharedPreference.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardMonthVM.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardWeekVM.dart';
import 'package:vi_nho/viewmodels/dashboard/dashboardYearVM.dart';
import 'package:vi_nho/viewmodels/dashboardMainVM.dart';
import 'package:vi_nho/viewmodels/filterVM.dart';
import 'package:vi_nho/viewmodels/themeVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/views/category/addCategoryView.dart';
import 'package:vi_nho/views/category/editCategoryView.dart';
import 'package:vi_nho/views/categoryView.dart';
import 'package:vi_nho/views/dashboard/dashboardMonthView.dart';
import 'package:vi_nho/views/dashboard/dashboardWeekView.dart';
import 'package:vi_nho/views/dashboard/dashboardYearView.dart';
import 'package:vi_nho/views/dashboardMainView.dart';
import 'package:vi_nho/views/transaction/addTransactionView.dart';
import 'package:vi_nho/views/transaction/editTransactionView.dart';
import 'package:vi_nho/views/settingView.dart';
import 'package:vi_nho/views/transactionView.dart';
import 'package:vi_nho/core/light_theme.dart';
import 'package:vi_nho/core/dark_theme.dart';
import 'models/transactionModel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreference.instance.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionVM()..initData()),
        ChangeNotifierProvider(create: (_) => FilterVM()),
        ChangeNotifierProvider(create: (_) => CategoryVM()..initData()),
        ChangeNotifierProvider.value(value: ThemeVM()),
        ChangeNotifierProxyProvider<TransactionVM, DashboardMainViewModel>(
          create: (_) => DashboardMainViewModel(null),
          update: (_, transactionVM, previous) => previous!..updateData(transactionVM),
        ),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeVM>().isDark;
    return MaterialApp(
      title: 'ChiNote App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/transaction-list':
            return MaterialPageRoute(builder: (_) => TransactionListView());
          case '/category-list':
            return MaterialPageRoute(builder: (_) => CategoryView());
          case '/transaction-add':
            return MaterialPageRoute(builder: (_) => AddTransactionView());
          case '/category-add':
            return MaterialPageRoute(builder: (_) => AddCategoryView());
          case '/transaction-edit':
            final transactionModel = settings.arguments as TransactionModel;
            return MaterialPageRoute(
              builder: (_) => EditTransactionView(transactionModel: transactionModel),
            );
          case '/category-edit':
            final category = settings.arguments as CategoryModel;
            return MaterialPageRoute(
              builder: (_) => EditCategoryView(categoryModel: category,),
            );
          case '/setting':
            return MaterialPageRoute(
              builder: (_) => SettingView(),
            );
          case '/home':
            return MaterialPageRoute(
                builder: (_) => DashboardMainView()
            );
          case '/dashboard-week':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                    create: (_) => DashboardWeekVM(
                        listTransaction: args['transactions'],
                        weekNumber: args['week'],
                        year: args['year']
                    ),
                  child: DashboardWeekView(),
                )
            );
          case '/dashboard-month':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => DashboardMonthVM(
                      listTransaction: args['transactions'],
                      monthNumber: args['month'],
                      year: args['year']
                  ),
                  child: DashboardMonthView(),
                )
            );
          case '/dashboard-year':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => DashboardYearVM(
                      listTransaction: args['transactions'],
                      year: args['year']
                  ),
                  child: DashboardYearView(),
                )
            );
        }
        return null;
      },
      home: const DashboardMainView(),
    );
  }
}



