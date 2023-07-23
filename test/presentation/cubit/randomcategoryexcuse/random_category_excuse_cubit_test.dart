import 'package:bloc_test/bloc_test.dart';
import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/domain/usecases/get_random_excuse_by_category.dart';
import 'package:excuserapp/presentation/cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'random_category_excuse_cubit_test.mocks.dart';

@GenerateMocks([
  GetRandomExcuseByCategoryUseCase,
])
void main() {
  late RandomCategoryExcuseCubit cubit;
  late MockGetRandomExcuseByCategoryUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetRandomExcuseByCategoryUseCase();
    cubit = RandomCategoryExcuseCubit(mockUseCase);
  });

  group('getRandomExcuseByCategory', () {
    final tExcuse =
        ExcuseModel(id: 0, excuse: 'Test Excuse', category: 'family');
        
    blocTest<RandomCategoryExcuseCubit, RandomCategoryExcuseState>(
      'emits RandomExcuseLoading, RandomCategoryExcuseLoaded when getRandomExcuseByCategory is called',
      setUp: () => when(mockUseCase.execute(any)).thenAnswer((_) async => tExcuse),
      build: () => cubit,
      act: (cubit) => cubit.getRandomExcuseByCategory(),
      expect: () => [
        RandomCategoryExcuseLoading(),
        RandomCategoryExcuseLoaded(excuse: tExcuse),
      ],
      verify: (_) => verify(mockUseCase.execute(tExcuse.category)).called(1),
    );

    blocTest(
      'emits RandomCategoryExcuseError when getRandomExcuseByCategory is called and throws an error',
      setUp: () => when(mockUseCase.execute(any)).thenThrow(Exception('error')),
      build: () => cubit,
      act: (cubit) => cubit.getRandomExcuseByCategory(),
      expect: () => [
        RandomCategoryExcuseLoading(),
        const RandomCategoryExcuseError('Exception: error'),
      ],
      verify: (_) => verify(mockUseCase.execute(tExcuse.category)).called(1),
    );
  });

  group('changeCategory', () {
    final tExcuse =
        ExcuseModel(id: 0, excuse: 'Test Excuse', category: 'family');

    test('updates category field', () {
      // arrange
      when(mockUseCase.execute(any)).thenAnswer((_) async => tExcuse);

      // act
      cubit.changeCategory('work');

      // assert
      expect(cubit.category, equals('work'));
    });
  });
}
