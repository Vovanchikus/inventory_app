import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/operation_type_model.dart';

class OperationTypesProvider extends ChangeNotifier {
  List<OperationTypeModel> _types = [];

  List<OperationTypeModel> get types => _types;

  Future<void> loadTypes() async {
    final box = await Hive.openBox<OperationTypeModel>('operation_types');
    _types = box.values.toList();
    notifyListeners();
  }
}
