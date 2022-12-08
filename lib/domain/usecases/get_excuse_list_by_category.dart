import '../repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetExcuseListByCategoryUseCase {
  final IExcuseRepository repository;
  GetExcuseListByCategoryUseCase(this.repository);
  Future<List<Excuse>> call(String category) async {
    return await repository.getExcuseListByCategory(category);
  }
}
