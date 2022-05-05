import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../domain/entities/excuse.dart';
import 'dao/excuse_dao.dart';

part 'database.g.dart';

@DriftDatabase(tables: [ExcuseDAO])
class ExcuseDatabase extends _$ExcuseDatabase {

  ExcuseDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  //TODO: Add try catch blocks to all methods

  Future<ExcuseDAOData> getRandomExcuse() async {
    Random rand = Random();
    int randomId = 0;
    select(excuseDAO).get().then((list) {
      print(list.length);
      randomId = rand.nextInt(list.length);
    });
    print(randomId);
    return await (select(excuseDAO)..where((tbl) => tbl.id.equals(randomId)))
        .getSingle();
  }

  Future<ExcuseDAOData> getExcuseById(int id) async {
    return await (select(excuseDAO)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<List<ExcuseDAOData>> getRandomExcuseList(int limit) async {
    //TODO: implement getRandomExcuseList
    return await (select(excuseDAO)..limit(limit)).get();
  }

  Future<ExcuseDAOData> getRandomExcuseByCategory(String category) async {
    return await (select(excuseDAO)
          ..where((tbl) => tbl.category.equals(category)))
        .getSingle();
  }

  Future<List<ExcuseDAOData>> getExcuseListByCategory(
      String category, int limit) async {
    return await (select(excuseDAO)
          ..where((tbl) => tbl.category.equals(category))
          ..limit(limit))
        .get();
  }

  Future<void> insertExcuse(Excuse excuse) async {
    await into(excuseDAO).insert(
      ExcuseDAOCompanion.insert(
        id: excuse.id,
        excuse: excuse.excuse,
        category: excuse.category,
      ),
      mode: InsertMode.replace,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
