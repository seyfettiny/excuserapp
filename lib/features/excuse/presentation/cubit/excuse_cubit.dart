import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'excuse_state.dart';

class ExcuseCubit extends Cubit<ExcuseState> {
  ExcuseCubit() : super(ExcuseInitial());
}
