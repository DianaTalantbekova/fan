part of 'collection_bloc.dart';

@immutable
abstract class CollectionEvent  extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadCollections extends CollectionEvent {
  @override
  List<Object?> get props => [];
}

class AddCollection extends CollectionEvent {
  final CollectionModel collection;
  AddCollection(this.collection);
  @override
  List<Object?> get props => [collection];
}

class DeleteSelectedCollections extends CollectionEvent {
  final List<CollectionModel> items;
  DeleteSelectedCollections(this.items);

  @override
  List<Object?> get props => [items];
}