// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryItemAdapter extends TypeAdapter<SearchHistoryItem> {
  @override
  final int typeId = 1;

  @override
  SearchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistoryItem(
      query: fields[0] as Query,
      date: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
