import 'package:isar/isar.dart';
import '../../domain/entities/work_order_entity.dart';

part 'work_order_model.g.dart';

/// Modelo embutido do Isar para cada Ordem de Serviço dentro de um ReportModel.
/// Como @embedded, não possui Id próprio e é armazenado como parte do ReportModel.
@embedded
class WorkOrderModel {
  WorkOrderModel();

  late String id;
  late String number;
  late String location;
  late String maintenanceType;
  late String cause;
  late String activities;
  late List<String> materialsUsed;
  late String quantityMeters;
  late String quantityPieces;
  late String startTime;
  late String endTime;
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
      ..cause = entity.cause
      ..activities = entity.activities
      ..materialsUsed = List<String>.from(entity.materialsUsed)
      ..quantityMeters = entity.quantityMeters
      ..quantityPieces = entity.quantityPieces
      ..startTime = entity.startTime
      ..endTime = entity.endTime
      ..status = entity.status
      ..osStatus = entity.osStatus
      ..photoPaths = List<String>.from(entity.photoPaths);
  }

  WorkOrderEntity toEntity() {
    return WorkOrderEntity(
      id: id,
      number: number,
      location: location,
      maintenanceType: maintenanceType,
      cause: cause,
      activities: activities,
      materialsUsed: List<String>.from(materialsUsed),
      quantityMeters: quantityMeters,
      quantityPieces: quantityPieces,
      startTime: startTime,
      endTime: endTime,
      status: status,
      osStatus: osStatus,
      photoPaths: List<String>.from(photoPaths),
    );
  }
}
