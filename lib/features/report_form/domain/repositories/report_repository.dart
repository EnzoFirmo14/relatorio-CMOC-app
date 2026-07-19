import '../entities/report_entity.dart';

/// Contrato (interface) do repositório de relatórios.
/// A camada de Domínio não sabe COMO os dados são armazenados.
abstract interface class IReportRepository {
  /// Salva (insert ou update) um relatório localmente.
  /// Retorna o [uuid] do relatório salvo.
  Future<String> saveReport(ReportEntity report);

  /// Recupera um relatório pelo seu [uuid].
  /// Retorna `null` se não existir.
  Future<ReportEntity?> getReportByUuid(String uuid);

  /// Retorna o relatório mais recente com status [ReportSyncStatus.draft].
  /// Utilizado para restaurar o rascunho na abertura do app.
  Future<ReportEntity?> getLatestDraft();

  /// Exclui um relatório pelo seu [uuid].
  Future<void> deleteReport(String uuid);

  /// Retorna todos os relatórios armazenados localmente, ordenados por data decrescente.
  Future<List<ReportEntity>> getAllReports();

  /// Atualiza o [syncStatus] de um relatório para [ReportSyncStatus.synced].
  Future<void> markAsSynced(String uuid);

  /// Atualiza o [syncStatus] de um relatório para qualquer estado.
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status);

  /// Retorna todos os relatórios pendentes ou com erro de envio.
  Future<List<ReportEntity>> getPendingReports();
}
