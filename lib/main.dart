import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/local_database.dart';
import 'api/api_service.dart';
import 'services/sync_service.dart';
import 'pages/home_page.dart';

// Импорты Hive моделей и адаптеров
import 'models/product_model.dart';
import 'models/category_model.dart';
import 'models/operation_model.dart';
import 'models/operation_type_model.dart';
import 'models/operation_product_model.dart';
import 'models/document_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Hive
  await Hive.initFlutter();

  // Регистрация всех адаптеров Hive
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(OperationModelAdapter());
  Hive.registerAdapter(OperationProductModelAdapter());
  Hive.registerAdapter(DocumentModelAdapter());
  Hive.registerAdapter(OperationTypeModelAdapter());

  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService =
        ApiService(baseUrl: 'https://192.168.0.106/api', ignoreSsl: true);
    final syncService = SyncService(api: apiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalDatabaseProvider()),
        Provider(create: (_) => apiService),
        Provider(create: (_) => syncService),
      ],
      child: MaterialApp(
        title: 'Inventory App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
