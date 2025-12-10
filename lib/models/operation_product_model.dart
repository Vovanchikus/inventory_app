import 'package:hive/hive.dart';

part 'operation_product_model.g.dart';

@HiveType(typeId: 3)
class OperationProductModel extends HiveObject {
  @HiveField(0)
  int productId;

  @HiveField(1)
  String? name;

  @HiveField(2)
  double quantity;

  @HiveField(3)
  String? counteragent;

  OperationProductModel({
    required this.productId,
    this.name,
    required this.quantity,
    this.counteragent,
  });
}
