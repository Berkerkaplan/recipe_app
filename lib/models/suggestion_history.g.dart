// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuggestionHistoryAdapter extends TypeAdapter<SuggestionHistory> {
  @override
  final int typeId = 0;

  @override
  SuggestionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SuggestionHistory(
      searchHistory: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SuggestionHistory obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.searchHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
