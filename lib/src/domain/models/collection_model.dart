import 'package:hive/hive.dart';

part 'collection_model.g.dart';

@HiveType(typeId: 1)
class CollectionModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;

  @HiveField(2)
  String? imagePath;

  @HiveField(2)
  DateTime? addedDate;

  CollectionModel({
    required this.name,
    this.imagePath,
    required this.id,
    this.addedDate,
  });
}
