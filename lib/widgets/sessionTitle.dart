import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool required;

  const SessionTitle({
    super.key,
    required this.title,
    this.subtitle = '',
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  if (subtitle.isNotEmpty)
                    TextSpan(
                      text: '  $subtitle',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (required)
            Text(
              '*',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}