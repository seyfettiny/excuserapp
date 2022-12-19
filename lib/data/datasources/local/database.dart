import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:excuserapp/data/datasources/local/excuse_table.dart';
import 'package:excuserapp/data/models/excuse_model.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [ExcuseTable],
  //include: {'tables.drift'},
)
class ExcuseDatabase extends _$ExcuseDatabase {
  ExcuseDatabase() : super(_openConnection());

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

  Future<ExcuseModel> getExcuseById(int id) async {
    final query = select(excuseTable)..where((t) => t.id.equals(id));

    final result = await query.getSingle();

    return ExcuseModel(
      id: result.id,
      excuse: result.excuse,
      category: result.category,
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
  Future<int> insertExcuse(int id, String excuse, String category) async {
    return await into(excuseTable).insert(
      ExcuseTableCompanion(
        id: Value(id),
        excuse: Value(excuse),
        category: Value(category),
      ),
    );
  }

  // Returns affected row
  Future<int> deleteExcuse(int id) async {
    return await (delete(excuseTable)..where((t) => t.id.equals(id))).go();
  }

  // Returns affected rows
  Future<int> deleteAllExcuses() async {
    return await delete(excuseTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
