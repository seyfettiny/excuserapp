import 'package:excuserapp/features/excuse/domain/repositories/excuse_repository.dart';

import '../entities/excuse.dart';

class GetUseCaseExcusesByCategory {
  final IExcuseRepository repository;
  GetUseCaseExcusesByCategory(this.repository);
  Future<List<Excuse>> call(String category, int id) async {
    return await repository.getExcusesByCategory(category, id);
  }
}
