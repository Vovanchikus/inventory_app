import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/document_model.dart';

class DocumentsProvider extends ChangeNotifier {
  List<DocumentModel> _documents = [];

  List<DocumentModel> get documents => _documents;

  Future<void> loadDocuments() async {
    final box = await Hive.openBox<DocumentModel>('documents');
    _documents = box.values.toList();
    notifyListeners();
  }
}
