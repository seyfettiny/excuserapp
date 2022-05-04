import 'package:excuserapp/features/excuse/domain/repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetExcuseByIdUseCase {
  IExcuseRepository repository;
  GetExcuseByIdUseCase(this.repository);
  Future<Excuse> execute(int id) async {
    return await repository.getExcuseById(id);
  }
}
