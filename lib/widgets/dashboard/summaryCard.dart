import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vi_nho/widgets/dashboard/summaryItem.dart';

class SummaryCard extends StatelessWidget {
  final String tieuDe1, tieuDe2, tieuDe3;
  final String tieuDe;
  final double tongThu, tongChi;
  final double? chechLech, percentIn, percentEx, balancePercent;
  bool? noZero;

  SummaryCard({
    super.key,
    this.tieuDe1 = 'Tổng thu',
    this.tieuDe2 = 'Tổng chi',
    this.tieuDe3 = 'Dư',
    required this.tongThu,
    required this.tongChi,
    this.chechLech,
    this.percentIn,
    this.percentEx,
    this.balancePercent,
    this.tieuDe = "Dashboard",
    this.noZero = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Card full chiều ngang
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tieuDe,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  SummaryItem(tieuDe1, tongThu, Colors.green, percentIn, noZero),
                  SummaryItem(tieuDe2, tongChi, Colors.red, percentEx, noZero),
                  if (chechLech != null)
                    SummaryItem(
                      tieuDe3,
                      chechLech!,
                      chechLech! > 0 ? Colors.green : Colors.redAccent,
                      balancePercent, noZero
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatCompactCurrency(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B'; // Tỷ
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M'; // Triệu
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(0)}K'; // Nghìn
    } else {
      return value.toStringAsFixed(0); // Số nhỏ
    }
  }
}
