import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionTitle extends StatelessWidget{

  String title, subtitle;

  SessionTitle({super.key, required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 16, right: 16, left: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: subtitle.isEmpty ? '' : ' - $subtitle',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    )
                  )
                ]
              )
          )
        )
    );
  }
}