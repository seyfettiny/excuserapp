import '../entities/excuse.dart';
import '../repositories/excuse_repository.dart';

class GetRandomExcuseUseCase {
  GetRandomExcuseUseCase(this.repository);

  final IExcuseRepository repository;

  Future<Excuse> execute() async {
    return await repository.getRandomExcuse();
  }
}