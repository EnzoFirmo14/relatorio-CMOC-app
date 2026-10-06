import 'package:isar_community/isar.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/water_level_entity.dart';
import '../../domain/entities/pump_entity.dart';
import '../../domain/entities/material_entity.dart';
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

@embedded
class EmbeddedWaterLevelModel {
  EmbeddedWaterLevelModel();

  late String pointId;
  late String location;
  late String level;
  bool? abastec;
  late String abastecMotivo;
  bool? vaz;
  late String vazLocal;
  late String trend;
  late String observations;

  factory EmbeddedWaterLevelModel.fromEntity(WaterLevelEntity entity) {
    return EmbeddedWaterLevelModel()
      ..pointId = entity.pointId
      ..location = entity.location
      ..level = entity.level
      ..abastec = entity.abastec
      ..abastecMotivo = entity.abastecMotivo
      ..vaz = entity.vaz
      ..vazLocal = entity.vazLocal
      ..trend = entity.trend
      ..observations = entity.observations;
  }

  WaterLevelEntity toEntity() {
    return WaterLevelEntity(
      pointId: pointId,
      location: location,
      level: level,
      abastec: abastec,
      abastecMotivo: abastecMotivo,
      vaz: vaz,
      vazLocal: vazLocal,
      trend: trend,
      observations: observations,
    );
  }
}

@embedded
class EmbeddedPumpModel {
  EmbeddedPumpModel();

  late String name;
  late String metragem;
  late String bombaStatus;
  late String limpeza;
  late String ocorrencias;

  factory EmbeddedPumpModel.fromEntity(PumpEntity entity) {
    return EmbeddedPumpModel()
      ..name = entity.name
      ..metragem = entity.metragem
      ..bombaStatus = entity.bombaStatus
      ..limpeza = entity.limpeza
      ..ocorrencias = entity.ocorrencias;
  }

  PumpEntity toEntity() {
    return PumpEntity(
      name: name,
      metragem: metragem,
      bombaStatus: bombaStatus,
      limpeza: limpeza,
      ocorrencias: ocorrencias,
    );
  }
}

@embedded
class EmbeddedMaterialModel {
  EmbeddedMaterialModel();

  late String name;
  late String quantity;

  factory EmbeddedMaterialModel.fromEntity(MaterialEntity entity) {
    return EmbeddedMaterialModel()
      ..name = entity.name
      ..quantity = entity.quantity;
  }

  MaterialEntity toEntity() {
    return MaterialEntity(
      name: name,
      quantity: quantity,
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
  ReportModelSyncStatus syncStatus = ReportModelSyncStatus.draft;

  String type = 'Equipagem';

  DateTime createdAt = DateTime.now();
  late DateTime updatedAt;

  late List<EmbeddedCollaboratorModel> operators;
  late List<WorkOrderModel> workOrders;
  late List<EmbeddedWaterLevelModel> waterLevels;
  late List<EmbeddedPumpModel> pumps;
  late List<EmbeddedMaterialModel> materialsUsed;

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
      ..type = entity.type
      ..syncStatus = _entityStatusToModel(entity.syncStatus)
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..operators = entity.operators
          .map(EmbeddedCollaboratorModel.fromEntity)
          .toList()
      ..workOrders = entity.workOrders
          .map(WorkOrderModel.fromEntity)
          .toList()
      ..waterLevels = entity.waterLevels
          .map(EmbeddedWaterLevelModel.fromEntity)
          .toList()
      ..pumps = entity.pumps
          .map(EmbeddedPumpModel.fromEntity)
          .toList()
      ..materialsUsed = entity.materialsUsed
          .map(EmbeddedMaterialModel.fromEntity)
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
      type: type,
      syncStatus: _modelStatusToEntity(syncStatus),
      createdAt: createdAt,
      updatedAt: updatedAt,
      operators: operators.map((o) => o.toEntity()).toList(),
      workOrders: workOrders.map((w) => w.toEntity()).toList(),
      waterLevels: waterLevels.map((w) => w.toEntity()).toList(),
      pumps: pumps.map((p) => p.toEntity()).toList(),
      materialsUsed: materialsUsed.map((m) => m.toEntity()).toList(),
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
