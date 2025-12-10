import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/operation_model.dart';
import '../models/operation_type_model.dart';
import '../models/operation_product_model.dart';
import '../models/document_model.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  Box<ProductModel>? _productBox;
  Box<CategoryModel>? _categoryBox;
  Box<OperationModel>? _operationBox;
  Box<OperationTypeModel>? _operationTypeBox;
  Box<OperationProductModel>? _operationProductBox;
  Box<DocumentModel>? _documentBox;

  Future<void> init() async {
    _productBox = await Hive.openBox<ProductModel>('products');
    _categoryBox = await Hive.openBox<CategoryModel>('categories');
    _operationBox = await Hive.openBox<OperationModel>('operations');
    _operationTypeBox =
        await Hive.openBox<OperationTypeModel>('operation_types');
    notifyListeners();
  }

  List<ProductModel> get products => _productBox?.values.toList() ?? [];
  List<CategoryModel> get categories => _categoryBox?.values.toList() ?? [];
  List<OperationModel> get operations => _operationBox?.values.toList() ?? [];
  List<OperationProductModel> get operationProduct =>
      _operationProductBox?.values.toList() ?? [];
  List<DocumentModel> get documents => _documentBox?.values.toList() ?? [];
  List<OperationTypeModel> get operationTypes =>
      _operationTypeBox?.values.toList() ?? [];

  ProductModel? getProduct(int id) => _productBox?.get(id);
  CategoryModel? getCategory(int id) => _categoryBox?.get(id);
  OperationModel? getOperation(int id) => _operationBox?.get(id);
  OperationTypeModel? getOperationType(int id) => _operationTypeBox?.get(id);
  DocumentModel? getDocument(int id) => _documentBox?.get(id);
  OperationProductModel? getOperationProduct(int id) =>
      _operationProductBox?.get(id);

  Future<void> clearAll() async {
    await _productBox?.clear();
    await _categoryBox?.clear();
    await _operationBox?.clear();
    await _operationTypeBox?.clear();
    notifyListeners();
  }
}
