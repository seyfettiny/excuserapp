part of 'random_category_excuse_cubit.dart';

abstract class RandomCategoryExcuseState extends Equatable {
  const RandomCategoryExcuseState();

  @override
  List<Object> get props => [];
}

class RandomCategoryExcuseInitial extends RandomCategoryExcuseState {}

class RandomCategoryExcuseLoading extends RandomCategoryExcuseState {}

class RandomCategoryExcuseLoaded extends RandomCategoryExcuseState {
  final Excuse excuse;

  const RandomCategoryExcuseLoaded({required this.excuse});

  RandomCategoryExcuseLoaded copyWith({Excuse? excuse}) {
    return RandomCategoryExcuseLoaded(excuse: excuse ?? this.excuse);
  }

  @override
  List<Object> get props => [excuse];
}

class RandomCategoryExcuseError extends RandomCategoryExcuseState {
  final String error;

  const RandomCategoryExcuseError(this.error);

  @override
  List<Object> get props => [error];
}