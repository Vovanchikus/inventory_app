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

  DocumentModel(
      {required this.id,
      this.name,
      this.type,
      this.fileUrl,
      this.fileName,
      this.createdAt});

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        fileUrl: json['file_url'],
        fileName: json['file_name'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'file_url': fileUrl,
        'file_name': fileName,
        'created_at': createdAt?.toIso8601String(),
      };
}
