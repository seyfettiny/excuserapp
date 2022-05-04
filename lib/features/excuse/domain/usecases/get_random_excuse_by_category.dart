import 'package:excuserapp/features/excuse/domain/repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetRandomExcuseByCategory {
  final IExcuseRepository repository;
  GetRandomExcuseByCategory(this.repository);
  Future<Excuse> execute(String category) async {
    return await repository.getRandomExcuseByCategory(category);
  }
}