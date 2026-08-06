// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrical_report_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetElectricalReportModelCollection on Isar {
  IsarCollection<ElectricalReportModel> get electricalReportModels =>
      this.collection();
}

const ElectricalReportModelSchema = CollectionSchema(
  name: r'ElectricalReportModel',
  id: -8713339558495080299,
  properties: {
    r'activities': PropertySchema(
      id: 0,
      name: r'activities',
      type: IsarType.objectList,

      target: r'ElectricalActivityModel',
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 2, name: r'date', type: IsarType.string),
    r'leader': PropertySchema(id: 3, name: r'leader', type: IsarType.string),
    r'location': PropertySchema(
      id: 4,
      name: r'location',
      type: IsarType.string,
    ),
    r'materialsUsed': PropertySchema(
      id: 5,
      name: r'materialsUsed',
      type: IsarType.objectList,

      target: r'ElectricalMaterialModel',
    ),
    r'members': PropertySchema(
      id: 6,
      name: r'members',
      type: IsarType.stringList,
    ),
    r'observations': PropertySchema(
      id: 7,
      name: r'observations',
      type: IsarType.string,
    ),
    r'photos': PropertySchema(
      id: 8,
      name: r'photos',
      type: IsarType.stringList,
    ),
    r'shift': PropertySchema(id: 9, name: r'shift', type: IsarType.string),
    r'uuid': PropertySchema(id: 10, name: r'uuid', type: IsarType.string),
  },

  estimateSize: _electricalReportModelEstimateSize,
  serialize: _electricalReportModelSerialize,
  deserialize: _electricalReportModelDeserialize,
  deserializeProp: _electricalReportModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
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
    r'ElectricalActivityModel': ElectricalActivityModelSchema,
    r'ElectricalMaterialModel': ElectricalMaterialModelSchema,
  },

  getId: _electricalReportModelGetId,
  getLinks: _electricalReportModelGetLinks,
  attach: _electricalReportModelAttach,
  version: '3.3.2',
);

int _electricalReportModelEstimateSize(
  ElectricalReportModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activities.length * 3;
  {
    final offsets = allOffsets[ElectricalActivityModel]!;
    for (var i = 0; i < object.activities.length; i++) {
      final value = object.activities[i];
      bytesCount += ElectricalActivityModelSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.leader.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.materialsUsed.length * 3;
  {
    final offsets = allOffsets[ElectricalMaterialModel]!;
    for (var i = 0; i < object.materialsUsed.length; i++) {
      final value = object.materialsUsed[i];
      bytesCount += ElectricalMaterialModelSchema.estimateSize(
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
  bytesCount += 3 + object.shift.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _electricalReportModelSerialize(
  ElectricalReportModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<ElectricalActivityModel>(
    offsets[0],
    allOffsets,
    ElectricalActivityModelSchema.serialize,
    object.activities,
  );
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.date);
  writer.writeString(offsets[3], object.leader);
  writer.writeString(offsets[4], object.location);
  writer.writeObjectList<ElectricalMaterialModel>(
    offsets[5],
    allOffsets,
    ElectricalMaterialModelSchema.serialize,
    object.materialsUsed,
  );
  writer.writeStringList(offsets[6], object.members);
  writer.writeString(offsets[7], object.observations);
  writer.writeStringList(offsets[8], object.photos);
  writer.writeString(offsets[9], object.shift);
  writer.writeString(offsets[10], object.uuid);
}

ElectricalReportModel _electricalReportModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ElectricalReportModel();
  object.activities =
      reader.readObjectList<ElectricalActivityModel>(
        offsets[0],
        ElectricalActivityModelSchema.deserialize,
        allOffsets,
        ElectricalActivityModel(),
      ) ??
      [];
  object.createdAt = reader.readDateTime(offsets[1]);
  object.date = reader.readString(offsets[2]);
  object.id = id;
  object.leader = reader.readString(offsets[3]);
  object.location = reader.readString(offsets[4]);
  object.materialsUsed =
      reader.readObjectList<ElectricalMaterialModel>(
        offsets[5],
        ElectricalMaterialModelSchema.deserialize,
        allOffsets,
        ElectricalMaterialModel(),
      ) ??
      [];
  object.members = reader.readStringList(offsets[6]) ?? [];
  object.observations = reader.readString(offsets[7]);
  object.photos = reader.readStringList(offsets[8]) ?? [];
  object.shift = reader.readString(offsets[9]);
  object.uuid = reader.readString(offsets[10]);
  return object;
}

P _electricalReportModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<ElectricalActivityModel>(
                offset,
                ElectricalActivityModelSchema.deserialize,
                allOffsets,
                ElectricalActivityModel(),
              ) ??
              [])
          as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readObjectList<ElectricalMaterialModel>(
                offset,
                ElectricalMaterialModelSchema.deserialize,
                allOffsets,
                ElectricalMaterialModel(),
              ) ??
              [])
          as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _electricalReportModelGetId(ElectricalReportModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _electricalReportModelGetLinks(
  ElectricalReportModel object,
) {
  return [];
}

void _electricalReportModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ElectricalReportModel object,
) {
  object.id = id;
}

extension ElectricalReportModelByIndex
    on IsarCollection<ElectricalReportModel> {
  Future<ElectricalReportModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  ElectricalReportModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<ElectricalReportModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<ElectricalReportModel?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(ElectricalReportModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(ElectricalReportModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<ElectricalReportModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(
    List<ElectricalReportModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension ElectricalReportModelQueryWhereSort
    on QueryBuilder<ElectricalReportModel, ElectricalReportModel, QWhere> {
  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ElectricalReportModelQueryWhere
    on
        QueryBuilder<
          ElectricalReportModel,
          ElectricalReportModel,
          QWhereClause
        > {
  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
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

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
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

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
  uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterWhereClause>
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

extension ElectricalReportModelQueryFilter
    on
        QueryBuilder<
          ElectricalReportModel,
          ElectricalReportModel,
          QFilterCondition
        > {
  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activities', length, true, length, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activities', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activities', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activities', 0, true, length, include);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activities', length, include, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activities',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  leaderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'leader', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  leaderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'leader', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  materialsUsedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', length, true, length, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  materialsUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  materialsUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  materialsUsedLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', 0, true, length, include);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  materialsUsedLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'materialsUsed', length, include, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'members', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'members', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', length, true, length, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', 0, true, length, include);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  membersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'members', length, include, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  observationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'observations', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  observationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'observations', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photos', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photos', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', length, true, length, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', 0, true, length, include);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  photosLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photos', length, include, 999999, true);
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  shiftIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shift', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  shiftIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shift', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }
}

extension ElectricalReportModelQueryObject
    on
        QueryBuilder<
          ElectricalReportModel,
          ElectricalReportModel,
          QFilterCondition
        > {
  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  activitiesElement(FilterQuery<ElectricalActivityModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'activities');
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    ElectricalReportModel,
    QAfterFilterCondition
  >
  materialsUsedElement(FilterQuery<ElectricalMaterialModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'materialsUsed');
    });
  }
}

extension ElectricalReportModelQueryLinks
    on
        QueryBuilder<
          ElectricalReportModel,
          ElectricalReportModel,
          QFilterCondition
        > {}

extension ElectricalReportModelQuerySortBy
    on QueryBuilder<ElectricalReportModel, ElectricalReportModel, QSortBy> {
  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByLeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByLeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByObservations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByObservationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ElectricalReportModelQuerySortThenBy
    on QueryBuilder<ElectricalReportModel, ElectricalReportModel, QSortThenBy> {
  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByLeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByLeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leader', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByObservations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByObservationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observations', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QAfterSortBy>
  thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ElectricalReportModelQueryWhereDistinct
    on QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct> {
  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByLeader({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leader', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'members');
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByObservations({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observations', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByPhotos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photos');
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByShift({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shift', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ElectricalReportModel, ElectricalReportModel, QDistinct>
  distinctByUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension ElectricalReportModelQueryProperty
    on
        QueryBuilder<
          ElectricalReportModel,
          ElectricalReportModel,
          QQueryProperty
        > {
  QueryBuilder<ElectricalReportModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    List<ElectricalActivityModel>,
    QQueryOperations
  >
  activitiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activities');
    });
  }

  QueryBuilder<ElectricalReportModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ElectricalReportModel, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ElectricalReportModel, String, QQueryOperations>
  leaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leader');
    });
  }

  QueryBuilder<ElectricalReportModel, String, QQueryOperations>
  locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<
    ElectricalReportModel,
    List<ElectricalMaterialModel>,
    QQueryOperations
  >
  materialsUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materialsUsed');
    });
  }

  QueryBuilder<ElectricalReportModel, List<String>, QQueryOperations>
  membersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'members');
    });
  }

  QueryBuilder<ElectricalReportModel, String, QQueryOperations>
  observationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observations');
    });
  }

  QueryBuilder<ElectricalReportModel, List<String>, QQueryOperations>
  photosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photos');
    });
  }

  QueryBuilder<ElectricalReportModel, String, QQueryOperations>
  shiftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shift');
    });
  }

  QueryBuilder<ElectricalReportModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ElectricalActivityModelSchema = Schema(
  name: r'ElectricalActivityModel',
  id: -4884040351786745475,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(id: 1, name: r'endTime', type: IsarType.string),
    r'equipment': PropertySchema(
      id: 2,
      name: r'equipment',
      type: IsarType.string,
    ),
    r'location': PropertySchema(
      id: 3,
      name: r'location',
      type: IsarType.string,
    ),
    r'serviceType': PropertySchema(
      id: 4,
      name: r'serviceType',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 5,
      name: r'startTime',
      type: IsarType.string,
    ),
    r'status': PropertySchema(id: 6, name: r'status', type: IsarType.string),
  },

  estimateSize: _electricalActivityModelEstimateSize,
  serialize: _electricalActivityModelSerialize,
  deserialize: _electricalActivityModelDeserialize,
  deserializeProp: _electricalActivityModelDeserializeProp,
);

int _electricalActivityModelEstimateSize(
  ElectricalActivityModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.endTime.length * 3;
  bytesCount += 3 + object.equipment.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.serviceType.length * 3;
  bytesCount += 3 + object.startTime.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _electricalActivityModelSerialize(
  ElectricalActivityModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeString(offsets[1], object.endTime);
  writer.writeString(offsets[2], object.equipment);
  writer.writeString(offsets[3], object.location);
  writer.writeString(offsets[4], object.serviceType);
  writer.writeString(offsets[5], object.startTime);
  writer.writeString(offsets[6], object.status);
}

ElectricalActivityModel _electricalActivityModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ElectricalActivityModel();
  object.description = reader.readString(offsets[0]);
  object.endTime = reader.readString(offsets[1]);
  object.equipment = reader.readString(offsets[2]);
  object.location = reader.readString(offsets[3]);
  object.serviceType = reader.readString(offsets[4]);
  object.startTime = reader.readString(offsets[5]);
  object.status = reader.readString(offsets[6]);
  return object;
}

P _electricalActivityModelDeserializeProp<P>(
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
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ElectricalActivityModelQueryFilter
    on
        QueryBuilder<
          ElectricalActivityModel,
          ElectricalActivityModel,
          QFilterCondition
        > {
  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
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
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endTime',
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
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'endTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'endTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'equipment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'equipment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'equipment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'equipment',
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
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'equipment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'equipment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'equipment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'equipment',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'equipment', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  equipmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'equipment', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'location', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'serviceType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serviceType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'serviceType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serviceType',
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
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'serviceType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'serviceType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'serviceType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'serviceType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serviceType', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  serviceTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'serviceType', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startTime',
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
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'startTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'startTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusGreaterThan(
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusLessThan(
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusBetween(
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalActivityModel,
    ElectricalActivityModel,
    QAfterFilterCondition
  >
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }
}

extension ElectricalActivityModelQueryObject
    on
        QueryBuilder<
          ElectricalActivityModel,
          ElectricalActivityModel,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ElectricalMaterialModelSchema = Schema(
  name: r'ElectricalMaterialModel',
  id: -8799893635393923756,
  properties: {
    r'item': PropertySchema(id: 0, name: r'item', type: IsarType.string),
    r'partNumber': PropertySchema(
      id: 1,
      name: r'partNumber',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 2,
      name: r'quantity',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(id: 3, name: r'unit', type: IsarType.string),
  },

  estimateSize: _electricalMaterialModelEstimateSize,
  serialize: _electricalMaterialModelSerialize,
  deserialize: _electricalMaterialModelDeserialize,
  deserializeProp: _electricalMaterialModelDeserializeProp,
);

int _electricalMaterialModelEstimateSize(
  ElectricalMaterialModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.item.length * 3;
  bytesCount += 3 + object.partNumber.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _electricalMaterialModelSerialize(
  ElectricalMaterialModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.item);
  writer.writeString(offsets[1], object.partNumber);
  writer.writeDouble(offsets[2], object.quantity);
  writer.writeString(offsets[3], object.unit);
}

ElectricalMaterialModel _electricalMaterialModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ElectricalMaterialModel();
  object.item = reader.readString(offsets[0]);
  object.partNumber = reader.readString(offsets[1]);
  object.quantity = reader.readDouble(offsets[2]);
  object.unit = reader.readString(offsets[3]);
  return object;
}

P _electricalMaterialModelDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ElectricalMaterialModelQueryFilter
    on
        QueryBuilder<
          ElectricalMaterialModel,
          ElectricalMaterialModel,
          QFilterCondition
        > {
  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'partNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'partNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'partNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'partNumber',
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'partNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'partNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'partNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'partNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'partNumber', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
    QAfterFilterCondition
  >
  partNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'partNumber', value: ''),
      );
    });
  }

  QueryBuilder<
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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
    ElectricalMaterialModel,
    ElectricalMaterialModel,
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

extension ElectricalMaterialModelQueryObject
    on
        QueryBuilder<
          ElectricalMaterialModel,
          ElectricalMaterialModel,
          QFilterCondition
        > {}
