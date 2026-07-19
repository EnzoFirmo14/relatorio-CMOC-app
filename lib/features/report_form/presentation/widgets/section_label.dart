import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkBlue,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(
              color: AppTheme.borderLight,
              thickness: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
