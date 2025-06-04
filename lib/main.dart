import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/viewmodels/filterVM.dart';
import 'package:vi_nho/views/addTransactionView.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/views/editTransactionView.dart';
import 'package:vi_nho/views/transactionView.dart';

import 'models/transactionModel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionVM()..initData()),
        ChangeNotifierProvider(create: (_) => FilterVM())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChiNote App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/transaction-list':
            return MaterialPageRoute(builder: (_) => TransactionListView());
          case '/transaction-add':
            return MaterialPageRoute(builder: (_) => AddTransactionView());
          case '/transaction-edit':
            final transactionModel = settings.arguments as TransactionModel;
            return MaterialPageRoute(
              builder: (_) => EditTransactionView(transactionModel: transactionModel),
            );
        }
        return null;
      },
      home: TransactionListView(),
    );
  }
}



