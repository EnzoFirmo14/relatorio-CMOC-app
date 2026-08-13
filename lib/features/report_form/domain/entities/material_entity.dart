import 'package:flutter/foundation.dart';

@immutable
class MaterialEntity {
  final String name;
  final String quantity;

  const MaterialEntity({
    required this.name,
    this.quantity = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialEntity &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
