import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../models/operation_model.dart';
import '../models/operation_product_model.dart';
import '../models/document_model.dart';
import '../models/category_model.dart';
import '../models/operation_type_model.dart';

class AppDatabase {
  static const String productsBox = 'products';
  static const String operationsBox = 'operations';
  static const String operationProductsBox = 'operation_products';
  static const String documentsBox = 'documents';
  static const String categoriesBox = 'categories';
  static const String operationTypesBox = 'operation_types';

  static Future<void> init() async {
    // ===== Регистрация адаптеров только если они ещё не зарегистрированы =====
    if (!Hive.isAdapterRegistered(ProductModelAdapter().typeId)) {
      Hive.registerAdapter(ProductModelAdapter());
    }
    if (!Hive.isAdapterRegistered(OperationModelAdapter().typeId)) {
      Hive.registerAdapter(OperationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(OperationProductModelAdapter().typeId)) {
      Hive.registerAdapter(OperationProductModelAdapter());
    }
    if (!Hive.isAdapterRegistered(DocumentModelAdapter().typeId)) {
      Hive.registerAdapter(DocumentModelAdapter());
    }
    if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(OperationTypeModelAdapter().typeId)) {
      Hive.registerAdapter(OperationTypeModelAdapter());
    }

    // ===== Открытие боксов безопасно =====
    await _openBox<ProductModel>(productsBox);
    await _openBox<OperationModel>(operationsBox);
    await _openBox<OperationProductModel>(operationProductsBox);
    await _openBox<DocumentModel>(documentsBox);
    await _openBox<CategoryModel>(categoriesBox);
    await _openBox<OperationTypeModel>(operationTypesBox);
  }

  // Вспомогательная функция для безопасного открытия бокса
  static Future<Box<T>> _openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    } else {
      return await Hive.openBox<T>(name);
    }
  }
}
