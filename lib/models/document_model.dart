import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 4)
class DocumentModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? type;

  @HiveField(3)
  String? fileUrl;

  @HiveField(4)
  String? fileName;

  @HiveField(5)
  DateTime? createdAt;

  DocumentModel({
    required this.id,
    this.name,
    this.type,
    this.fileUrl,
    this.fileName,
    this.createdAt,
  });
}
