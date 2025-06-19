import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopCategory extends StatelessWidget{
  List<MapEntry<String, double>> data; // Đã sắp xếp rùi.

  TopCategory(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Danh mục tiêu nhiều nhất",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ...data.take(5).map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 10),
                  SizedBox(width: 8),
                  Expanded(child: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
                  Text(
                    NumberFormat.currency(locale: 'vi').format(entry.value.toDouble()),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
}