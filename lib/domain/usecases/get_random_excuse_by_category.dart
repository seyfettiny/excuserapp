import '../entities/excuse.dart';
import '../repositories/excuse_repository.dart';

class GetRandomExcuseByCategoryUseCase {
  final IExcuseRepository repository;
  GetRandomExcuseByCategoryUseCase(this.repository);
  Future<Excuse> execute(String category) async {
    return await repository.getRandomExcuseByCategory(category);
  }
}