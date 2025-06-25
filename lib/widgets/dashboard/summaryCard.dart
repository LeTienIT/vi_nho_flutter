import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget{
  String tieuDe;
  double tongThu, tongChi; double? chechLech, percentIn, percentEx, balancePercent;
  
  SummaryCard({super.key, required this.tongThu, required this.tongChi, this.chechLech, this.percentIn, this.percentEx, this.balancePercent, this.tieuDe="Dashboard"});

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
                _summaryItem('Tổng Thu', tongThu, Colors.green, percentIn),
                _summaryItem('Tổng Chi', tongChi, Colors.red, percentEx),
                if(chechLech!=null)
                  _summaryItem('Dư', chechLech!, chechLech!.toDouble() > 0 ? Colors.green : Colors.redAccent, balancePercent),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _summaryItem(String title, double amount, Color color, [double? percent]) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(NumberFormat.currency(locale: 'vi').format(amount), style: TextStyle(color: color, fontSize: 16)),
        if (percent != null && percent.isFinite)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _buildPercentText(percent),
              style: TextStyle(
                color: percent >= 0 ? Colors.red : Colors.green,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
  String _buildPercentText(double percent) {
    final formatted = percent.abs().toStringAsFixed(1);
    return percent >= 0 ? '↑ $formatted%' : '↓ $formatted%';
  }

}