import 'package:bloc_test/bloc_test.dart';
import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/domain/usecases/get_random_excuse_by_category.dart';
import 'package:excuserapp/presentation/cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
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
    test('emits RandomCategoryExcuseLoading', () {
      // arrange
      when(mockUseCase.execute(any)).thenAnswer((_) async => tExcuse);

      // act
      cubit.getRandomExcuseByCategory();

      // assert
      expect(cubit.state, equals(RandomCategoryExcuseLoading()));
    });
    blocTest(
      'emits RandomCategoryExcuseLoaded',
      build: () {
        when(mockUseCase.execute(any)).thenAnswer((_) async => tExcuse);
        return cubit;
      },
      act: (cubit) => cubit.getRandomExcuseByCategory(),
      expect: () => [
        RandomCategoryExcuseLoading(),
        RandomCategoryExcuseLoaded(excuse: tExcuse),
      ],
    );
    test('emits RandomCategoryExcuseError', () {
      // arrange
      when(mockUseCase.execute(any)).thenThrow(Exception('error'));

      // act
      cubit.getRandomExcuseByCategory();

      // assert
      expect(cubit.state,
          equals(const RandomCategoryExcuseError('Exception: error')));
    });
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
