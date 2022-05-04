import 'package:excuserapp/features/excuse/domain/entities/excuse.dart';

import '../../domain/repositories/excuse_repository.dart';

class ExcuseRepository implements IExcuseRepository {
  @override
  Future<Excuse> getExcuseById(int id) {
    // TODO: implement getExcuseById
    throw UnimplementedError();
  }

  @override
  Future<List<Excuse>> getExcuseListByCategory(String category, int limit) {
    // TODO: implement getExcuseListByCategory
    throw UnimplementedError();
  }

  @override
  Future<Excuse> getRandomExcuse() {
    // TODO: implement getRandomExcuse
    throw UnimplementedError();
  }

  @override
  Future<Excuse> getRandomExcuseByCategory(String category) {
    // TODO: implement getRandomExcuseByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Excuse>> getRandomExcuseList(int limit) {
    // TODO: implement getRandomExcuseList
    throw UnimplementedError();
  }
}
