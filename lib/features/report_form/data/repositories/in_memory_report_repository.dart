import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';

/// Uma implementação em memória de [IReportRepository] para uso na Web (onde o Isar v3 não é suportado).
class InMemoryReportRepository implements IReportRepository {
  final List<ReportEntity> _reports = [];

  @override
  Future<String> saveReport(ReportEntity report) async {
    final index = _reports.indexWhere((r) => r.uuid == report.uuid);
    if (index != -1) {
      _reports[index] = report;
    } else {
      _reports.add(report);
    }
    return report.uuid;
  }

  @override
  Future<ReportEntity?> getReportByUuid(String uuid) async {
    try {
      return _reports.firstWhere((r) => r.uuid == uuid);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ReportEntity?> getLatestDraft() async {
    final drafts = _reports.where((r) => r.syncStatus == ReportSyncStatus.draft).toList();
    if (drafts.isEmpty) return null;
    drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return drafts.first;
  }

  @override
  Future<void> deleteReport(String uuid) async {
    _reports.removeWhere((r) => r.uuid == uuid);
  }

  @override
  Future<List<ReportEntity>> getAllReports() async {
    final list = List<ReportEntity>.from(_reports);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> markAsSynced(String uuid) async {
    await updateSyncStatus(uuid, ReportSyncStatus.synced);
  }

  @override
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status) async {
    final index = _reports.indexWhere((r) => r.uuid == uuid);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(
        syncStatus: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<List<ReportEntity>> getPendingReports() async {
    return _reports.where((r) => 
      r.syncStatus == ReportSyncStatus.pending || 
      r.syncStatus == ReportSyncStatus.error
    ).toList();
  }
}
