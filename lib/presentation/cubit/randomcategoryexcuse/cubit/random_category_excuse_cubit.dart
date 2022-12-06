import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/excuse.dart';
import '../../../../domain/usecases/get_random_excuse_by_category.dart';

part 'random_category_excuse_state.dart';

class RandomCategoryExcuseCubit extends Cubit<RandomCategoryExcuseState> {
  String excuse = '';
  String category = 'family';
  final GetRandomExcuseByCategoryUseCase getRandomExcuseByCategoryUseCase;

  RandomCategoryExcuseCubit(this.getRandomExcuseByCategoryUseCase)
      : super(RandomCategoryExcuseInitial());

  Future<void> getRandomExcuseByCategory() async {
    emit(RandomCategoryExcuseLoading());
    try {
      final result = await getRandomExcuseByCategoryUseCase.execute(category);
      excuse = result.excuse;
      emit(RandomCategoryExcuseLoaded(excuse: result));
    } on Exception catch (e) {
      emit(RandomCategoryExcuseError(e.toString()));
    }
  }

  void changeCategory(String category) {
    this.category = category;
  }
}
