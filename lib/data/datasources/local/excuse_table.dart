
import 'package:drift/drift.dart';

class ExcuseTable extends Table {
  IntColumn get id => integer()();
  TextColumn get excuse => text()();
  TextColumn get category => text()();
}