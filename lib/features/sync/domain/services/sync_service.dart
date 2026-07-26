import 'dart:async';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/services/image_service.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/domain/entities/work_order_entity.dart';
import '../../../report_form/domain/repositories/report_repository.dart';
import '../../data/datasources/report_remote_datasource.dart';

class SyncService {
  final IReportRepository localRepository;
  final IReportRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;
  final CloudinaryService cloudinaryService;

  StreamSubscription<bool>? _connectivitySubscription;

  SyncService({
    required this.localRepository,
    required this.remoteDataSource,
    required this.connectivityService,
    required this.cloudinaryService,
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

        // --- UPLOAD DAS IMAGENS LOCAIS PARA O CLOUDINARY ---
        ReportEntity normalizedReport = report;
        List<WorkOrderEntity> updatedWorkOrders = [];
        bool reportHasChanges = false;

        for (final os in report.workOrders) {
          List<String> updatedPhotoPaths = [];
          bool osHasChanges = false;

          for (final path in os.photoPaths) {
            if (!path.startsWith('http://') && !path.startsWith('https://')) {
              // É uma foto local. Realiza o upload para o Cloudinary.
              final absolutePath = await ImageService.getAbsolutePath(path);
              final secureUrl = await cloudinaryService.uploadImage(absolutePath);
              updatedPhotoPaths.add(secureUrl);
              osHasChanges = true;
            } else {
              updatedPhotoPaths.add(path);
            }
          }

          if (osHasChanges) {
            updatedWorkOrders.add(os.copyWith(photoPaths: updatedPhotoPaths));
            reportHasChanges = true;
          } else {
            updatedWorkOrders.add(os);
          }
        }

        if (reportHasChanges) {
          normalizedReport = report.copyWith(workOrders: updatedWorkOrders);
          // Atualiza o banco de dados local com as novas URLs do Cloudinary
          await localRepository.saveReport(normalizedReport);
        }

        // 2. Envio da versão local (mais recente ou novo registro)
        await remoteDataSource.sendReport(normalizedReport);
        await localRepository.markAsSynced(normalizedReport.uuid);
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
