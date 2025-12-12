import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../widgets/card_item.dart';
import '../theme/app_theme.dart';
import '../services/sync_service.dart';

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

  Future<void> loadProducts() async {
    final box = await Hive.openBox<ProductModel>('products');
    if (!mounted) return;
    setState(() => products = box.values.toList());
  }

  Future<void> _syncProductsDelayed() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await refreshProducts();
  }

  Future<void> refreshProducts() async {
    setState(() => isSyncing = true);
    try {
      await widget.syncService.syncProducts();
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
          appBar: AppBar(title: const Text("Products")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Price: ${product.price}'),
                Text('Unit: ${product.unit}'),
                Text('Quantity: ${product.quantity}'),
                Text('Inv Number: ${product.invNumber}'),
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
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: refreshProducts,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: products.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: isSyncing
                                ? const CircularProgressIndicator()
                                : const Text("No products",
                                    style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, i) => ProductCard(product: products[i]),
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
    );
  }
}
