// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCollaboratorModelCollection on Isar {
  IsarCollection<CollaboratorModel> get collaboratorModels => this.collection();
}

const CollaboratorModelSchema = CollectionSchema(
  name: r'CollaboratorModel',
  id: 8824645008609805813,
  properties: {
    r'isCustom': PropertySchema(
      id: 0,
      name: r'isCustom',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'registration': PropertySchema(
      id: 2,
      name: r'registration',
      type: IsarType.string,
    )
  },
  estimateSize: _collaboratorModelEstimateSize,
  serialize: _collaboratorModelSerialize,
  deserialize: _collaboratorModelDeserialize,
  deserializeProp: _collaboratorModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'registration': IndexSchema(
      id: 5339774487194984570,
      name: r'registration',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'registration',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _collaboratorModelGetId,
  getLinks: _collaboratorModelGetLinks,
  attach: _collaboratorModelAttach,
  version: '3.1.0+1',
);

int _collaboratorModelEstimateSize(
  CollaboratorModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.registration.length * 3;
  return bytesCount;
}

void _collaboratorModelSerialize(
  CollaboratorModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isCustom);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.registration);
}

CollaboratorModel _collaboratorModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CollaboratorModel();
  object.id = id;
  object.isCustom = reader.readBool(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.registration = reader.readString(offsets[2]);
  return object;
}

P _collaboratorModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _collaboratorModelGetId(CollaboratorModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _collaboratorModelGetLinks(
    CollaboratorModel object) {
  return [];
}

void _collaboratorModelAttach(
    IsarCollection<dynamic> col, Id id, CollaboratorModel object) {
  object.id = id;
}

extension CollaboratorModelByIndex on IsarCollection<CollaboratorModel> {
  Future<CollaboratorModel?> getByRegistration(String registration) {
    return getByIndex(r'registration', [registration]);
  }

  CollaboratorModel? getByRegistrationSync(String registration) {
    return getByIndexSync(r'registration', [registration]);
  }

  Future<bool> deleteByRegistration(String registration) {
    return deleteByIndex(r'registration', [registration]);
  }

  bool deleteByRegistrationSync(String registration) {
    return deleteByIndexSync(r'registration', [registration]);
  }

  Future<List<CollaboratorModel?>> getAllByRegistration(
      List<String> registrationValues) {
    final values = registrationValues.map((e) => [e]).toList();
    return getAllByIndex(r'registration', values);
  }

  List<CollaboratorModel?> getAllByRegistrationSync(
      List<String> registrationValues) {
    final values = registrationValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'registration', values);
  }

  Future<int> deleteAllByRegistration(List<String> registrationValues) {
    final values = registrationValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'registration', values);
  }

  int deleteAllByRegistrationSync(List<String> registrationValues) {
    final values = registrationValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'registration', values);
  }

  Future<Id> putByRegistration(CollaboratorModel object) {
    return putByIndex(r'registration', object);
  }

  Id putByRegistrationSync(CollaboratorModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'registration', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRegistration(List<CollaboratorModel> objects) {
    return putAllByIndex(r'registration', objects);
  }

  List<Id> putAllByRegistrationSync(List<CollaboratorModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'registration', objects, saveLinks: saveLinks);
  }
}

extension CollaboratorModelQueryWhereSort
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QWhere> {
  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CollaboratorModelQueryWhere
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QWhereClause> {
  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
      registrationEqualTo(String registration) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'registration',
        value: [registration],
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterWhereClause>
      registrationNotEqualTo(String registration) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registration',
              lower: [],
              upper: [registration],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registration',
              lower: [registration],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registration',
              lower: [registration],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registration',
              lower: [],
              upper: [registration],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CollaboratorModelQueryFilter
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QFilterCondition> {
  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      isCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCustom',
        value: value,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationEqualTo(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationGreaterThan(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationLessThan(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationBetween(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationStartsWith(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationEndsWith(
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

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registration',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registration',
        value: '',
      ));
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterFilterCondition>
      registrationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registration',
        value: '',
      ));
    });
  }
}

extension CollaboratorModelQueryObject
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QFilterCondition> {}

extension CollaboratorModelQueryLinks
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QFilterCondition> {}

extension CollaboratorModelQuerySortBy
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QSortBy> {
  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      sortByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      sortByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      sortByRegistration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registration', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      sortByRegistrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registration', Sort.desc);
    });
  }
}

extension CollaboratorModelQuerySortThenBy
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QSortThenBy> {
  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByRegistration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registration', Sort.asc);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QAfterSortBy>
      thenByRegistrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registration', Sort.desc);
    });
  }
}

extension CollaboratorModelQueryWhereDistinct
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QDistinct> {
  QueryBuilder<CollaboratorModel, CollaboratorModel, QDistinct>
      distinctByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustom');
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollaboratorModel, CollaboratorModel, QDistinct>
      distinctByRegistration({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registration', caseSensitive: caseSensitive);
    });
  }
}

extension CollaboratorModelQueryProperty
    on QueryBuilder<CollaboratorModel, CollaboratorModel, QQueryProperty> {
  QueryBuilder<CollaboratorModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CollaboratorModel, bool, QQueryOperations> isCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustom');
    });
  }

  QueryBuilder<CollaboratorModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CollaboratorModel, String, QQueryOperations>
      registrationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registration');
    });
  }
}
