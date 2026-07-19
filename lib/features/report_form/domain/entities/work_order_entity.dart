import 'package:flutter/foundation.dart';

/// Entidade de domínio que representa uma Ordem de Serviço (OS).
@immutable
class WorkOrderEntity {
  final String id;
  final String number;
  final String location;
  final String maintenanceType;
  final String cause;
  final String activities;
  final List<String> materialsUsed;
  final String quantityMeters;
  final String quantityPieces;
  final String startTime;
  final String endTime;
  final String status;
  final String osStatus;
  final List<String> photoPaths;

  const WorkOrderEntity({
    required this.id,
    required this.number,
    this.location = '',
    this.maintenanceType = '',
    this.cause = '',
    this.activities = '',
    this.materialsUsed = const [],
    this.quantityMeters = '',
    this.quantityPieces = '',
    this.startTime = '',
    this.endTime = '',
    this.status = '',
    this.osStatus = '',
    this.photoPaths = const [],
  });

  WorkOrderEntity copyWith({
    String? id,
    String? number,
    String? location,
    String? maintenanceType,
    String? cause,
    String? activities,
    List<String>? materialsUsed,
    String? quantityMeters,
    String? quantityPieces,
    String? startTime,
    String? endTime,
    String? status,
    String? osStatus,
    List<String>? photoPaths,
  }) {
    return WorkOrderEntity(
      id: id ?? this.id,
      number: number ?? this.number,
      location: location ?? this.location,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      cause: cause ?? this.cause,
      activities: activities ?? this.activities,
      materialsUsed: materialsUsed ?? this.materialsUsed,
      quantityMeters: quantityMeters ?? this.quantityMeters,
      quantityPieces: quantityPieces ?? this.quantityPieces,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      osStatus: osStatus ?? this.osStatus,
      photoPaths: photoPaths ?? this.photoPaths,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkOrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
