import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/operation_model.dart';

class OperationsProvider extends ChangeNotifier {
  List<OperationModel> _operations = [];

  List<OperationModel> get operations => _operations;

  Future<void> loadOperations() async {
    final box = await Hive.openBox<OperationModel>('operations');
    _operations = box.values.toList();
    notifyListeners();
  }
}
