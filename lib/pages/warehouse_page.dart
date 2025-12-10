import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/card_item.dart';

class WarehousePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Склад")),
      body: RefreshIndicator(
        onRefresh: () => productsProvider.loadProducts(),
        child: ListView.builder(
          itemCount: productsProvider.products.length,
          itemBuilder: (_, index) {
            final p = productsProvider.products[index];
            return CardItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      "Ед: ${p.unit} | Цена: ${p.price} | Кол-во: ${p.quantity}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
