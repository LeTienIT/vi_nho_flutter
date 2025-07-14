import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryItem extends StatelessWidget{

  String title; double amount; Color color; double? percent; bool? noZoro;

  SummaryItem(this.title, this.amount, this.color, [this.percent, this.noZoro = false]);

  @override
  Widget build(BuildContext context){
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatAmountOnly(amount,noZero: noZoro!),
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  ' ₫',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          if (percent != null && percent!.isFinite)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _buildPercentText(percent!),
                style: TextStyle(
                  color: title=='Tổng thu' ? percent! >= 0 ? Colors.green : Colors.red : percent! >= 0 ? Colors.red : Colors.green,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
        ],
      ),
    );
  }
  String _buildPercentText(double percent) {
    final formatted = percent.abs().toStringAsFixed(1);
    return percent >= 0 ? '↑ $formatted%' : '↓ $formatted%';
  }

  String _formatAmountOnly(double amount, {bool noZero = false}) {
    if(noZero){
      if(amount <= 0){
        return '^_^';
      }
    }
    final format = NumberFormat.currency(locale: 'vi', symbol: '');
    return format.format(amount).trim();
  }
}