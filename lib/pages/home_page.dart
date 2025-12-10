import 'package:flutter/material.dart';
import 'warehouse_page.dart';
import 'history_page.dart';
import 'documents_page.dart';
import 'categories_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final pages = [
    WarehousePage(),
    HistoryPage(),
    DocumentsPage(),
    CategoriesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.warehouse), label: "Склад"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "История"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: "Документы"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Категории"),
        ],
      ),
    );
  }
}
