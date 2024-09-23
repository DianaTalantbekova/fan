// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FanModelAdapter extends TypeAdapter<FanModel> {
  @override
  final int typeId = 0;

  @override
  FanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FanModel(
      name: fields[0] as String,
      image: fields[1] as String?,
      description: fields[2] as String?,
      audioFile: fields[3] as String?,
      isCollection: fields[4] as bool,
      isFavorite: fields[5] as bool,
      id: fields[6] as String,
      keyCollection: fields[7] as String?,
      isCart: fields[8] as bool?,
      price: fields[9] as double?,
      addedDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FanModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.audioFile)
      ..writeByte(4)
      ..write(obj.isCollection)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.keyCollection)
      ..writeByte(8)
      ..write(obj.isCart)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.addedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
