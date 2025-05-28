import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vi_nho/widgets/sessionTitle.dart';

class TypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  const TypeSelector({required this.selected, required this.onChanged});

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
              onChanged: onChanged
          ),
          RadioListTile(
              value: 'Chi',
              title: Text('Tiền ra'),
              groupValue: selected,
              onChanged: onChanged
          ),
        ],
      ),
    );
  }
}
