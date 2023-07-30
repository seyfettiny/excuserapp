import 'package:drift/drift.dart';
import 'package:flutter/material.dart' hide Table;

import '../../../constants/app_constants.dart';
import '../../../util/get_locale.dart';
import '../../models/excuse_model.dart';
import 'excuse_table.dart';
import 'settings_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [ExcuseTable, SettingsTable],
)
class ExcuseDatabase extends _$ExcuseDatabase {
  ExcuseDatabase(QueryExecutor queryExecutor) : super(queryExecutor);

  @override
  int get schemaVersion => 1;

  Future<List<ExcuseModel>> getAllExcuses() async {
    final query = select(excuseTable);

    final result = await query.get();

    return result
        .map((e) => ExcuseModel(
              id: e.id,
              excuse: e.excuse,
              category: e.category,
            ))
        .toList();
  }

  Future<ExcuseModel?> getExcuseById(int id, String locale) async {
    final query = select(excuseTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.language.equals(locale));

    final result = await query.getSingleOrNull();
    if (result == null) {
      return null;
    }
    return ExcuseModel(
      id: result.id,
      excuse: result.excuse,
      category: result.category,
      locale: result.language,
    );
  }

  Future<ExcuseModel> getExcuseByCategory(String category) async {
    final query = select(excuseTable)
      ..where((t) => t.category.equals(category));

    final result = await query.getSingle();

    return ExcuseModel(
      id: result.id,
      excuse: result.excuse,
      category: result.category,
    );
  }

  Future<ExcuseModel> getRandomExcuseByCategory(String category) async {
    const randomNum = CustomExpression<int>('RANDOM()');

    final query = select(excuseTable)
      ..where((t) => t.category.equals(category))
      ..orderBy([
        (excuse) => OrderingTerm(expression: randomNum, mode: OrderingMode.asc),
      ])
      ..limit(1);

    final result = await query.getSingle();

    return ExcuseModel(
      id: result.id,
      excuse: result.excuse,
      category: result.category,
    );
  }

  Future<ExcuseModel> getRandomExcuse() async {
    const randomNum = CustomExpression<int>('RANDOM()');

    final query = select(excuseTable)
      ..orderBy([
        (excuse) => OrderingTerm(expression: randomNum, mode: OrderingMode.asc),
      ])
      ..limit(1);

    final result = await query.getSingle();

    return ExcuseModel(
      id: result.id,
      excuse: result.excuse,
      category: result.category,
    );
  }

  // Returns the generated id
  Future<int> insertExcuse(
      int id, String excuse, String category, String language) async {
    bool validToInsert = await getExcuseById(id, language) == null;
    if (validToInsert) {
      return await into(excuseTable).insert(
        ExcuseTableCompanion(
          id: Value(id),
          excuse: Value(excuse),
          category: Value(category),
          language: Value(language),
        ),
      );
    } else {
      return -1;
    }
  }

  // Returns affected row
  Future<int> deleteExcuse(int id) async {
    return await (delete(excuseTable)..where((t) => t.id.equals(id))).go();
  }

  // Returns affected rows
  Future<int> deleteAllExcuses() async {
    return await delete(excuseTable).go();
  }

  Future<int> setLocale(String language) async {
    return await into(settingsTable).insertOnConflictUpdate(
      SettingsTableCompanion(
        id: const Value(0),
        language: Value(language),
      ),
    );
  }

  Future<String> getLocale() async {
    final query = select(settingsTable);

    final result = await query.getSingle().then((value) {
      return value;
    }).onError((error, stackTrace) async {
      var currentLocale = GetLocale.getLocale();
      setLocale(currentLocale);
      return SettingsTableData(id: 0, language: currentLocale);
    });

    return result.language;
  }
}
