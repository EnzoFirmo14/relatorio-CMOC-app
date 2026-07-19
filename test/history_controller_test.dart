import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/features/history/presentation/controllers/history_controller.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/collaborator_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/report_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/work_order_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/repositories/report_repository.dart';

class _FakeHistoryReportRepository implements IReportRepository {
  final List<ReportEntity> db = [];

  @override
  Future<String> saveReport(ReportEntity report) async {
    db.removeWhere((r) => r.uuid == report.uuid);
    db.add(report);
    return report.uuid;
  }

  @override
  Future<ReportEntity?> getReportByUuid(String uuid) async {
    return db.any((r) => r.uuid == uuid) ? db.firstWhere((r) => r.uuid == uuid) : null;
  }

  @override
  Future<ReportEntity?> getLatestDraft() async {
    final drafts = db.where((r) => r.syncStatus == ReportSyncStatus.draft).toList();
    return drafts.isNotEmpty ? drafts.last : null;
  }

  @override
  Future<void> deleteReport(String uuid) async {
    db.removeWhere((r) => r.uuid == uuid);
  }

  @override
  Future<List<ReportEntity>> getAllReports() async {
    // Retorna ordenado decrescente por data para simular o Isar
    final sorted = List<ReportEntity>.from(db);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  @override
  Future<void> markAsSynced(String uuid) async {
    final idx = db.indexWhere((r) => r.uuid == uuid);
    if (idx != -1) {
      db[idx] = db[idx].copyWith(syncStatus: ReportSyncStatus.synced);
    }
  }

  @override
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status) async {
    final idx = db.indexWhere((r) => r.uuid == uuid);
    if (idx != -1) {
      db[idx] = db[idx].copyWith(syncStatus: status);
    }
  }

  @override
  Future<List<ReportEntity>> getPendingReports() async {
    return db
        .where((r) =>
            r.syncStatus == ReportSyncStatus.pending ||
            r.syncStatus == ReportSyncStatus.error)
        .toList();
  }
}

ReportEntity _mockReport({
  required String uuid,
  required String name,
  required String registration,
  required String equip,
  required String osNumber,
  required ReportSyncStatus status,
  required DateTime date,
}) {
  return ReportEntity(
    uuid: uuid,
    date: date,
    shift: 'T1',
    team: 'A',
    globalEquipment: equip,
    syncStatus: status,
    createdAt: date,
    updatedAt: date,
    operators: [
      CollaboratorEntity(id: registration, registration: registration, name: name),
    ],
    workOrders: [
      WorkOrderEntity(
        id: 'os-$uuid',
        number: osNumber,
        location: 'Galeria Sul',
        activities: 'Manutenção de motor',
      ),
    ],
  );
}

void main() {
  late _FakeHistoryReportRepository repository;
  late HistoryController controller;

  setUp(() async {
    repository = _FakeHistoryReportRepository();

    // Insere dados mockados no fake database
    final now = DateTime.now();
    await repository.saveReport(_mockReport(
      uuid: 'uuid-1',
      name: 'Acacio Oliveira',
      registration: '4786',
      equip: 'PT302',
      osNumber: 'OS-001',
      status: ReportSyncStatus.draft,
      date: now.subtract(const Duration(days: 2)),
    ));
    await repository.saveReport(_mockReport(
      uuid: 'uuid-2',
      name: 'Adailton Santos',
      registration: '9930',
      equip: 'Jumbo XL',
      osNumber: 'OS-002',
      status: ReportSyncStatus.pending,
      date: now.subtract(const Duration(days: 1)),
    ));
    await repository.saveReport(_mockReport(
      uuid: 'uuid-3',
      name: 'João Silva',
      registration: '1122',
      equip: 'PT302',
      osNumber: 'OS-003',
      status: ReportSyncStatus.synced,
      date: now,
    ));

    controller = HistoryController(repository);
    await controller.loadReports(); // Aguarda carregamento inicial
  });

  group('HistoryController Tests', () {
    test('Deve carregar a lista inicial completa', () {
      final state = controller.debugState;
      expect(state.allReports.length, equals(3));
      expect(state.filteredReports.length, equals(3));
      // Verifica ordenação por data decrescente (mais recente primeiro)
      expect(state.filteredReports[0].uuid, equals('uuid-3'));
      expect(state.filteredReports[1].uuid, equals('uuid-2'));
      expect(state.filteredReports[2].uuid, equals('uuid-1'));
    });

    test('Deve filtrar por busca textual (Nome)', () {
      controller.setSearchQuery('Acacio');
      final state = controller.debugState;
      expect(state.filteredReports.length, equals(1));
      expect(state.filteredReports.first.uuid, equals('uuid-1'));
    });

    test('Deve filtrar por busca de matrícula', () {
      controller.setSearchQuery('9930');
      final state = controller.debugState;
      expect(state.filteredReports.length, equals(1));
      expect(state.filteredReports.first.uuid, equals('uuid-2'));
    });

    test('Deve filtrar por busca de equipamento', () {
      controller.setSearchQuery('PT302');
      final state = controller.debugState;
      // Duas ordens de serviço têm PT302
      expect(state.filteredReports.length, equals(2));
      expect(state.filteredReports[0].uuid, equals('uuid-3'));
      expect(state.filteredReports[1].uuid, equals('uuid-1'));
    });

    test('Deve filtrar por busca de número de OS', () {
      controller.setSearchQuery('OS-002');
      final state = controller.debugState;
      expect(state.filteredReports.length, equals(1));
      expect(state.filteredReports.first.uuid, equals('uuid-2'));
    });

    test('Deve filtrar por Status (Rascunho)', () {
      controller.setStatusFilter('Rascunho');
      var state = controller.debugState;
      expect(state.filteredReports.length, equals(1));
      expect(state.filteredReports.first.uuid, equals('uuid-1'));

      controller.setStatusFilter('Em Andamento');
      state = controller.debugState;
      expect(state.filteredReports.length, equals(1));
      expect(state.filteredReports.first.uuid, equals('uuid-2'));

      controller.setStatusFilter('Finalizada');
      state = controller.debugState;
      expect(state.filteredReports.length, equals(1));
      expect(state.filteredReports.first.uuid, equals('uuid-3'));
    });

    test('Deve limpar filtros ao selecionar "Todos"', () {
      controller.setStatusFilter('Rascunho');
      expect(controller.debugState.filteredReports.length, equals(1));

      controller.setStatusFilter('Todos');
      expect(controller.debugState.filteredReports.length, equals(3));
    });

    test('Deve deletar um relatório e atualizar lista', () async {
      await controller.deleteReport('uuid-2');
      final state = controller.debugState;
      expect(state.allReports.length, equals(2));
      expect(state.filteredReports.length, equals(2));
      expect(state.allReports.any((r) => r.uuid == 'uuid-2'), isFalse);
    });
  });
}
