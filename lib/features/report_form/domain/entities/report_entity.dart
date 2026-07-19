import 'package:flutter/foundation.dart';
import 'collaborator_entity.dart';
import 'work_order_entity.dart';

/// Status do ciclo de vida do rascunho/relatório.
enum ReportSyncStatus {
  draft,      // Rascunho local não enviado
  pending,    // Aguardando conexão para sincronizar
  synced,     // Sincronizado com sucesso no Firebase
  error,      // Falhou na sincronização
}

/// Entidade de domínio que representa o formulário de relatório completo.
@immutable
class ReportEntity {
  final String uuid;
  final DateTime date;
  final String shift;
  final String team;
  final String globalEquipment;
  final String globalLocation;
  final double fuelLevel;
  final String availableMaterials;
  final String observations;
  final List<CollaboratorEntity> operators;
  final List<WorkOrderEntity> workOrders;
  final ReportSyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReportEntity({
    required this.uuid,
    required this.date,
    this.shift = '',
    this.team = '',
    this.globalEquipment = '',
    this.globalLocation = '',
    this.fuelLevel = 0.0,
    this.availableMaterials = '',
    this.observations = '',
    this.operators = const [],
    this.workOrders = const [],
    this.syncStatus = ReportSyncStatus.draft,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDraft => syncStatus == ReportSyncStatus.draft;
  bool get isPending => syncStatus == ReportSyncStatus.pending;
  bool get isSynced => syncStatus == ReportSyncStatus.synced;

  ReportEntity copyWith({
    String? uuid,
    DateTime? date,
    String? shift,
    String? team,
    String? globalEquipment,
    String? globalLocation,
    double? fuelLevel,
    String? availableMaterials,
    String? observations,
    List<CollaboratorEntity>? operators,
    List<WorkOrderEntity>? workOrders,
    ReportSyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportEntity(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      shift: shift ?? this.shift,
      team: team ?? this.team,
      globalEquipment: globalEquipment ?? this.globalEquipment,
      globalLocation: globalLocation ?? this.globalLocation,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      observations: observations ?? this.observations,
      operators: operators ?? this.operators,
      workOrders: workOrders ?? this.workOrders,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportEntity &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}
