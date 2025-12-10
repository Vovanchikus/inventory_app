import 'package:hive/hive.dart';
part 'operation_type_model.g.dart';

@HiveType(typeId: 5)
class OperationTypeModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

  OperationTypeModel({required this.id, required this.name});

  factory OperationTypeModel.fromJson(Map<String, dynamic> json) =>
      OperationTypeModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
