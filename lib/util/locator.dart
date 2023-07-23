// coverage:ignore-file

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:excuserapp/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/local/database.dart';
import '../data/datasources/remote/excuser_api.dart';
import '../data/repositories/excuse_repository.dart';
import '../domain/repositories/excuse_repository.dart';
import '../domain/usecases/get_random_excuse.dart';
import '../domain/usecases/get_random_excuse_by_category.dart';
import '../presentation/cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';
import '../presentation/cubit/randomexcuse/random_excuse_cubit.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<IExcuseRepository>(() => ExcuseRepository(locator(), locator(), locator()));
  locator.registerLazySingleton(() => GetRandomExcuseUseCase(locator()));
  locator.registerLazySingleton(() => GetRandomExcuseByCategoryUseCase(locator()));
  locator.registerLazySingleton(() => ExcuserAPI(locator(), locator()));
  locator.registerLazySingleton(() => ExcuseDatabase(_openConnection()));
  locator.registerLazySingleton(() => InternetConnectionChecker());

  locator.registerFactory(() => RandomExcuseCubit(locator()));
  locator.registerFactory(() => RandomCategoryExcuseCubit(locator()));
  locator.registerFactory(() => AppLocaleCubit(locator()));

  locator.registerSingleton<SupabaseClient>(SupabaseClient(dotenv.env['API_URL']!, dotenv.env['API_KEY']!));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
