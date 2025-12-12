import 'package:hive/hive.dart';
import 'operation_product_model.dart';
import 'document_model.dart';

part 'operation_model.g.dart';

@HiveType(typeId: 5)
class OperationModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String? type;

  @HiveField(2)
  DateTime? createdAt;

  @HiveField(3)
  List<OperationProductModel> products;

  @HiveField(4)
  List<DocumentModel> documents;

  @HiveField(5)
  List<String>? counteragents;

  OperationModel({
    required this.id,
    this.type,
    this.createdAt,
    required this.products,
    required this.documents,
    this.counteragents,
  });
}
