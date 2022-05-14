import 'package:excuserapp/features/excuse/domain/repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetRandomExcuseByCategoryUseCase {
  final IExcuseRepository repository;
  GetRandomExcuseByCategoryUseCase(this.repository);
  Future<Excuse> execute(String category) async {
    return await repository.getRandomExcuseByCategory(category);
  }
}