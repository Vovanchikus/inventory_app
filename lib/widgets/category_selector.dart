import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../theme/app_theme.dart';

class CategorySelector extends StatefulWidget {
  final void Function(CategoryModel? category) onCategorySelected;

  const CategorySelector({super.key, required this.onCategorySelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late Box<CategoryModel> box;

  /// Уровни категорий
  /// [ [level1], [level2], [level3], ... ]
  List<List<CategoryModel>> levels = [];

  /// Выбранные категории по уровням
  /// Например: [cat1, cat12, cat123]
  List<CategoryModel?> selected = [];

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    box = await Hive.openBox<CategoryModel>('categories');

    final level1 = box.values.where((c) => c.parentId == null).toList();

    setState(() {
      levels = [level1];
      selected = [null];
    });

    widget.onCategorySelected(null);
  }

  /// Получение детей любого уровня
  List<CategoryModel> _getChildren(CategoryModel parent) {
    return box.values.where((c) => c.parentId == parent.id).toList();
  }

  void _select(int levelIndex, CategoryModel? category) {
    setState(() {
      selected[levelIndex] = category;

      // отрезаем уровни глубже текущего
      levels = levels.sublist(0, levelIndex + 1);
      selected = selected.sublist(0, levelIndex + 1);

      if (category != null) {
        final children = _getChildren(category);
        if (children.isNotEmpty) {
          levels.add(children);
          selected.add(null);
        }
      }
    });

    // Последний выбранный = категория фильтрации
    final active = selected.lastWhere((cat) => cat != null, orElse: () => null);
    widget.onCategorySelected(active);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int levelIndex = 0; levelIndex < levels.length; levelIndex++)
          _buildLevel(levelIndex, levels[levelIndex]),
      ],
    );
  }

  Widget _buildLevel(int levelIndex, List<CategoryModel> cats) {
    final sel = selected[levelIndex];

    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: cats.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return _item(
              name: "Все",
              isSelected: sel == null,
              onTap: () => _select(levelIndex, null),
            );
          }

          final c = cats[i - 1];
          return _item(
            name: c.name,
            isSelected: sel == c,
            onTap: () => _select(levelIndex, c),
          );
        },
      ),
    );
  }

  Widget _item({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : AppTheme.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
