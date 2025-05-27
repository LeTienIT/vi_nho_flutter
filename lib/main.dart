import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/views/addTransactionView.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/views/transactionView.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionVM()..initData()),
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
      routes: {
        "/transaction-list": (context)=>TransactionListView(),
        "/transaction-add": (context)=>AddTransactionView(),
      },
      home: TransactionListView(),
    );
  }
}



