import 'package:isar_community/isar.dart';

part 'electrical_report_model.g.dart';

@embedded
class ElectricalActivityModel {
  ElectricalActivityModel();

  late String description;
  late String serviceType;
  late String equipment;
  late String location;
  late String status;
  late String startTime;
  late String endTime;
}

@embedded
class ElectricalMaterialModel {
  ElectricalMaterialModel();

  late String item;
  late double quantity;
  late String unit;
  late String partNumber;
}

@collection
class ElectricalReportModel {
  ElectricalReportModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String date;
  late String shift;
  late String leader;
  late List<String> members;
  late String location;
  late String observations;
  late DateTime createdAt;

  late List<ElectricalActivityModel> activities;
  late List<ElectricalMaterialModel> materialsUsed;
  late List<String> photos;
}
