import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/navigation/app_routes.dart';
import 'core/services/isar_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco local Isar antes de construir qualquer widget.
  await IsarService.instance.init();

  // Inicializa o Firebase
  try {
    debugPrint('Plataforma Web? $kIsWeb');
    debugPrint('Firebase Options Web apiKey: ${DefaultFirebaseOptions.web.apiKey}');
    final options = DefaultFirebaseOptions.currentPlatform;
    debugPrint('Current Platform Options: $options');
    await Firebase.initializeApp(
      options: options,
    );
  } catch (e) {
    debugPrint('Firebase init fallback: $e');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMOC Relatório',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
