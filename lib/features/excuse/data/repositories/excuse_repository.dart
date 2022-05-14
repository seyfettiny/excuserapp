import 'package:excuserapp/features/excuse/data/datasources/remote/excuser_api.dart';
import 'package:excuserapp/features/excuse/domain/entities/excuse.dart';

import '../../domain/repositories/excuse_repository.dart';

class ExcuseRepository implements IExcuseRepository {
  final ExcuserAPI api;

  ExcuseRepository(this.api);
  @override
  Future<Excuse> getExcuseById(int id) async {
    return await api.getExcuseById(id);
  }

  @override
  Future<List<Excuse>> getExcuseListByCategory(
      String category, int limit) async {
    return await api.getExcuseListByCategory(category, limit);
  }

  @override
  Future<Excuse> getRandomExcuse() async {
    return await api.getRandomExcuse();
  }

  @override
  Future<Excuse> getRandomExcuseByCategory(String category) async {
    return await api.getRandomExcuseByCategory(category);
  }

  @override
  Future<List<Excuse>> getRandomExcuseList(int limit) async {
    return await api.getRandomExcuseList(limit);
  }
}
