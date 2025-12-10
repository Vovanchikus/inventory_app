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

  Future<void> syncAll() async {
    try {
      await syncProducts();
      await syncCategories();
      await syncOperations();
      await syncOperationTypes();
    } catch (e) {
      print('Sync error: $e');
    }
  }

  Future<void> syncProducts() async {
    try {
      final data = await api.fetchList('products');
      final box = await Hive.openBox<ProductModel>('products');

      for (var item in data) {
        final product = ProductModel(
          id: item['id'] ?? 0,
          name: (item['name'] ?? '').toString(),
          unit: (item['unit'] ?? '').toString(),
          quantity: _toDouble(item['quantity']),
          price: _toDouble(item['price']),
          sum: _toDouble(item['sum']),
          createdAt: _parseDate(item['created_at']),
          updatedAt: _parseDate(item['updated_at']),
          categoryId: item['category_id'],
        );
        box.put(product.id, product);
      }
    } catch (e) {
      print('Sync products error: $e');
    }
  }

  Future<void> syncCategories() async {
    try {
      final data = await api.fetchList('categories');
      final box = await Hive.openBox<CategoryModel>('categories');

      // Создаём категории без children
      for (var item in data) {
        final category = CategoryModel(
          id: item['id'] ?? 0,
          name: (item['name'] ?? '').toString(),
          parentId: item['parent_id'],
          slug: item['slug']?.toString(),
          children: null,
        );
        box.put(category.id, category);
      }

      // Создаём HiveList для детей
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

  Future<void> syncOperations() async {
    try {
      final data = await api.fetchList('operations');
      final box = await Hive.openBox<OperationModel>('operations');

      for (var item in data) {
        final products = (item['products'] as List<dynamic>? ?? [])
            .map((p) => OperationProductModel(
                  productId: p['id'] ?? 0,
                  name: (p['name'] ?? '').toString(),
                  quantity: _toDouble(p['quantity']),
                  counteragent: p['counteragent']?.toString(),
                ))
            .toList();

        final documents = (item['documents'] as List<dynamic>? ?? [])
            .map((d) => DocumentModel(
                  id: d['id'] ?? 0,
                  name: (d['name'] ?? '').toString(),
                  type: (d['type'] ?? '').toString(),
                  fileUrl: (d['file_url'] ?? '').toString(),
                  fileName: (d['file_name'] ?? '').toString(),
                  createdAt: _parseDate(d['created_at']),
                ))
            .toList();

        final operation = OperationModel(
          id: item['id'] ?? 0,
          type: (item['type'] ?? '').toString(),
          createdAt: _parseDate(item['created_at']),
          products: products,
          documents: documents,
          counteragents: (item['counteragents'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
        );

        box.put(operation.id, operation);
      }
    } catch (e) {
      print('Sync operations error: $e');
    }
  }

  Future<void> syncOperationTypes() async {
    try {
      final data = await api.fetchList('operation-types');
      final box = await Hive.openBox<OperationTypeModel>('operation_types');

      for (var item in data) {
        final type = OperationTypeModel(
          id: item['id'] ?? 0,
          name: (item['name'] ?? '').toString(),
        );
        box.put(type.id, type);
      }
    } catch (e) {
      print('Sync operation types error: $e');
    }
  }

  // Вспомогательные методы для безопасности типов
  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String)
      return double.tryParse(value.replaceAll(',', '.')) ?? 0;
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
