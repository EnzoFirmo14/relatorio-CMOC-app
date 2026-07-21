// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReportModelCollection on Isar {
  IsarCollection<ReportModel> get reportModels => this.collection();
}

const ReportModelSchema = CollectionSchema(
  name: r'ReportModel',
  id: 3139160268685868544,
  properties: {
    r'availableMaterials': PropertySchema(
      id: 0,
      name: r'availableMaterials',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'fuelLevel': PropertySchema(
      id: 3,
      name: r'fuelLevel',
      type: IsarType.double,
    ),
    r'globalEquipment': PropertySchema(
      id: 4,
      name: r'globalEquipment',
      type: IsarType.string,
    ),
    r'globalLocation': PropertySchema(
      id: 5,
      name: r'globalLocation',
      type: IsarType.string,
    ),
    r'observations': PropertySchema(
      id: 6,
      name: r'observations',
      type: IsarType.string,
    ),
    r'operators': PropertySchema(
      id: 7,
      name: r'operators',
      type: IsarType.objectList,
      target: r'EmbeddedCollaboratorModel',
    ),
    r'shift': PropertySchema(
      id: 8,
      name: r'shift',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _ReportModelsyncStatusEnumValueMap,
    ),
    r'team': PropertySchema(
      id: 10,
      name: r'team',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 12,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'workOrders': PropertySchema(
      id: 13,
      name: r'workOrders',
      type: IsarType.objectList,
      target: r'WorkOrderModel',
    )
  },
  estimateSize: _reportModelEstimateSize,
  serialize: _reportModelSerialize,
  deserialize: _reportModelDeserialize,
  deserializeProp: _reportModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427725056,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'EmbeddedCollaboratorModel': EmbeddedCollaboratorModelSchema,
    r'WorkOrderModel': WorkOrderModelSchema
  },
  getId: _reportModelGetId,
  getLinks: _reportModelGetLinks,
  attach: _reportModelAttach,
  version: '3.1.0+1',
);

int _reportModelEstimateSize(
  ReportModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.availableMaterials.length * 3;
  bytesCount += 3 + object.globalEquipment.length * 3;
  bytesCount += 3 + object.globalLocation.length * 3;
  bytesCount += 3 + object.observations.length * 3;
  bytesCount += 3 + object.operators.length * 3;
  {
    final offsets = allOffsets[EmbeddedCollaboratorModel]!;
    for (var i = 0; i < object.operators.length; i++) {
      final value = object.operators[i];
      bytesCount += EmbeddedCollaboratorModelSchema.estimateSize(
          value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.shift.length * 3;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  bytesCount += 3 + object.team.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  bytesCount += 3 + object.workOrders.length * 3;
  {
    final offsets = allOffsets[WorkOrderModel]!;
    for (var i = 0; i < object.workOrders.length; i++) {
      final value = object.workOrders[i];
      bytesCount +=
          WorkOrderModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _reportModelSerialize(
  ReportModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.availableMaterials);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeDouble(offsets[3], object.fuelLevel);
  writer.writeString(offsets[4], object.globalEquipment);
  writer.writeString(offsets[5], object.globalLocation);
  writer.writeString(offsets[6], object.observations);
  writer.writeObjectList<EmbeddedCollaboratorModel>(
    offsets[7],
    allOffsets,
    EmbeddedCollaboratorModelSchema.serialize,
    object.operators,
  );
  writer.writeString(offsets[8], object.shift);
  writer.writeString(offsets[9], object.syncStatus.name);
  writer.writeString(offsets[10], object.team);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeString(offsets[12], object.uuid);
  writer.writeObjectList<WorkOrderModel>(
    offsets[13],
    allOffsets,
    WorkOrderModelSchema.serialize,
    object.workOrders,
  );
}

ReportModel _reportModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReportModel();
  object.availableMaterials = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.fuelLevel = reader.readDouble(offsets[3]);
  object.globalEquipment = reader.readString(offsets[4]);
  object.globalLocation = reader.readString(offsets[5]);
  object.id = id;
  object.observations = reader.readString(offsets[6]);
  object.operators = reader.readObjectList<EmbeddedCollaboratorModel>(
        offsets[7],
        EmbeddedCollaboratorModelSchema.deserialize,
        allOffsets,
        EmbeddedCollaboratorModel(),
      ) ??
      [];
  object.shift = reader.readString(offsets[8]);
  object.syncStatus =
      _ReportModelsyncStatusValueEnumMap[reader.readStringOrNull(offsets[9])] ??
          ReportModelSyncStatus.draft;
  object.team = reader.readString(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.uuid = reader.readString(offsets[12]);
  object.workOrders = reader.readObjectList<WorkOrderModel>(
        offsets[13],
        WorkOrderModelSchema.deserialize,
        allOffsets,
        WorkOrderModel(),
      ) ??
      [];
  return object;
}

P _reportModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readObjectList<EmbeddedCollaboratorModel>(
            offset,
            EmbeddedCollaboratorModelSchema.deserialize,
            allOffsets,
            EmbeddedCollaboratorModel(),
          ) ??
          []) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (_ReportModelsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          ReportModelSyncStatus.draft) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readObjectList<WorkOrderModel>(
            offset,
            WorkOrderModelSchema.deserialize,
            allOffsets,
            WorkOrderModel(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReportModelsyncStatusEnumValueMap = {
  r'draft': r'draft',
  r'pending': r'pending',
  r'synced': r'synced',
  r'error': r'error',
};
const _ReportModelsyncStatusValueEnumMap = {
  r'draft': ReportModelSyncStatus.draft,
  r'pending': ReportModelSyncStatus.pending,
  r'synced': ReportModelSyncStatus.synced,
  r'error': ReportModelSyncStatus.error,
};

Id _reportModelGetId(ReportModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reportModelGetLinks(ReportModel object) {
  return [];
}

void _reportModelAttach(
    IsarCollection<dynamic> col, Id id, ReportModel object) {
  object.id = id;
}

extension ReportModelByIndex on IsarCollection<ReportModel> {
  Future<ReportModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  ReportModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<ReportModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<ReportModel?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(ReportModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(ReportModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<ReportModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<ReportModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension ReportModelQueryWhereSort
    on QueryBuilder<ReportModel, ReportModel, QWhere> {
  QueryBuilder<ReportModel, ReportModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReportModelQueryWhere
    on QueryBuilder<ReportModel, ReportModel, QWhereClause> {
  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterWhereClause> uuidNotEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ReportModelQueryFilter
    on QueryBuilder<ReportModel, ReportModel, QFilterCondition> {
  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableMaterials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableMaterials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableMaterials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableMaterials',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'availableMaterials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'availableMaterials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'availableMaterials',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'availableMaterials',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableMaterials',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      availableMaterialsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'availableMaterials',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      fuelLevelEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuelLevel',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      fuelLevelGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fuelLevel',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      fuelLevelLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fuelLevel',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      fuelLevelBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fuelLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'globalEquipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'globalEquipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'globalEquipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'globalEquipment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'globalEquipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'globalEquipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'globalEquipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'globalEquipment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'globalEquipment',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalEquipmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'globalEquipment',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'globalLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'globalLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'globalLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'globalLocation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'globalLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'globalLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'globalLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'globalLocation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'globalLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      globalLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'globalLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'observations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'observations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observations',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observations',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      observationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observations',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'operators',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'operators',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'operators',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'operators',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'operators',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'operators',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shift',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      shiftGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shift',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shift',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shift',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shift',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shift',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shift',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shift',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> shiftIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shift',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      shiftIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shift',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusEqualTo(
    ReportModelSyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusGreaterThan(
    ReportModelSyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusLessThan(
    ReportModelSyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusBetween(
    ReportModelSyncStatus lower,
    ReportModelSyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'team',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'team',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'team',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'team',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'team',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'team',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'team',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'team',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> teamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'team',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      teamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'team',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workOrders',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workOrders',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workOrders',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workOrders',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workOrders',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workOrders',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ReportModelQueryObject
    on QueryBuilder<ReportModel, ReportModel, QFilterCondition> {
  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      operatorsElement(FilterQuery<EmbeddedCollaboratorModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'operators');
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterFilterCondition>
      workOrdersElement(FilterQuery<WorkOrderModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'workOrders');
    });
  }
}

extension ReportModelQueryLinks
    on QueryBuilder<ReportModel, ReportModel, QFilterCondition> {}

extension ReportModelQuerySortBy
    on QueryBuilder<ReportModel, ReportModel, QSortBy> {
  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      sortByAvailableMaterials() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableMaterials', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      sortByAvailableMaterialsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableMaterials', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByFuelLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLevel', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByFuelLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLevel', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByGlobalEquipment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalEquipment', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      sortByGlobalEquipmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalEquipment', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByGlobalLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalLocation', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      sortByGlobalLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalLocation', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByObservations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      sortByObservationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByTeam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'team', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByTeamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'team', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ReportModelQuerySortThenBy
    on QueryBuilder<ReportModel, ReportModel, QSortThenBy> {
  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      thenByAvailableMaterials() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableMaterials', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      thenByAvailableMaterialsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableMaterials', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByFuelLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLevel', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByFuelLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLevel', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByGlobalEquipment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalEquipment', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      thenByGlobalEquipmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalEquipment', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByGlobalLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalLocation', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      thenByGlobalLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalLocation', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByObservations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy>
      thenByObservationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByTeam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'team', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByTeamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'team', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ReportModelQueryWhereDistinct
    on QueryBuilder<ReportModel, ReportModel, QDistinct> {
  QueryBuilder<ReportModel, ReportModel, QDistinct>
      distinctByAvailableMaterials({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'availableMaterials',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByFuelLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fuelLevel');
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByGlobalEquipment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'globalEquipment',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByGlobalLocation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'globalLocation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByObservations(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observations', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByShift(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shift', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctBySyncStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByTeam(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'team', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ReportModel, ReportModel, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension ReportModelQueryProperty
    on QueryBuilder<ReportModel, ReportModel, QQueryProperty> {
  QueryBuilder<ReportModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations>
      availableMaterialsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableMaterials');
    });
  }

  QueryBuilder<ReportModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ReportModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ReportModel, double, QQueryOperations> fuelLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fuelLevel');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations>
      globalEquipmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'globalEquipment');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations> globalLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'globalLocation');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations> observationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observations');
    });
  }

  QueryBuilder<ReportModel, List<EmbeddedCollaboratorModel>, QQueryOperations>
      operatorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operators');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations> shiftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shift');
    });
  }

  QueryBuilder<ReportModel, ReportModelSyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations> teamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'team');
    });
  }

  QueryBuilder<ReportModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ReportModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<ReportModel, List<WorkOrderModel>, QQueryOperations>
      workOrdersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workOrders');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EmbeddedCollaboratorModelSchema = Schema(
  name: r'EmbeddedCollaboratorModel',
  id: 5824696152780669952,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'isCustom': PropertySchema(
      id: 1,
      name: r'isCustom',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'registration': PropertySchema(
      id: 3,
      name: r'registration',
      type: IsarType.string,
    )
  },
  estimateSize: _embeddedCollaboratorModelEstimateSize,
  serialize: _embeddedCollaboratorModelSerialize,
  deserialize: _embeddedCollaboratorModelDeserialize,
  deserializeProp: _embeddedCollaboratorModelDeserializeProp,
);

int _embeddedCollaboratorModelEstimateSize(
  EmbeddedCollaboratorModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.registration.length * 3;
  return bytesCount;
}

void _embeddedCollaboratorModelSerialize(
  EmbeddedCollaboratorModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeBool(offsets[1], object.isCustom);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.registration);
}

EmbeddedCollaboratorModel _embeddedCollaboratorModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmbeddedCollaboratorModel();
  object.id = reader.readString(offsets[0]);
  object.isCustom = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.registration = reader.readString(offsets[3]);
  return object;
}

P _embeddedCollaboratorModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EmbeddedCollaboratorModelQueryFilter on QueryBuilder<
    EmbeddedCollaboratorModel, EmbeddedCollaboratorModel, QFilterCondition> {
  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> isCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCustom',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
          QAfterFilterCondition>
      registrationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
          QAfterFilterCondition>
      registrationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registration',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registration',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedCollaboratorModel, EmbeddedCollaboratorModel,
      QAfterFilterCondition> registrationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registration',
        value: '',
      ));
    });
  }
}

extension EmbeddedCollaboratorModelQueryObject on QueryBuilder<
    EmbeddedCollaboratorModel, EmbeddedCollaboratorModel, QFilterCondition> {}
