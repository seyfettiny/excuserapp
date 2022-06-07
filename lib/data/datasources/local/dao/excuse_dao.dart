
import 'package:drift/drift.dart';

class ExcuseDAO extends Table {
  IntColumn get id => integer()();
  TextColumn get excuse => text()();
  TextColumn get category => text()();
}