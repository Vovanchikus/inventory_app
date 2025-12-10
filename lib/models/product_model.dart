import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class ProductModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String unit;

  @HiveField(3)
  String? invNumber;

  @HiveField(4)
  double price;

  @HiveField(5)
  double quantity;

  @HiveField(6)
  double sum;

  @HiveField(7)
  int? categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.unit,
    this.invNumber,
    required this.price,
    required this.quantity,
    required this.sum,
    this.categoryId,
  });

  // Генерация из JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  // Преобразование в JSON
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
