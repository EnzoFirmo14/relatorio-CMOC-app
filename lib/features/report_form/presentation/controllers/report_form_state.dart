import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/report_entity.dart';

@immutable
class OperatorState {
  final String name;
  final String registration;

  const OperatorState({
    required this.name,
    required this.registration,
  });

  OperatorState copyWith({
    String? name,
    String? registration,
  }) {
    return OperatorState(
      name: name ?? this.name,
      registration: registration ?? this.registration,
    );
  }
}

@immutable
class WorkOrderState {
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

  const WorkOrderState({
    required this.id,
    required this.number,
    required this.location,
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
    this.osStatus = 'Rascunho',
    this.photoPaths = const [],
  });

  // Calcula a duracao em minutos
  int get durationInMinutes {
    if (startTime.isEmpty || endTime.isEmpty) return 0;
    try {
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');
      if (startParts.length != 2 || endParts.length != 2) return 0;

      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
      return endMinutes - startMinutes;
    } catch (_) {
      return 0;
    }
  }

  String get durationFormatted {
    final mins = durationInMinutes;
    if (mins <= 0) return '';
    final h = mins ~/ 60;
    final m = mins % 60;
    final hStr = h > 0 ? '${h}h ' : '';
    final mStr = m > 0 ? '${m}min' : '';
    return (hStr + mStr).trim();
  }

  WorkOrderState copyWith({
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
    return WorkOrderState(
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
}


/// Status do autosave exibido no header.
enum AutosaveStatus { idle, saving, saved, error }

@immutable
class ReportFormState {
  /// Identificador único do rascunho — persiste entre sessões.
  final String uuid;
  final DateTime date;
  final List<OperatorState> operators;
  final String shift;
  final String team;
  final List<WorkOrderState> workOrders;
  final String globalEquipment;
  final String globalLocation;
  final double fuelLevel;
  final String availableMaterials;
  final String observations;
  final String reportStatus;
  final ReportSyncStatus syncStatus;

  // UI States
  final List<String> validationErrors;
  final bool showValidationPanel;
  final bool draftBannerVisible;
  final int osCounter;
  final List<Map<String, String>> customCollaborators; // colaboradores extras cadastrados
  final AutosaveStatus autosaveStatus;

  ReportFormState({
    String? uuid,
    required this.date,
    this.operators = const [OperatorState(name: '', registration: '')],
    this.shift = 'T1',
    this.team = 'A',
    this.workOrders = const [],
    this.globalEquipment = '',
    this.globalLocation = '',
    this.fuelLevel = 50.0,
    this.availableMaterials = '',
    this.observations = '',
    this.reportStatus = 'Rascunho',
    this.syncStatus = ReportSyncStatus.draft,
    this.validationErrors = const [],
    this.showValidationPanel = false,
    this.draftBannerVisible = false,
    this.osCounter = 0,
    this.customCollaborators = const [],
    this.autosaveStatus = AutosaveStatus.idle,
  }) : uuid = uuid ?? const Uuid().v4();

  ReportFormState copyWith({
    String? uuid,
    DateTime? date,
    List<OperatorState>? operators,
    String? shift,
    String? team,
    List<WorkOrderState>? workOrders,
    String? globalEquipment,
    String? globalLocation,
    double? fuelLevel,
    String? availableMaterials,
    String? observations,
    String? reportStatus,
    ReportSyncStatus? syncStatus,
    List<String>? validationErrors,
    bool? showValidationPanel,
    bool? draftBannerVisible,
    int? osCounter,
    List<Map<String, String>>? customCollaborators,
    AutosaveStatus? autosaveStatus,
  }) {
    return ReportFormState(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      operators: operators ?? this.operators,
      shift: shift ?? this.shift,
      team: team ?? this.team,
      workOrders: workOrders ?? this.workOrders,
      globalEquipment: globalEquipment ?? this.globalEquipment,
      globalLocation: globalLocation ?? this.globalLocation,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      observations: observations ?? this.observations,
      reportStatus: reportStatus ?? this.reportStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      validationErrors: validationErrors ?? this.validationErrors,
      showValidationPanel: showValidationPanel ?? this.showValidationPanel,
      draftBannerVisible: draftBannerVisible ?? this.draftBannerVisible,
      osCounter: osCounter ?? this.osCounter,
      customCollaborators: customCollaborators ?? this.customCollaborators,
      autosaveStatus: autosaveStatus ?? this.autosaveStatus,
    );
  }
}
