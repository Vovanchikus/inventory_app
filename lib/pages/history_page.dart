import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/operations_provider.dart';
import '../widgets/card_item.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final operationsProvider = Provider.of<OperationsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("История операций")),
      body: RefreshIndicator(
        onRefresh: () => operationsProvider.loadOperations(),
        child: ListView.builder(
          itemCount: operationsProvider.operations.length,
          itemBuilder: (_, index) {
            final op = operationsProvider.operations[index];
            return CardItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Тип: ${op.type}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Дата: ${op.createdAt}"),
                  const SizedBox(height: 6),
                  ...op.products.map((p) =>
                      Text("${p.name} x${p.quantity} (${p.counteragent})")),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
