import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _loading = false;

  List<ProductModel> get products => _products;
  bool get loading => _loading;

  /// Загрузка продуктов (с локального хранилища и сервера)
  Future<void> loadProducts({bool fromServer = true}) async {
    _loading = true;
    notifyListeners();

    var box = Hive.box<ProductModel>('products');

    // Загружаем локальные данные
    _products = box.values.toList();
    notifyListeners();

    if (fromServer) {
      try {
        final response = await http
            .get(Uri.parse('http://192.168.0.106/api/products'))
            .timeout(const Duration(seconds: 5)); // таймаут 5 секунд

        if (response.statusCode == 200) {
          final data = json.decode(response.body)['data'] as List;

          _products = data.map((e) {
            final p = ProductModel(
              id: e['id'],
              name: e['name'],
              unit: e['unit'],
              invNumber: e['inv_number'],
              price: e['price'] is num
                  ? (e['price'] as num).toDouble()
                  : double.tryParse(e['price'].toString()) ?? 0.0,
              quantity: e['quantity'] is num
                  ? (e['quantity'] as num).toDouble()
                  : double.tryParse(e['quantity'].toString()) ?? 0.0,
              sum: e['sum'] is num
                  ? (e['sum'] as num).toDouble()
                  : double.tryParse(e['sum'].toString()) ?? 0.0,
              categoryId: e['category_id'],
            );

            // Сохраняем/обновляем в Hive
            box.put(p.id, p);
            return p;
          }).toList();

          print("Hive products: ${box.values.toList()}");
        } else {
          print("Сервер вернул статус: ${response.statusCode}");
        }
      } on http.ClientException catch (e) {
        print("Ошибка клиента HTTP: $e");
      } on TimeoutException catch (_) {
        print("Превышено время ожидания сервера. Используем локальные данные.");
      } catch (e) {
        print("Ошибка загрузки с сервера: $e");
      }
    }

    _loading = false;
    notifyListeners();
  }
}
