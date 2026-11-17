import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/api_config.dart';
import 'providers/product_provider.dart';
import 'screens/product_list_screen.dart';

void main() async {
  // Memastikan inisialisasi framework Flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi konfigurasi PBO untuk IP address & SharedPreferences
  await ApiConfig.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Produk Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ProductListScreen(),
    );
  }
}
