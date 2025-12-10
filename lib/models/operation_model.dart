import 'package:hive/hive.dart';
import 'operation_product_model.dart';
import 'document_model.dart';
part 'operation_model.g.dart';

@HiveType(typeId: 3)
class OperationModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  DateTime? createdAt;
  @HiveField(3)
  List<OperationProductModel>? products;
  @HiveField(4)
  List<DocumentModel>? documents;
  @HiveField(5)
  List<String>? counteragents;

  OperationModel({
    required this.id,
    this.type,
    this.createdAt,
    this.products,
    this.documents,
    this.counteragents,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) => OperationModel(
        id: json['id'],
        type: json['type'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        products: json['products'] != null
            ? List<OperationProductModel>.from(
                json['products'].map((x) => OperationProductModel.fromJson(x)))
            : [],
        documents: json['documents'] != null
            ? List<DocumentModel>.from(
                json['documents'].map((x) => DocumentModel.fromJson(x)))
            : [],
        counteragents: json['counteragents'] != null
            ? List<String>.from(json['counteragents'])
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'created_at': createdAt?.toIso8601String(),
        'products': products?.map((x) => x.toJson()).toList(),
        'documents': documents?.map((x) => x.toJson()).toList(),
        'counteragents': counteragents,
      };
}
