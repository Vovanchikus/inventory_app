// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationProductModelAdapter extends TypeAdapter<OperationProductModel> {
  @override
  final int typeId = 3;

  @override
  OperationProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperationProductModel(
      productId: fields[0] as int,
      name: fields[1] as String?,
      quantity: fields[2] as double,
      counteragent: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OperationProductModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.counteragent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
