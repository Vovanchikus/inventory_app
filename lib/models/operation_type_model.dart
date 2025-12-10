import 'package:hive/hive.dart';

part 'operation_type_model.g.dart';

@HiveType(typeId: 6)
class OperationTypeModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  OperationTypeModel({
    required this.id,
    required this.name,
  });
}
