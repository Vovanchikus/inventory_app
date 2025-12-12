import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? slug;

  @HiveField(3)
  int? parentId;

  @HiveField(4)
  List<int> childrenIds; // ❗ только ID, никаких вложенных моделей

  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.parentId,
    this.childrenIds = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      parentId: json['parent_id'],
      childrenIds: (json['children'] as List<dynamic>?)
              ?.map<int>((c) => c['id'] as int)
              .toList() ??
          [],
    );
  }
}
