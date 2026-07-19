import 'dart:async';
import '../../../../core/services/connectivity_service.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/domain/repositories/report_repository.dart';
import '../../data/datasources/report_remote_datasource.dart';

class SyncService {
  final IReportRepository _localRepository;
  final IReportRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  StreamSubscription<bool>? _connectivitySubscription;

  SyncService({
    required IReportRepository localRepository,
    required IReportRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  })  : _localRepository = localRepository,
        _remoteDataSource = remoteDataSource,
        _connectivityService = connectivityService;

  /// Inicia a escuta ativa da rede para sincronização automática quando a internet voltar.
  void initAutoSyncListener({void Function(int count)? onSyncCompleted}) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivityService.onConnectivityChanged.listen((isOnline) async {
      if (isOnline) {
        final syncedCount = await syncPendingReports();
        if (syncedCount > 0) {
          onSyncCompleted?.call(syncedCount);
        }
      }
    });
  }

  /// Cancela a assinatura do listener de rede.
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Processa a fila de relatórios pendentes de envio.
  /// Retorna a quantidade de relatórios sincronizados com sucesso.
  Future<int> syncPendingReports() async {
    final isOnline = await _connectivityService.checkHasInternet();
    if (!isOnline) return 0;

    final pendingReports = await _localRepository.getPendingReports();
    if (pendingReports.isEmpty) return 0;

    int syncedCount = 0;

    for (final report in pendingReports) {
      try {
        // 1. Resolução de Conflitos (Last-Write-Wins)
        final remoteReport =
            await _remoteDataSource.fetchRemoteReport(report.uuid);

        if (remoteReport != null &&
            remoteReport.updatedAt.isAfter(report.updatedAt)) {
          // Servidor possui versão mais recente: atualiza o banco local com a remota
          await _localRepository.saveReport(remoteReport);
          await _localRepository.markAsSynced(remoteReport.uuid);
          syncedCount++;
          continue;
        }

        // 2. Envio da versão local (mais recente ou novo registro)
        await _remoteDataSource.sendReport(report);
        await _localRepository.markAsSynced(report.uuid);
        syncedCount++;
      } catch (_) {
        // Marca como erro para retentativa posterior
        await _localRepository.updateSyncStatus(
            report.uuid, ReportSyncStatus.error);
      }
    }

    return syncedCount;
  }
}
