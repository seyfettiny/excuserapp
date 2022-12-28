part of 'random_excuse_cubit.dart';

abstract class RandomExcuseState extends Equatable {
  const RandomExcuseState();

  @override
  List<Object> get props => [];
}

class RandomExcuseInitial extends RandomExcuseState {}

class RandomExcuseLoading extends RandomExcuseState {}

class RandomExcuseLoaded extends RandomExcuseState {
  final Excuse excuse;

  const RandomExcuseLoaded({required this.excuse});

  RandomExcuseLoaded copyWith({Excuse? excuse}) {
    return RandomExcuseLoaded(excuse: excuse ?? this.excuse);
  }

  @override
  List<Object> get props => [excuse];
}

class RandomExcuseError extends RandomExcuseState {
  final String error;

  const RandomExcuseError(this.error);

  @override
  List<Object> get props => [error];
}
