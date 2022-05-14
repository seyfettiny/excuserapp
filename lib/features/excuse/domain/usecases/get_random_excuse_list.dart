import '../repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetRandomExcuseListUseCase {
  IExcuseRepository repository;
  GetRandomExcuseListUseCase(this.repository);
  Future<List<Excuse>> getRandomExcuseList(int limit) async{
    return await repository.getRandomExcuseList(limit);
  }
}