import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/operation_model.dart';
import '../models/operation_product_model.dart';

class OperationCard extends StatelessWidget {
  final OperationModel operation;

  const OperationCard({super.key, required this.operation});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final products = operation.products ?? [];
    final counteragents = operation.counteragents ?? [];
    final documents = operation.documents ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: AppTheme.shadow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  operation.type ?? "–",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _formatDate(operation.createdAt),
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (products.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: products
                    .map((p) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text('${p.name ?? "–"} × ${p.quantity}',
                              style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 8),
            if (counteragents.isNotEmpty)
              Text(
                'Counteragents: ${counteragents.join(", ")}',
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              ),
            if (documents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Documents: ${documents.length}',
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
