// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueryModeAdapter extends TypeAdapter<QueryMode> {
  @override
  final int typeId = 4;

  @override
  QueryMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueryMode.mei;
      case 1:
        return QueryMode.sei;
      case 2:
        return QueryMode.person;
      case 3:
        return QueryMode.wildcard;
      default:
        return QueryMode.mei;
    }
  }

  @override
  void write(BinaryWriter writer, QueryMode obj) {
    switch (obj) {
      case QueryMode.mei:
        writer.writeByte(0);
        break;
      case QueryMode.sei:
        writer.writeByte(1);
        break;
      case QueryMode.person:
        writer.writeByte(2);
        break;
      case QueryMode.wildcard:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
