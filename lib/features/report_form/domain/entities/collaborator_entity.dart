import 'package:flutter/foundation.dart';

/// Entidade de domínio que representa um colaborador (executante).
@immutable
class CollaboratorEntity {
  final String id;
  final String registration;
  final String name;

  /// [isCustom] indica se o colaborador foi cadastrado manualmente
  /// durante a sessão (não existe na lista fixa de [AppConstants]).
  final bool isCustom;

  const CollaboratorEntity({
    required this.id,
    required this.registration,
    required this.name,
    this.isCustom = false,
  });

  CollaboratorEntity copyWith({
    String? id,
    String? registration,
    String? name,
    bool? isCustom,
  }) {
    return CollaboratorEntity(
      id: id ?? this.id,
      registration: registration ?? this.registration,
      name: name ?? this.name,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollaboratorEntity &&
          runtimeType == other.runtimeType &&
          registration == other.registration;

  @override
  int get hashCode => registration.hashCode;
}
