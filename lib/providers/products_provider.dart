import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../services/sync_service.dart';

class ProductsProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  late SyncService syncService;

  ProductsProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    final box = await Hive.openBox<ProductModel>('products');
    products = box.values.toList();
    notifyListeners();
  }

  Future<void> sync() async {
    await syncService.syncProducts();
    await loadProducts();
  }
}
