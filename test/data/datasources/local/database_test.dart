import 'package:drift/native.dart';
import 'package:excuserapp/data/datasources/local/database.dart';
import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExcuseDatabase database;
  setUp(() {
    database = ExcuseDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });
  test('should insert Excuse', () async {
    final id = await database.insertExcuse(1, 'excuse', 'category');

    final excuse = await database.getExcuseById(id);

    expect(excuse.id, id);
  });

  test('should get Excuse by id', () async {
    await database.insertExcuse(1, 'excuse', 'category');

    final excuse = await database.getExcuseById(1);

    expect(excuse.id, 1);
  });

  test('should get all excuses as List', () async {
    await database.insertExcuse(1, 'excuse', 'category');
    await database.insertExcuse(2, 'excuse', 'category');
    await database.insertExcuse(3, 'excuse', 'category');

    final excuses = await database.getAllExcuses();

    expect(excuses.length, 3);
  });

  test('should get all excuses as List<ExcuseModel>', () async {
    await database.insertExcuse(4, 'excuse', 'category');
    await database.insertExcuse(5, 'excuse', 'category');
    await database.insertExcuse(6, 'excuse', 'category');

    final excuses = await database.getAllExcuses();

    expect(excuses, isA<List<ExcuseModel>>());
  });

  test('should get Excuse by Category', () async {
    await database.insertExcuse(7, 'excuse', 'category');

    final excuse = await database.getExcuseByCategory('category');

    expect(excuse.category, 'category');
  });

  test('should get random excuse', () async {
    await database.insertExcuse(8, 'excuse', 'category');

    final excuse = await database.getRandomExcuse();

    expect(excuse, isA<ExcuseModel>());
  });

  test('should get random excuse by category', () async {
    await database.insertExcuse(9, 'excuse', 'category');

    final excuse = await database.getRandomExcuseByCategory('category');

    expect(excuse.category, 'category');
  });

  test('should delete Excuse by id', () async {
    await database.insertExcuse(10, 'excuse', 'category');

    final row = await database.deleteExcuse(10);

    expect(row, 1);
  });

  test('should delete all excuses', () async {
    await database.insertExcuse(11, 'excuse', 'category');
    await database.insertExcuse(12, 'excuse', 'category');
    await database.insertExcuse(13, 'excuse', 'category');

    final rows = await database.deleteAllExcuses();

    expect(rows, isPositive);
  });

}
