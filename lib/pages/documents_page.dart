import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/documents_provider.dart';
import '../widgets/card_item.dart';

class DocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final docsProvider = Provider.of<DocumentsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Документы")),
      body: RefreshIndicator(
        onRefresh: () => docsProvider.loadDocuments(),
        child: ListView.builder(
          itemCount: docsProvider.documents.length,
          itemBuilder: (_, index) {
            final doc = docsProvider.documents[index];
            return CardItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.name ?? 'Без названия',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Файл: ${doc.fileName ?? '-'}"),
                  Text("Дата: ${doc.createdAt ?? '-'}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
