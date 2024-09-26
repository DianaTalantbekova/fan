part of 'collection_bloc.dart';

@immutable
sealed class CollectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<CollectionModel> collections;

  CollectionLoaded(this.collections);

  @override
  List<Object?> get props => [collections];
}

class CollectionError extends CollectionState {
  final String message;

  CollectionError(this.message);

  @override
  List<Object?> get props => [message];
}
