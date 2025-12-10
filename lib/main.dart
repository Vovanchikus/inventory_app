import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_page.dart';
import 'providers/products_provider.dart';
import 'providers/categories_provider.dart';
import 'providers/operations_provider.dart';
import 'providers/documents_provider.dart';
import 'providers/operation_types_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => OperationsProvider()),
        ChangeNotifierProvider(create: (_) => DocumentsProvider()),
        ChangeNotifierProvider(create: (_) => OperationTypesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
