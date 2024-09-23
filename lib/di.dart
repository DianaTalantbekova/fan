import 'package:fan/src/data/collection_repository.dart';
import 'package:fan/src/domain/models/collection_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'src/data/fan_repository.dart';
import 'src/domain/models/fan_model.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  await Hive.initFlutter();
  var fanBox = await Hive.openBox<FanModel>('fans');
  var collectionBox = await Hive.openBox<CollectionModel>('collections');

  getIt.registerSingleton<Box<FanModel>>(fanBox);
  getIt.registerSingleton<Box<CollectionModel>>(collectionBox);

  getIt.registerLazySingleton<FanRepository>(() => FanRepository(fanBox));
  getIt.registerLazySingleton<CollectionRepository>(() => CollectionRepository(collectionBox));
}