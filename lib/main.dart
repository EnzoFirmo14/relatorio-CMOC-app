import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'core/navigation/app_routes.dart';
import 'core/services/isar_service.dart';
import 'core/theme/app_theme.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/cloudinary_service.dart';
import 'features/sync/domain/services/sync_service.dart';
import 'features/report_form/data/repositories/report_repository_impl.dart';
import 'features/report_form/data/datasources/report_local_datasource.dart';
import 'features/sync/data/datasources/report_remote_datasource.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // Inicializa o Firebase no isolate em segundo plano
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Inicializa o Isar no isolate em segundo plano
      await IsarService.instance.init();

      // Cria as dependências de sincronização manualmente
      final isar = IsarService.instance.isar;
      final localDataSource = ReportLocalDataSource(isar);
      final localRepository = ReportRepositoryImpl(localDataSource);
      final remoteDataSource = ReportFirestoreDataSource();
      final connectivityService = ConnectivityService();
      final cloudinaryService = CloudinaryService();

      final syncService = SyncService(
        localRepository: localRepository,
        remoteDataSource: remoteDataSource,
        connectivityService: connectivityService,
        cloudinaryService: cloudinaryService,
      );

      final syncedCount = await syncService.syncPendingReports();
      debugPrint('[WorkManager] Sincronização automática em segundo plano concluída. Sincronizados: $syncedCount');
      return true;
    } catch (e, stack) {
      debugPrint('[WorkManager] Erro ao sincronizar em segundo plano: $e');
      debugPrint(stack.toString());
      return false;
    }
  });
}

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

  // Inicializa o Workmanager para rodar tarefas em segundo plano (apenas Mobile)
  if (!kIsWeb) {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
      );
      
      // Registra a tarefa periódica para rodar a cada 15 minutos em segundo plano
      await Workmanager().registerPeriodicTask(
        'sync-task-periodic',
        'sync-task',
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } catch (e) {
      debugPrint('Falha ao inicializar Workmanager: $e');
    }
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
      title: 'InfraLog CMOC (beta)',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
