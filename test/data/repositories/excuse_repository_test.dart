// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:excuserapp/data/datasources/local/database.dart';
import 'package:excuserapp/data/datasources/remote/excuser_api.dart';
import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/data/repositories/excuse_repository.dart';
import 'package:excuserapp/util/random_num.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'excuse_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ExcuserAPI>(),
  MockSpec<ExcuseDatabase>(),
  MockSpec<InternetConnectionChecker>(),
])
void main() {
  late ExcuseRepository repository;
  late MockExcuserAPI mockAPI;
  late MockExcuseDatabase mockDatabase;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(() {
    mockDatabase = MockExcuseDatabase();
    mockAPI = MockExcuserAPI();
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    repository =
        ExcuseRepository(mockAPI, mockDatabase, mockInternetConnectionChecker);
  });
  group('With no internet connection', () {
    setUp(() {
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
    });
    test(
        'should return local excuse when the call to remote data source is unsuccessful',
        () async {
      //arrange
      final excuse = ExcuseModel(
          id: 1, excuse: 'My dog ate my homework', category: 'school');
      when(mockDatabase.getRandomExcuse()).thenAnswer((_) async => excuse);

      //act
      final result = await repository.getRandomExcuse();

      //assert
      expect(result, excuse);
    });

    test(
        'should return local random category excuse when the call to remote data source is unsuccessful',
        () async {
      //arrange
      final excuse = ExcuseModel(
          id: 1, excuse: 'My dog ate my homework', category: 'school');
      when(mockDatabase.getRandomExcuseByCategory('school'))
          .thenAnswer((_) async => excuse);

      //act
      final result = await repository.getRandomExcuseByCategory('school');

      //assert
      expect(result, excuse);
    });
  });

  group('With internet connection', () {
    final randomId = RandomNum.random(1, 70);
    setUp(() {
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
    });
    test(
        'should return remote random excuse when the call to remote data source is successful',
        () async {
      //arrange
      final excuse = ExcuseModel(
          id: randomId, excuse: 'My dog ate my homework', category: 'school');
      when(mockAPI.getRandomExcuse(any)).thenAnswer((_) async => excuse);
      when(mockDatabase.insertExcuse(excuse.id, excuse.excuse, excuse.category))
          .thenAnswer((_) async => 1);

      //act
      final result = await repository.getRandomExcuse();

      //assert
      expect(result, excuse);
    });

    test(
        'should throw exception when the call to remote data source is not successful',
        () async {
      //arrange
      when(mockAPI.getRandomExcuse(any)).thenThrow(Exception('Error'));

      //act
      final call = repository.getRandomExcuse();

      //assert
      expect(call, throwsA(isA<Exception>()));
    });

    test(
        'should return remote random excuse with given category when the call to remote data source is successful',
        () async {
      //arrange
      final excuse = ExcuseModel(
          id: randomId, excuse: 'My dog ate my homework', category: 'school');
      when(mockAPI.getExcuseListByCategory(any))
          .thenAnswer((_) async => [excuse]);
      when(mockDatabase.insertExcuse(any, any, any)).thenAnswer((_) async => 1);
      when(mockAPI.getRandomExcuseByCategory(any, any))
          .thenAnswer((_) async => excuse);

      //act
      final result = await repository.getRandomExcuseByCategory('school');

      //assert
      expect(result, excuse);
    });

    test(
        'should throw exception when the call to remote data source is not successful',
        () async {
      //arrange
      when(mockAPI.getRandomExcuseByCategory(any, any))
          .thenThrow(Exception('Error'));

      //act
      final call = repository.getRandomExcuseByCategory('school');

      //assert
      expect(call, throwsA(isA<Exception>()));
    });
  });

  test('should return excuse by given ID', () async {
    //arrange
    final excuse = ExcuseModel(
        id: 1, excuse: 'My dog ate my homework', category: 'school');
    when(mockAPI.getExcuseById(1)).thenAnswer((_) async => excuse);

    //act
    final result = await repository.getExcuseById(1);

    //assert
    expect(result, excuse);
  });

  test('should return excuse list by given category', () async {
    //arrange
    final data = jsonDecode(
        await File('test/helpers/dummy_excuses.json').readAsString());
    final excuses = <ExcuseModel>[
      ...data
          .where((excuse) => excuse['category'] == 'school')
          .map((excuse) => ExcuseModel.fromJson(excuse))
          .toList()
    ];

    when(mockAPI.getExcuseListByCategory(any)).thenAnswer((_) async => excuses);

    //act
    final result = await repository.getExcuseListByCategory('school');

    //assert
    expect(result, excuses);
  });
}
