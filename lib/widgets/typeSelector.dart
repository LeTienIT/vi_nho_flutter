import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  final int planID;
  final bool enable;

  const TypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.planID = -1,
    this.enable = true,
  });

  Widget _buildTile(
      BuildContext context, {
        required String value,
        required String title,
        required IconData icon,
        required Color color,
        bool enabled = true,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: selected == value ? color.withOpacity(0.1) : Colors.transparent,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selected,
        onChanged: enabled ? onChanged : null,
        title: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        activeColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTile(
            context,
            value: 'Thu',
            title: 'Tiền vào',
            icon: Icons.arrow_downward,
            color: Colors.green,
            enabled: enable,
          ),
          _buildTile(
            context,
            value: 'Chi',
            title: 'Tiền ra',
            icon: Icons.arrow_upward,
            color: Colors.red,
            enabled: enable,
          ),
          _buildTile(
            context,
            value: 'Tiết kiệm',
            title: 'Tiết kiệm',
            icon: Icons.savings,
            color: Colors.blue,
            enabled: planID != -1,
          ),
        ],
      ),
    );
  }
}
