import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../models/excuse_model.dart';

part 'database.g.dart';

class ExcuseDB extends Table {
  IntColumn get id => integer()();
  TextColumn get excuse => text()();
  TextColumn get category => text()();
}

@DriftDatabase(tables: [ExcuseDB])
class ExcuseDatabase extends _$ExcuseDatabase {
  ExcuseDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
