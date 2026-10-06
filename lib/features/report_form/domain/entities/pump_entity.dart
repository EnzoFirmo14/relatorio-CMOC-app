import 'package:flutter/foundation.dart';

@immutable
class PumpEntity {
  final String name;
  final String metragem;
  final String bombaStatus;
  final String limpeza;
  final String ocorrencias;

  const PumpEntity({
    required this.name,
    required this.metragem,
    required this.bombaStatus,
    required this.limpeza,
    required this.ocorrencias,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PumpEntity &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
