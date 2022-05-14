import 'package:dio/dio.dart';
import 'features/excuse/data/datasources/local/database.dart';
import 'features/excuse/data/datasources/remote/excuser_api.dart';
import 'features/excuse/domain/repositories/excuse_repository.dart';
import 'features/excuse/presentation/cubit/excuse_cubit.dart';
import 'package:get_it/get_it.dart';

import 'features/excuse/data/repositories/excuse_repository.dart';
import 'features/excuse/domain/usecases/get_random_excuse.dart';
import 'features/excuse/domain/usecases/get_random_excuse_by_category.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => IExcuseRepository);
  locator.registerLazySingleton(() => ExcuseRepository(locator()));
  locator.registerLazySingleton(() => GetRandomExcuseUseCase(locator()));
  locator
      .registerLazySingleton(() => GetRandomExcuseByCategoryUseCase(locator()));
  locator.registerLazySingleton(() => ExcuserAPI(locator()));
  locator.registerLazySingleton(() => ExcuseDatabase());

  locator.registerFactory(() => ExcuseCubit(
        getRandomExcuseUseCase: locator(),
        getRandomExcuseByCategoryUseCase: locator(),
      ));

  locator.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    ),
  );
}
