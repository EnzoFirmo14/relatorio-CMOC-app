import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/isar_service.dart';
import '../../data/datasources/report_local_datasource.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/in_memory_report_repository.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/work_order_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import 'report_form_state.dart';

// ─── Providers ─────────────────────────────────────────────────────────────

/// Provider do repositório local — pode ser sobrescrito em testes com mock.
final reportRepositoryProvider = Provider<IReportRepository>((ref) {
  if (kIsWeb) {
    return InMemoryReportRepository();
  }
  final dataSource = ReportLocalDataSource(IsarService.instance.isar);
  return ReportRepositoryImpl(dataSource);
});

final reportFormControllerProvider =
    NotifierProvider<ReportFormController, ReportFormState>(
  ReportFormController.new,
);

// ─── Controller ────────────────────────────────────────────────────────────

class ReportFormController extends Notifier<ReportFormState> {
  late IReportRepository _repository;

  @override
  ReportFormState build() {
    _repository = ref.read(reportRepositoryProvider);
    _loadLatestDraft();
    return ReportFormState(date: DateTime.now());
  }

  // ─── Draft Management ──────────────────────────────────────────────────

  /// Carrega o último rascunho salvo no Isar.
  /// Se houver rascunho, preenche o estado e exibe o banner.
  Future<void> _loadLatestDraft() async {
    try {
      final draft = await _repository.getLatestDraft();
      if (draft == null) return;

      state = _entityToState(draft).copyWith(
        draftBannerVisible: true,
        autosaveStatus: AutosaveStatus.saved,
      );
    } catch (_) {
      // Silently fail: o app continua com estado vazio se o Isar falhar.
    }
  }

  /// Descarta o rascunho atual e reinicia o formulário.
  Future<void> discardDraft() async {
    try {
      await _repository.deleteReport(state.uuid);
    } catch (_) {}
    state = ReportFormState(date: DateTime.now());
  }

  /// Carrega um relatório específico para edição.
  void loadReport(ReportEntity report) {
    state = _entityToState(report).copyWith(
      draftBannerVisible: false,
      autosaveStatus: AutosaveStatus.saved,
    );
  }

  /// Duplica um relatório específico gerando um novo rascunho.
  Future<void> duplicateReport(ReportEntity report) async {
    final now = DateTime.now();
    // Clona o relatório com nova identidade e data
    final cloned = report.copyWith(
      uuid: const Uuid().v4(),
      date: now,
      syncStatus: ReportSyncStatus.draft,
      createdAt: now,
      updatedAt: now,
    );

    // Carrega o clone no formulário e persiste imediatamente
    state = _entityToState(cloned).copyWith(
      draftBannerVisible: false,
      autosaveStatus: AutosaveStatus.saving,
    );

    try {
      await _repository.saveReport(cloned);
      state = state.copyWith(autosaveStatus: AutosaveStatus.saved);
    } catch (_) {
      state = state.copyWith(autosaveStatus: AutosaveStatus.error);
    }
  }

  /// Persiste o estado atual no Isar como rascunho.
  /// Chamado automaticamente a cada mutação relevante do formulário.
  Future<void> _autosave() async {
    state = state.copyWith(autosaveStatus: AutosaveStatus.saving);
    try {
      final entity = _stateToEntity();
      await _repository.saveReport(entity);
      state = state.copyWith(autosaveStatus: AutosaveStatus.saved);
    } catch (_) {
      state = state.copyWith(autosaveStatus: AutosaveStatus.error);
    }
  }

  /// Valida o relatório, marca seu status como pendente e tenta enviá-lo imediatamente ao Firestore.
  /// Se offline, permanece na fila pendente para sincronização automática futura.
  Future<bool> submitReport() async {
    final errors = validateForm();
    if (errors.isNotEmpty) {
      return false;
    }

    state = state.copyWith(
      syncStatus: ReportSyncStatus.pending,
      reportStatus: 'Pendente',
    );

    await _autosave();

    try {
      await ref.read(syncControllerProvider.notifier).triggerSync();
      state = state.copyWith(
        syncStatus: ReportSyncStatus.synced,
        reportStatus: 'Sincronizado',
      );
    } catch (e) {
      debugPrint('Erro no triggerSync de submitReport: $e');
    }

    return true;
  }

  // ─── Field Setters ─────────────────────────────────────────────────────

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
    _autosave();
  }

  void setShift(String shift) {
    state = state.copyWith(shift: shift);
    _autosave();
  }

  void setTeam(String team) {
    state = state.copyWith(team: team);
    _autosave();
  }

  void setGlobalEquipment(String equipment) {
    state = state.copyWith(globalEquipment: equipment);
    _autosave();
  }

  void setGlobalLocation(String location) {
    state = state.copyWith(globalLocation: location);
    _autosave();
  }

  void setFuelLevel(double level) {
    state = state.copyWith(fuelLevel: level);
    _autosave();
  }

  void setAvailableMaterials(String materials) {
    state = state.copyWith(availableMaterials: materials);
    _autosave();
  }

  void setObservations(String observations) {
    state = state.copyWith(observations: observations);
    _autosave();
  }

  void setReportStatus(String status) {
    state = state.copyWith(reportStatus: status);
    _autosave();
  }

  void setShowValidationPanel(bool show) {
    state = state.copyWith(showValidationPanel: show);
  }

  void clearValidationErrors() {
    state = state.copyWith(validationErrors: const [], showValidationPanel: false);
  }

  // ─── Operators (Executantes) ────────────────────────────────────────────

  void addOperator([String name = '', String registration = '']) {
    final updated = List<OperatorState>.from(state.operators)
      ..add(OperatorState(name: name, registration: registration));
    state = state.copyWith(operators: updated);
    _autosave();
  }

  void removeOperator(int index) {
    if (state.operators.length <= 1) {
      updateOperator(0, '', '');
      return;
    }
    final updated = List<OperatorState>.from(state.operators)..removeAt(index);
    state = state.copyWith(operators: updated);
    _autosave();
  }

  void updateOperator(int index, String name, String registration) {
    if (index < 0 || index >= state.operators.length) return;
    final updated = List<OperatorState>.from(state.operators);
    updated[index] = OperatorState(name: name, registration: registration);
    state = state.copyWith(operators: updated);
    _autosave();
  }

  void registerCustomCollaborator(String name, String registration) {
    final exists = state.customCollaborators.any((c) => c['mat'] == registration);
    if (!exists) {
      final updated = List<Map<String, String>>.from(state.customCollaborators)
        ..add({'mat': registration, 'nome': name});
      state = state.copyWith(customCollaborators: updated);
    }
    // Colaboradores customizados também são salvos para que o autocomplete
    // os lembre na próxima sessão (via entidade operators quando selecionados).
    _autosave();
  }

  /// Retorna colaboradores consolidados (fixos + cadastrados localmente).
  List<Map<String, String>> getConsolidatedCollaborators() {
    final list = List<Map<String, String>>.from(AppConstants.colaboradoresIniciais);
    for (final colab in state.customCollaborators) {
      if (!list.any((c) => c['mat'] == colab['mat'])) {
        list.add(colab);
      }
    }
    list.sort((a, b) => (a['nome'] ?? '').compareTo(b['nome'] ?? ''));
    return list;
  }

  // ─── Work Orders (OS) ──────────────────────────────────────────────────

  String getNextOSNumber() {
    final count = state.osCounter + 1;
    return 'OS-${count.toString().padLeft(3, '0')}';
  }

  void addWorkOrder(String location, [String? customNum]) {
    final count = state.osCounter + 1;
    final osNum = (customNum != null && customNum.isNotEmpty)
        ? customNum
        : 'OS-${count.toString().padLeft(3, '0')}';
    final osId = 'os-$count';

    final newOS = WorkOrderState(
      id: osId,
      number: osNum,
      location: location,
    );

    final updated = List<WorkOrderState>.from(state.workOrders)..add(newOS);
    state = state.copyWith(workOrders: updated, osCounter: count);
    _autosave();
  }

  void removeWorkOrder(String id) {
    final updated = List<WorkOrderState>.from(state.workOrders)
      ..removeWhere((o) => o.id == id);
    state = state.copyWith(workOrders: updated);
    _autosave();
  }

  void updateWorkOrder(
    String id,
    WorkOrderState Function(WorkOrderState) updateFunc,
  ) {
    final updated = List<WorkOrderState>.from(state.workOrders);
    final idx = updated.indexWhere((o) => o.id == id);
    if (idx != -1) {
      updated[idx] = updateFunc(updated[idx]);
      state = state.copyWith(workOrders: updated);
      _autosave();
    }
  }

  // ─── Validation ────────────────────────────────────────────────────────

  List<String> validateForm() {
    final List<String> errors = [];

    if (state.operators.isEmpty ||
        (state.operators[0].name.trim().isEmpty &&
            state.operators[0].registration.trim().isEmpty)) {
      errors.add('Informe pelo menos um Executante');
    }

    if (state.globalEquipment.trim().isEmpty) {
      errors.add('Equipamento deve ser selecionado ou informado ("N/A")');
    }
    if (state.globalLocation.trim().isEmpty) {
      errors.add('Local Global deve ser preenchido ou informado ("N/A")');
    }
    if (state.availableMaterials.trim().isEmpty) {
      errors.add('Materiais Disponíveis deve ser preenchido ou informado ("N/A")');
    }
    if (state.observations.trim().isEmpty) {
      errors.add('Observações Gerais devem ser preenchidas ou informadas ("N/A")');
    }

    if (state.workOrders.isEmpty) {
      errors.add('Adicione pelo menos uma Ordem de Serviço (OS)');
    }

    for (final os in state.workOrders) {
      final prefix = 'OS ${os.number}: ';

      if (os.maintenanceType.isEmpty) {
        errors.add('${prefix}Tipo de Manutenção não selecionado');
      }
      if (os.activities.trim().isEmpty) {
        errors.add('${prefix}Atividades realizadas não preenchidas');
      }
      if (os.cause.trim().isEmpty) {
        errors.add('${prefix}Causa/Motivo deve ser preenchido ou informado ("N/A")');
      }
      if (os.materialsUsed.isEmpty &&
          os.quantityMeters.trim().isEmpty &&
          os.quantityPieces.trim().isEmpty) {
        errors.add('${prefix}Materiais/Metros/Peças devem ser informados ou marcados como "N/A"');
      }
      if (os.startTime.isEmpty) {
        errors.add('${prefix}Horário de Início não preenchido');
      }
      if (os.endTime.isEmpty) {
        errors.add('${prefix}Horário de Término não preenchido');
      }
      if (os.startTime.isNotEmpty && os.endTime.isNotEmpty) {
        if (os.durationInMinutes <= 0) {
          errors.add('${prefix}Horário de Término deve ser depois do Início');
        }
      }
      if (os.status.isEmpty) {
        errors.add('${prefix}Status da OS não selecionado');
      }
    }

    state = state.copyWith(
      validationErrors: errors,
      showValidationPanel: errors.isNotEmpty,
    );

    return errors;
  }


  // ─── WhatsApp Text Generator ───────────────────────────────────────────

  String generateWhatsAppText() {
    final List<String> lines = [];
    lines.add('🔧 *RELATÓRIO DE TURNO — EQUIPAGEM — CMOC*');
    lines.add('━━━━━━━━━━━━━━━━━━━━━━━');
    lines.add('');
    lines.add('📋 *IDENTIFICAÇÃO*');
    lines.add('─────────────────────');

    final dateStr = _formatDate(state.date);
    lines.add('*Data:* $dateStr');

    for (int i = 0; i < state.operators.length; i++) {
      final op = state.operators[i];
      if (op.name.isNotEmpty || op.registration.isNotEmpty) {
        final details = [
          if (op.name.isNotEmpty) op.name,
          if (op.registration.isNotEmpty) 'Mat: ${op.registration}',
        ].join(' | ');
        lines.add('*Executante ${i + 1}:* $details');
      }
    }

    lines.add('*Turno:* ${state.shift}  |  *Turma:* ${state.team}');

    if (state.workOrders.isNotEmpty) {
      lines.add('');
      lines.add('📝 *ORDENS DE SERVIÇO — ATIVIDADES*');
      lines.add('─────────────────────');

      for (final os in state.workOrders) {
        lines.add('');
        final osLoc = os.location.isNotEmpty ? ' | 📍 ${os.location}' : '';
        lines.add('▸ *OS:* ${os.number}$osLoc');
        if (os.maintenanceType.isNotEmpty) {
          lines.add('*Tipo Manutenção:* ${os.maintenanceType}');
        }
        if (os.cause.isNotEmpty) {
          lines.add('*Causa:* ${os.cause}');
        }
        if (os.activities.trim().isNotEmpty) {
          lines.add('*Atividades:* ${os.activities.trim()}');
        }

        final mats = os.materialsUsed;
        if (mats.isNotEmpty) {
          lines.add('*Materiais:* ✓${mats.join(', ✓')}');
          if (os.quantityMeters.isNotEmpty) {
            lines.add('*Qtd. Metros:* ${os.quantityMeters}m');
          }
          if (os.quantityPieces.isNotEmpty) {
            lines.add('*Qtd. Peças:* ${os.quantityPieces}');
          }
        }

        if (os.startTime.isNotEmpty) {
          final end =
              os.endTime.isNotEmpty ? '  |  *Término:* ${os.endTime}' : '';
          lines.add('*Início:* ${os.startTime}$end');
        }
        if (os.status.isNotEmpty) {
          lines.add('*Status:* ${os.status}');
        }
        if (os.activities.isEmpty && mats.isEmpty) {
          lines.add('_(sem descrição)_');
        }
      }
    }

    final equipG = state.globalEquipment;
    final localG = state.globalLocation;
    final fuelG = state.fuelLevel;
    final matdispG = state.availableMaterials;

    if (equipG.isNotEmpty || localG.isNotEmpty || matdispG.isNotEmpty) {
      lines.add('');
      lines.add('🔩 *EQUIPAMENTO*');
      lines.add('─────────────────────');
      if (equipG.isNotEmpty) lines.add('*Equipamento:* $equipG');
      if (localG.isNotEmpty) lines.add('*Local:* $localG');
      lines.add('*Nível Combustível:* ${fuelG.toInt()}%');
      if (matdispG.isNotEmpty) lines.add('*Materiais Disponíveis:* $matdispG');
    }

    final obs = state.observations;
    if (obs.isNotEmpty) {
      lines.add('');
      lines.add('┌──────────────────────┐');
      lines.add('⚠️  *OBSERVAÇÕES / PENDÊNCIAS*');
      lines.add('└──────────────────────┘');
      for (final line in obs.split('\n')) {
        if (line.trim().isNotEmpty) {
          lines.add('▪ ${line.trim()}');
        }
      }
      lines.add('');
    }

    lines.add('');
    lines.add('━━━━━━━━━━━━━━━━━━━━━━━');
    return lines.join('\n');
  }

  void clearForm() {
    final oldCustomCollaborators = state.customCollaborators;
    state = ReportFormState(
      date: DateTime.now(),
      customCollaborators: oldCustomCollaborators,
    );
    _autosave();
  }

  void fillMechanicalMockData() {
    state = state.copyWith(
      date: DateTime.now(),
      shift: 'T1',
      team: 'A',
      observations: 'Turno operado em ritmo normal. Equipamentos testados e liberados para a equipe de operação.',
      operators: [
        const OperatorState(name: 'Adonis Evaristo Sousa dos Santos', registration: '99300182'),
        const OperatorState(name: 'Gabriel Alves Queiroz Lopes', registration: '99300456'),
      ],
      workOrders: [
        const WorkOrderState(
          id: 'os-1',
          number: 'OM-001',
          location: 'E22 - 01',
          maintenanceType: 'Inspeção',
          equipmentType: 'Bomba',
          tagVal: 'BAEI3072',
          tagDesc: 'BOMBA MULTIESTAGIO EQUIPE EQ4-125-100-24',
          activities: 'Realizada inspeção visual, teste de pressão e verificação de gaxetas. Sem anormalidades.',
          startTime: '08:00',
          endTime: '10:30',
          hasStoppage: true,
          stoppageStartTime: '08:15',
          stoppageEndTime: '09:00',
          pressure: '12.5',
          horometer: '45210',
          tasks: {
            'oleo': 'sim',
            'troca-oleo': 'nao',
            'gaxeta': 'sim',
            'ajuste-gaxeta': 'sim',
            'lubr-bomba': 'sim',
            'agua-refrig': 'ok',
          },
          status: 'Concluído',
          isFinalized: true,
        ),
        const WorkOrderState(
          id: 'os-2',
          number: 'OM-002',
          location: 'HL',
          maintenanceType: 'Preditiva',
          datasulOm: 'DS-99482',
          equipmentType: 'Motor',
          tagVal: 'BAEI3079',
          tagDesc: 'BOMBA FLUTUANTE WEIR',
          activities: 'Análise de vibração e medição de temperatura de rolamentos.',
          startTime: '11:00',
          endTime: '12:15',
          hasStoppage: false,
          vibrationSpeed: '4.2',
          vibrationGe: '1.8',
          vibrationTemp: '68.5',
          tasks: {
            'predTarefas': 'vibracao',
          },
          status: 'Liberado',
          isFinalized: true,
        ),
        const WorkOrderState(
          id: 'os-3',
          number: 'OM-003',
          location: 'Oficina Infra',
          maintenanceType: 'Corretiva',
          equipmentType: 'Exaustor',
          tagVal: 'VEPI3003',
          tagDesc: 'VENTILADOR AXIAL VENTILAÇÃO PRIMÁRIA 300CV',
          cause: 'Desgaste prematuro de rolamentos',
          symptom: 'Ruído excessivo e vibração elevada',
          intervention: 'Substituição completa de rolamento e rebalanceamento do rotor.',
          activities: 'Montagem e teste em bancada concluídos com sucesso.',
          startTime: '13:30',
          endTime: '17:00',
          hasStoppage: true,
          stoppageStartTime: '13:30',
          stoppageEndTime: '17:00',
          tasks: {
            'lubr-exaust': 'sim',
            'torque-paraf': 'sim',
          },
          status: 'Bombeamento Parado',
          isFinalized: false,
        ),
      ],
      osCounter: 3,
    );
    _autosave();
  }

  void fillMockData() {
    state = state.copyWith(
      date: DateTime.now(),
      shift: AppConstants.shiftOptions.isNotEmpty ? AppConstants.shiftOptions.first : 'T1',
      team: AppConstants.teamOptions.isNotEmpty ? AppConstants.teamOptions.first : 'A',
      globalEquipment: AppConstants.equipOptions.isNotEmpty ? AppConstants.equipOptions.first : 'PT302',
      globalLocation: 'Frente de Lavra 01',
      fuelLevel: 75.0,
      availableMaterials: 'Duto de 800, Abraçadeira de 110',
      observations: 'Operação realizada com sucesso. Sem intercorrências.',
      operators: [
        const OperatorState(name: 'Acacio Oliveira Souza', registration: '4786'),
        const OperatorState(name: 'Adailton Silva Santos', registration: '99300599'),
      ],
      workOrders: [
        const WorkOrderState(
          id: 'os-1',
          number: 'OS-001',
          location: 'Galeria Norte',
          maintenanceType: 'Avanço',
          cause: 'Avanço de Tubulação',
          activities: 'Instalação de 3 tubos de ventilação adicionais.',
          materialsUsed: ['Duto de 800', 'Abraçadeira Comum'],
          quantityMeters: '18',
          quantityPieces: '3',
          startTime: '08:00',
          endTime: '10:30',
          status: 'Liberado',
        ),
        const WorkOrderState(
          id: 'os-2',
          number: 'OS-002',
          location: 'Poço 3',
          maintenanceType: 'Corretiva',
          cause: 'Tubo Danificado',
          activities: 'Substituição de duto rasgado por um novo.',
          materialsUsed: ['Duto de 1000', 'Corrente'],
          quantityMeters: '6',
          quantityPieces: '1',
          startTime: '13:00',
          endTime: '14:15',
          status: 'Corrigido',
        ),
      ],
      osCounter: 2,
    );
    _autosave();
  }


  // ─── Photo Management ──────────────────────────────────────────────────

  /// Adiciona o caminho de uma foto a uma OS específica.
  void addPhotoToWorkOrder(String osId, String filePath) {
    final updatedWorkOrders = state.workOrders.map((os) {
      if (os.id == osId) {
        return os.copyWith(photoPaths: [...os.photoPaths, filePath]);
      }
      return os;
    }).toList();

    state = state.copyWith(workOrders: updatedWorkOrders);
    _autosave();
  }

  /// Remove o caminho de uma foto de uma OS específica.
  void removePhotoFromWorkOrder(String osId, String filePath) {
    final updatedWorkOrders = state.workOrders.map((os) {
      if (os.id == osId) {
        final updatedPhotos = List<String>.from(os.photoPaths)..remove(filePath);
        return os.copyWith(photoPaths: updatedPhotos);
      }
      return os;
    }).toList();

    state = state.copyWith(workOrders: updatedWorkOrders);
    _autosave();
  }

  // ─── Converters (State <-> Entity) ────────────────────────────────────

  ReportEntity _stateToEntity() {
    return ReportEntity(
      uuid: state.uuid,
      date: state.date,
      shift: state.shift,
      team: state.team,
      globalEquipment: state.globalEquipment,
      globalLocation: state.globalLocation,
      fuelLevel: state.fuelLevel,
      availableMaterials: state.availableMaterials,
      observations: state.observations,
      syncStatus: state.syncStatus,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      operators: state.operators
          .where((o) => o.name.isNotEmpty || o.registration.isNotEmpty)
          .map(
            (o) => CollaboratorEntity(
              id: o.registration,
              registration: o.registration,
              name: o.name,
            ),
          )
          .toList(),
      workOrders: state.workOrders
          .map(
            (os) => WorkOrderEntity(
              id: os.id,
              number: os.number,
              location: os.location,
              maintenanceType: os.maintenanceType,
              maintenanceTypeOutro: os.maintenanceTypeOutro,
              equipmentType: os.equipmentType,
              equipmentOutro: os.equipmentOutro,
              datasulOm: os.datasulOm,
              tagVal: os.tagVal,
              tagDesc: os.tagDesc,
              tagOutro: os.tagOutro,
              cause: os.cause,
              symptom: os.symptom,
              intervention: os.intervention,
              activities: os.activities,
              materialsUsed: os.materialsUsed,
              quantityMeters: os.quantityMeters,
              quantityPieces: os.quantityPieces,
              startTime: os.startTime,
              endTime: os.endTime,
              hasStoppage: os.hasStoppage,
              stoppageStartTime: os.stoppageStartTime,
              stoppageEndTime: os.stoppageEndTime,
              pressure: os.pressure,
              horometer: os.horometer,
              vibrationSpeed: os.vibrationSpeed,
              vibrationGe: os.vibrationGe,
              vibrationTemp: os.vibrationTemp,
              predOtherDesc: os.predOtherDesc,
              tasks: os.tasks,
              isFinalized: os.isFinalized,
              status: os.status,
              osStatus: os.osStatus,
              photoPaths: os.photoPaths,
            ),
          )
          .toList(),
    );
  }

  ReportFormState _entityToState(ReportEntity entity) {
    final ops = entity.operators.isNotEmpty
        ? entity.operators
            .map((e) => OperatorState(name: e.name, registration: e.registration))
            .toList()
        : [const OperatorState(name: '', registration: '')];

    final workOrders = entity.workOrders
        .map(
          (e) => WorkOrderState(
            id: e.id,
            number: e.number,
            location: e.location,
            maintenanceType: e.maintenanceType,
            maintenanceTypeOutro: e.maintenanceTypeOutro,
            equipmentType: e.equipmentType,
            equipmentOutro: e.equipmentOutro,
            datasulOm: e.datasulOm,
            tagVal: e.tagVal,
            tagDesc: e.tagDesc,
            tagOutro: e.tagOutro,
            cause: e.cause,
            symptom: e.symptom,
            intervention: e.intervention,
            activities: e.activities,
            materialsUsed: e.materialsUsed,
            quantityMeters: e.quantityMeters,
            quantityPieces: e.quantityPieces,
            startTime: e.startTime,
            endTime: e.endTime,
            hasStoppage: e.hasStoppage,
            stoppageStartTime: e.stoppageStartTime,
            stoppageEndTime: e.stoppageEndTime,
            pressure: e.pressure,
            horometer: e.horometer,
            vibrationSpeed: e.vibrationSpeed,
            vibrationGe: e.vibrationGe,
            vibrationTemp: e.vibrationTemp,
            predOtherDesc: e.predOtherDesc,
            tasks: e.tasks,
            isFinalized: e.isFinalized,
            status: e.status,
            osStatus: e.osStatus,
            photoPaths: e.photoPaths,
          ),
        )
        .toList();


    return ReportFormState(
      uuid: entity.uuid,
      date: entity.date,
      shift: entity.shift,
      team: entity.team,
      globalEquipment: entity.globalEquipment,
      globalLocation: entity.globalLocation,
      fuelLevel: entity.fuelLevel,
      availableMaterials: entity.availableMaterials,
      observations: entity.observations,
      reportStatus: entity.syncStatus == ReportSyncStatus.synced
          ? 'Sincronizado'
          : entity.syncStatus == ReportSyncStatus.pending
              ? 'Pendente'
              : 'Rascunho',
      syncStatus: entity.syncStatus,
      operators: ops,
      workOrders: workOrders,
      osCounter: workOrders.length,
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }
}
