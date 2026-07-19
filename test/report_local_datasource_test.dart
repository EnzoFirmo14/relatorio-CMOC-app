import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:flutter_teste_1/features/report_form/data/datasources/report_local_datasource.dart';
import 'package:flutter_teste_1/features/report_form/data/models/collaborator_model.dart';
import 'package:flutter_teste_1/features/report_form/data/models/report_model.dart';
import 'package:flutter_teste_1/features/report_form/data/models/work_order_model.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/collaborator_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/report_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/work_order_entity.dart';

/// Helper para criar um ReportEntity de teste com campos preenchidos.
ReportEntity _makeReport({
  String uuid = 'test-uuid-001',
  ReportSyncStatus syncStatus = ReportSyncStatus.draft,
}) {
  final now = DateTime.now();
  return ReportEntity(
    uuid: uuid,
    date: now,
    shift: 'T1',
    team: 'A',
    globalEquipment: 'Jumbo XL',
    globalLocation: 'Nível 4 — Galeria Leste',
    fuelLevel: 75.0,
    availableMaterials: 'Bits, Varetas',
    observations: 'Sem pendências',
    syncStatus: syncStatus,
    createdAt: now,
    updatedAt: now,
    operators: const [
      CollaboratorEntity(id: '001', registration: '001', name: 'João Silva'),
    ],
    workOrders: const [
      WorkOrderEntity(
        id: 'os-1',
        number: 'OS-001',
        location: 'Galeria 4E',
        maintenanceType: 'Corretiva',
        cause: 'Desgaste natural',
        activities: 'Troca de brocas',
        materialsUsed: ['Broca 45mm'],
        startTime: '08:00',
        endTime: '10:30',
        status: 'Concluída',
      ),
    ],
  );
}

void main() {
  late Isar isar;
  late ReportLocalDataSource dataSource;

  setUpAll(() async {
    // Abre o Isar em memória para testes
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [ReportModelSchema, CollaboratorModelSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      inspector: false,
    );
    dataSource = ReportLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('ReportLocalDataSource', () {
    test('Deve salvar e recuperar um relatório pelo uuid', () async {
      final report = _makeReport();
      await dataSource.saveReport(report);

      final recovered = await dataSource.getReportByUuid(report.uuid);

      expect(recovered, isNotNull);
      expect(recovered!.uuid, equals(report.uuid));
      expect(recovered.shift, equals('T1'));
      expect(recovered.team, equals('A'));
      expect(recovered.globalEquipment, equals('Jumbo XL'));
      expect(recovered.operators.length, equals(1));
      expect(recovered.operators.first.name, equals('João Silva'));
      expect(recovered.workOrders.length, equals(1));
      expect(recovered.workOrders.first.number, equals('OS-001'));
    });

    test('Deve retornar null ao buscar uuid inexistente', () async {
      final result = await dataSource.getReportByUuid('uuid-inexistente');
      expect(result, isNull);
    });

    test('Deve retornar o rascunho mais recente', () async {
      final now = DateTime.now();
      // Usa datas explicitamente distintas para garantir ordenação correta.
      final older = ReportEntity(
        uuid: 'old-001',
        date: now.subtract(const Duration(hours: 2)),
        syncStatus: ReportSyncStatus.draft,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      );
      final newer = ReportEntity(
        uuid: 'new-002',
        date: now,
        syncStatus: ReportSyncStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await dataSource.saveReport(older);
      await dataSource.saveReport(newer);

      final draft = await dataSource.getLatestDraft();
      expect(draft, isNotNull);
      expect(draft!.uuid, equals('new-002'));
    });

    test('Deve retornar null para getLatestDraft quando não há rascunhos', () async {
      final draft = await dataSource.getLatestDraft();
      expect(draft, isNull);
    });

    test('Deve excluir um relatório existente pelo uuid', () async {
      final report = _makeReport();
      await dataSource.saveReport(report);

      await dataSource.deleteReport(report.uuid);

      final result = await dataSource.getReportByUuid(report.uuid);
      expect(result, isNull);
    });

    test('Deve silenciosamente ignorar exclusão de uuid inexistente', () async {
      expect(
        () async => await dataSource.deleteReport('nao-existe'),
        returnsNormally,
      );
    });

    test('Deve retornar todos os relatórios salvos', () async {
      await dataSource.saveReport(_makeReport(uuid: 'uuid-a'));
      await dataSource.saveReport(_makeReport(uuid: 'uuid-b'));
      await dataSource.saveReport(_makeReport(uuid: 'uuid-c'));

      final all = await dataSource.getAllReports();
      expect(all.length, equals(3));
    });

    test('Deve marcar um relatório como sincronizado', () async {
      final report = _makeReport();
      await dataSource.saveReport(report);

      await dataSource.markAsSynced(report.uuid);

      final result = await dataSource.getReportByUuid(report.uuid);
      expect(result, isNotNull);
      expect(result!.syncStatus, equals(ReportSyncStatus.synced));
    });

    test('Deve realizar upsert ao salvar o mesmo uuid duas vezes', () async {
      final report = _makeReport();
      await dataSource.saveReport(report);

      // Modifica e salva novamente com mesmo uuid
      final updated = report.copyWith(shift: 'T2', team: 'B');
      await dataSource.saveReport(updated);

      final all = await dataSource.getAllReports();
      expect(all.length, equals(1), reason: 'Não deve criar duplicata');

      final recovered = await dataSource.getReportByUuid(report.uuid);
      expect(recovered!.shift, equals('T2'));
      expect(recovered.team, equals('B'));
    });
  });
}
