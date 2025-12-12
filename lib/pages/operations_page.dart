import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../theme/app_theme.dart';
import '../models/operation_model.dart';
import '../widgets/operation_card.dart';
import '../services/sync_service.dart';

enum SortOption { dateDesc, dateAsc, type }

class OperationsPage extends StatefulWidget {
  final SyncService syncService;

  const OperationsPage({super.key, required this.syncService});

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  List<OperationModel> operations = [];
  List<OperationModel> filteredOperations = [];
  bool isSyncing = false;

  // Фильтры и сортировка
  SortOption currentSort = SortOption.dateDesc;
  String? currentTypeFilter;
  List<String> allTypes = [];

  @override
  void initState() {
    super.initState();
    loadOperations();
    refreshOperations();
  }

  Future<void> loadOperations() async {
    try {
      final box = await Hive.openBox<OperationModel>('operations');
      if (!mounted) return;

      operations = box.values.toList();
      allTypes = operations.map((op) => op.type ?? '').toSet().toList();
      applyFilters();
    } catch (e) {
      print('Error loading operations from Hive: $e');
    }
  }

  void applyFilters() {
    List<OperationModel> list = [...operations];

    // фильтр по типу
    if (currentTypeFilter != null && currentTypeFilter!.isNotEmpty) {
      list = list.where((op) => op.type == currentTypeFilter).toList();
    }

    // сортировка
    switch (currentSort) {
      case SortOption.dateDesc:
        list.sort((a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)));
        break;
      case SortOption.dateAsc:
        list.sort((a, b) => (a.createdAt ?? DateTime(2000))
            .compareTo(b.createdAt ?? DateTime(2000)));
        break;
      case SortOption.type:
        list.sort((a, b) => (a.type ?? '').compareTo(b.type ?? ''));
        break;
    }

    setState(() {
      filteredOperations = list;
    });
  }

  Future<void> refreshOperations() async {
    setState(() => isSyncing = true);
    try {
      await widget.syncService.syncOperations();
      await loadOperations();
    } catch (e) {
      print('Sync operations error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка синхронизации: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSyncing = false);
    }
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Сортировка
          ChoiceChip(
            label: const Text("Date Desc"),
            selected: currentSort == SortOption.dateDesc,
            onSelected: (_) {
              currentSort = SortOption.dateDesc;
              applyFilters();
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text("Date Asc"),
            selected: currentSort == SortOption.dateAsc,
            onSelected: (_) {
              currentSort = SortOption.dateAsc;
              applyFilters();
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text("Type"),
            selected: currentSort == SortOption.type,
            onSelected: (_) {
              currentSort = SortOption.type;
              applyFilters();
            },
          ),
          const SizedBox(width: 16),
          // Фильтры по типу
          ChoiceChip(
            label: const Text("All types"),
            selected: currentTypeFilter == null,
            onSelected: (_) {
              currentTypeFilter = null;
              applyFilters();
            },
          ),
          ...allTypes.map((type) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ChoiceChip(
                label: Text(type.isEmpty ? '–' : type),
                selected: currentTypeFilter == type,
                onSelected: (_) {
                  currentTypeFilter = type;
                  applyFilters();
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Operations"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildChips(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refreshOperations,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: filteredOperations.isEmpty
                        ? ListView(
                            key: const ValueKey('empty'),
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                  child: isSyncing
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "No operations",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            key: const ValueKey('list'),
                            itemCount: filteredOperations.length,
                            itemBuilder: (_, i) =>
                                OperationCard(operation: filteredOperations[i]),
                          ),
                  ),
                ),
              ),
            ],
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
