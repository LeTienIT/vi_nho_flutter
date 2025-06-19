import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget{
  List<FlSpot> data;
  String tieuDe;

  LineChartWidget(this.data, {this.tieuDe = 'Biểu đồ', super.key});

  @override
  Widget build(BuildContext context) {
    final minX = data.map((e) => e.x).reduce((a, b) => a < b ? a : b).toDouble();
    final maxXRaw = data.map((e) => e.x).reduce((a, b) => a > b ? a : b).toInt();
    final maxX = getSafeMaxDay(maxXRaw, DateTime.now()).toDouble();
    final List<int> daysWithData = data.map((e) => e.x.toInt()).toList();
    LineChartBarData lineChartBarData = LineChartBarData(
      spots: data,
      isCurved: true,
      color: Colors.blue,
      barWidth: 2,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
    );
    LineChartData chartData = LineChartData(
      minX: minX,
      maxX: maxX,
      minY: 1000,
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (daysWithData.contains(value.toInt()) || value.toDouble() == maxX) {
                return Text('${value.toInt()}', style: TextStyle(fontSize: 10));
              }
              return const SizedBox.shrink();
            }
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 100000,
            getTitlesWidget: (value, meta) => Text('${value ~/ 1000}k'),
          ),
        ),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [lineChartBarData],
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                tieuDe,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(chartData),
            )
          ],
        ),
      ),
    );
  }
  int getDaysInMonth(int year, int month) {
    final beginningNextMonth = (month < 12)
        ? DateTime(year, month + 1, 1)
        : DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1)).day;
  }
  int getSafeMaxDay(int currentMaxDay, DateTime ref) {
    final daysInMonth = getDaysInMonth(ref.year, ref.month);
    return (currentMaxDay < daysInMonth) ? currentMaxDay + 1 : currentMaxDay;
  }
}