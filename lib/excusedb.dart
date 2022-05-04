import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'excuse.g.dart';

class Excuse extends Table {
  IntColumn get id => integer()();
  TextColumn get excuse => text()();
  TextColumn get category => text()();
}

@DriftDatabase(tables: [Excuse])
class ExcuseDatabase extends _$ExcuseDatabase {
  ExcuseDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}