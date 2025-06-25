import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget{
  String label, content;
  TextAlign? labelAlign, contentAlign;
  TextStyle? labelStyle, contentStyle;
  CardTitle({super.key, this.label='Label', this.content='Content', this.contentAlign, this.contentStyle, this.labelAlign, this.labelStyle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              label,
              style: labelStyle,
              textAlign: labelAlign,
            ),
            Text(
              content,
              style: contentStyle,
              textAlign: contentAlign,
            )
          ],
        ),
      ),
    );
  }
}