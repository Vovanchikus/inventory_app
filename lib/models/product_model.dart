import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
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
  int? categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.sum,
    this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      sum: (json['sum'] ?? 0).toDouble(),
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'quantity': quantity,
        'price': price,
        'sum': sum,
        'category_id': categoryId,
      };
}
