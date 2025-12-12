import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'theme/app_theme.dart';
import 'db/app_database.dart';
import 'api/api_service.dart';
import 'services/sync_service.dart';

import 'pages/products_page.dart';
import 'pages/operations_page.dart';
import 'pages/documents_page.dart';
import 'pages/home_page.dart';
import 'pages/scan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Register + open boxes
  await AppDatabase.init();

  // API service
  final api = ApiService(baseUrl: 'http://192.168.0.106/api');

  // Sync service
  final sync = SyncService(api: api);

  runApp(MyApp(syncService: sync));
}

class MyApp extends StatelessWidget {
  final SyncService syncService;

  const MyApp({super.key, required this.syncService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Inventory App",
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BottomBar(syncService: syncService),
    );
  }
}

class BottomBar extends StatefulWidget {
  final SyncService syncService;

  const BottomBar({super.key, required this.syncService});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 0;

  late final pages = <Widget>[
    HomePage(syncService: widget.syncService),
    ProductsPage(syncService: widget.syncService),
    OperationsPage(syncService: widget.syncService),
    DocumentsPage(syncService: widget.syncService),
  ];

  void _onTabTapped(int tappedIndex) {
    setState(() {
      index = tappedIndex;
    });
  }

  void _scanQR() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScanPage(syncService: widget.syncService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.qr_code_scanner, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(0, Icons.dashboard_outlined, "Dashboard"),
              _buildTabItem(1, Icons.inventory_2_outlined, "Products"),
              const SizedBox(width: 48), // место под FAB
              _buildTabItem(2, Icons.swap_horiz, "Operations"),
              _buildTabItem(3, Icons.description_outlined, "Documents"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int tabIndex, IconData icon, String label) {
    final isSelected = index == tabIndex;
    final color = isSelected ? AppTheme.primary : AppTheme.textSecondary;

    return InkWell(
      onTap: () => _onTabTapped(tabIndex),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
