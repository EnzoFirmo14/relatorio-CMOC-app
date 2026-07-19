import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/core/services/connectivity_service.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/report_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/repositories/report_repository.dart';
import 'package:flutter_teste_1/features/sync/data/datasources/report_remote_datasource.dart';
import 'package:flutter_teste_1/features/sync/domain/services/sync_service.dart';

class FakeConnectivityService implements ConnectivityService {
  bool isOnline = true;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> checkHasInternet() async => isOnline;

  void setOnline(bool value) {
    isOnline = value;
    _controller.add(value);
  }

  void dispose() {
    _controller.close();
  }
}

class FakeLocalRepository implements IReportRepository {
  final Map<String, ReportEntity> store = {};

  @override
  Future<String> saveReport(ReportEntity report) async {
    store[report.uuid] = report;
    return report.uuid;
  }

  @override
  Future<ReportEntity?> getReportByUuid(String uuid) async => store[uuid];

  @override
  Future<ReportEntity?> getLatestDraft() async => null;

  @override
  Future<void> deleteReport(String uuid) async {
    store.remove(uuid);
  }

  @override
  Future<List<ReportEntity>> getAllReports() async => store.values.toList();

  @override
  Future<void> markAsSynced(String uuid) async {
    await updateSyncStatus(uuid, ReportSyncStatus.synced);
  }

  @override
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status) async {
    final existing = store[uuid];
    if (existing != null) {
      store[uuid] = existing.copyWith(syncStatus: status);
    }
  }

  @override
  Future<List<ReportEntity>> getPendingReports() async {
    return store.values
        .where((r) =>
            r.syncStatus == ReportSyncStatus.pending ||
            r.syncStatus == ReportSyncStatus.error)
        .toList();
  }
}

class FakeRemoteDataSource implements IReportRemoteDataSource {
  final Map<String, ReportEntity> remoteStore = {};
  bool shouldFail = false;

  @override
  Future<void> sendReport(ReportEntity report) async {
    if (shouldFail) {
      throw Exception('Simulated Network Error');
    }
    remoteStore[report.uuid] = report.copyWith(syncStatus: ReportSyncStatus.synced);
  }

  @override
  Future<ReportEntity?> fetchRemoteReport(String uuid) async => remoteStore[uuid];

  @override
  Future<List<ReportEntity>> fetchAllRemoteReports() async => remoteStore.values.toList();
}

void main() {
  late FakeLocalRepository localRepo;
  late FakeRemoteDataSource remoteDS;
  late FakeConnectivityService connectivity;
  late SyncService syncService;

  setUp(() {
    localRepo = FakeLocalRepository();
    remoteDS = FakeRemoteDataSource();
    connectivity = FakeConnectivityService();
    syncService = SyncService(
      localRepository: localRepo,
      remoteDataSource: remoteDS,
      connectivityService: connectivity,
    );
  });

  tearDown(() {
    connectivity.dispose();
  });

  group('SyncService Tests', () {
    test('Nao deve sincronizar quando o dispositivo estiver offline', () async {
      connectivity.isOnline = false;
      
      final report = ReportEntity(
        uuid: 'rep-1',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: ReportSyncStatus.pending,
      );
      await localRepo.saveReport(report);

      final syncedCount = await syncService.syncPendingReports();
      expect(syncedCount, equals(0));
      expect(remoteDS.remoteStore, isEmpty);
    });

    test('Deve enviar relatorio pendente com sucesso quando online', () async {
      connectivity.isOnline = true;
      
      final report = ReportEntity(
        uuid: 'rep-1',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: ReportSyncStatus.pending,
      );
      await localRepo.saveReport(report);

      final syncedCount = await syncService.syncPendingReports();
      expect(syncedCount, equals(1));
      
      final localUpdated = await localRepo.getReportByUuid('rep-1');
      expect(localUpdated?.syncStatus, equals(ReportSyncStatus.synced));
      expect(remoteDS.remoteStore.containsKey('rep-1'), isTrue);
    });

    test('Deve atualizar status para error quando o envio remoto falhar', () async {
      connectivity.isOnline = true;
      remoteDS.shouldFail = true;
      
      final report = ReportEntity(
        uuid: 'rep-1',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: ReportSyncStatus.pending,
      );
      await localRepo.saveReport(report);

      final syncedCount = await syncService.syncPendingReports();
      expect(syncedCount, equals(0));
      
      final localUpdated = await localRepo.getReportByUuid('rep-1');
      expect(localUpdated?.syncStatus, equals(ReportSyncStatus.error));
    });

    test('Controle de conflitos: deve aceitar versao remota mais recente (Last-Write-Wins)', () async {
      connectivity.isOnline = true;
      final now = DateTime.now();

      // Relatório local antigo com pendência
      final localReport = ReportEntity(
        uuid: 'rep-1',
        date: now,
        createdAt: now,
        globalEquipment: 'Versão Local Antiga',
        updatedAt: now.subtract(const Duration(hours: 2)),
        syncStatus: ReportSyncStatus.pending,
      );
      await localRepo.saveReport(localReport);

      // Relatório remoto mais recente
      final remoteReport = ReportEntity(
        uuid: 'rep-1',
        date: now,
        createdAt: now,
        globalEquipment: 'Versão Remota Recente',
        updatedAt: now.subtract(const Duration(minutes: 10)),
        syncStatus: ReportSyncStatus.synced,
      );
      remoteDS.remoteStore['rep-1'] = remoteReport;

      final syncedCount = await syncService.syncPendingReports();
      expect(syncedCount, equals(1));

      final localUpdated = await localRepo.getReportByUuid('rep-1');
      expect(localUpdated?.globalEquipment, equals('Versão Remota Recente'));
      expect(localUpdated?.syncStatus, equals(ReportSyncStatus.synced));
    });
  });
}
