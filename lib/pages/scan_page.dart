import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:collection/collection.dart';
import 'products_page.dart';
import '../services/sync_service.dart';
import '../models/product_model.dart';
import 'package:hive/hive.dart';

class ScanPage extends StatefulWidget {
  final SyncService syncService;

  const ScanPage({super.key, required this.syncService});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController cameraController = MobileScannerController();
  String? scannedCode;

  Future<void> _handleScannedCode(String code) async {
    if (scannedCode != null) return;
    scannedCode = code;

    final box = await Hive.openBox<ProductModel>('products');

    // Ищем по invNumber
    final product = box.values.firstWhereOrNull((p) => p.invNumber == code);

    if (product != null) {
      // Открываем страницу товара
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductsPage(
            productId: product.id.toString(),
            syncService: widget.syncService,
          ),
        ),
      ).then((_) {
        scannedCode = null;
        cameraController.start();
      });
    } else {
      // Модалка: товар не найден
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Товар не найден'),
          content: Text('QR код "$code" не соответствует ни одному товару.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                scannedCode = null;
                cameraController.start();
              },
              child: const Text('Продолжить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканер QR'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code != null) {
                  _handleScannedCode(code);
                  break;
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
