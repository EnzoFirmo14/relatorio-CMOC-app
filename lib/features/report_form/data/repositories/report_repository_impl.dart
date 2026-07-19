import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_local_datasource.dart';

/// Implementação concreta de [IReportRepository] que delega ao [ReportLocalDataSource].
///
/// Isola a camada de apresentação de todos os detalhes de persistência.
class ReportRepositoryImpl implements IReportRepository {
  final ReportLocalDataSource _localDataSource;

  const ReportRepositoryImpl(this._localDataSource);

  @override
  Future<String> saveReport(ReportEntity report) {
    return _localDataSource.saveReport(report);
  }

  @override
  Future<ReportEntity?> getReportByUuid(String uuid) {
    return _localDataSource.getReportByUuid(uuid);
  }

  @override
  Future<ReportEntity?> getLatestDraft() {
    return _localDataSource.getLatestDraft();
  }

  @override
  Future<void> deleteReport(String uuid) {
    return _localDataSource.deleteReport(uuid);
  }

  @override
  Future<List<ReportEntity>> getAllReports() {
    return _localDataSource.getAllReports();
  }

  @override
  Future<void> markAsSynced(String uuid) {
    return _localDataSource.markAsSynced(uuid);
  }

  @override
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status) {
    return _localDataSource.updateSyncStatus(uuid, status);
  }

  @override
  Future<List<ReportEntity>> getPendingReports() {
    return _localDataSource.getPendingReports();
  }
}
