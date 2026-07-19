import 'package:flutter/material.dart';

class SupervisorDashboardPage extends StatelessWidget {
  const SupervisorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Supervisor'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.dashboard_customize_outlined,
                size: 64,
                color: Color(0xFF2D1B69),
              ),
              const SizedBox(height: 24),
              Text(
                'Dashboard Supervisor',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Painel de controle e monitoramento sincronizado (Sera migrada na Fase 10).',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar ao Formulário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
