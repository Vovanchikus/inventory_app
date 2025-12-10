import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

class ProductService {
  static const String apiUrl = 'http://192.168.0.106/api/products';

  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');

  /// Получение всех продуктов
  Future<List<ProductModel>> getProducts({bool forceRefresh = false}) async {
    // Если есть данные и не нужно обновлять, возвращаем локальные
    if (!forceRefresh && _productBox.isNotEmpty) {
      return _productBox.values.toList();
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        // Очистим локальные данные перед обновлением
        await _productBox.clear();

        // Сохраняем новые данные
        for (var item in data) {
          final product = ProductModel(
            id: item['id'],
            name: item['name'],
            unit: item['unit'],
            invNumber: item['inv_number'],
            price: (item['price'] as num).toDouble(),
            quantity: (item['quantity'] as num).toDouble(),
            sum: (item['sum'] as num).toDouble(),
            categoryId: item['category_id'],
          );
          _productBox.put(product.id, product);
        }

        return _productBox.values.toList();
      } else {
        // Если сервер недоступен, возвращаем локальные данные
        return _productBox.values.toList();
      }
    } catch (e) {
      // При ошибке сети возвращаем локальные данные
      return _productBox.values.toList();
    }
  }
}
