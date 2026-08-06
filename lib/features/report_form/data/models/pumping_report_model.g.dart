// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pumping_report_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPumpingReportModelCollection on Isar {
  IsarCollection<PumpingReportModel> get pumpingReportModels =>
      this.collection();
}

const PumpingReportModelSchema = CollectionSchema(
  name: r'PumpingReportModel',
  id: 631094232552471,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.string),
    r'leader': PropertySchema(id: 2, name: r'leader', type: IsarType.string),
    r'location': PropertySchema(
      id: 3,
      name: r'location',
      type: IsarType.string,
    ),
    r'materialsUsed': PropertySchema(
      id: 4,
      name: r'materialsUsed',
      type: IsarType.objectList,

      target: r'PumpingMaterialModel',
    ),
    r'members': PropertySchema(
      id: 5,
      name: r'members',
      type: IsarType.stringList,
    ),
    r'observations': PropertySchema(
      id: 6,
      name: r'observations',
      type: IsarType.string,
    ),
    r'photos': PropertySchema(
      id: 7,
      name: r'photos',
      type: IsarType.stringList,
    ),
    r'pumps': PropertySchema(
      id: 8,
      name: r'pumps',
      type: IsarType.objectList,

      target: r'PumpModel',
    ),
    r'safetyCheck': PropertySchema(
      id: 9,
      name: r'safetyCheck',
      type: IsarType.object,

      target: r'SafetyCheckModel',
    ),
    r'shift': PropertySchema(id: 10, name: r'shift', type: IsarType.string),
    r'totalVolumeM3': PropertySchema(
      id: 11,
      name: r'totalVolumeM3',
      type: IsarType.double,
    ),
    r'uuid': PropertySchema(id: 12, name: r'uuid', type: IsarType.string),
    r'waterLevels': PropertySchema(
      id: 13,
      name: r'waterLevels',
      type: IsarType.objectList,

      target: r'WaterLevelModel',
    ),
  },

  estimateSize: _pumpingReportModelEstimateSize,
  serialize: _pumpingReportModelSerialize,
  deserialize: _pumpingReportModelDeserialize,
  deserializeProp: _pumpingReportModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 213439734042772,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'PumpModel': PumpModelSchema,
    r'WaterLevelModel': WaterLevelModelSchema,
    r'PumpingMaterialModel': PumpingMaterialModelSchema,
    r'SafetyCheckModel': SafetyCheckModelSchema,
  },

  getId: _pumpingReportModelGetId,
  getLinks: _pumpingReportModelGetLinks,
  attach: _pumpingReportModelAttach,
  version: '3.3.2',
);

int _pumpingReportModelEstimateSize(
  PumpingReportModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.leader.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.materialsUsed.length * 3;
  {
    final offsets = allOffsets[PumpingMaterialModel]!;
    for (var i = 0; i < object.materialsUsed.length; i++) {
      final value = object.materialsUsed[i];
      bytesCount += PumpingMaterialModelSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.members.length * 3;
  {
    for (var i = 0; i < object.members.length; i++) {
      final value = object.members[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.observations.length * 3;
  bytesCount += 3 + object.photos.length * 3;
  {
    for (var i = 0; i < object.photos.length; i++) {
      final value = object.photos[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.pumps.length * 3;
  {
    final offsets = allOffsets[PumpModel]!;
    for (var i = 0; i < object.pumps.length; i++) {
      final value = object.pumps[i];
      bytesCount += PumpModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount +=
      3 +
      SafetyCheckModelSchema.estimateSize(
        object.safetyCheck,
        allOffsets[SafetyCheckModel]!,
        allOffsets,
      );
  bytesCount += 3 + object.shift.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  bytesCount += 3 + object.waterLevels.length * 3;
  {
    final offsets = allOffsets[WaterLevelModel]!;
    for (var i = 0; i < object.waterLevels.length; i++) {
      final value = object.waterLevels[i];
      bytesCount += WaterLevelModelSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  return bytesCount;
}

void _pumpingReportModelSerialize(
  PumpingReportModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.date);
  writer.writeString(offsets[2], object.leader);
  writer.writeString(offsets[3], object.location);
  writer.writeObjectList<PumpingMaterialModel>(
    offsets[4],
    allOffsets,
    PumpingMaterialModelSchema.serialize,
    object.materialsUsed,
  );
  writer.writeStringList(offsets[5], object.members);
  writer.writeString(offsets[6], object.observations);
  writer.writeStringList(offsets[7], object.photos);
  writer.writeObjectList<PumpModel>(
    offsets[8],
    allOffsets,
    PumpModelSchema.serialize,
    object.pumps,
  );
  writer.writeObject<SafetyCheckModel>(
    offsets[9],
    allOffsets,
    SafetyCheckModelSchema.serialize,
    object.safetyCheck,
  );
  writer.writeString(offsets[10], object.shift);
  writer.writeDouble(offsets[11], object.totalVolumeM3);
  writer.writeString(offsets[12], object.uuid);
  writer.writeObjectList<WaterLevelModel>(
    offsets[13],
    allOffsets,
    WaterLevelModelSchema.serialize,
    object.waterLevels,
  );
}

PumpingReportModel _pumpingReportModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PumpingReportModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.date = reader.readString(offsets[1]);
  object.id = id;
  object.leader = reader.readString(offsets[2]);
  object.location = reader.readString(offsets[3]);
  object.materialsUsed =
      reader.readObjectList<PumpingMaterialModel>(
        offsets[4],
        PumpingMaterialModelSchema.deserialize,
        allOffsets,
        PumpingMaterialModel(),
      ) ??
      [];
  object.members = reader.readStringList(offsets[5]) ?? [];
  object.observations = reader.readString(offsets[6]);
  object.photos = reader.readStringList(offsets[7]) ?? [];
  object.pumps =
      reader.readObjectList<PumpModel>(
        offsets[8],
        PumpModelSchema.deserialize,
        allOffsets,
        PumpModel(),
      ) ??
      [];
  object.safetyCheck =
      reader.readObjectOrNull<SafetyCheckModel>(
        offsets[9],
        SafetyCheckModelSchema.deserialize,
        allOffsets,
      ) ??
      SafetyCheckModel();
  object.shift = reader.readString(offsets[10]);
  object.totalVolumeM3 = reader.readDouble(offsets[11]);
  object.uuid = reader.readString(offsets[12]);
  object.waterLevels =
      reader.readObjectList<WaterLevelModel>(
        offsets[13],
        WaterLevelModelSchema.deserialize,
        allOffsets,
        WaterLevelModel(),
      ) ??
      [];
  return object;
}

P _pumpingReportModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectList<PumpingMaterialModel>(
                offset,
                PumpingMaterialModelSchema.deserialize,
                allOffsets,
                PumpingMaterialModel(),
              ) ??
              [])
          as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readObjectList<PumpModel>(
                offset,
                PumpModelSchema.deserialize,
                allOffsets,
                PumpModel(),
              ) ??
              [])
          as P;
    case 9:
      return (reader.readObjectOrNull<SafetyCheckModel>(
                offset,
                SafetyCheckModelSchema.deserialize,
                allOffsets,
              ) ??
              SafetyCheckModel())
          as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readObjectList<WaterLevelModel>(
                offset,
                WaterLevelModelSchema.deserialize,
                allOffsets,
                WaterLevelModel(),
              ) ??
              [])
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pumpingReportModelGetId(PumpingReportModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pumpingReportModelGetLinks(
  PumpingReportModel object,
) {
  return [];
}

void _pumpingReportModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PumpingReportModel object,
) {
  object.id = id;
}

extension PumpingReportModelByIndex on IsarCollection<PumpingReportModel> {
  Future<PumpingReportModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  PumpingReportModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<PumpingReportModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<PumpingReportModel?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(PumpingReportModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(PumpingReportModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<PumpingReportModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(
    List<PumpingReportModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension PumpingReportModelQueryWhereSort
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QWhere> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PumpingReportModelQueryWhere
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QWhereClause> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterWhereClause>
  uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PumpingReportModelQueryFilter
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QFilterCondition> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'date',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'leader',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'leader',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'leader',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'leader',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'leader',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'leader',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'leader',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'leader',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'leader', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  leaderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'leader', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'location',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'location',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', length, true, length, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', 0, true, 0, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', 0, false, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', 0, true, length, include);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', length, include, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materialsUsed',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'members',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'members',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'members',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'members',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'members',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'members',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'members',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'members',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'members', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'members', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', length, true, length, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', 0, true, 0, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', 0, false, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', 0, true, length, include);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', length, include, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  membersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'observations',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'observations',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'observations', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  observationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'observations', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photos',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photos',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photos', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photos', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', length, true, length, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', 0, true, 0, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', 0, false, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', 0, true, length, include);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', length, include, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  photosLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photos',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'pumps', length, true, length, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'pumps', 0, true, 0, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'pumps', 0, false, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'pumps', 0, true, length, include);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'pumps', length, include, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pumps',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shift',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'shift',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'shift',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shift', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  shiftIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shift', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  totalVolumeM3EqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalVolumeM3',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  totalVolumeM3GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalVolumeM3',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  totalVolumeM3LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalVolumeM3',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  totalVolumeM3Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalVolumeM3',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'waterLevels', length, true, length, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'waterLevels', 0, true, 0, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'waterLevels', 0, false, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'waterLevels', 0, true, length, include);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'waterLevels', length, include, 999999, true);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterLevels',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PumpingReportModelQueryObject
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QFilterCondition> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  materialsUsedElement(FilterQuery<PumpingMaterialModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'materialsUsed');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  pumpsElement(FilterQuery<PumpModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'pumps');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  safetyCheck(FilterQuery<SafetyCheckModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'safetyCheck');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterFilterCondition>
  waterLevelsElement(FilterQuery<WaterLevelModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'waterLevels');
    });
  }
}

extension PumpingReportModelQueryLinks
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QFilterCondition> {}

extension PumpingReportModelQuerySortBy
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QSortBy> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByLeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByLeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByObservations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByObservationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByTotalVolumeM3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumeM3', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByTotalVolumeM3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumeM3', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PumpingReportModelQuerySortThenBy
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QSortThenBy> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByLeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByLeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByObservations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByObservationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByTotalVolumeM3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumeM3', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByTotalVolumeM3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumeM3', Sort.desc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QAfterSortBy>
  thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PumpingReportModelQueryWhereDistinct
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct> {
  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByLeader({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leader', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'members');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByObservations({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observations', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByPhotos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photos');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByShift({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shift', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByTotalVolumeM3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVolumeM3');
    });
  }

  QueryBuilder<PumpingReportModel, PumpingReportModel, QDistinct>
  distinctByUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PumpingReportModelQueryProperty
    on QueryBuilder<PumpingReportModel, PumpingReportModel, QQueryProperty> {
  QueryBuilder<PumpingReportModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PumpingReportModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PumpingReportModel, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PumpingReportModel, String, QQueryOperations> leaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leader');
    });
  }

  QueryBuilder<PumpingReportModel, String, QQueryOperations>
  locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<PumpingReportModel, List<PumpingMaterialModel>, QQueryOperations>
  materialsUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materialsUsed');
    });
  }

  QueryBuilder<PumpingReportModel, List<String>, QQueryOperations>
  membersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'members');
    });
  }

  QueryBuilder<PumpingReportModel, String, QQueryOperations>
  observationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observations');
    });
  }

  QueryBuilder<PumpingReportModel, List<String>, QQueryOperations>
  photosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photos');
    });
  }

  QueryBuilder<PumpingReportModel, List<PumpModel>, QQueryOperations>
  pumpsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pumps');
    });
  }

  QueryBuilder<PumpingReportModel, SafetyCheckModel, QQueryOperations>
  safetyCheckProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'safetyCheck');
    });
  }

  QueryBuilder<PumpingReportModel, String, QQueryOperations> shiftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shift');
    });
  }

  QueryBuilder<PumpingReportModel, double, QQueryOperations>
  totalVolumeM3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVolumeM3');
    });
  }

  QueryBuilder<PumpingReportModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<PumpingReportModel, List<WaterLevelModel>, QQueryOperations>
  waterLevelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterLevels');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PumpModelSchema = Schema(
  name: r'PumpModel',
  id: 347272371417437,
  properties: {
    r'downtimeHours': PropertySchema(
      id: 0,
      name: r'downtimeHours',
      type: IsarType.double,
    ),
    r'downtimeReason': PropertySchema(
      id: 1,
      name: r'downtimeReason',
      type: IsarType.string,
    ),
    r'flowRate': PropertySchema(
      id: 2,
      name: r'flowRate',
      type: IsarType.string,
    ),
    r'location': PropertySchema(
      id: 3,
      name: r'location',
      type: IsarType.string,
    ),
    r'observations': PropertySchema(
      id: 4,
      name: r'observations',
      type: IsarType.string,
    ),
    r'operatingHours': PropertySchema(
      id: 5,
      name: r'operatingHours',
      type: IsarType.string,
    ),
    r'pressure': PropertySchema(
      id: 6,
      name: r'pressure',
      type: IsarType.string,
    ),
    r'pumpId': PropertySchema(id: 7, name: r'pumpId', type: IsarType.string),
    r'status': PropertySchema(id: 8, name: r'status', type: IsarType.string),
  },

  estimateSize: _pumpModelEstimateSize,
  serialize: _pumpModelSerialize,
  deserialize: _pumpModelDeserialize,
  deserializeProp: _pumpModelDeserializeProp,
);

int _pumpModelEstimateSize(
  PumpModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.downtimeReason.length * 3;
  bytesCount += 3 + object.flowRate.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.observations.length * 3;
  bytesCount += 3 + object.operatingHours.length * 3;
  bytesCount += 3 + object.pressure.length * 3;
  bytesCount += 3 + object.pumpId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _pumpModelSerialize(
  PumpModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.downtimeHours);
  writer.writeString(offsets[1], object.downtimeReason);
  writer.writeString(offsets[2], object.flowRate);
  writer.writeString(offsets[3], object.location);
  writer.writeString(offsets[4], object.observations);
  writer.writeString(offsets[5], object.operatingHours);
  writer.writeString(offsets[6], object.pressure);
  writer.writeString(offsets[7], object.pumpId);
  writer.writeString(offsets[8], object.status);
}

PumpModel _pumpModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PumpModel();
  object.downtimeHours = reader.readDouble(offsets[0]);
  object.downtimeReason = reader.readString(offsets[1]);
  object.flowRate = reader.readString(offsets[2]);
  object.location = reader.readString(offsets[3]);
  object.observations = reader.readString(offsets[4]);
  object.operatingHours = reader.readString(offsets[5]);
  object.pressure = reader.readString(offsets[6]);
  object.pumpId = reader.readString(offsets[7]);
  object.status = reader.readString(offsets[8]);
  return object;
}

P _pumpModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PumpModelQueryFilter
    on QueryBuilder<PumpModel, PumpModel, QFilterCondition> {
  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeHoursEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downtimeHours',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downtimeHours',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downtimeHours',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downtimeHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downtimeReason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downtimeReason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downtimeReason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downtimeReason',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'downtimeReason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'downtimeReason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'downtimeReason',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'downtimeReason',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downtimeReason', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  downtimeReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'downtimeReason', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'flowRate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'flowRate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'flowRate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'flowRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'flowRate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'flowRate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'flowRate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'flowRate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> flowRateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'flowRate', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  flowRateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'flowRate', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'location',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'location',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> observationsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> observationsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'observations',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'observations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> observationsMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'observations',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'observations', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  observationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'observations', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'operatingHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'operatingHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'operatingHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'operatingHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'operatingHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'operatingHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'operatingHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'operatingHours',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'operatingHours', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  operatingHoursIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'operatingHours', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pressure',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pressure',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pressure',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pressure',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pressure',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pressure',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pressure',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pressure',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pressureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pressure', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition>
  pressureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pressure', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pumpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pumpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pumpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pumpId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pumpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pumpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pumpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pumpId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pumpId', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> pumpIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pumpId', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<PumpModel, PumpModel, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }
}

extension PumpModelQueryObject
    on QueryBuilder<PumpModel, PumpModel, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WaterLevelModelSchema = Schema(
  name: r'WaterLevelModel',
  id: 598904152704380,
  properties: {
    r'level': PropertySchema(id: 0, name: r'level', type: IsarType.string),
    r'location': PropertySchema(
      id: 1,
      name: r'location',
      type: IsarType.string,
    ),
    r'pointId': PropertySchema(id: 2, name: r'pointId', type: IsarType.string),
    r'trend': PropertySchema(id: 3, name: r'trend', type: IsarType.string),
  },

  estimateSize: _waterLevelModelEstimateSize,
  serialize: _waterLevelModelSerialize,
  deserialize: _waterLevelModelDeserialize,
  deserializeProp: _waterLevelModelDeserializeProp,
);

int _waterLevelModelEstimateSize(
  WaterLevelModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.level.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.pointId.length * 3;
  bytesCount += 3 + object.trend.length * 3;
  return bytesCount;
}

void _waterLevelModelSerialize(
  WaterLevelModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.level);
  writer.writeString(offsets[1], object.location);
  writer.writeString(offsets[2], object.pointId);
  writer.writeString(offsets[3], object.trend);
}

WaterLevelModel _waterLevelModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WaterLevelModel();
  object.level = reader.readString(offsets[0]);
  object.location = reader.readString(offsets[1]);
  object.pointId = reader.readString(offsets[2]);
  object.trend = reader.readString(offsets[3]);
  return object;
}

P _waterLevelModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension WaterLevelModelQueryFilter
    on QueryBuilder<WaterLevelModel, WaterLevelModel, QFilterCondition> {
  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'level',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'level',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'level',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'level', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  levelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'level', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'location',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'location',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'location',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pointId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pointId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pointId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pointId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pointId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pointId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pointId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pointId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pointId', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  pointIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pointId', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'trend',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trend',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trend',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trend',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'trend',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'trend',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'trend',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'trend',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trend', value: ''),
      );
    });
  }

  QueryBuilder<WaterLevelModel, WaterLevelModel, QAfterFilterCondition>
  trendIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'trend', value: ''),
      );
    });
  }
}

extension WaterLevelModelQueryObject
    on QueryBuilder<WaterLevelModel, WaterLevelModel, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PumpingMaterialModelSchema = Schema(
  name: r'PumpingMaterialModel',
  id: -738581002994167,
  properties: {
    r'item': PropertySchema(id: 0, name: r'item', type: IsarType.string),
    r'quantity': PropertySchema(
      id: 1,
      name: r'quantity',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(id: 2, name: r'unit', type: IsarType.string),
  },

  estimateSize: _pumpingMaterialModelEstimateSize,
  serialize: _pumpingMaterialModelSerialize,
  deserialize: _pumpingMaterialModelDeserialize,
  deserializeProp: _pumpingMaterialModelDeserializeProp,
);

int _pumpingMaterialModelEstimateSize(
  PumpingMaterialModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.item.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _pumpingMaterialModelSerialize(
  PumpingMaterialModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.item);
  writer.writeDouble(offsets[1], object.quantity);
  writer.writeString(offsets[2], object.unit);
}

PumpingMaterialModel _pumpingMaterialModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PumpingMaterialModel();
  object.item = reader.readString(offsets[0]);
  object.quantity = reader.readDouble(offsets[1]);
  object.unit = reader.readString(offsets[2]);
  return object;
}

P _pumpingMaterialModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PumpingMaterialModelQueryFilter
    on
        QueryBuilder<
          PumpingMaterialModel,
          PumpingMaterialModel,
          QFilterCondition
        > {
  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'item',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'item',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'item',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'item',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'item',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'item',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'item',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'item',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'item', value: ''),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  itemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'item', value: ''),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  quantityEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'quantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  quantityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  quantityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  quantityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unit', value: ''),
      );
    });
  }

  QueryBuilder<
    PumpingMaterialModel,
    PumpingMaterialModel,
    QAfterFilterCondition
  >
  unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'unit', value: ''),
      );
    });
  }
}

extension PumpingMaterialModelQueryObject
    on
        QueryBuilder<
          PumpingMaterialModel,
          PumpingMaterialModel,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SafetyCheckModelSchema = Schema(
  name: r'SafetyCheckModel',
  id: 460532979155474,
  properties: {
    r'gasMeasured': PropertySchema(
      id: 0,
      name: r'gasMeasured',
      type: IsarType.bool,
    ),
    r'hasAPR': PropertySchema(id: 1, name: r'hasAPR', type: IsarType.bool),
    r'hasLOTO': PropertySchema(id: 2, name: r'hasLOTO', type: IsarType.bool),
  },

  estimateSize: _safetyCheckModelEstimateSize,
  serialize: _safetyCheckModelSerialize,
  deserialize: _safetyCheckModelDeserialize,
  deserializeProp: _safetyCheckModelDeserializeProp,
);

int _safetyCheckModelEstimateSize(
  SafetyCheckModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _safetyCheckModelSerialize(
  SafetyCheckModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.gasMeasured);
  writer.writeBool(offsets[1], object.hasAPR);
  writer.writeBool(offsets[2], object.hasLOTO);
}

SafetyCheckModel _safetyCheckModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SafetyCheckModel();
  object.gasMeasured = reader.readBool(offsets[0]);
  object.hasAPR = reader.readBool(offsets[1]);
  object.hasLOTO = reader.readBool(offsets[2]);
  return object;
}

P _safetyCheckModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SafetyCheckModelQueryFilter
    on QueryBuilder<SafetyCheckModel, SafetyCheckModel, QFilterCondition> {
  QueryBuilder<SafetyCheckModel, SafetyCheckModel, QAfterFilterCondition>
  gasMeasuredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gasMeasured', value: value),
      );
    });
  }

  QueryBuilder<SafetyCheckModel, SafetyCheckModel, QAfterFilterCondition>
  hasAPREqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasAPR', value: value),
      );
    });
  }

  QueryBuilder<SafetyCheckModel, SafetyCheckModel, QAfterFilterCondition>
  hasLOTOEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasLOTO', value: value),
      );
    });
  }
}

extension SafetyCheckModelQueryObject
    on QueryBuilder<SafetyCheckModel, SafetyCheckModel, QFilterCondition> {}
