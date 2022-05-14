part of 'excuse_cubit.dart';

abstract class ExcuseState extends Equatable {
  const ExcuseState();

  @override
  List<Object> get props => [];
}

class ExcuseInitial extends ExcuseState {}
class ExcuseLoading extends ExcuseState {}
class ExcuseLoaded extends ExcuseState {
  final Excuse excuse;

  const ExcuseLoaded({required this.excuse});

  @override
  List<Object> get props => [excuse];
}
class ExcuseError extends ExcuseState {}