import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int? parentId;

  @HiveField(3)
  String? slug;

  @HiveField(4)
  HiveList<CategoryModel>? children;

  CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    this.slug,
    this.children,
  });
}
