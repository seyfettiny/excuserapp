// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excusedb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ExcuseData extends DataClass implements Insertable<ExcuseData> {
  final int id;
  final String excuse;
  final String category;
  ExcuseData({required this.id, required this.excuse, required this.category});
  factory ExcuseData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ExcuseData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      excuse: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}excuse'])!,
      category: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['excuse'] = Variable<String>(excuse);
    map['category'] = Variable<String>(category);
    return map;
  }

  ExcuseCompanion toCompanion(bool nullToAbsent) {
    return ExcuseCompanion(
      id: Value(id),
      excuse: Value(excuse),
      category: Value(category),
    );
  }

  factory ExcuseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExcuseData(
      id: serializer.fromJson<int>(json['id']),
      excuse: serializer.fromJson<String>(json['excuse']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'excuse': serializer.toJson<String>(excuse),
      'category': serializer.toJson<String>(category),
    };
  }

  ExcuseData copyWith({int? id, String? excuse, String? category}) =>
      ExcuseData(
        id: id ?? this.id,
        excuse: excuse ?? this.excuse,
        category: category ?? this.category,
      );
  @override
  String toString() {
    return (StringBuffer('ExcuseData(')
          ..write('id: $id, ')
          ..write('excuse: $excuse, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, excuse, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExcuseData &&
          other.id == this.id &&
          other.excuse == this.excuse &&
          other.category == this.category);
}

class ExcuseCompanion extends UpdateCompanion<ExcuseData> {
  final Value<int> id;
  final Value<String> excuse;
  final Value<String> category;
  const ExcuseCompanion({
    this.id = const Value.absent(),
    this.excuse = const Value.absent(),
    this.category = const Value.absent(),
  });
  ExcuseCompanion.insert({
    required int id,
    required String excuse,
    required String category,
  })  : id = Value(id),
        excuse = Value(excuse),
        category = Value(category);
  static Insertable<ExcuseData> custom({
    Expression<int>? id,
    Expression<String>? excuse,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (excuse != null) 'excuse': excuse,
      if (category != null) 'category': category,
    });
  }

  ExcuseCompanion copyWith(
      {Value<int>? id, Value<String>? excuse, Value<String>? category}) {
    return ExcuseCompanion(
      id: id ?? this.id,
      excuse: excuse ?? this.excuse,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (excuse.present) {
      map['excuse'] = Variable<String>(excuse.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExcuseCompanion(')
          ..write('id: $id, ')
          ..write('excuse: $excuse, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $ExcuseTable extends Excuse with TableInfo<$ExcuseTable, ExcuseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExcuseTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _excuseMeta = const VerificationMeta('excuse');
  @override
  late final GeneratedColumn<String?> excuse = GeneratedColumn<String?>(
      'excuse', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String?> category = GeneratedColumn<String?>(
      'category', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, excuse, category];
  @override
  String get aliasedName => _alias ?? 'excuse';
  @override
  String get actualTableName => 'excuse';
  @override
  VerificationContext validateIntegrity(Insertable<ExcuseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('excuse')) {
      context.handle(_excuseMeta,
          excuse.isAcceptableOrUnknown(data['excuse']!, _excuseMeta));
    } else if (isInserting) {
      context.missing(_excuseMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  ExcuseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ExcuseData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ExcuseTable createAlias(String alias) {
    return $ExcuseTable(attachedDatabase, alias);
  }
}

abstract class _$ExcuseDatabase extends GeneratedDatabase {
  _$ExcuseDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ExcuseTable excuse = $ExcuseTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [excuse];
}
