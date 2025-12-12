import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/sync_service.dart';
import '../widgets/dashboard_card.dart';
import '../theme/app_theme.dart';
import '../models/product_model.dart';
import '../models/operation_model.dart';
import '../models/document_model.dart';
import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  final SyncService syncService;

  const HomePage({super.key, required this.syncService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int productsCount = 0;
  int operationsCount = 0;
  int documentsCount = 0;
  int categoriesCount = 0;
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    loadCounts(); // сначала показываем локальные данные
    _syncCountsDelayed(); // потом пробуем синхронизацию
  }

  Future<void> loadCounts() async {
    try {
      final productsBox = await Hive.openBox<ProductModel>('products');
      final operationsBox = await Hive.openBox<OperationModel>('operations');
      final documentsBox = await Hive.openBox<DocumentModel>('documents');
      final categoriesBox = await Hive.openBox<CategoryModel>('categories');

      if (!mounted) return;

      setState(() {
        productsCount = productsBox.length;
        operationsCount = operationsBox.length;
        documentsCount = documentsBox.length;
        categoriesCount = categoriesBox.length;
      });
    } catch (e) {
      print('Error loading counts: $e');
    }
  }

  Future<void> _syncCountsDelayed() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await refreshCounts();
  }

  Future<void> refreshCounts() async {
    setState(() => isSyncing = true);
    try {
      await widget.syncService.syncAll(); // синхронизация с сервером
    } catch (e) {
      print('Sync error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Нет доступа к серверу, отображаются локальные данные')),
        );
      }
    } finally {
      await loadCounts(); // обновляем данные из Hive
      if (mounted) setState(() => isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: "Товаров",
                        icon: Icons.inventory_2,
                        color: Colors.blue,
                        animateValue: productsCount, // любое число
                      ),
                    ),
                    Expanded(
                      child: DashboardCard(
                        title: "Операций",
                        icon: Icons.swap_horiz,
                        color: Colors.green,
                        animateValue: operationsCount,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: "Документов",
                        icon: Icons.description,
                        color: Colors.orange,
                        animateValue: documentsCount,
                      ),
                    ),
                    Expanded(
                      child: DashboardCard(
                        title: "Категорий",
                        icon: Icons.category,
                        color: Colors.purple,
                        animateValue: categoriesCount,
                      ),
                    ),
                  ],
                ),
              ],
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
