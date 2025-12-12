import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/operation_model.dart';
import '../models/operation_product_model.dart';
import '../models/document_model.dart';
import '../models/operation_type_model.dart';
import '../api/api_service.dart';

class SyncService {
  final ApiService api;

  SyncService({required this.api});

  /// Синхронизация всего
  Future<void> syncAll() async {
    try {
      await syncProducts();
      await syncCategories();
      await syncOperations();
      await syncOperationTypes();

      // Обновляем документы из операций
      await syncDocumentsFromOperations();
    } catch (e) {
      print('Sync error: $e');
    }
  }

  /// Продукты
  Future<void> syncProducts() async {
    try {
      final data = await api.fetchList('products');
      final box = await Hive.openBox<ProductModel>('products');
      await box.clear();

      for (var item in data) {
        final product = ProductModel(
            id: _toInt(item['id']),
            name: (item['name'] ?? '').toString(),
            unit: (item['unit'] ?? '').toString(),
            quantity: _toDouble(item['quantity']),
            price: _toDouble(item['price']),
            sum: _toDouble(item['sum']),
            createdAt: _parseDate(item['created_at']),
            updatedAt: _parseDate(item['updated_at']),
            categoryId: _toInt(item['category_id']),
            invNumber: (item['inv_number'] ?? '').toString());
        box.put(product.id, product);
      }
    } catch (e) {
      print('Sync products error: $e');
      rethrow;
    }
  }

  /// Категории
  Future<void> syncCategories() async {
    try {
      final data = await api.fetchList('categories');
      final box = await Hive.openBox<CategoryModel>('categories');
      await box.clear();

      for (var item in data) {
        final category = CategoryModel(
          id: _toInt(item['id']),
          name: (item['name'] ?? '').toString(),
          parentId: _toInt(item['parent_id']),
          slug: item['slug']?.toString(),
          children: null,
        );
        box.put(category.id, category);
      }

      // Добавляем детей
      for (var category in box.values) {
        if (category.parentId != null) {
          final parent = box.get(category.parentId);
          if (parent != null) {
            final childrenList = parent.children ?? HiveList(box);
            childrenList.add(category);
            parent.children = childrenList;
            parent.save();
          }
        }
      }
    } catch (e) {
      print('Sync categories error: $e');
    }
  }

  /// Операции
  Future<void> syncOperations() async {
    try {
      final data = await api.fetchList('operations');
      final box = await Hive.openBox<OperationModel>('operations');
      await box.clear();

      for (var item in data) {
        final products = (item['products'] as List<dynamic>? ?? [])
            .map((p) => OperationProductModel(
                  productId: _toInt(p['id']),
                  name: (p['name'] ?? '').toString(),
                  quantity: _toDouble(p['quantity']),
                  counteragent: p['counteragent']?.toString(),
                ))
            .toList();

        final documents = (item['documents'] as List<dynamic>? ?? [])
            .map((d) => DocumentModel(
                  id: _toInt(d['id']),
                  name: (d['name'] ?? '').toString(),
                  type: (d['type'] ?? '').toString(),
                  fileUrl: (d['file_url'] ?? '').toString(),
                  fileName: (d['file_name'] ?? '').toString(),
                  createdAt: _parseDate(d['created_at']),
                ))
            .toList();

        final operation = OperationModel(
          id: _toInt(item['id']),
          type: (item['type'] ?? '').toString(),
          createdAt: _parseDate(item['created_at']),
          products: products,
          documents: documents,
          counteragents: (item['counteragents'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
        );

        box.put(operation.id, operation);
      }
    } catch (e) {
      print('Sync operations error: $e');
    }
  }

  /// Объединяем все документы из операций в отдельный box
  Future<void> syncDocumentsFromOperations() async {
    try {
      final opBox = await Hive.openBox<OperationModel>('operations');
      final docBox = await Hive.openBox<DocumentModel>('documents');

      await docBox.clear(); // опционально очищаем старые документы

      for (var operation in opBox.values) {
        for (var doc in operation.documents) {
          docBox.put('${operation.id}_${doc.id}', doc);
        }
      }

      print('Documents from operations synced: ${docBox.length}');
    } catch (e) {
      print('Sync documents from operations error: $e');
      rethrow;
    }
  }

  /// Типы операций
  Future<void> syncOperationTypes() async {
    try {
      final data = await api.fetchList('operation-types');
      final box = await Hive.openBox<OperationTypeModel>('operation_types');
      await box.clear();

      for (var item in data) {
        final type = OperationTypeModel(
          id: _toInt(item['id']),
          name: (item['name'] ?? '').toString(),
        );
        box.put(type.id, type);
      }
    } catch (e) {
      print('Sync operation types error: $e');
    }
  }

  /// Вспомогательные методы
  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String)
      return double.tryParse(value.replaceAll(',', '.')) ?? 0;
    return 0;
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
