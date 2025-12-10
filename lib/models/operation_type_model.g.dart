// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationTypeModelAdapter extends TypeAdapter<OperationTypeModel> {
  @override
  final int typeId = 6;

  @override
  OperationTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperationTypeModel(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OperationTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
