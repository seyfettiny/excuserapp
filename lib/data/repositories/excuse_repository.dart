import '../models/excuse_model.dart';
import '../../util/random_num.dart';
import 'package:flutter/foundation.dart';
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
        final locale = await database.getLocale();
        await database.insertExcuse(
            result.id, result.excuse, result.category, locale);
        return result;
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
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
        final randomIndex = RandomNum.random(1, categoryList.length);
        final selectedExcuse = categoryList[randomIndex];
        final locale = await database.getLocale();
        await database
            .insertExcuse(selectedExcuse.id, selectedExcuse.excuse, selectedExcuse.category, locale)
            .onError((error, stackTrace) => 0);
        return selectedExcuse;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      return await database.getRandomExcuseByCategory(category);
    }
  }
}
