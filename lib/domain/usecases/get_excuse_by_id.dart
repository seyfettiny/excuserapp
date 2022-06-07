import '../entities/excuse.dart';
import '../repositories/excuse_repository.dart';

class GetExcuseByIdUseCase {
  IExcuseRepository repository;
  GetExcuseByIdUseCase(this.repository);
  Future<Excuse> execute(int id) async {
    return await repository.getExcuseById(id);
  }
}
