import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/excuse.dart';
import '../../../domain/usecases/get_random_excuse.dart';

part 'random_excuse_state.dart';

class RandomExcuseCubit extends Cubit<RandomExcuseState> {
  String excuse = '';
  final GetRandomExcuseUseCase getRandomExcuseUseCase;

  RandomExcuseCubit(this.getRandomExcuseUseCase) : super(RandomExcuseInitial());

  Future<void> getRandomExcuse() async {
    emit(RandomExcuseLoading());
    try {
      final result = await getRandomExcuseUseCase.execute();
      excuse = result.excuse;
      emit(RandomExcuseLoaded(excuse: result));
    } on Exception catch (e) {
      emit(RandomExcuseError(e.toString()));
    }
  }
}
