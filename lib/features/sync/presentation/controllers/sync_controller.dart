import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../report_form/domain/repositories/report_repository.dart';
import '../../../report_form/presentation/controllers/report_form_controller.dart';
import '../../data/datasources/report_remote_datasource.dart';
import '../../domain/services/sync_service.dart';

class SyncState {
  final bool isOnline;
  final bool isSyncing;
  final int pendingCount;
  final bool hasError;
  final DateTime? lastSyncTime;

  const SyncState({
    this.isOnline = true,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.hasError = false,
    this.lastSyncTime,
  });

  SyncState copyWith({
    bool? isOnline,
    bool? isSyncing,
    int? pendingCount,
    bool? hasError,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      hasError: hasError ?? this.hasError,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final reportRemoteDataSourceProvider = Provider<IReportRemoteDataSource>((ref) {
  return ReportFirestoreDataSource();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  final remoteDataSource = ref.watch(reportRemoteDataSourceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return SyncService(
    localRepository: repository,
    remoteDataSource: remoteDataSource,
    connectivityService: connectivity,
  );
});

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncState>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  final syncService = ref.watch(syncServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return SyncController(
    repository: repository,
    syncService: syncService,
    connectivityService: connectivity,
  );
});

// ─── Controller ──────────────────────────────────────────────────────────────

class SyncController extends StateNotifier<SyncState> {
  final IReportRepository repository;
  final SyncService syncService;
  final ConnectivityService connectivityService;
  StreamSubscription<bool>? _netSub;

  SyncController({
    required this.repository,
    required this.syncService,
    required this.connectivityService,
  }) : super(const SyncState()) {
    _init();
  }

  void _init() async {
    // Escuta alterações de rede
    _netSub = connectivityService.onConnectivityChanged.listen((online) {
      state = state.copyWith(isOnline: online);
      if (online) {
        triggerSync();
      }
    });

    final online = await connectivityService.checkHasInternet();
    state = state.copyWith(isOnline: online);
    refreshPendingCount();

    // Inicia escuta automática
    syncService.initAutoSyncListener(onSyncCompleted: (_) {
      refreshPendingCount();
    });
  }

  @override
  void dispose() {
    _netSub?.cancel();
    syncService.dispose();
    super.dispose();
  }

  /// Recarrega a contagem de relatórios pendentes de envio.
  Future<void> refreshPendingCount() async {
    try {
      final pending = await repository.getPendingReports();
      state = state.copyWith(
        pendingCount: pending.length,
        hasError: pending.any((r) => r.syncStatus.name == 'error'),
      );
    } catch (_) {}
  }

  /// Dispara manualmente o processo de sincronização.
  Future<void> triggerSync() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, hasError: false);
    try {
      final synced = await syncService.syncPendingReports();
      final pending = await repository.getPendingReports();

      state = state.copyWith(
        isSyncing: false,
        pendingCount: pending.length,
        hasError: pending.any((r) => r.syncStatus.name == 'error'),
        lastSyncTime: synced > 0 ? DateTime.now() : state.lastSyncTime,
      );
    } catch (_) {
      state = state.copyWith(isSyncing: false, hasError: true);
    }
  }
}
