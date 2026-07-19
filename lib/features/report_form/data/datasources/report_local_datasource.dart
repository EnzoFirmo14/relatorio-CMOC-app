import 'package:isar/isar.dart';
import '../../domain/entities/report_entity.dart';
import '../models/report_model.dart';

/// Data Source local responsável por todas as operações CRUD no Isar.
///
/// Recebe diretamente a instância do [Isar] para facilitar testes em memória.
class ReportLocalDataSource {
  final Isar _isar;

  const ReportLocalDataSource(this._isar);

  /// Salva (insert ou update) um [ReportModel] no banco.
  /// A anotação [@Index(unique: true, replace: true)] garante o upsert pelo uuid.
  Future<String> saveReport(ReportEntity entity) async {
    final model = ReportModel.fromEntity(entity);
    await _isar.writeTxn(() async {
      await _isar.reportModels.put(model);
    });
    return entity.uuid;
  }

  /// Busca um relatório pelo [uuid].
  Future<ReportEntity?> getReportByUuid(String uuid) async {
    final model = await _isar.reportModels
        .where()
        .uuidEqualTo(uuid)
        .findFirst();
    return model?.toEntity();
  }

  /// Retorna o rascunho mais recente (ordenado por [updatedAt] decrescente).
  Future<ReportEntity?> getLatestDraft() async {
    final model = await _isar.reportModels
        .filter()
        .syncStatusEqualTo(ReportModelSyncStatus.draft)
        .sortByUpdatedAtDesc()
        .findFirst();
    return model?.toEntity();
  }

  /// Exclui o relatório com o [uuid] fornecido.
  Future<void> deleteReport(String uuid) async {
    final existing = await _isar.reportModels
        .where()
        .uuidEqualTo(uuid)
        .findFirst();
    if (existing == null) return;

    await _isar.writeTxn(() async {
      await _isar.reportModels.delete(existing.id);
    });
  }

  /// Retorna todos os relatórios, ordenados por data decrescente.
  Future<List<ReportEntity>> getAllReports() async {
    final models = await _isar.reportModels
        .where()
        .sortByDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  /// Marca um relatório como sincronizado.
  Future<void> markAsSynced(String uuid) async {
    await updateSyncStatus(uuid, ReportSyncStatus.synced);
  }

  /// Atualiza o status de sincronização de um relatório.
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status) async {
    final existing = await _isar.reportModels
        .where()
        .uuidEqualTo(uuid)
        .findFirst();
    if (existing == null) return;

    final modelStatus = ReportModelSyncStatus.values.firstWhere(
      (e) => e.name == status.name,
      orElse: () => ReportModelSyncStatus.draft,
    );

    await _isar.writeTxn(() async {
      existing.syncStatus = modelStatus;
      await _isar.reportModels.put(existing);
    });
  }

  /// Retorna relatórios pendentes ou com erro de envio.
  Future<List<ReportEntity>> getPendingReports() async {
    final models = await _isar.reportModels
        .filter()
        .syncStatusEqualTo(ReportModelSyncStatus.pending)
        .or()
        .syncStatusEqualTo(ReportModelSyncStatus.error)
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }
}
