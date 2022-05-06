import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'excuse_event.dart';
part 'excuse_state.dart';

class ExcuseBloc extends Bloc<ExcuseEvent, ExcuseState> {
  ExcuseBloc() : super(ExcuseInitial()) {
    on<ExcuseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}