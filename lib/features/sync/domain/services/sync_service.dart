import 'dart:async';
import '../../../../core/services/connectivity_service.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/domain/repositories/report_repository.dart';
import '../../data/datasources/report_remote_datasource.dart';

class SyncService {
  final IReportRepository localRepository;
  final IReportRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;

  StreamSubscription<bool>? _connectivitySubscription;

  SyncService({
    required this.localRepository,
    required this.remoteDataSource,
    required this.connectivityService,
  });

  /// Inicia a escuta activa da rede para sincronização automática quando a internet voltar.
  void initAutoSyncListener({void Function(int count)? onSyncCompleted}) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        connectivityService.onConnectivityChanged.listen((isOnline) async {
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
    final isOnline = await connectivityService.checkHasInternet();
    if (!isOnline) return 0;

    final pendingReports = await localRepository.getPendingReports();
    if (pendingReports.isEmpty) return 0;

    int syncedCount = 0;

    for (final report in pendingReports) {
      try {
        // 1. Resolução de Conflitos (Last-Write-Wins)
        final remoteReport =
            await remoteDataSource.fetchRemoteReport(report.uuid);

        if (remoteReport != null &&
            remoteReport.updatedAt.isAfter(report.updatedAt)) {
          // Servidor possui versão mais recente: atualiza o banco local com a remota
          await localRepository.saveReport(remoteReport);
          await localRepository.markAsSynced(remoteReport.uuid);
          syncedCount++;
          continue;
        }

        // 2. Envio da versão local (mais recente ou novo registro)
        await remoteDataSource.sendReport(report);
        await localRepository.markAsSynced(report.uuid);
        syncedCount++;
      } catch (_) {
        // Marca como erro para retentativa posterior
        await localRepository.updateSyncStatus(
            report.uuid, ReportSyncStatus.error);
      }
    }

    return syncedCount;
  }
}
