import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String content;
  final IconData? icon; // Optional

  const InfoRow({
    super.key,
    required this.label,
    required this.content,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
              children: [
                TextSpan(
                  text: '$label ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                TextSpan(
                  text: content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
