import 'package:bloc/bloc.dart';
import 'package:fan/src/data/collection_repository.dart';
import 'package:fan/src/domain/models/collection_model.dart';
import 'package:meta/meta.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository collectionRepository;

  CollectionBloc(this.collectionRepository) : super(CollectionInitial()) {
    on<LoadCollections>((event, emit) async {
      emit(CollectionLoading());
      try {
        final collections = await collectionRepository.getAllCollections();
        emit(CollectionLoaded(collections));
      } catch (e) {
        emit(CollectionError(e.toString()));
      }
    });

    on<AddCollection>((event, emit) async {
      try {
        await collectionRepository.addCollection(event.collection);
        emit(CollectionLoaded(await collectionRepository.getAllCollections()));
      } catch (e) {
        emit(CollectionError(e.toString()));
      }
    });

    on<DeleteSelectedCollections>((event, emit) async {
      try {
        for (var item in event.items) {
          await collectionRepository.deleteCollection(item.id);
        }
        emit(CollectionLoaded(await collectionRepository.getAllCollections()));
      } catch (e) {
        emit(CollectionError(e.toString()));
      }
    });
  }
}