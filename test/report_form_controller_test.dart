import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/report_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/repositories/report_repository.dart';
import 'package:flutter_teste_1/features/report_form/presentation/controllers/report_form_controller.dart';
import 'package:flutter_teste_1/features/report_form/presentation/controllers/report_form_state.dart';

/// Implementação stub do repositório para uso em testes unitários.
/// Não depende de Isar ou qualquer persistência real.
class _FakeReportRepository implements IReportRepository {
  @override
  Future<String> saveReport(ReportEntity report) async => report.uuid;

  @override
  Future<ReportEntity?> getReportByUuid(String uuid) async => null;

  @override
  Future<ReportEntity?> getLatestDraft() async => null;

  @override
  Future<void> deleteReport(String uuid) async {}

  @override
  Future<List<ReportEntity>> getAllReports() async => [];

  @override
  Future<void> markAsSynced(String uuid) async {}

  @override
  Future<void> updateSyncStatus(String uuid, ReportSyncStatus status) async {}

  @override
  Future<List<ReportEntity>> getPendingReports() async => [];
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        // Sobrescreve o repositório com stub para não precisar do Isar.
        reportRepositoryProvider.overrideWithValue(_FakeReportRepository()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Deve iniciar com estado de rascunho padrao', () {
    final state = container.read(reportFormControllerProvider);
    expect(state.shift, equals('T1'));
    expect(state.team, equals('A'));
    expect(state.workOrders, isEmpty);
    expect(state.operators.length, equals(1));
    expect(state.operators[0].name, isEmpty);
    expect(state.operators[0].registration, isEmpty);
  });

  test('Deve gerenciar adicao, edicao e remocao de executantes', () {
    final controller = container.read(reportFormControllerProvider.notifier);

    // 1. Atualizar primeiro executante
    controller.updateOperator(0, 'Acacio Oliveira Souza', '4786');
    var state = container.read(reportFormControllerProvider);
    expect(state.operators[0].name, equals('Acacio Oliveira Souza'));
    expect(state.operators[0].registration, equals('4786'));

    // 2. Adicionar executante secundario
    controller.addOperator('Adailton Silva Santos', '99300599');
    state = container.read(reportFormControllerProvider);
    expect(state.operators.length, equals(2));
    expect(state.operators[1].name, equals('Adailton Silva Santos'));
    expect(state.operators[1].registration, equals('99300599'));

    // 3. Remover executante
    controller.removeOperator(1);
    state = container.read(reportFormControllerProvider);
    expect(state.operators.length, equals(1));
  });

  test('Deve gerenciar fluxo de OSs', () {
    final controller = container.read(reportFormControllerProvider.notifier);

    // 1. Adicionar OS
    controller.addWorkOrder('Bomba B-04', 'OS-001');
    var state = container.read(reportFormControllerProvider);
    expect(state.workOrders.length, equals(1));
    expect(state.workOrders[0].number, equals('OS-001'));
    expect(state.workOrders[0].location, equals('Bomba B-04'));
    expect(state.workOrders[0].osStatus, equals('Rascunho'));

    // 2. Atualizar campos da OS
    controller.updateWorkOrder('os-1', (os) => os.copyWith(
      maintenanceType: 'Avanço',
      cause: 'Avanço de Tubulação',
      activities: 'Instalação de tubos de 180',
      startTime: '08:00',
      endTime: '09:30',
      status: 'Liberado',
      osStatus: 'Finalizada',
    ));

    state = container.read(reportFormControllerProvider);
    final os = state.workOrders[0];
    expect(os.maintenanceType, equals('Avanço'));
    expect(os.cause, equals('Avanço de Tubulação'));
    expect(os.durationInMinutes, equals(90));
    expect(os.durationFormatted, equals('1h 30min'));
    expect(os.osStatus, equals('Finalizada'));

    // 3. Remover OS
    controller.removeWorkOrder('os-1');
    state = container.read(reportFormControllerProvider);
    expect(state.workOrders, isEmpty);
  });

  test('Deve validar campos obrigatorios e retornar erros', () {
    final controller = container.read(reportFormControllerProvider.notifier);

    // Estado inicial vazio -> deve dar erro de falta de executante
    var errors = controller.validateForm();
    expect(errors, contains('Informe pelo menos um Executante'));

    // Preenche executante -> erro de executante deve sumir
    controller.updateOperator(0, 'Acacio Oliveira Souza', '4786');
    errors = controller.validateForm();
    expect(errors, isNot(contains('Informe pelo menos um Executante')));

    // Adiciona OS vazia -> deve dar erros de tipo de manutencao, atividades, status e horario inicio
    controller.addWorkOrder('Bomba B-04', 'OS-001');
    errors = controller.validateForm();
    expect(errors, contains('OS OS-001: Tipo de Manutenção não selecionado'));
    expect(errors, contains('OS OS-001: Atividades realizadas não preenchidas'));
    expect(errors, contains('OS OS-001: Status não selecionado'));
    expect(errors, contains('OS OS-001: Horário de Início não preenchido'));

    // Preenche OS com horario invalido (termino antes do inicio)
    controller.updateWorkOrder('os-1', (os) => os.copyWith(
      maintenanceType: 'Apoio',
      activities: 'Apoio geral',
      status: 'Liberado',
      startTime: '10:00',
      endTime: '09:00',
    ));
    errors = controller.validateForm();
    expect(errors, contains('OS OS-001: Horário de Término deve ser depois do Início'));
  });

  test('Deve formatar texto do WhatsApp exatamente como esperado', () {
    final controller = container.read(reportFormControllerProvider.notifier);
    
    // Configura o relatorio
    final date = DateTime(2026, 7, 18);
    controller.setDate(date);
    controller.updateOperator(0, 'Acacio Oliveira Souza', '4786');
    controller.setShift('T1');
    controller.setTeam('A');
    
    // Adiciona OS
    controller.addWorkOrder('Bomba B-04', 'OS-001');
    controller.updateWorkOrder('os-1', (os) => os.copyWith(
      maintenanceType: 'Apoio',
      cause: 'Apoio a Elétrica',
      activities: 'Reparo de cabo elétrico do motor',
      materialsUsed: ['Cabo de Aço', 'Suporte'],
      quantityMeters: '15',
      quantityPieces: '2',
      startTime: '08:00',
      endTime: '09:30',
      status: 'Liberado',
    ));

    // Equipamento e Obs
    controller.setGlobalEquipment('PT302');
    controller.setGlobalLocation('Galeria Norte');
    controller.setFuelLevel(75.0);
    controller.setObservations('Motor em perfeito estado de funcionamento.\nPendência de pintura.');

    final formattedText = controller.generateWhatsAppText();

    // Validacoes no texto formatado
    expect(formattedText, contains('🔧 *RELATÓRIO DE TURNO — EQUIPAGEM — CMOC*'));
    expect(formattedText, contains('*Data:* 18/07/2026'));
    expect(formattedText, contains('*Executante 1:* Acacio Oliveira Souza | Mat: 4786'));
    expect(formattedText, contains('*Turno:* T1  |  *Turma:* A'));
    expect(formattedText, contains('▸ *OS:* OS-001 | 📍 Bomba B-04'));
    expect(formattedText, contains('*Tipo Manutenção:* Apoio'));
    expect(formattedText, contains('*Causa:* Apoio a Elétrica'));
    expect(formattedText, contains('*Atividades:* Reparo de cabo elétrico do motor'));
    expect(formattedText, contains('*Materiais:* ✓Cabo de Aço, ✓Suporte'));
    expect(formattedText, contains('*Qtd. Metros:* 15m'));
    expect(formattedText, contains('*Qtd. Peças:* 2'));
    expect(formattedText, contains('*Início:* 08:00  |  *Término:* 09:30'));
    expect(formattedText, contains('*Status:* Liberado'));
    expect(formattedText, contains('*Equipamento:* PT302'));
    expect(formattedText, contains('*Local:* Galeria Norte'));
    expect(formattedText, contains('*Nível Combustível:* 75%'));
    expect(formattedText, contains('⚠️  *OBSERVAÇÕES / PENDÊNCIAS*'));
    expect(formattedText, contains('▪ Motor em perfeito estado de funcionamento.'));
    expect(formattedText, contains('▪ Pendência de pintura.'));
  });

  test('Deve gerenciar adicao e remocao de fotos na OS', () {
    final controller = container.read(reportFormControllerProvider.notifier);
    
    // Adiciona OS
    controller.addWorkOrder('Bomba B-04', 'OS-001');
    
    // Adiciona foto
    controller.addPhotoToWorkOrder('os-1', 'photos/img_1.jpg');
    var state = container.read(reportFormControllerProvider);
    expect(state.workOrders[0].photoPaths, contains('photos/img_1.jpg'));
    
    // Remove foto
    controller.removePhotoFromWorkOrder('os-1', 'photos/img_1.jpg');
    state = container.read(reportFormControllerProvider);
    expect(state.workOrders[0].photoPaths, isNot(contains('photos/img_1.jpg')));
  });
}
