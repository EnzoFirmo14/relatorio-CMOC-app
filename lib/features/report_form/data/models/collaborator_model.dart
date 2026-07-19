import 'package:isar/isar.dart';
import '../../domain/entities/collaborator_entity.dart';

part 'collaborator_model.g.dart';

/// Modelo de persistência do Isar para colaboradores cadastrados localmente.
/// Colaboradores da lista fixa NÃO são armazenados aqui.
/// Apenas os cadastrados manualmente durante a sessão e que devem persistir.
@collection
class CollaboratorModel {
  CollaboratorModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String registration;

  late String name;

  late bool isCustom;

  // ─── Converters ───────────────────────────────────────────────────────────

  factory CollaboratorModel.fromEntity(CollaboratorEntity entity) {
    return CollaboratorModel()
      ..registration = entity.registration
      ..name = entity.name
      ..isCustom = entity.isCustom;
  }

  CollaboratorEntity toEntity() {
    return CollaboratorEntity(
      id: id.toString(),
      registration: registration,
      name: name,
      isCustom: isCustom,
    );
  }
}
