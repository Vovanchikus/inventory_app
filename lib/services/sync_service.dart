import 'package:hive/hive.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/operation_model.dart';
import '../models/document_model.dart';
import '../models/operation_type_model.dart';

class SyncService {
  final ApiService api;

  SyncService(this.api);

  Future<void> syncAll() async {
    await syncProducts();
    await syncCategories();
    await syncOperations();
    await syncDocuments();
    await syncOperationTypes();
  }

  Future<void> syncProducts() async {
    final items = await api.fetch('products');
    final box = await Hive.openBox<ProductModel>('products');
    await box.clear();
    for (var item in items) {
      box.put(item['id'], ProductModel.fromJson(item));
    }
  }

  Future<void> syncCategories() async {
    final items = await api.fetch('categories');
    final box = await Hive.openBox<CategoryModel>('categories');
    await box.clear();
    for (var item in items) {
      box.put(item['id'], CategoryModel.fromJson(item));
    }
  }

  Future<void> syncOperations() async {
    final items = await api.fetch('operations');
    final box = await Hive.openBox<OperationModel>('operations');
    await box.clear();
    for (var item in items) {
      box.put(item['id'], OperationModel.fromJson(item));
    }
  }

  Future<void> syncDocuments() async {
    final items = await api.fetch('documents');
    final box = await Hive.openBox<DocumentModel>('documents');
    await box.clear();
    for (var item in items) {
      box.put(item['id'], DocumentModel.fromJson(item));
    }
  }

  Future<void> syncOperationTypes() async {
    final items = await api.fetch('operation-types');
    final box = await Hive.openBox<OperationTypeModel>('operation_types');
    await box.clear();
    for (var item in items) {
      box.put(item['id'], OperationTypeModel.fromJson(item));
    }
  }
}
