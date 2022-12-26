import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/util/random_num.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain/repositories/excuse_repository.dart';
import '../datasources/local/database.dart';
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
  Future<ExcuseModel> getExcuseById(int id) async {
    return await api.getExcuseById(id);
  }

  @override
  Future<List<ExcuseModel>> getExcuseListByCategory(String category) async {
    return await api.getExcuseListByCategory(category);
  }

  @override
  Future<ExcuseModel> getRandomExcuse() async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        //TODO: Change this to get the total number of excuses
        final result = await api.getRandomExcuse(RandomNum.random(1, 70));
        await database.insertExcuse(result.id, result.excuse, result.category);
        return result;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      return await database.getRandomExcuse();
    }
  }

  @override
  Future<ExcuseModel> getRandomExcuseByCategory(String category) async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final List categoryList = await getExcuseListByCategory(category);
        final randomIndex = RandomNum.random(0, categoryList.length);
        final result =
            await api.getRandomExcuseByCategory(category, randomIndex);
        await database
            .insertExcuse(result.id, result.excuse, result.category)
            .onError((error, stackTrace) => 0);
        return result;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      return await database.getRandomExcuseByCategory(category);
    }
  }
}
