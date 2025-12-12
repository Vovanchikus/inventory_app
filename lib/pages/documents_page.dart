import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/document_model.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';

class DocumentsPage extends StatefulWidget {
  final SyncService syncService;

  const DocumentsPage({super.key, required this.syncService});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  List<DocumentModel> documents = [];
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadDocuments(); // сразу показываем локальные документы
    _syncDocumentsDelayed(); // затем синхронизируем с сервером
  }

  Future<void> _loadDocuments() async {
    try {
      final box = await Hive.openBox<DocumentModel>('documents');
      if (!mounted) return;

      setState(() {
        // сортируем документы по дате создания, последние сверху
        documents = box.values.toList()
          ..sort((a, b) =>
              b.createdAt?.compareTo(a.createdAt ?? DateTime(0)) ?? 0);
      });
    } catch (e) {
      debugPrint('Error loading documents: $e');
    }
  }

  Future<void> _syncDocumentsDelayed() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _refreshDocuments();
  }

  Future<void> _refreshDocuments() async {
    setState(() => isSyncing = true);
    try {
      // синхронизируем операции, чтобы получить актуальные документы
      await widget.syncService.syncOperations();
      await widget.syncService.syncDocumentsFromOperations();
    } catch (e) {
      debugPrint('Sync documents error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Нет доступа к серверу, отображаются локальные данные',
            ),
          ),
        );
      }
    } finally {
      await _loadDocuments(); // обновляем локальные данные после синхронизации
      if (mounted) setState(() => isSyncing = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Documents"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshDocuments,
            child: documents.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: isSyncing
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "No documents",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (_, i) {
                      final doc = documents[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(doc.name ?? "Без названия"),
                          subtitle: Text(
                            "Date: ${_formatDate(doc.createdAt)} | Type: ${doc.type ?? '-'}",
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            // TODO: открыть детальную страницу документа
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (isSyncing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                minHeight: 4,
              ),
            ),
        ],
      ),
    );
  }
}
