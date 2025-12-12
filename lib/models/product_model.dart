import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String unit;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  double price;

  @HiveField(5)
  double sum;

  @HiveField(6)
  DateTime? createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  @HiveField(8)
  int? categoryId;

  @HiveField(9)
  String invNumber;

  ProductModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.sum,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    required this.invNumber,
  });
}
