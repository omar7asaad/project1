// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_bindings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.getInstance();
  final token = storage.getToken();
  final start = (token != null && token.trim().isNotEmpty)
      ? AppRoutes.home
      : AppRoutes.login;
  runApp(const MyApp(initialRoute: AppRoutes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      getPages: AppPages.pages,
      initialRoute: initialRoute,
    );
  }
}

