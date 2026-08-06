import 'package:isar_community/isar.dart';

part 'pumping_report_model.g.dart';

@embedded
class PumpModel {
  PumpModel();

  late String pumpId;
  late String location;
  late String flowRate;
  late String pressure;
  late String operatingHours;
  late String status;
  late String downtimeReason;
  late double downtimeHours;
  late String observations;
}

@embedded
class WaterLevelModel {
  WaterLevelModel();

  late String pointId;
  late String location;
  late String level;
  late String trend;
}

@embedded
class PumpingMaterialModel {
  PumpingMaterialModel();

  late String item;
  late double quantity;
  late String unit;
}

@embedded
class SafetyCheckModel {
  SafetyCheckModel();

  late bool hasAPR;
  late bool hasLOTO;
  late bool gasMeasured;
}

@collection
class PumpingReportModel {
  PumpingReportModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String date;
  late String shift;
  late String leader;
  late List<String> members;
  late String location;
  late double totalVolumeM3;
  late String observations;
  late DateTime createdAt;

  late List<PumpModel> pumps;
  late List<WaterLevelModel> waterLevels;
  late List<PumpingMaterialModel> materialsUsed;
  late SafetyCheckModel safetyCheck;
  late List<String> photos;
}
