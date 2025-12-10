import 'package:hive/hive.dart';
part 'operation_product_model.g.dart';

@HiveType(typeId: 2)
class OperationProductModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int productId;
  @HiveField(2)
  double quantity;
  @HiveField(3)
  String? counteragent;

  OperationProductModel({
    required this.id,
    required this.productId,
    required this.quantity,
    this.counteragent,
  });

  factory OperationProductModel.fromJson(Map<String, dynamic> json) =>
      OperationProductModel(
        id: json['id'],
        productId: json['id'],
        quantity: (json['quantity'] ?? 0).toDouble(),
        counteragent: json['counteragent'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'quantity': quantity,
        'counteragent': counteragent,
      };
}
