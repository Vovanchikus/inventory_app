import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categories_provider.dart';
import '../widgets/card_item.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Категории")),
      body: RefreshIndicator(
        onRefresh: () => categoriesProvider.loadCategories(),
        child: ListView.builder(
          itemCount: categoriesProvider.categories.length,
          itemBuilder: (_, index) {
            final c = categoriesProvider.categories[index];
            return CardItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Родитель: ${c.parentId ?? '-'}"),
                  if (c.children.isNotEmpty)
                    Text(
                        "Дочерние: ${c.children.map((e) => e.name).join(', ')}")
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
