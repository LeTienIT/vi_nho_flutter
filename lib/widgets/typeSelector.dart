import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  int planID; bool enable;
  TypeSelector({super.key, required this.selected, required this.onChanged, this.planID=-1, this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RadioListTile<String>(
              value: 'Thu',
              title: Text('Tiền vào'),
              groupValue: selected,
              onChanged: enable ? onChanged : null
          ),
          RadioListTile(
              value: 'Chi',
              title: Text('Tiền ra'),
              groupValue: selected,
              onChanged: enable ? onChanged : null
          ),
          RadioListTile(
            value: 'Tiết kiệm',
            title: Text('Tiết kiệm'),
            groupValue: selected,
            onChanged: planID!= -1 ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
