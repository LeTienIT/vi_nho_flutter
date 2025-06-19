import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vi_nho/widgets/numberForm.dart';

class SummaryCard extends StatelessWidget{
  String tieuDe;
  double tongThu, tongChi, chechLech;
  
  SummaryCard({super.key, required this.tongThu, required this.tongChi, required this.chechLech, this.tieuDe="Dashboard"});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('Tổng Thu', tongThu, Colors.green),
                _summaryItem('Tổng Chi', tongChi, Colors.red),
                _summaryItem('Dư', chechLech, chechLech> 0 ? Colors.green : Colors.redAccent),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _summaryItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(NumberFormat.currency(locale: 'vi').format(amount), style: TextStyle(color: color, fontSize: 16)),
      ],
    );
  }
}