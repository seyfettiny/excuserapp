import '../entities/excuse.dart';

abstract class IExcuseRepository {
  Future<Excuse> getRandomExcuse();
  Future<Excuse> getExcuseById(int id);
  Future<Excuse> getRandomExcuseByCategory(String category);
  Future<List<Excuse>> getExcusesByCategory(String category, int limit);
}
