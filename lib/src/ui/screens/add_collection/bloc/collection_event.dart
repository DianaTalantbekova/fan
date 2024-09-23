part of 'collection_bloc.dart';

@immutable
abstract class CollectionEvent {}

class LoadCollections extends CollectionEvent {}

class AddCollection extends CollectionEvent {
  final CollectionModel collection;
  AddCollection(this.collection);
}

class DeleteSelectedCollections extends CollectionEvent {
  final List<CollectionModel> items;
  DeleteSelectedCollections(this.items);
}