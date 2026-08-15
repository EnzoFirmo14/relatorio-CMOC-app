import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../domain/entities/work_order_entity.dart';

part 'work_order_model.g.dart';

/// Modelo embutido do Isar para cada Ordem de Serviço / Manutenção dentro de um ReportModel.
@embedded
class WorkOrderModel {
  WorkOrderModel();

  late String id;
  late String number;
  late String location;
  late String maintenanceType;
  late String maintenanceTypeOutro;
  late String equipmentType;
  late String equipmentOutro;
  late String datasulOm;
  late String tagVal;
  late String tagDesc;
  late String tagOutro;
  late String cause;
  late String symptom;
  late String intervention;
  late String activities;
  late List<String> materialsUsed;
  late String quantityMeters;
  late String quantityPieces;
  late String startTime;
  late String endTime;
  late bool hasStoppage;
  late String stoppageStartTime;
  late String stoppageEndTime;
  late String pressure;
  late String horometer;
  late String vibrationSpeed;
  late String vibrationGe;
  late String vibrationTemp;
  late String predOtherDesc;
  late String tasksJson;
  late bool isFinalized;
  late String status;
  late String osStatus;
  late List<String> photoPaths;

  // ─── Converters ───────────────────────────────────────────────────────────

  factory WorkOrderModel.fromEntity(WorkOrderEntity entity) {
    return WorkOrderModel()
      ..id = entity.id
      ..number = entity.number
      ..location = entity.location
      ..maintenanceType = entity.maintenanceType
      ..maintenanceTypeOutro = entity.maintenanceTypeOutro
      ..equipmentType = entity.equipmentType
      ..equipmentOutro = entity.equipmentOutro
      ..datasulOm = entity.datasulOm
      ..tagVal = entity.tagVal
      ..tagDesc = entity.tagDesc
      ..tagOutro = entity.tagOutro
      ..cause = entity.cause
      ..symptom = entity.symptom
      ..intervention = entity.intervention
      ..activities = entity.activities
      ..materialsUsed = List<String>.from(entity.materialsUsed)
      ..quantityMeters = entity.quantityMeters
      ..quantityPieces = entity.quantityPieces
      ..startTime = entity.startTime
      ..endTime = entity.endTime
      ..hasStoppage = entity.hasStoppage
      ..stoppageStartTime = entity.stoppageStartTime
      ..stoppageEndTime = entity.stoppageEndTime
      ..pressure = entity.pressure
      ..horometer = entity.horometer
      ..vibrationSpeed = entity.vibrationSpeed
      ..vibrationGe = entity.vibrationGe
      ..vibrationTemp = entity.vibrationTemp
      ..predOtherDesc = entity.predOtherDesc
      ..tasksJson = jsonEncode(entity.tasks)
      ..isFinalized = entity.isFinalized
      ..status = entity.status
      ..osStatus = entity.osStatus
      ..photoPaths = List<String>.from(entity.photoPaths);
  }

  WorkOrderEntity toEntity() {
    Map<String, String> parsedTasks = {};
    try {
      if (tasksJson.isNotEmpty) {
        final decoded = jsonDecode(tasksJson);
        if (decoded is Map) {
          parsedTasks = decoded.map((key, value) => MapEntry(key.toString(), value.toString()));
        }
      }
    } catch (_) {}

    return WorkOrderEntity(
      id: id,
      number: number,
      location: location,
      maintenanceType: maintenanceType,
      maintenanceTypeOutro: maintenanceTypeOutro,
      equipmentType: equipmentType,
      equipmentOutro: equipmentOutro,
      datasulOm: datasulOm,
      tagVal: tagVal,
      tagDesc: tagDesc,
      tagOutro: tagOutro,
      cause: cause,
      symptom: symptom,
      intervention: intervention,
      activities: activities,
      materialsUsed: List<String>.from(materialsUsed),
      quantityMeters: quantityMeters,
      quantityPieces: quantityPieces,
      startTime: startTime,
      endTime: endTime,
      hasStoppage: hasStoppage,
      stoppageStartTime: stoppageStartTime,
      stoppageEndTime: stoppageEndTime,
      pressure: pressure,
      horometer: horometer,
      vibrationSpeed: vibrationSpeed,
      vibrationGe: vibrationGe,
      vibrationTemp: vibrationTemp,
      predOtherDesc: predOtherDesc,
      tasks: parsedTasks,
      isFinalized: isFinalized,
      status: status,
      osStatus: osStatus,
      photoPaths: List<String>.from(photoPaths),
    );
  }
}

