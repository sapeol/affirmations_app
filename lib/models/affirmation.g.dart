// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affirmation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAffirmationCollection on Isar {
  IsarCollection<Affirmation> get affirmations => this.collection();
}

const AffirmationSchema = CollectionSchema(
  name: r'Affirmation',
  id: -5052806666404387660,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'isCustom': PropertySchema(
      id: 1,
      name: r'isCustom',
      type: IsarType.bool,
    ),
    r'localizedTextJson': PropertySchema(
      id: 2,
      name: r'localizedTextJson',
      type: IsarType.string,
    ),
    r'persona': PropertySchema(
      id: 3,
      name: r'persona',
      type: IsarType.byte,
      enumMap: _AffirmationpersonaEnumValueMap,
    )
  },
  estimateSize: _affirmationEstimateSize,
  serialize: _affirmationSerialize,
  deserialize: _affirmationDeserialize,
  deserializeProp: _affirmationDeserializeProp,
  idName: r'id',
  indexes: {
    r'author': IndexSchema(
      id: 1831044620441877526,
      name: r'author',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'author',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _affirmationGetId,
  getLinks: _affirmationGetLinks,
  attach: _affirmationAttach,
  version: '3.1.0+1',
);

int _affirmationEstimateSize(
  Affirmation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.localizedTextJson.length * 3;
  return bytesCount;
}

void _affirmationSerialize(
  Affirmation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeBool(offsets[1], object.isCustom);
  writer.writeString(offsets[2], object.localizedTextJson);
  writer.writeByte(offsets[3], object.persona.index);
}

Affirmation _affirmationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Affirmation(
    author: reader.readStringOrNull(offsets[0]) ?? "Dopermations",
    isCustom: reader.readBoolOrNull(offsets[1]) ?? false,
    localizedTextJson: reader.readString(offsets[2]),
    persona:
        _AffirmationpersonaValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            DopePersona.general,
  );
  object.id = id;
  return object;
}

P _affirmationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "Dopermations") as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_AffirmationpersonaValueEnumMap[reader.readByteOrNull(offset)] ??
          DopePersona.general) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AffirmationpersonaEnumValueMap = {
  'overthinker': 0,
  'builder': 1,
  'burntOut': 2,
  'striver': 3,
  'adhdBrain': 4,
  'general': 5,
};
const _AffirmationpersonaValueEnumMap = {
  0: DopePersona.overthinker,
  1: DopePersona.builder,
  2: DopePersona.burntOut,
  3: DopePersona.striver,
  4: DopePersona.adhdBrain,
  5: DopePersona.general,
};

Id _affirmationGetId(Affirmation object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _affirmationGetLinks(Affirmation object) {
  return [];
}

void _affirmationAttach(
    IsarCollection<dynamic> col, Id id, Affirmation object) {
  object.id = id;
}

extension AffirmationQueryWhereSort
    on QueryBuilder<Affirmation, Affirmation, QWhere> {
  QueryBuilder<Affirmation, Affirmation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AffirmationQueryWhere
    on QueryBuilder<Affirmation, Affirmation, QWhereClause> {
  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idBetween(
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

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> authorEqualTo(
      String author) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'author',
        value: [author],
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> authorNotEqualTo(
      String author) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'author',
              lower: [],
              upper: [author],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'author',
              lower: [author],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'author',
              lower: [author],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'author',
              lower: [],
              upper: [author],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AffirmationQueryFilter
    on QueryBuilder<Affirmation, Affirmation, QFilterCondition> {
  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> authorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      authorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> authorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> authorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> authorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> authorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> isCustomEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCustom',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localizedTextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localizedTextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localizedTextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localizedTextJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localizedTextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localizedTextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localizedTextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localizedTextJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localizedTextJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      localizedTextJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localizedTextJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> personaEqualTo(
      DopePersona value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'persona',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      personaGreaterThan(
    DopePersona value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'persona',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> personaLessThan(
    DopePersona value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'persona',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> personaBetween(
    DopePersona lower,
    DopePersona upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'persona',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AffirmationQueryObject
    on QueryBuilder<Affirmation, Affirmation, QFilterCondition> {}

extension AffirmationQueryLinks
    on QueryBuilder<Affirmation, Affirmation, QFilterCondition> {}

extension AffirmationQuerySortBy
    on QueryBuilder<Affirmation, Affirmation, QSortBy> {
  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy>
      sortByLocalizedTextJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localizedTextJson', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy>
      sortByLocalizedTextJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localizedTextJson', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByPersona() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persona', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByPersonaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persona', Sort.desc);
    });
  }
}

extension AffirmationQuerySortThenBy
    on QueryBuilder<Affirmation, Affirmation, QSortThenBy> {
  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy>
      thenByLocalizedTextJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localizedTextJson', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy>
      thenByLocalizedTextJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localizedTextJson', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByPersona() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persona', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByPersonaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persona', Sort.desc);
    });
  }
}

extension AffirmationQueryWhereDistinct
    on QueryBuilder<Affirmation, Affirmation, QDistinct> {
  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustom');
    });
  }

  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByLocalizedTextJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localizedTextJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByPersona() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'persona');
    });
  }
}

extension AffirmationQueryProperty
    on QueryBuilder<Affirmation, Affirmation, QQueryProperty> {
  QueryBuilder<Affirmation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Affirmation, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<Affirmation, bool, QQueryOperations> isCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustom');
    });
  }

  QueryBuilder<Affirmation, String, QQueryOperations>
      localizedTextJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localizedTextJson');
    });
  }

  QueryBuilder<Affirmation, DopePersona, QQueryOperations> personaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'persona');
    });
  }
}
