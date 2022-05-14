import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/excuse.dart';
import '../../domain/usecases/get_random_excuse.dart';
import '../../domain/usecases/get_random_excuse_by_category.dart';

part 'excuse_state.dart';

class ExcuseCubit extends Cubit<ExcuseState> {
  final GetRandomExcuseUseCase getRandomExcuseUseCase;
  final GetRandomExcuseByCategoryUseCase getRandomExcuseByCategoryUseCase;

  ExcuseCubit(
      {required this.getRandomExcuseUseCase,
      required this.getRandomExcuseByCategoryUseCase})
      : super(ExcuseInitial());

  Future<void> getRandomExcuse() async {
    emit(ExcuseLoading());
    try {
      final result = await getRandomExcuseUseCase.execute();
      emit(ExcuseLoaded(excuse: result));
    } on Exception catch (e) {
      emit(ExcuseError(e.toString()));
    }
  }

  Future<void> getRandomExcuseByCategory(String category) async {
    emit(ExcuseLoading());
    try {
      final result = await getRandomExcuseByCategoryUseCase.execute(category);
      emit(ExcuseLoaded(excuse: result));
    } on Exception catch (e) {
      emit(ExcuseError(e.toString()));
    }
  }
}
