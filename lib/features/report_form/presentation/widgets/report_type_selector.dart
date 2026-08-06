import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/report_type_provider.dart';

class ReportTypeSelector extends ConsumerWidget {
  const ReportTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCategory = ref.watch(activeReportCategoryProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: AppTheme.subCardBg(context),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.border(context),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          _buildItem(
            context: context,
            ref: ref,
            category: ReportCategory.equipagem,
            icon: Icons.build_circle_outlined,
            activeIcon: Icons.build_circle,
            label: 'Equipagem',
            isSelected: currentCategory == ReportCategory.equipagem,
            accentColor: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 4),
          _buildItem(
            context: context,
            ref: ref,
            category: ReportCategory.eletrica,
            icon: Icons.bolt_outlined,
            activeIcon: Icons.bolt,
            label: 'Elétrica',
            isSelected: currentCategory == ReportCategory.eletrica,
            accentColor: const Color(0xFFFFB300), // Amber/Yellow
          ),
          const SizedBox(width: 4),
          _buildItem(
            context: context,
            ref: ref,
            category: ReportCategory.bombeamento,
            icon: Icons.water_drop_outlined,
            activeIcon: Icons.water_drop,
            label: 'Bombeamento',
            isSelected: currentCategory == ReportCategory.bombeamento,
            accentColor: AppTheme.cmocGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required WidgetRef ref,
    required ReportCategory category,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required Color accentColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(activeReportCategoryProvider.notifier).state = category;
        },
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: isSelected
                ? (AppTheme.isDark(context) ? accentColor.withValues(alpha: 0.25) : accentColor.withValues(alpha: 0.12))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: isSelected
                ? Border.all(color: accentColor, width: 1.5)
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 18,
                color: isSelected ? accentColor : AppTheme.textMutedColor(context),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppTheme.textPrimary(context) : AppTheme.textMutedColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
