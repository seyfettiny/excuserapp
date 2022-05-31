import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env/env.dart';
import 'features/excuse/data/datasources/local/database.dart';
import 'features/excuse/data/datasources/remote/excuser_api.dart';
import 'features/excuse/domain/repositories/excuse_repository.dart';
import 'package:get_it/get_it.dart';
import 'features/excuse/data/repositories/excuse_repository.dart';
import 'features/excuse/domain/usecases/get_random_excuse.dart';
import 'features/excuse/domain/usecases/get_random_excuse_by_category.dart';
import 'features/excuse/presentation/cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'features/excuse/presentation/cubit/randomexcuse/random_excuse_cubit.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<IExcuseRepository>(
      () => ExcuseRepository(locator(), locator(), locator()));
  locator.registerLazySingleton(() => GetRandomExcuseUseCase(locator()));
  locator.registerLazySingleton(() => GetRandomExcuseByCategoryUseCase(locator()));
  locator.registerLazySingleton(() => ExcuserAPI(locator()));
  locator.registerLazySingleton(() => ExcuseDatabase());

  locator.registerFactory(() => RandomExcuseCubit(locator(),));
  locator.registerFactory(() => RandomCategoryExcuseCubit(locator(),));
  locator.registerSingleton<String>(Platform.localeName);
  locator.registerLazySingleton(() => InternetConnectionChecker());
  locator.registerSingleton<SupabaseClient>(
      SupabaseClient(Env.apiUrl, Env.apiKey));
}
