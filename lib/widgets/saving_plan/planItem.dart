import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vi_nho/widgets/infoRow.dart';

import '../../core/tool.dart';
import '../../models/planModel.dart';

class PlanItem extends StatelessWidget{
  PlanModel plan;
  PlanItem({super.key, required this.plan});
  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    String trangThai;
    if (plan.hoanThanh == 0) {
      statusColor = Colors.blue;
      trangThai = 'Đang thực hiện';
    } else {
      switch (plan.thanhCong) {
        case 1:
          trangThai = 'Hoàn thành';
          statusColor = Colors.green;
          break;
        case 0:
          trangThai = 'Hoàn thành ~ 100%';
          statusColor = Colors.orange;
          break;
        case -1:
        default:
          trangThai = 'KHÔNG THÀNH CÔNG';
          statusColor = Colors.red;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          InfoRow(label: 'Thời hạn: ', content: '${DateFormat('dd/MM/yyyy').format(plan.ngayBD)} -> ${DateFormat('dd/MM/yyyy').format(plan.ngayKT)}',),
          SizedBox(height: 8,),

          InfoRow(label: 'Chu kỳ: ', content: plan.chuKy),
          SizedBox(height: 8,),

          InfoRow(label: 'Tổng: ', content: NumberFormat.currency(locale: 'vi').format(plan.tongSoTien)),
          SizedBox(height: 8,),

          InfoRow(label: 'Trạng thái: ', content: trangThai),
        ],
      ),
    );
  }

}