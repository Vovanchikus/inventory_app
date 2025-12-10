import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  Future<void> loadCategories() async {
    final box = await Hive.openBox<CategoryModel>('categories');
    _categories = box.values.toList();
    notifyListeners();
  }
}
