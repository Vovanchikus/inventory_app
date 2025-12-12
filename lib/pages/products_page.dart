import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../widgets/card_item.dart';
import '../theme/app_theme.dart';
import '../services/sync_service.dart';
import '../widgets/category_selector.dart';

class ProductsPage extends StatefulWidget {
  final SyncService syncService;
  final String? productId;

  const ProductsPage({
    super.key,
    required this.syncService,
    this.productId,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    loadProducts().then((_) {
      if (widget.productId != null) {
        _showProductById(widget.productId!);
      }
    });
    _syncProductsDelayed();
  }

  Future<void> _syncProductsDelayed() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await refreshProducts();
  }

  Future<void> refreshProducts() async {
    setState(() => isSyncing = true);
    try {
      await widget.syncService.syncAll();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Нет доступа к серверу, отображаются локальные данные'),
          ),
        );
      }
    } finally {
      await loadProducts();
      if (mounted) setState(() => isSyncing = false);
    }
  }

  Future<void> loadProducts() async {
    final box = await Hive.openBox<ProductModel>('products');
    if (!mounted) return;
    setState(() {
      products = box.values.toList();
      filteredProducts = List.from(products);
    });
  }

  // ------------------------------------------------------------
  // ФИЛЬТРАЦИЯ ПО КАТЕГОРИЯМ (работает с CategoryModel.childrenIds)
  // ------------------------------------------------------------

  void filterProducts(CategoryModel? category) {
    setState(() {
      if (category == null) {
        filteredProducts = List.from(products);
      } else {
        final ids = _getAllCategoryIds(category);
        filteredProducts = products
            .where((p) => p.categoryId != null && ids.contains(p.categoryId))
            .toList();
      }
    });
  }

  /// Возвращает все id категории и её рекурсивных детей
  List<int> _getAllCategoryIds(CategoryModel category) {
    final List<int> ids = [category.id];

    // рекурсивно обрабатываем childrenIds (в модели у тебя хранится список id)
    for (final childId in category.childrenIds) {
      final child = _getCategoryById(childId);
      if (child != null) {
        ids.addAll(_getAllCategoryIds(child));
      }
    }

    return ids;
  }

  /// БЕЗОПАСНО получить категорию по id из Hive — возвращает nullable
  CategoryModel? _getCategoryById(int id) {
    // Получаем уже открытый бокс (если он не открыт, лучше открыть заранее в инициализации)
    if (!Hive.isBoxOpen('categories')) return null;
    final box = Hive.box<CategoryModel>('categories');

    for (final c in box.values) {
      if (c.id == id) return c;
    }
    return null;
  }

  // ------------------------------------------------------------

  void _showProductById(String id) {
    final product = products.firstWhere(
      (p) => p.id.toString() == id,
      orElse: () => ProductModel(
        id: 0,
        name: 'Не найдено',
        price: 0,
        unit: '',
        quantity: 0,
        sum: 0,
        invNumber: 'Не найдено',
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(product.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Цена: ${product.price}'),
                Text('Ед. измерения: ${product.unit}'),
                Text('Количество: ${product.quantity}'),
                Text('Инв. номер: ${product.invNumber}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Товары"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CategorySelector(
            onCategorySelected: filterProducts,
          ),
          const Divider(height: 1),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: refreshProducts,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: filteredProducts.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                  child: isSyncing
                                      ? const CircularProgressIndicator()
                                      : const Text("Нет товаров",
                                          style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (_, i) =>
                                ProductCard(product: filteredProducts[i]),
                          ),
                  ),
                ),
                if (isSyncing)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      color: AppTheme.primary,
                      backgroundColor: AppTheme.primary.withOpacity(0.2),
                      minHeight: 4,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
