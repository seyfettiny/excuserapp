import '../repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetUseCaseExcuseListByCategory {
  final IExcuseRepository repository;
  GetUseCaseExcuseListByCategory(this.repository);
  Future<List<Excuse>> call(String category) async {
    return await repository.getExcuseListByCategory(category);
  }
}
