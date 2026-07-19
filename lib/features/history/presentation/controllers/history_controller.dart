import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/presentation/controllers/report_form_controller.dart';

/// Estado da tela de Histórico Local.
class HistoryState {
  final List<ReportEntity> allReports;
  final List<ReportEntity> filteredReports;
  final String searchQuery;
  final String? statusFilter;
  final bool isLoading;

  const HistoryState({
    this.allReports = const [],
    this.filteredReports = const [],
    this.searchQuery = '',
    this.statusFilter,
    this.isLoading = false,
  });

  HistoryState copyWith({
    List<ReportEntity>? allReports,
    List<ReportEntity>? filteredReports,
    String? searchQuery,
    String? statusFilter,
    bool? isLoading,
  }) {
    return HistoryState(
      allReports: allReports ?? this.allReports,
      filteredReports: filteredReports ?? this.filteredReports,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter == '' ? null : (statusFilter ?? this.statusFilter),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─── Provider ──────────────────────────────────────────────────────────────

final historyControllerProvider =
    StateNotifierProvider<HistoryController, HistoryState>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return HistoryController(repository);
});

// ─── Controller ───

class HistoryController extends StateNotifier<HistoryState> {
  final dynamic _repository;

  HistoryController(this._repository) : super(const HistoryState()) {
    loadReports();
  }

  /// Carrega todos os relatórios do banco Isar.
  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _repository.getAllReports();
      state = state.copyWith(
        allReports: list,
        isLoading: false,
      );
      _applyFilters();
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Altera o termo de busca por texto.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Altera o filtro de status selecionado.
  void setStatusFilter(String? status) {
    // Se for 'Todos', passa String vazia no copyWith para resetar para null
    state = state.copyWith(statusFilter: status == 'Todos' ? '' : status);
    _applyFilters();
  }

  /// Remove permanentemente um relatório pelo uuid.
  Future<void> deleteReport(String uuid) async {
    try {
      await _repository.deleteReport(uuid);
      await loadReports();
    } catch (_) {}
  }

  /// Aplica a busca textual e o filtro de status sobre os dados em memória.
  void _applyFilters() {
    var list = List<ReportEntity>.from(state.allReports);

    // 1. Filtro por status
    if (state.statusFilter != null) {
      list = list.where((r) {
        final statusStr = _syncStatusToString(r.syncStatus);
        return statusStr.toLowerCase() == state.statusFilter!.toLowerCase();
      }).toList();
    }

    // 2. Busca textual (nome do executante, matricula, número de OS, local ou equipamento)
    if (state.searchQuery.trim().isNotEmpty) {
      final query = state.searchQuery.toLowerCase().trim();
      list = list.where((r) {
        // Executantes
        final operatorsMatch = r.operators.any((o) =>
            o.name.toLowerCase().contains(query) ||
            o.registration.toLowerCase().contains(query));

        // OSs
        final osMatch = r.workOrders.any((os) =>
            os.number.toLowerCase().contains(query) ||
            os.location.toLowerCase().contains(query) ||
            os.activities.toLowerCase().contains(query));

        // Equipamento global
        final equipMatch = r.globalEquipment.toLowerCase().contains(query);

        return operatorsMatch || osMatch || equipMatch;
      }).toList();
    }

    state = state.copyWith(filteredReports: list);
  }

  String _syncStatusToString(ReportSyncStatus status) {
    switch (status) {
      case ReportSyncStatus.draft:
        return 'Rascunho';
      case ReportSyncStatus.pending:
        return 'Em Andamento';
      case ReportSyncStatus.synced:
        return 'Finalizada';
      case ReportSyncStatus.error:
        return 'Erro';
    }
  }
}
