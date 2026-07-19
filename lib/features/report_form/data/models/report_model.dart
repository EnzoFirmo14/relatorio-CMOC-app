import 'package:isar/isar.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/work_order_entity.dart';
import 'work_order_model.dart';

part 'report_model.g.dart';

/// Enum de sincronização persisto como inteiro no Isar.
enum ReportModelSyncStatus {
  draft,
  pending,
  synced,
  error,
}

/// Modelo embutido para colaboradores/executantes dentro do ReportModel.
/// Como cada relatório tem poucos executantes (até ~6), usamos embedded
/// para evitar a complexidade de links do Isar.
@embedded
class EmbeddedCollaboratorModel {
  EmbeddedCollaboratorModel();

  late String id;
  late String registration;
  late String name;
  late bool isCustom;

  factory EmbeddedCollaboratorModel.fromEntity(CollaboratorEntity entity) {
    return EmbeddedCollaboratorModel()
      ..id = entity.id
      ..registration = entity.registration
      ..name = entity.name
      ..isCustom = entity.isCustom;
  }

  CollaboratorEntity toEntity() {
    return CollaboratorEntity(
      id: id,
      registration: registration,
      name: name,
      isCustom: isCustom,
    );
  }
}

/// Coleção principal do Isar para o relatório completo.
@collection
class ReportModel {
  ReportModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late DateTime date;
  late String shift;
  late String team;
  late String globalEquipment;
  late String globalLocation;
  late double fuelLevel;
  late String availableMaterials;
  late String observations;

  @Enumerated(EnumType.name)
  late ReportModelSyncStatus syncStatus;

  late DateTime createdAt;
  late DateTime updatedAt;

  late List<EmbeddedCollaboratorModel> operators;
  late List<WorkOrderModel> workOrders;

  // ─── Converters ───────────────────────────────────────────────────────────

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel()
      ..uuid = entity.uuid
      ..date = entity.date
      ..shift = entity.shift
      ..team = entity.team
      ..globalEquipment = entity.globalEquipment
      ..globalLocation = entity.globalLocation
      ..fuelLevel = entity.fuelLevel
      ..availableMaterials = entity.availableMaterials
      ..observations = entity.observations
      ..syncStatus = _entityStatusToModel(entity.syncStatus)
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..operators = entity.operators
          .map(EmbeddedCollaboratorModel.fromEntity)
          .toList()
      ..workOrders = entity.workOrders
          .map(WorkOrderModel.fromEntity)
          .toList();
  }

  ReportEntity toEntity() {
    return ReportEntity(
      uuid: uuid,
      date: date,
      shift: shift,
      team: team,
      globalEquipment: globalEquipment,
      globalLocation: globalLocation,
      fuelLevel: fuelLevel,
      availableMaterials: availableMaterials,
      observations: observations,
      syncStatus: _modelStatusToEntity(syncStatus),
      createdAt: createdAt,
      updatedAt: updatedAt,
      operators: operators.map((o) => o.toEntity()).toList(),
      workOrders: workOrders.map((w) => w.toEntity()).toList(),
    );
  }

  static ReportModelSyncStatus _entityStatusToModel(ReportSyncStatus status) {
    switch (status) {
      case ReportSyncStatus.draft:
        return ReportModelSyncStatus.draft;
      case ReportSyncStatus.pending:
        return ReportModelSyncStatus.pending;
      case ReportSyncStatus.synced:
        return ReportModelSyncStatus.synced;
      case ReportSyncStatus.error:
        return ReportModelSyncStatus.error;
    }
  }

  static ReportSyncStatus _modelStatusToEntity(ReportModelSyncStatus status) {
    switch (status) {
      case ReportModelSyncStatus.draft:
        return ReportSyncStatus.draft;
      case ReportModelSyncStatus.pending:
        return ReportSyncStatus.pending;
      case ReportModelSyncStatus.synced:
        return ReportSyncStatus.synced;
      case ReportModelSyncStatus.error:
        return ReportSyncStatus.error;
    }
  }
}
