import 'package:drift/drift.dart';

class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement().withDefault(const Constant(0))();
  TextColumn get language => text()();
}