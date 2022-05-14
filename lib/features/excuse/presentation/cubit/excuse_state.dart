part of 'excuse_cubit.dart';

abstract class ExcuseState extends Equatable {
  const ExcuseState();

  @override
  List<Object> get props => [];
}

enum ExcuseStatus { initial, loading, success, failure }
extension ExcuseStatusX on ExcuseStatus {
  bool get isInitial => this == ExcuseStatus.initial;
  bool get isLoading => this == ExcuseStatus.loading;
  bool get isSuccess => this == ExcuseStatus.success;
  bool get isFailure => this == ExcuseStatus.failure;
}

class ExcuseInitial extends ExcuseState {}

class ExcuseLoading extends ExcuseState {}

class ExcuseLoaded extends ExcuseState {
  final Excuse excuse;

  const ExcuseLoaded({required this.excuse});

  ExcuseLoaded copyWith({Excuse? excuse}) {
    return ExcuseLoaded(excuse: excuse ?? this.excuse);
  }

  @override
  List<Object> get props => [excuse];
}

class ExcuseError extends ExcuseState {
  final String error;

  const ExcuseError(this.error);

  @override
  List<Object> get props => [error];
}
