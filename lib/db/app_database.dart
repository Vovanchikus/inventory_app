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
    // Регистрация адаптеров Hive
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(OperationModelAdapter());
    Hive.registerAdapter(OperationProductModelAdapter());
    Hive.registerAdapter(DocumentModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(OperationTypeModelAdapter());

    // Открытие боксов
    await Hive.openBox<ProductModel>(productsBox);
    await Hive.openBox<OperationModel>(operationsBox);
    await Hive.openBox<OperationProductModel>(operationProductsBox);
    await Hive.openBox<DocumentModel>(documentsBox);
    await Hive.openBox<CategoryModel>(categoriesBox);
    await Hive.openBox<OperationTypeModel>(operationTypesBox);
  }
}
