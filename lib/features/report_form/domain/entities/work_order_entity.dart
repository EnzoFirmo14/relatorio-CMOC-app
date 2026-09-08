import 'package:flutter/foundation.dart';

/// Entidade de domínio que representa uma Ordem de Serviço / Manutenção (OS/OM).
@immutable
class WorkOrderEntity {
  final String id;
  final String number;
  final String location;
  final String maintenanceType;
  final String maintenanceTypeOutro;
  final String equipmentType;
  final String equipmentOutro;
  final String datasulOm;
  final String tagVal;
  final String tagDesc;
  final String tagOutro;
  final String cause;
  final String symptom;
  final String intervention;
  final String activities;
  final List<String> materialsUsed;
  final String quantityMeters;
  final String quantityPieces;
  final String callTime;
  final String startTime;
  final String endTime;
  final bool hasStoppage;
  final String stoppageStartTime;
  final String stoppageEndTime;
  final String pressure;
  final String horometer;
  final String vibrationSpeed;
  final String vibrationGe;
  final String vibrationTemp;
  final String predOtherDesc;
  final Map<String, String> tasks;
  final bool isFinalized;
  final String status;
  final String osStatus;
  final List<String> photoPaths;

  const WorkOrderEntity({
    required this.id,
    required this.number,
    this.location = '',
    this.maintenanceType = '',
    this.maintenanceTypeOutro = '',
    this.equipmentType = '',
    this.equipmentOutro = '',
    this.datasulOm = '',
    this.tagVal = '',
    this.tagDesc = '',
    this.tagOutro = '',
    this.cause = '',
    this.symptom = '',
    this.intervention = '',
    this.activities = '',
    this.materialsUsed = const [],
    this.quantityMeters = '',
    this.quantityPieces = '',
    this.callTime = '',
    this.startTime = '',
    this.endTime = '',
    this.hasStoppage = false,
    this.stoppageStartTime = '',
    this.stoppageEndTime = '',
    this.pressure = '',
    this.horometer = '',
    this.vibrationSpeed = '',
    this.vibrationGe = '',
    this.vibrationTemp = '',
    this.predOtherDesc = '',
    this.tasks = const {},
    this.isFinalized = false,
    this.status = '',
    this.osStatus = '',
    this.photoPaths = const [],
  });

  WorkOrderEntity copyWith({
    String? id,
    String? number,
    String? location,
    String? maintenanceType,
    String? maintenanceTypeOutro,
    String? equipmentType,
    String? equipmentOutro,
    String? datasulOm,
    String? tagVal,
    String? tagDesc,
    String? tagOutro,
    String? cause,
    String? symptom,
    String? intervention,
    String? activities,
    List<String>? materialsUsed,
    String? quantityMeters,
    String? quantityPieces,
    String? callTime,
    String? startTime,
    String? endTime,
    bool? hasStoppage,
    String? stoppageStartTime,
    String? stoppageEndTime,
    String? pressure,
    String? horometer,
    String? vibrationSpeed,
    String? vibrationGe,
    String? vibrationTemp,
    String? predOtherDesc,
    Map<String, String>? tasks,
    bool? isFinalized,
    String? status,
    String? osStatus,
    List<String>? photoPaths,
  }) {
    return WorkOrderEntity(
      id: id ?? this.id,
      number: number ?? this.number,
      location: location ?? this.location,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      maintenanceTypeOutro: maintenanceTypeOutro ?? this.maintenanceTypeOutro,
      equipmentType: equipmentType ?? this.equipmentType,
      equipmentOutro: equipmentOutro ?? this.equipmentOutro,
      datasulOm: datasulOm ?? this.datasulOm,
      tagVal: tagVal ?? this.tagVal,
      tagDesc: tagDesc ?? this.tagDesc,
      tagOutro: tagOutro ?? this.tagOutro,
      cause: cause ?? this.cause,
      symptom: symptom ?? this.symptom,
      intervention: intervention ?? this.intervention,
      activities: activities ?? this.activities,
      materialsUsed: materialsUsed ?? this.materialsUsed,
      quantityMeters: quantityMeters ?? this.quantityMeters,
      quantityPieces: quantityPieces ?? this.quantityPieces,
      callTime: callTime ?? this.callTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hasStoppage: hasStoppage ?? this.hasStoppage,
      stoppageStartTime: stoppageStartTime ?? this.stoppageStartTime,
      stoppageEndTime: stoppageEndTime ?? this.stoppageEndTime,
      pressure: pressure ?? this.pressure,
      horometer: horometer ?? this.horometer,
      vibrationSpeed: vibrationSpeed ?? this.vibrationSpeed,
      vibrationGe: vibrationGe ?? this.vibrationGe,
      vibrationTemp: vibrationTemp ?? this.vibrationTemp,
      predOtherDesc: predOtherDesc ?? this.predOtherDesc,
      tasks: tasks ?? this.tasks,
      isFinalized: isFinalized ?? this.isFinalized,
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

