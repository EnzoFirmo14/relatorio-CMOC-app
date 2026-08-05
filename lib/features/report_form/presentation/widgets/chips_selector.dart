import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChipsSelector<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final void Function(T) onSelected;
  final String Function(T) labelBuilder;

  const ChipsSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);
    final textMutedColor = AppTheme.textMutedColor(context);
    final borderColor = AppTheme.border(context);
    final subCardBg = AppTheme.subCardBg(context);

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((opt) {
        final isSel = opt == selected;
        return GestureDetector(
          onTap: () => onSelected(opt),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isSel ? primaryColor.withValues(alpha: 0.18) : subCardBg,
              border: Border.all(
                color: isSel ? primaryColor : borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              labelBuilder(opt),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.0,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                color: isSel ? primaryColor : textMutedColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
