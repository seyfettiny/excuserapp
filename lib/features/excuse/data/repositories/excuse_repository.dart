import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../datasources/local/database.dart';

import '../../domain/entities/excuse.dart';
import '../../domain/repositories/excuse_repository.dart';
import '../datasources/remote/excuser_api.dart';

class ExcuseRepository implements IExcuseRepository {
  final ExcuserAPI api;
  final ExcuseDatabase database;
  final InternetConnectionChecker internetConnectionChecker;
  ExcuseRepository(
    this.api,
    this.database,
    this.internetConnectionChecker,
  );
  @override
  Future<Excuse> getExcuseById(int id) async {
    return await api.getExcuseById(id);
  }

  @override
  Future<List<Excuse>> getExcuseListByCategory(
      String category) async {
    return await api.getExcuseListByCategory(category);
  }

  @override
  Future<Excuse> getRandomExcuse() async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final result = await api.getRandomExcuse();
        await database
            .insertExcuse(result.id, result.excuse, result.category)
            .onError((error, stackTrace) => 0);
        return result;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      var daoResult = await database.getRandomExcuse().getSingle();
      return Excuse(
          excuse: daoResult.excuse!,
          category: daoResult.category!,
          id: daoResult.id);
    }
  }

  @override
  Future<Excuse> getRandomExcuseByCategory(String category) async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final result = await api.getRandomExcuseByCategory(category);
        await database
            .insertExcuse(result.id, result.excuse, result.category)
            .onError((error, stackTrace) => 0);
        return result;
      } catch (e) {
        throw Exception(e);
      }
    }
    return await api.getRandomExcuseByCategory(category);
  }

  @override
  Future<List<Excuse>> getRandomExcuseList(int limit) async {
    return await api.getRandomExcuseList(limit);
  }
}
