import 'package:flutter/foundation.dart';

@immutable
class WaterLevelEntity {
  final String pointId;
  final String location;
  final String level;
  final bool? abastec;
  final String abastecMotivo;
  final bool? vaz;
  final String vazLocal;
  final String trend;
  final String observations;

  const WaterLevelEntity({
    required this.pointId,
    required this.location,
    required this.level,
    this.abastec,
    this.abastecMotivo = '',
    this.vaz,
    this.vazLocal = '',
    this.trend = '',
    this.observations = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLevelEntity &&
          runtimeType == other.runtimeType &&
          pointId == other.pointId;

  @override
  int get hashCode => pointId.hashCode;
}
