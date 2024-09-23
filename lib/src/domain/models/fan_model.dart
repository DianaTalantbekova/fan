import 'package:hive/hive.dart';

part 'fan_model.g.dart';

@HiveType(typeId: 0)
class FanModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? image;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? audioFile;

  @HiveField(4)
  bool isCollection;

  @HiveField(5)
  bool isFavorite;

  @HiveField(6)
  String id;

  @HiveField(7)
  final String? keyCollection;

  @HiveField(8)
  bool? isCart;

  @HiveField(9)
  double? price;

  @HiveField(10)
  final DateTime? addedDate;

  FanModel({
    required this.name,
    this.image,
    this.description,
    this.audioFile,
    required this.isCollection,
    required this.isFavorite,
    required this.id,
    this.keyCollection,
    this.isCart,
    this.price,
    required this.addedDate,
  });
}
