import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReportCategory {
  equipagem,
  eletrica,
  bombeamento,
}

final activeReportCategoryProvider = StateProvider<ReportCategory>(
  (ref) => ReportCategory.equipagem,
);
