import 'package:bloc_test/bloc_test.dart';
import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/domain/usecases/get_random_excuse.dart';
import 'package:excuserapp/presentation/cubit/randomexcuse/random_excuse_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'random_excuse_cubit_test.mocks.dart';

@GenerateMocks([
  GetRandomExcuseUseCase,
])
void main() {
  late RandomExcuseCubit cubit;
  late MockGetRandomExcuseUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetRandomExcuseUseCase();
    cubit = RandomExcuseCubit(mockUseCase);
  });

  group('getRandomExcuse', () {
    final tExcuse =
        ExcuseModel(id: 0, excuse: 'Test Excuse', category: 'family');

    blocTest<RandomExcuseCubit, RandomExcuseState>(
      'emits RandomExcuseLoading, RandomExcuseLoaded when getRandomExcuse is called',
      setUp: () => when(mockUseCase.execute()).thenAnswer((_) async => tExcuse),
      build: () => cubit,
      act: (cubit) => cubit.getRandomExcuse(),
      expect: () => [
        RandomExcuseLoading(),
        RandomExcuseLoaded(excuse: tExcuse),
      ],
      verify: (_) => verify(mockUseCase.execute()).called(1),
    );

    blocTest(
      'emits RandomExcuseError when getRandomExcuse is called and throws an error',
      setUp: () => when(mockUseCase.execute()).thenThrow(Exception('error')),
      build: () => cubit,
      act: (cubit) => cubit.getRandomExcuse(),
      expect: () => [
        RandomExcuseLoading(),
        const RandomExcuseError('Exception: error'),
      ],
      verify: (_) => verify(mockUseCase.execute()).called(1),
    );
  });
}
