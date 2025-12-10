import 'package:hive/hive.dart';
import 'product_model.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int? parentId;
  @HiveField(3)
  String slug;
  @HiveField(4)
  List<CategoryModel>? children;

  CategoryModel(
      {required this.id,
      required this.name,
      this.parentId,
      required this.slug,
      this.children});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        parentId: json['parent_id'],
        slug: json['slug'],
        children: json['children'] != null
            ? List<CategoryModel>.from(
                json['children'].map((x) => CategoryModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'parent_id': parentId,
        'slug': slug,
        'children': children?.map((x) => x.toJson()).toList(),
      };
}
