part of 'collection_bloc.dart';

@immutable
sealed class CollectionState {}

final class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<CollectionModel> collections;

  CollectionLoaded(this.collections);
}

class CollectionError extends CollectionState {
  final String message;

  CollectionError(this.message);
}
