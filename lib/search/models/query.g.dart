// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueryAdapter extends TypeAdapter<Query> {
  @override
  final int typeId = 2;

  @override
  Query read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Query(
      fields[0] as String,
      fields[1] as QueryMode,
    );
  }

  @override
  void write(BinaryWriter writer, Query obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.mode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
