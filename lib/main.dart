import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/dependency_injection.dart' as di;
import 'features/categories/data/models/category_model.dart';
import 'features/transactions/data/models/transaction_model.dart';
import 'features/transactions/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionTypeModelAdapter());
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
