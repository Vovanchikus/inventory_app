// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationModelAdapter extends TypeAdapter<OperationModel> {
  @override
  final int typeId = 2;

  @override
  OperationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperationModel(
      id: fields[0] as int,
      type: fields[1] as String?,
      createdAt: fields[2] as DateTime?,
      products: (fields[3] as List).cast<OperationProductModel>(),
      documents: (fields[4] as List).cast<DocumentModel>(),
      counteragents: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, OperationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.products)
      ..writeByte(4)
      ..write(obj.documents)
      ..writeByte(5)
      ..write(obj.counteragents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
