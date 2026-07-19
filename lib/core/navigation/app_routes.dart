import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/report_form/presentation/pages/report_form_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/supervisor/presentation/pages/supervisor_dashboard_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String login = '/login';
  static const String form = '/form';
  static const String history = '/history';
  static const String supervisor = '/supervisor';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        // Inicialmente direciona para o login (ou formulário)
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case form:
        return MaterialPageRoute(builder: (_) => const ReportFormPage());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      case supervisor:
        return MaterialPageRoute(builder: (_) => const SupervisorDashboardPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
