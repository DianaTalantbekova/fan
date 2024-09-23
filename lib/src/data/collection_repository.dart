import 'package:hive/hive.dart';
import '../domain/models/collection_model.dart';

class CollectionRepository {
  final Box<CollectionModel> collectionBox;

  CollectionRepository(this.collectionBox);

  Future<List<CollectionModel>> getAllCollections() async {
    return collectionBox.values.toList();
  }

  Future<void> addCollection(CollectionModel collection) async {
    await collectionBox.put(collection.id, collection);
  }

  Future<void> deleteCollection(String collectionId) async {
    await collectionBox.delete(collectionId);
  }
}