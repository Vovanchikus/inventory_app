import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/local_database.dart';
import '../services/sync_service.dart';
import '../models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  // Загружаем локальные данные сразу при старте
  Future<void> _loadLocalData() async {
    final db = Provider.of<LocalDatabaseProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await db.init();
    } catch (e) {
      print('Error loading local DB: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки локальных данных')),
      );
    }

    setState(() => _isLoading = false);
  }

  // Синхронизация с сервером
  Future<void> _syncData() async {
    final sync = Provider.of<SyncService>(context, listen: false);
    final db = Provider.of<LocalDatabaseProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await sync.syncAll(); // синхронизация
      await db.init(); // обновляем локальные данные
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Синхронизация завершена')),
      );
    } catch (e) {
      print('Sync failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка синхронизации')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<LocalDatabaseProvider>(context);
    final products = db.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _isLoading ? null : _syncData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('Нет товаров'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final ProductModel product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        'Кол-во: ${product.quantity}, Цена: ${product.price}',
                      ),
                    );
                  },
                ),
    );
  }
}
